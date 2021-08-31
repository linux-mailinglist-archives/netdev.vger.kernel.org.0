Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8693FCF11
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 23:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239316AbhHaVX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 17:23:59 -0400
Received: from mail-ot1-f44.google.com ([209.85.210.44]:45863 "EHLO
        mail-ot1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbhHaVX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 17:23:58 -0400
Received: by mail-ot1-f44.google.com with SMTP id l7-20020a0568302b0700b0051c0181deebso858929otv.12;
        Tue, 31 Aug 2021 14:23:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wUx9V4VMzp/B15LcV0R/B+k8WpG+YIR/wnvRb9JZesY=;
        b=eM6Q3lUDaVWfsf+F7fCEO8gNjsEO9C+r8Hn5dLnrtI/ZT4au4nfowQA1zBlNC7CNrt
         7Y0j/FLGE2XndfTSo8oFg7qZdm2sKR9vkICW/KfiquQu5EJKTnCWNLESWxvaGvQlo5zH
         p1d+I1E4VBuazNu7iwP4kRp+jvvmuhAcCX+Mosc3ElAhCpudEyiceVn2qybhqI74q2Zf
         QsDp3ep9AKcYKJhKx5VmssrUBSBvHvf+OKYk4gutDDXMlXmDaeH/aQE9I3wYk2uaMWYq
         aPCrpuMf5/GaFhdiVDc5rEkrz2d2ZE39dmxq5DiHxECqPbS0CFffGaku5OA37Ty1Ly2B
         Uwpg==
X-Gm-Message-State: AOAM533V9H3VrVRGRORNneBdwPAJ8+vWr4AlppHc6eHTwXEsHmzSB4LJ
        a4eCvN/0/kj8jg3yKuBOy6MS8ceJow==
X-Google-Smtp-Source: ABdhPJx68CiltMvlQWW7XQDzxPXrlYNB0M+lz+RG3htfHDCPSgm6oi8Kyx/DfROlwDgq4po4zNOXKg==
X-Received: by 2002:a9d:d35:: with SMTP id 50mr25379100oti.22.1630444982315;
        Tue, 31 Aug 2021 14:23:02 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id z7sm4232632oti.65.2021.08.31.14.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 14:23:01 -0700 (PDT)
Received: (nullmailer pid 669145 invoked by uid 1000);
        Tue, 31 Aug 2021 21:23:00 -0000
Date:   Tue, 31 Aug 2021 16:23:00 -0500
From:   Rob Herring <robh@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH devicetree 1/2] dt-bindings: arm: fsl: document the
 LX2160A BlueBox 3 boards
Message-ID: <YS6dtKYnwle++wA6@robh.at.kernel.org>
References: <20210827202722.2567687-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827202722.2567687-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Aug 2021 23:27:21 +0300, Vladimir Oltean wrote:
> Document the compatible string for the LX2160A system that is part of
> the BlueBox 3. Also add a separate compatible string for Rev A, since
> technically it uses a different device tree.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  Documentation/devicetree/bindings/arm/fsl.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
