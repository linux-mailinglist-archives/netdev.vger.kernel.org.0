Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A73F4E1974
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 03:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244664AbiCTCPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 22:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244679AbiCTCPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 22:15:16 -0400
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEFD117E26;
        Sat, 19 Mar 2022 19:13:50 -0700 (PDT)
Received: by mail-io1-f41.google.com with SMTP id b16so13398941ioz.3;
        Sat, 19 Mar 2022 19:13:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=4X/zQGDYpkVVW7IWxE5DUh7i3uSLBkv1mL4wCcuAH0c=;
        b=xsv38eYd+HY9kxg3j7cM5bj/4vIGU9rl7LlNpE5OcHcvsdnhey8LLd35/raJAHZ4Gu
         L5xTFkmYgD7wTHa0DHdCvcw8fbjAGoJWPP/mE9YZx8tqeH9O6o+dx9aQXsRdufeWQWR/
         bBayb337RM3BkKilIY4NPSTmzVGqxY41o1W9PEkj6Vj70NvY6oYUiqsnNhVtLICjCJSm
         ASxnjeBxW3zpy7ALevmUf65QEq7i4odGuRoE+s9wnnJKqNRVkNUHkuntcgRBy8yTb4cr
         COaGrZnBf2DyaERUZQ+P8WCdIVNYdu+Ck6UjSq0tATUH8HCeGb6cFk2nbMSwXRocYWVH
         6aTw==
X-Gm-Message-State: AOAM5302rIek5cyFsIM7oSdwd0rlQPqKpg3aOyz5l5NSEsIsgf37QeHD
        LegIekryYO6b1Ksp0LKdMw==
X-Google-Smtp-Source: ABdhPJx11hfWDir6SQ/nINMJ8tzicnfsB7q7t+560DbBvqMA1MP1SJQBt+i7toEFD2yVV2TJNFidpA==
X-Received: by 2002:a05:6638:3295:b0:317:d9c8:51f9 with SMTP id f21-20020a056638329500b00317d9c851f9mr8081749jav.48.1647742429802;
        Sat, 19 Mar 2022 19:13:49 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id q9-20020a5edb09000000b00645c7a00cbbsm6392975iop.20.2022.03.19.19.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 19:13:48 -0700 (PDT)
Received: (nullmailer pid 2990523 invoked by uid 1000);
        Sun, 20 Mar 2022 02:13:33 -0000
From:   Rob Herring <robh@kernel.org>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     hkallweit1@gmail.com, f.fainelli@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, kuba@kernel.org,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        davem@davemloft.net, devicetree@vger.kernel.org, andrew@lunn.ch,
        olteanv@gmail.com, vivien.didelot@gmail.com, robh+dt@kernel.org,
        woojung.huh@microchip.com
In-Reply-To: <20220318085540.281721-2-prasanna.vengateshan@microchip.com>
References: <20220318085540.281721-1-prasanna.vengateshan@microchip.com> <20220318085540.281721-2-prasanna.vengateshan@microchip.com>
Subject: Re: [PATCH v9 net-next 01/11] dt-bindings: net: make internal-delay-ps based on phy-mode
Date:   Sat, 19 Mar 2022 20:13:33 -0600
Message-Id: <1647742413.985820.2990522.nullmailer@robh.at.kernel.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Mar 2022 14:25:30 +0530, Prasanna Vengateshan wrote:
> *-internal-delay-ps properties would be applicable only for RGMII interface
> modes.
> 
> It is changed as per the request,
> https://lore.kernel.org/netdev/d8e5f6a8-a7e1-dabd-f4b4-ea8ea21d0a1d@gmail.com/
> 
> Ran dt_binding_check to confirm nothing is broken and submitting as a RFC
> patch to receive feedback.
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> ---
>  .../bindings/net/ethernet-controller.yaml     | 37 +++++++++++++------
>  1 file changed, 25 insertions(+), 12 deletions(-)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:
./Documentation/devicetree/bindings/net/ethernet-controller.yaml:232:20: [warning] wrong indentation: expected 18 but found 19 (indentation)
./Documentation/devicetree/bindings/net/ethernet-controller.yaml:233:21: [warning] wrong indentation: expected 21 but found 20 (indentation)

dtschema/dtc warnings/errors:

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1606943

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

