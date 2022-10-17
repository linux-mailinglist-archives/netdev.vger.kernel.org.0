Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6732460163C
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 20:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiJQS04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 14:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbiJQS0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 14:26:54 -0400
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BD474CE6;
        Mon, 17 Oct 2022 11:26:53 -0700 (PDT)
Received: by mail-oo1-f50.google.com with SMTP id g15-20020a4a894f000000b0047f8e899623so2755953ooi.5;
        Mon, 17 Oct 2022 11:26:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=14x/M1tKZwx1cpScI/Zn9umGF7nknJ0iPBkHXl0p60w=;
        b=7wpMGAuxXsPn25YuNGrtZ3sAIgRIs+/YMxs4yEM4jxwxANNFxPtv2oezL2EABBiqbp
         7Eg3qS4W/M+Oflco5puM2LewRCuo1eW/h7MNSWFbrOzO5IsROFw1d5+SIM27H7ilkAv1
         fUIZY/rHN6kI/g1NXyH9KN5wsgeMI9vpy8V8evlkhfQ7+9umgz37IAb9LEOff3R10o6b
         2R3WC1wtcKH7VCHFoTSTZHm7nLjdm9NMsKrFazjM5Vt/QwLLV3/WhzCwp/0J3tKnjoxH
         FkKqE3UUR5NAWeD1PQq6gVBkO3KG+DkgYpDqxAUp6ROYKFBO/SNMLfuSuqiodr6kqoT4
         4VcQ==
X-Gm-Message-State: ACrzQf3IcXZ9Y+c5ezB/S6rI5hSlaGVUw4eF00P6EEDey7QHp+NGeC5Q
        yqa8RC07zW4TKgVCFvcwIyu1n1btOA==
X-Google-Smtp-Source: AMsMyM4CG65ULQoMsmj7Stme8+7rka/kGz7dJ4wC47I7Ms/prM1SAEmqglGIHsHsjKKzmkj+TXJmxA==
X-Received: by 2002:a4a:d31a:0:b0:47e:70a5:7eed with SMTP id g26-20020a4ad31a000000b0047e70a57eedmr4773127oos.16.1666031212900;
        Mon, 17 Oct 2022 11:26:52 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id i34-20020a056870892200b0013320d9d9casm5148668oao.44.2022.10.17.11.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 11:26:52 -0700 (PDT)
Received: (nullmailer pid 2246065 invoked by uid 1000);
        Mon, 17 Oct 2022 18:26:53 -0000
Date:   Mon, 17 Oct 2022 13:26:53 -0500
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?Q?Micha=C5=82?= Grzelak <mig@semihalf.com>
Cc:     robh+dt@kernel.org, edumazet@google.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        krzysztof.kozlowski+dt@linaro.org, upstream@semihalf.com,
        devicetree@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        mw@semihalf.com, kuba@kernel.org
Subject: Re: [PATCH v5 1/3] dt-bindings: net: marvell,pp2: convert to
 json-schema
Message-ID: <166603121217.2246011.825778809609571162.robh@kernel.org>
References: <20221014213254.30950-1-mig@semihalf.com>
 <20221014213254.30950-2-mig@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221014213254.30950-2-mig@semihalf.com>
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

On Fri, 14 Oct 2022 23:32:52 +0200, Michał Grzelak wrote:
> Convert the marvell,pp2 bindings from text to proper schema.
> 
> Move 'marvell,system-controller' and 'dma-coherent' properties from
> port up to the controller node, to match what is actually done in DT.
> 
> Rename all subnodes to match "^(ethernet-)?port@[0-2]$" and deprecate
> port-id in favour of 'reg'.
> 
> Signed-off-by: Michał Grzelak <mig@semihalf.com>
> ---
>  .../devicetree/bindings/net/marvell,pp2.yaml  | 305 ++++++++++++++++++
>  .../devicetree/bindings/net/marvell-pp2.txt   | 141 --------
>  MAINTAINERS                                   |   2 +-
>  3 files changed, 306 insertions(+), 142 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/marvell,pp2.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/marvell-pp2.txt
> 

Reviewed-by: Rob Herring <robh@kernel.org>
