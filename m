Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8AA52213F
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 18:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347385AbiEJQe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 12:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347422AbiEJQe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 12:34:26 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25ACD2A28F7;
        Tue, 10 May 2022 09:30:22 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id cu23-20020a17090afa9700b001d98d8e53b7so2261380pjb.0;
        Tue, 10 May 2022 09:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nmTwo0VlGN7HZAEkbWFLYNGP+DbFScpw15RdeNhAOsM=;
        b=qMCb6EA6TVj1ZK4i4rl/lUDMseHdpoxbJATbR6ben/NEwzK95Ap98M+yg9DJpq4d7M
         5BUqzE4bgssTbTyEID5eYtcQ8m3H2eBYuyEE7IlCgmr02G/Zb95HQy3TAZXue71yDlrV
         M9sC7hSQQO7Sp3yz+9+2N9h+L51HPoafgeMVnx9kL8q6tvHcay5Vwa4U+ERUmeWWZ8v8
         /aIiRgaZ4N09/kZETp9vIS1yhv0b4xcaqSUjgFbnmnhLD8Q6Les4ZUMPQ380fX8dmkRX
         gVtg3+LQLp1GFPNB8t1YBRaQbXWrNSPMQio8AAeTYRudwa33AA0M6pN3Ljwh6aj24XCs
         1/lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nmTwo0VlGN7HZAEkbWFLYNGP+DbFScpw15RdeNhAOsM=;
        b=dBIyVwqvG4cX8xYUINsj9kovoKx/dOt7nsHybIu6IbA0jYGfd+JgY8cF5hVTQwSE8S
         S2UT+at6VUDduLqkqzCN1xUjQLk0mVE89J9m4u3rrMkH9EwYHo7NmaaXhKIepVOruLZH
         5DqKpYIyYwvSviAeKbv4rYvl2EjUfbg7b1Ga0Io/4+6LIyygVPu9Pi3EiRmO6Md565FQ
         MCk8otZOyCihPYSe9P38xTReWMA+ysdqKfIPyo6aNV5jp2VXIECCL3eMXfLZU8Pvj/E/
         Fa/0WXja3sQ35t1dqSYrZnYf0AAM1/cZQed/br1mJVGeAC9L1XmJ6gSADjFNjKuavjhV
         mdCA==
X-Gm-Message-State: AOAM532APkKiIDQadlDFbJ5OV1q9PVjFv3i8IBl0ZwrqzzXNDTAFpM8S
        yWaA2vLsR2oxpCU3hqR/u20=
X-Google-Smtp-Source: ABdhPJzthHrKIyJiyo3f4D4rf/UY0bGjefzB0w9VP88JxxNfui2ZBhjOs9clpHhgT62RFv260NQxQQ==
X-Received: by 2002:a17:90b:610:b0:1d9:4008:cfee with SMTP id gb16-20020a17090b061000b001d94008cfeemr752504pjb.71.1652200221607;
        Tue, 10 May 2022 09:30:21 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id cr11-20020a056a000f0b00b00510c135da63sm1680324pfb.9.2022.05.10.09.30.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 09:30:21 -0700 (PDT)
Message-ID: <1b097089-d6e6-5622-15aa-7038b66b1367@gmail.com>
Date:   Tue, 10 May 2022 09:30:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next v4 00/12] add support for Renesas RZ/N1 ethernet
 subsystem devices
Content-Language: en-US
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?Q?Miqu=c3=a8l_Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
References: <20220509131900.7840-1-clement.leger@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220509131900.7840-1-clement.leger@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/9/22 06:18, Clément Léger wrote:
> The Renesas RZ/N1 SoCs features an ethernet subsystem which contains
> (most notably) a switch, two GMACs, and a MII converter [1]. This
> series adds support for the switch and the MII converter.
> 
> The MII converter present on this SoC has been represented as a PCS
> which sit between the MACs and the PHY. This PCS driver is probed from
> the device-tree since it requires to be configured. Indeed the MII
> converter also contains the registers that are handling the muxing of
> ports (Switch, MAC, HSR, RTOS, etc) internally to the SoC.
> 
> The switch driver is based on DSA and exposes 4 ports + 1 CPU
> management port. It include basic bridging support as well as FDB and
> statistics support.
> 
> This series needs commits 14f11da778ff6421 ("soc: renesas: rzn1: Select
> PM and PM_GENERIC_DOMAINS configs") and ed66b37f916ee23b ("ARM: dts:
> r9a06g032: Add missing '#power-domain-cells'") which are available on
> the renesas-devel tree in order to enable generic power domain on
> RZ/N1.
> 
> Link: [1] https://www.renesas.com/us/en/document/mah/rzn1d-group-rzn1s-group-rzn1l-group-users-manual-r-engine-and-ethernet-peripherals
Build testing this patch set gave me the following Kconfig warnings:

WARNING: unmet direct dependencies detected for PCS_RZN1_MIIC
   Depends on [n]: NETDEVICES [=y] && (ARCH_RZN1 [=n] || COMPILE_TEST [=n])
   Selected by [m]:
   - NET_DSA_RZN1_A5PSW [=m] && NETDEVICES [=y] && NET_DSA [=m]

WARNING: unmet direct dependencies detected for PCS_RZN1_MIIC
   Depends on [n]: NETDEVICES [=y] && (ARCH_RZN1 [=n] || COMPILE_TEST [=n])
   Selected by [m]:
   - NET_DSA_RZN1_A5PSW [=m] && NETDEVICES [=y] && NET_DSA [=m]

WARNING: unmet direct dependencies detected for PCS_RZN1_MIIC
   Depends on [n]: NETDEVICES [=y] && (ARCH_RZN1 [=n] || COMPILE_TEST [=n])
   Selected by [m]:
   - NET_DSA_RZN1_A5PSW [=m] && NETDEVICES [=y] && NET_DSA [=m]

I started off with arm64's defconfig and then enabled all of the DSA 
drivers.
-- 
Florian
