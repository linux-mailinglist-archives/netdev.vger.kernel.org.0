Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58405F0DC0
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiI3Ol3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiI3Ol2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:41:28 -0400
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B86105032;
        Fri, 30 Sep 2022 07:41:27 -0700 (PDT)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-131fd187e35so1956947fac.7;
        Fri, 30 Sep 2022 07:41:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Rp5relsESPzdML4Jyj9/5J2AdsLsmoQhxmmTQVJ+cFk=;
        b=RC8UBsYCdQeJZ13rPoS4vwJvGXAaWmexMPYVA/76S9ZzyfdgF4AK/z0a7B/WiEmYWG
         D9FmWSKcKQ21dtw4sdncxElRI/Hr9hUbKlZWmJqgMKyVK4n9l12D/glvwtK3AJsWwmVV
         nZ7YHt/4eC0nHsNPFlfqctIdTsV3yddWaL5OFxxCL/fAtZ9M7hSqSmIR9yTLy/+0I4eF
         Skz4Xik7u87BqMvE25CXHiMDGEwuHbcwANFX9DJRVycMJT3Na5HwTeAR5cA2uvUTHyQV
         7Z2GTC77+Kl2hVbW3oWHHAko1vRcjmPGvLIfZHCKrv6QKH8f5ojvFhplhx5A93Q2DaX5
         zc0w==
X-Gm-Message-State: ACrzQf1g/jWJAYnOE7RRcfG3xcdyL4hTCWphh6JsbabNk4OWKv3A3Dde
        QdDc9hErNpJJbfb2MarfOg==
X-Google-Smtp-Source: AMsMyM4Ifw1ozypLUSeDv/Yoz/ICemxdZrfoCpZ801ivouJ+Xc0QmUbxkoopn9Q223G9Adc4LwP5gw==
X-Received: by 2002:a05:6870:5b9d:b0:12b:5871:22f4 with SMTP id em29-20020a0568705b9d00b0012b587122f4mr5092720oab.211.1664548886802;
        Fri, 30 Sep 2022 07:41:26 -0700 (PDT)
Received: from macbook.herring.priv (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id j8-20020a4adf48000000b00475dc6c6f31sm486877oou.45.2022.09.30.07.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 07:41:26 -0700 (PDT)
Received: (nullmailer pid 285949 invoked by uid 1000);
        Fri, 30 Sep 2022 14:41:25 -0000
Date:   Fri, 30 Sep 2022 09:41:25 -0500
From:   Rob Herring <robh@kernel.org>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     edumazet@google.com, robh+dt@kernel.org, davem@davemloft.net,
        devicetree@vger.kernel.org, pabeni@redhat.com,
        krzysztof.kozlowski+dt@linaro.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 1/6] dt-bindings: net: tsnep: Allow
 dma-coherent
Message-ID: <166454888495.285888.6881149802161547142.robh@kernel.org>
References: <20220927195842.44641-1-gerhard@engleder-embedded.com>
 <20220927195842.44641-2-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927195842.44641-2-gerhard@engleder-embedded.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Sep 2022 21:58:37 +0200, Gerhard Engleder wrote:
> Within SoCs like ZynqMP, FPGA logic can be connected to different kinds
> of AXI master ports. Also cache coherent AXI master ports are available.
> The property "dma-coherent" is used to signal that DMA is cache
> coherent.
> 
> Add "dma-coherent" property to allow the configuration of cache coherent
> DMA.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  Documentation/devicetree/bindings/net/engleder,tsnep.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
