Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B50ED4F85C2
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 19:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346059AbiDGRW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 13:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiDGRW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 13:22:57 -0400
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C303E22;
        Thu,  7 Apr 2022 10:20:57 -0700 (PDT)
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-de3ca1efbaso7069557fac.9;
        Thu, 07 Apr 2022 10:20:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rwhEiY9odJROCRAy+Ndxe/cp+ZV49XR/EL4wYOpAE08=;
        b=IIUUip01Dqt5QiwJ/erRQUjGGkM6va0LGj10SXbl1yeuvdrUag2BL9+ZE6FIYVXigL
         SSHewX4d9bFiJtKezNgpdA9uArp7uu1Yme51d/4VsXJc0OQpmT8e/LVGpfkHwcU05Dxv
         R0sZ42oUn466RSwjOipkaJjAw8gY7QFYNTgKBEqATDpvgSdgCoWFvpeRGytESUDHaIVc
         JZzmGJrCyFlk8bz4uIt3JvuQ2TaTRaQQ2jGRRp9cxO0jTjO8o3zW9MFAdTbKdPIlzOX9
         o15Q9HD+lz/JKeBZ12niMjd4/loko+sp7P8ftYoLb1zbDgQv+htegkEOsSX0RmVGXRuO
         gaNg==
X-Gm-Message-State: AOAM5326JifmjyuVw3Y5MjKjQUBnnff6hTd7L0fhPbkPY321Tbhr7HP5
        5NPCUs9JTbxpg9kb7z/bIg==
X-Google-Smtp-Source: ABdhPJzOkKryYuGQU1yXI/kalRRJK9WAgKPBFsBxb61733YyUlHX5uXdCZkO25oICRI+DQ0DnHBrxQ==
X-Received: by 2002:a05:6870:d1c8:b0:e2:b03:1d44 with SMTP id b8-20020a056870d1c800b000e20b031d44mr6489525oac.162.1649352056351;
        Thu, 07 Apr 2022 10:20:56 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id 65-20020aca0544000000b002f980b50140sm3707530oif.18.2022.04.07.10.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 10:20:56 -0700 (PDT)
Received: (nullmailer pid 1485057 invoked by uid 1000);
        Thu, 07 Apr 2022 17:20:55 -0000
Date:   Thu, 7 Apr 2022 12:20:55 -0500
From:   Rob Herring <robh@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v2 01/14] dt-bindings: net: mediatek: add optional
 properties for the SoC ethernet core
Message-ID: <Yk8ddwmSiFg3pslA@robh.at.kernel.org>
References: <20220405195755.10817-1-nbd@nbd.name>
 <20220405195755.10817-2-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405195755.10817-2-nbd@nbd.name>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 09:57:42PM +0200, Felix Fietkau wrote:
> From: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> Introduce dma-coherent, cci-control and hifsys optional properties to
> the mediatek ethernet controller bindings
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  Documentation/devicetree/bindings/net/mediatek-net.txt | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/mediatek-net.txt b/Documentation/devicetree/bindings/net/mediatek-net.txt
> index 72d03e07cf7c..13cb12ee4ed6 100644
> --- a/Documentation/devicetree/bindings/net/mediatek-net.txt
> +++ b/Documentation/devicetree/bindings/net/mediatek-net.txt
> @@ -41,6 +41,12 @@ Required properties:
>  - mediatek,pctl: phandle to the syscon node that handles the ports slew rate
>  	and driver current: only for MT2701 and MT7623 SoC
>  
> +Optional properties:
> +- dma-coherent: present if dma operations are coherent
> +- mediatek,cci-control: phandle to the cache coherent interconnect node

There's a common property for this already. See CCI-400 binding.

> +- mediatek,hifsys: phandle to the mediatek hifsys controller used to provide
> +	various clocks and reset to the system.
> +

This series is adding a handful of new properties. Please convert the 
binding to DT schema first.

Rob
