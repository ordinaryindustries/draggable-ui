//
//
// DragTest
//
// Created by Ordinary Industries on 12/30/23.
// Copyright (c) 2023 Ordinary Industries. All rights reserved.
//
// Twitter: @OrdinaryInds
// TikTok: @OrdinaryInds
//


import SwiftUI

struct ContentView: View {
    @State private var dragOffset: CGSize = .zero
    @State private var position: CGSize = .zero
    @State private var canDrag: Bool = false
    let buttonSize: CGFloat = 80
    let dragDamping: CGFloat = 0.36
    let buttonScale: CGFloat = 0.9
    let cornerSnapMargin: CGFloat = 100
    
    var body: some View {
        VStack {
            Spacer()
            GeometryReader { proxy in
                if canDrag {
                    withAnimation {
                        RoundedRectangle(cornerRadius: 40)
                            .fill(.clear)
                            .strokeBorder(.white, style: StrokeStyle(lineWidth: 2.0, lineCap: .round, dash: [10]))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .opacity(0.2)
                    }
                }
                
                Circle()
                    .fill(.white)
                    .frame(width: canDrag ? buttonSize * buttonScale : buttonSize)
                    .offset(x: dragOffset.width + position.width, y: dragOffset.height + position.height)
                    .onAppear {
                        position.width = proxy.frame(in: .local).maxX - buttonSize
                        position.height = proxy.frame(in: .local).maxY - buttonSize
                    }
                    .gesture(
                        LongPressGesture(minimumDuration: 0.4)
                            .onEnded({ _ in
                                print("Long press ended.")
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                    canDrag.toggle()
                                }
                            })
                    )
                    .sensoryFeedback(.impact, trigger: canDrag)
                    .simultaneousGesture(
                        DragGesture()
                            .onChanged({ value in
                                if canDrag {
                                    withAnimation() {
                                        print("Position: \(position.height) Drag distance \(value.translation.height)")
                                        
                                        if position.height + value.translation.height < .zero {
                                            print("Out of bounds!")
                                            
                                            dragOffset.height = value.translation.height
                                            dragOffset.width = value.translation.width
                                        } else {
                                            dragOffset = value.translation
                                        }
                                    }
                                }
                            })
                            .onEnded({ value in
                                if canDrag {
                                    // When button is let go set it's position.
                                    withAnimation() {
                                        position.width += value.translation.width
                                        position.height += value.translation.height
                                        
                                        // Reset the drag delta.
                                        dragOffset = .zero
                                        
                                        
                                        // Calculate x position.
                                        if position.width + buttonSize / 2 < proxy.size.width / 2 {
                                            position.width = .zero
                                        } else {
                                            position.width = proxy.size.width - buttonSize
                                        }
                                        
                                        // Calculate y position.
                                        // If the button is above the draggable area.
                                        if position.height < .zero {
                                            position.height = .zero
                                        // If the button is below the draggable area.
                                        } else if position.height > proxy.size.height - buttonSize {
                                            position.height = proxy.size.height - buttonSize
                                        } else if proxy.size.height - position.height < cornerSnapMargin {
                                            position.height = proxy.size.height - buttonSize
                                        }
                                        
                                    }
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                        canDrag.toggle()
                                    }
                                }
                                
                            })
                        
                    )
            }
            .frame(maxWidth: .infinity)
            .frame(height: 400)
            .padding()
        }
        .background(.black)
        .ignoresSafeArea()
        
    }
}

#Preview {
    ContentView()
}
