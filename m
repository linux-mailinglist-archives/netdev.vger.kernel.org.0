Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF2263DBE2
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiK3RYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiK3RY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:24:29 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8203729349;
        Wed, 30 Nov 2022 09:24:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1669828953; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=S/tfmU/bGGwQvtztH48Ct75lrbtqrXhXhFaZ/qxNerqJ91kUiHyxbc1jZgMG+4D0FKKkKH/4VQ3BLtqRTavpPoP0qk/GhDBztMZabk/SDYZC/2nEdVUnHFj4lt4oCEoZYdqNVJlYpWtQohH7Xk7iafENArs6IvnxKDn4lbCO+NY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1669828953; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=NbXEpZ0aVb9mBV+yGpUjXQNqRrz9CwkBfjyCJADEE7w=; 
        b=C23QGjP6pvzkPw8IT2Uuj+OI28I1OxDdVDda3ZHxJKaLJwmEtBXvApFXi3zZ/mEx84iI22v9FKFVcEQyP1mwTeNAA8c8CIyncscoEw3nyF5RjPbZJoaHJj5B5pIq3hX61yGE+U4Eyaav9m6qghMn5BR1/svu5KRcXCc4bCqS2NY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1669828952;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=NbXEpZ0aVb9mBV+yGpUjXQNqRrz9CwkBfjyCJADEE7w=;
        b=fgVncX7MMGMyEBfpkO8jiLauPmhaMoiVDaHCHtIu1b+XSbYbH5rq3QxvQ66+UjGq
        V03JuP9AIYknMLnVMBa8W3NqAG1KZGS1eLpr23f5DQnweBY5641jnmU3F92tMwbCwcF
        9EJMyICQRP12neK7zmEutFcDRBKbw0f9SP1sI86M=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1669828951728942.0277054948851; Wed, 30 Nov 2022 09:22:31 -0800 (PST)
Message-ID: <32638470-b074-3b14-bfb2-10b49307b9e3@arinc9.com>
Date:   Wed, 30 Nov 2022 20:22:15 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 0/5] remove label = "cpu" from DSA dt-binding
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        soc@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Stefan Agner <stefan@agner.ch>,
        Heiko Stuebner <heiko@sntech.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Tim Harvey <tharvey@gateworks.com>,
        Peng Fan <peng.fan@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Frank Wunderlich <frank-w@public-files.de>,
        Michael Riesch <michael.riesch@wolfvision.net>,
        Oleksij Rempel <linux@rempel-privat.de>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-sunxi@lists.linux.dev, linux-rockchip@lists.infradead.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <20221130141040.32447-1-arinc.unal@arinc9.com>
 <Y4d9B7VSHvqJn0iS@lunn.ch>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <Y4d9B7VSHvqJn0iS@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.11.2022 18:55, Andrew Lunn wrote:
> On Wed, Nov 30, 2022 at 05:10:35PM +0300, Arınç ÜNAL wrote:
>> Hello folks,
>>
>> With this patch series, we're completely getting rid of 'label = "cpu";'
>> which is not used by the DSA dt-binding at all.
>>
>> Information for taking the patches for maintainers:
>> Patch 1: netdev maintainers (based off netdev/net-next.git main)
>> Patch 2-3: SoC maintainers (based off soc/soc.git soc/dt)
>> Patch 4: MIPS maintainers (based off mips/linux.git mips-next)
>> Patch 5: PowerPC maintainers (based off powerpc/linux.git next-test)
> 
> Hi Arınç
> 
> So your plan is that each architecture maintainer merges one patch?

Initially, I sent this series to soc@kernel.org to take it all but Rob 
said it must be this way instead.

> 
> That is fine, but it is good to be explicit, otherwise patches will
> fall through the cracks because nobody picks them up. I generally use
> To: to indicate who i expect to merge a patch, and everybody else in
> the Cc:

Thanks for this, I'll follow suit if I don't see any activity for a few 
weeks.

> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
>      Andrew

Arınç
