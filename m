Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6785D69A2F4
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 01:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbjBQAcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 19:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjBQAcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 19:32:53 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1F365BF;
        Thu, 16 Feb 2023 16:32:51 -0800 (PST)
Received: from [192.168.1.90] (unknown [86.120.32.152])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: cristicc)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 2189766020BD;
        Fri, 17 Feb 2023 00:32:48 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1676593969;
        bh=Pijk7J1JiCVDIPHd1Fu56Q59b7X2BTHU0d+zzfSw4ok=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=R2YHuHryIxI4sX2DHvXuf3KkHJD0wdjhm5wp/kDeuQ1BcrJNTcNmeQunFVnY4zdAs
         uTQOGAl5b/d/h7z6f6tfbukkf5pEC+9omQGycaFq8ETbHgv9NFKIQaxQcDv3QEotNs
         2U5oXYEiCqKvOl9eqGHT+AeXqkuKIJZHwEjpIvOB2Sa9HhzhgvFfPXT4RtlKegzlah
         ZpcJWmvUYMyQxYyzZfdcZOUodk/yfGp5SwUOtDRVS3GQBvcxq01CQgBDOgWHPKhSkN
         OAGvg9p1k+jg6j0+p6EWD1tkh3ghxG3KHv5Aq31mk5CpBrQ2PPIIyohNjZoTTEp114
         2EKZugb5oSkmA==
Message-ID: <a824a7f6-0a62-7cab-180b-f20297311a2b@collabora.com>
Date:   Fri, 17 Feb 2023 02:32:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH 07/12] dt-bindings: net: Add StarFive JH7100 SoC
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sagar Kadam <sagar.kadam@sifive.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
 <20230211031821.976408-8-cristian.ciocaltea@collabora.com>
 <Y+e74UIV/Td91lKB@lunn.ch>
 <586971af-2d78-456d-a605-6c7b2aefda91@collabora.com>
 <Y+zXv90rGfQupjPP@lunn.ch>
 <cfa0f980-4bb6-4419-909c-3fce697cf8f9@collabora.com>
 <Y+5t4Jlb0ytw40pu@lunn.ch>
From:   Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
In-Reply-To: <Y+5t4Jlb0ytw40pu@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/16/23 19:54, Andrew Lunn wrote:
>> I gave "rgmii-id" a try and it's not usable, I get too many errors. So
>> "rgmii" should be the right choice here.
> 
> I would actually say it shows we don't understand what is going on
> with delays. "rgmii" is not every often the correct value. The fact it
> works suggests the MAC is adding delays.
> 
> What value are you using for starfive,gtxclk-dlychain ? 

This is set to '4' in patch 12/12.

> Try 0 and then "rgmii-id"

I made some more tests and it seems the only stable configuration is 
"rgmii" with "starfive,gtxclk-dlychain" set to 4:

phy-mode | dlychain | status
---------+----------+--------------------------------------------
rgmii    |        4 | OK (no issues observed)
rgmii-id |        4 | BROKEN (errors reported [1])
rgmii    |        0 | UNRELIABLE (no errors, but frequent stalls)
rgmii-id |        0 | BROKEN (errors reported)

[1] Reported errors in case of BROKEN status:
$ grep '' /sys/class/net/eth0/statistics/* | grep -v ':0$'

/sys/class/net/eth0/statistics/rx_crc_errors:6
/sys/class/net/eth0/statistics/rx_errors:6
/sys/class/net/eth0/statistics/tx_bytes:10836
/sys/class/net/eth0/statistics/tx_packets:46

> 	Andrew			
> 
