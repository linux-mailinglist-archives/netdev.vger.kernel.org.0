Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9F1242950
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 14:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgHLMbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 08:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbgHLMbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 08:31:09 -0400
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9256C06174A
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 05:31:08 -0700 (PDT)
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTPSA id B9322140A47;
        Wed, 12 Aug 2020 14:31:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1597235463; bh=BhDXRw48Svg9+hnAUi9TFAEyRmmgSVy7Qlkw4e+RLrY=;
        h=Date:From:To;
        b=CbWTWpMYZBUjQ6iUw9EkRLFT72eA74hODGChDoLM+VKcw3377WV6iTlhjhd6uUcI6
         ZcA+M9BZibn2JJN8DeSbd9xwEAiTrTOlLGRqLLwGtHfxTlyikuXUdD0O7XBnqaw/C0
         tICknm3x7FUc+wrQZeCmDWV+uArJtGhsC1GRxhvM=
Date:   Wed, 12 Aug 2020 14:31:03 +0200
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC russell-king 0/4] Support for RollBall 10G copper
 SFP modules
Message-ID: <20200812143103.4c8100c6@dellmb.labs.office.nic.cz>
In-Reply-To: <20200811150808.GL1551@shell.armlinux.org.uk>
References: <20200810220645.19326-1-marek.behun@nic.cz>
        <20200811150808.GL1551@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Aug 2020 16:08:09 +0100
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> Are you sure they are 10GBASE-KR, and not 10GBASE-R ?  Please send me
> the contents of MMD 31 register 0xf001.  Also knowing MMD 1 registers
> 2 and 3 would be useful to confirm exactly which version of the PHY
> has been used.
> 
> Thanks.
> 

1f:f001 = 0x0004
01:0002 = 0x002b
01:0003 = 0x09ab

Marek
