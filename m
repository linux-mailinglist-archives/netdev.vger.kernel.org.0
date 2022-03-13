Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C71F4D740E
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 10:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234203AbiCMJsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 05:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232537AbiCMJsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 05:48:31 -0400
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9172E19FF44;
        Sun, 13 Mar 2022 01:47:23 -0800 (PST)
Received: by mail-ej1-f49.google.com with SMTP id qt6so27939236ejb.11;
        Sun, 13 Mar 2022 01:47:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=M97CWnu/E+hDBRfUYrCNmTXpaSXL0Lol+UOD+eQVr8o=;
        b=hx/n02dInlmfUM1+eYmKqcUZ3Rwod0cSWy4jDkmiZOBGJe1jrQiu4de2p6N6D1Ya8G
         icJ4D/x54+fKlqlL3vRJttT4zFilEX3elp65d4apyJH+/HKXHHhi4TFx3NnqQHl++Xsb
         ZS2kzPY2H0gyyzNeJK4Vtq+/gXgrbqgnJxOysbNVqCYv/zRmoIRpg1f4k52Yh0jd+V6+
         PkoLKLLd829/wBW4HbwprEWNTIBfIhTqg15e5hLAalRxl+Iv9XSDesdGJiVFG25J00bu
         n3ROJZLvQN6oHicVXqvustbOLOQWo6Yk0XE7aWJiaT0EP4bf+75QH9xExfDMmyPy1yqw
         0JEQ==
X-Gm-Message-State: AOAM530MGTTynK5BbBL07ceb6CpsowwQ96I0NRwAtTbejCBj8OlqR90N
        xuOw9JN9ffCBsFsHAKyV210=
X-Google-Smtp-Source: ABdhPJyChU/S2kUNguyGaLeciSzuqsilhL9JtF+8/0PQfUwA1qIAXOo5fWDuaXSyAJg4o2LfuEa9Mg==
X-Received: by 2002:a17:906:39da:b0:6cf:7f09:a7bc with SMTP id i26-20020a17090639da00b006cf7f09a7bcmr15515252eje.457.1647164841863;
        Sun, 13 Mar 2022 01:47:21 -0800 (PST)
Received: from [192.168.0.150] (xdsl-188-155-174-239.adslplus.ch. [188.155.174.239])
        by smtp.googlemail.com with ESMTPSA id r19-20020a17090638d300b006d6e4fc047bsm5435402ejd.11.2022.03.13.01.47.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Mar 2022 01:47:21 -0800 (PST)
Message-ID: <08b89b3f-d0d3-e96f-d1c3-80e8dfd0798f@kernel.org>
Date:   Sun, 13 Mar 2022 10:47:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v2 1/3] dt-bindings: net: mscc-miim: add lan966x
 compatible
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220313002536.13068-1-michael@walle.cc>
 <20220313002536.13068-2-michael@walle.cc>
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <20220313002536.13068-2-michael@walle.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/03/2022 01:25, Michael Walle wrote:
> The MDIO controller has support to release the internal PHYs from reset
> by specifying a second memory resource. This is different between the
> currently supported SparX-5 and the LAN966x. Add a new compatible to
> distiguish between these two.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  Documentation/devicetree/bindings/net/mscc-miim.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/mscc-miim.txt b/Documentation/devicetree/bindings/net/mscc-miim.txt
> index 7104679cf59d..a9efff252ca6 100644
> --- a/Documentation/devicetree/bindings/net/mscc-miim.txt
> +++ b/Documentation/devicetree/bindings/net/mscc-miim.txt
> @@ -2,7 +2,7 @@ Microsemi MII Management Controller (MIIM) / MDIO
>  =================================================
>  
>  Properties:
> -- compatible: must be "mscc,ocelot-miim"
> +- compatible: must be "mscc,ocelot-miim" or "mscc,lan966x-miim"

No wildcards, use one, specific compatible.

Best regards,
Krzysztof
