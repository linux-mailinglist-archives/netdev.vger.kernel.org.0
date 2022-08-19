Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85F73599998
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 12:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347069AbiHSKTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 06:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245098AbiHSKTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 06:19:18 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1760E9AAA
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 03:19:16 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id e21so245603edc.7
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 03:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=9PRzllhJrW4nda04MMqcFq+A4kf3qNJ7A/iPe2SNAl4=;
        b=IItieutfPGt23hFObB/TZJun7PFuvTWPN6vHP6pMhOYuKXX0A1Po58zBIm4263y40S
         U1iCTQd43csg2YBdUvD5KwjHvySrLwV/jOioiye2YVgkNx2lQ+x8ZdZmrwABMsSnrnsW
         jTeBjeH/yny/7ix5tgm+IbDmUc6eulEOpyQ/M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=9PRzllhJrW4nda04MMqcFq+A4kf3qNJ7A/iPe2SNAl4=;
        b=VY1ZMuY6io+pnOJOv2xMhV5X7i4uJUCQb6dAlKNyjN/oVWCFtPyEO+PUTWPhGSoQTa
         uKAuPCN+/L848dGWYKDbuN14YkiQ+njo7tUYFww4IS+mojy3uBaJinJxx7W/3I41TkAb
         0uRBCaENVN4nGx2uEX0PEEIsRAADxDXIEKdFacWGmv9pa2nkMrSUpM+YejwxzNd+sclt
         kU3cikzg+Y7QbpjPIOpG3E9MZ25wps5Hr+BuKJaWBwrLA/JTLnE6Tyy02qKkFGT766CD
         WhyKiGrtM07+wmHMxRaTo0Ox/EXPDIW2kEyW3Wc1U+19qffnHlN2FMSSiaspdUZKVxbY
         Ex/g==
X-Gm-Message-State: ACgBeo2XTTDle73qBDXplXVHV/Driuo1WTadeTd328IOYSLgFaOZ85QC
        WCCbGvYJYUvSrAnGPRKd8JE1PjCMDpjI3qF1
X-Google-Smtp-Source: AA6agR7RVmAAb1tfYBQPkofP5JnvVJCloBnrjd53m9KmpmnCbOR0IlEg0RgcTKXmwi08jsYeebBj6A==
X-Received: by 2002:a05:6402:d06:b0:440:3e9d:77d with SMTP id eb6-20020a0564020d0600b004403e9d077dmr5347471edb.286.1660904355201;
        Fri, 19 Aug 2022 03:19:15 -0700 (PDT)
Received: from [172.16.11.74] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id cy2-20020a0564021c8200b00443d8118155sm2805970edb.69.2022.08.19.03.19.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Aug 2022 03:19:14 -0700 (PDT)
Message-ID: <095c6c01-d4dd-8275-19fc-f9fe1ea40ab8@rasmusvillemoes.dk>
Date:   Fri, 19 Aug 2022 12:19:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] net: dsa: microchip: keep compatibility with device
 tree blobs with no phy-mode
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Craig McQueen <craig@mcqueen.id.au>
References: <20220818143250.2797111-1-vladimir.oltean@nxp.com>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
In-Reply-To: <20220818143250.2797111-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/08/2022 16.32, Vladimir Oltean wrote:
> DSA has multiple ways of specifying a MAC connection to an internal PHY.
> One requires a DT description like this:
> 
> 	port@0 {
> 		reg = <0>;
> 		phy-handle = <&internal_phy>;
> 		phy-mode = "internal";
> 	};
> 
> (which is IMO the recommended approach, as it is the clearest
> description)
> 
> but it is also possible to leave the specification as just:
> 
> 	port@0 {
> 		reg = <0>;
> 	}
> 
> and if the driver implements ds->ops->phy_read and ds->ops->phy_write,
> the DSA framework "knows" it should create a ds->slave_mii_bus, and it
> should connect to a non-OF-based internal PHY on this MDIO bus, at an
> MDIO address equal to the port address.
> 
> There is also an intermediary way of describing things:
> 
> 	port@0 {
> 		reg = <0>;
> 		phy-handle = <&internal_phy>;
> 	};

Well, there's also e.g. arch/arm/boot/dts/at91-sama5d3_ksz9477_evb.dts
which sets the phy-mode but not the phy-handle:

                        port@0 {
                                reg = <0>;
                                label = "lan1";
                                phy-mode = "internal";
                        };

And doing that in my case seems to fix things (I wouldn't know what
phy-handle to point at anyway), so since we're still in development, I
think I'll do that. But if I want to follow the new-world-order to the
letter, should I also figure out a way to point at a phy-handle?
> Fixes: 2c709e0bdad4 ("net: dsa: microchip: ksz8795: add phylink support")
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=216320
> Reported-by: Craig McQueen <craig@mcqueen.id.au>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

I've also tested this patch on top of v5.19 without altering my .dts,
and that also seems to fix things, so I suppose you can add

Fixes: 65ac79e18120 ("net: dsa: microchip: add the phylink get_caps")
Tested-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Thanks,
Rasmus
