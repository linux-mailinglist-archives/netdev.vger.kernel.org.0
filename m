Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F69064A724
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 19:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbiLLSch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 13:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbiLLScG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 13:32:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71E717595;
        Mon, 12 Dec 2022 10:30:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88144611C2;
        Mon, 12 Dec 2022 18:30:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1996CC433F1;
        Mon, 12 Dec 2022 18:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670869800;
        bh=BJzMWseu2TKrkWXTG3+oF/opcZitJC3uFEXLhD8p4dM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iNfZF1XqOlvgflDZ5Y1E12KIZVnLW6mwFhm00J5W73WTT2k25U5hcbPzP0pMKbPUD
         kvGGAgUZBlQroU09zGoRQyVe+theVsCvywgrBQMgCFiJzMn1626N1WvPa4FLFJLGQS
         D7kCHk1llEQpgOMpN21x+/PTgYYaXsvZvQ6gHnqJNz6lPeFXaqPhgqp1BclTc0Bmat
         cQWyHOhAmDssl/H5rXq7Qm5TY8IfT63qGeuIZcTRS/zJj0IE/QyQIQ1ZQRW8YsfZJV
         v89T3p2Ceep0WuOU/CvtRpUav8zq/sLXNoPKqAMfVx0v/MvlIq565CPIXsLyza6J+8
         xVHVOjiiDatjg==
Date:   Mon, 12 Dec 2022 10:29:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [PATCH v5 net-next 00/10] dt-binding preparation for ocelot
 switches
Message-ID: <20221212102958.0948b360@kernel.org>
In-Reply-To: <20221210033033.662553-1-colin.foster@in-advantage.com>
References: <20221210033033.662553-1-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  9 Dec 2022 19:30:23 -0800 Colin Foster wrote:
> Ocelot switches have the abilitiy to be used internally via
> memory-mapped IO or externally via SPI or PCIe. This brings up issues
> for documentation, where the same chip might be accessed internally in a
> switchdev manner, or externally in a DSA configuration. This patch set
> is perparation to bring DSA functionality to the VSC7512, utilizing as
> much as possible with an almost identical VSC7514 chip.
> 
> This patch set changed quite a bit from v2, so I'll omit the background
> of how those sets came to be. Rob offered a lot of very useful guidance.
> My thanks.
> 
> At the end of the day, with this patch set, there should be a framework
> to document Ocelot switches (and any switch) in scenarios where they can
> be controlled internally (ethernet-switch) or externally (dsa-switch).

A lot of carried over review tags here, so please let me know if
there's anything that needs to be reviewed here, otherwise I'd like 
to merge the series for 6.2 by the end of the day.
