Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17DEE62002B
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 22:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbiKGVEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 16:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233262AbiKGVEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 16:04:02 -0500
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4EAAE4D;
        Mon,  7 Nov 2022 13:04:02 -0800 (PST)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-13be3ef361dso14081856fac.12;
        Mon, 07 Nov 2022 13:04:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L+c0H1nBQxf6B5rWZoqrhhXaMFx8nOWvIRgKOUuZgCQ=;
        b=Os1C9OmFZxXyot1D4JI0JKO95+L4uHiINpcwIffGpv9ZWax0REKUGqyFnEc+1xPU6y
         mQV8Xut+z9WngU3+gQyc7n8dOxilPc4quVQxJJke3mjakM9TkZFm5PXhY7mydW2scq74
         WBCabHcpycZbwUvm9oCo35T2/i/sDdPAzAWYzOx4KWyd95SLumsRx97t1lZeOiVp/4qP
         tJHmwVs3KTtmzgbdvSlgrKx7hOTBHkVe8dAHx8B4fEjwpaMeH6WXsdmG3V4NrzVcv83J
         qofszBS+MV3PB/YSjjo8w+wRtpO8TIe5ZhcGOtzqk2XWjHLWJOIhm7LxTuDFcDV09rxc
         +9Ew==
X-Gm-Message-State: ACrzQf3ZNmpaRjf6sXoArGjFAgwpn/qZT3AnLjCFAndSHoWpkjWis8DM
        Hgs4/AWBmGCiszuNsDbT+GdL0oMw8w==
X-Google-Smtp-Source: AMsMyM7iV1H7kfmpYIoK0N/dnb0NSM4HcqlprZMaw+9WO09jmwomfbql9idJSNQqwHzQ/kIe67ecqw==
X-Received: by 2002:a05:6870:2427:b0:13b:1f89:ab27 with SMTP id n39-20020a056870242700b0013b1f89ab27mr31504849oap.20.1667855041453;
        Mon, 07 Nov 2022 13:04:01 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id a7-20020a9d5c87000000b0066c495a651dsm3345441oti.38.2022.11.07.13.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 13:04:00 -0800 (PST)
Received: (nullmailer pid 1625023 invoked by uid 1000);
        Mon, 07 Nov 2022 21:04:02 -0000
Date:   Mon, 7 Nov 2022 15:04:02 -0600
From:   Rob Herring <robh@kernel.org>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     devicetree@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] dt-bindings: net: tsnep: Fix typo on generic
 nvmem property
Message-ID: <166785504045.1624928.9983956469114639512.robh@kernel.org>
References: <20221104162147.1288230-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104162147.1288230-1-miquel.raynal@bootlin.com>
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


On Fri, 04 Nov 2022 17:21:47 +0100, Miquel Raynal wrote:
> While working on the nvmem description I figured out this file had the
> "nvmem-cell-names" property name misspelled. Fix the typo, as
> "nvmem-cells-names" has never existed.
> 
> Fixes: 603094b2cdb7 ("dt-bindings: net: Add tsnep Ethernet controller")
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  Documentation/devicetree/bindings/net/engleder,tsnep.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
