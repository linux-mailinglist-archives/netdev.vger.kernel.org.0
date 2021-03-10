Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B080433485F
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbhCJTz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232901AbhCJTzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 14:55:17 -0500
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6B7C061760;
        Wed, 10 Mar 2021 11:55:16 -0800 (PST)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4DwjV73mSDz1rxLc;
        Wed, 10 Mar 2021 20:55:11 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4DwjV70ntJz1t6pv;
        Wed, 10 Mar 2021 20:55:11 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id p9Tj1_pKEKj4; Wed, 10 Mar 2021 20:55:10 +0100 (CET)
X-Auth-Info: m9ayv+O76G84j3AzcsOX0vzMJdRHnzApJZPy8u31ICEk+Rpgd5FTh2R3WpcFQzHT
Received: from igel.home (ppp-46-244-173-168.dynamic.mnet-online.de [46.244.173.168])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Wed, 10 Mar 2021 20:55:10 +0100 (CET)
Received: by igel.home (Postfix, from userid 1000)
        id D7D0D2C3762; Wed, 10 Mar 2021 20:55:08 +0100 (CET)
From:   Andreas Schwab <schwab@linux-m68k.org>
To:     <Claudiu.Beznea@microchip.com>
Cc:     <linux-riscv@lists.infradead.org>, <ckeepax@opensource.cirrus.com>,
        <andrew@lunn.ch>, <w@1wt.eu>, <Nicolas.Ferre@microchip.com>,
        <daniel@0x0f.com>, <alexandre.belloni@bootlin.com>,
        <pthombar@cadence.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: macb broken on HiFive Unleashed
References: <87tupl30kl.fsf@igel.home>
        <04a7e801-9a55-c926-34ad-3a7665077a4e@microchip.com>
X-Yow:  YOW!!  What should the entire human race DO??  Consume a fifth
 of CHIVAS REGAL, ski NUDE down MT. EVEREST, and have a wild
 SEX WEEKEND!
Date:   Wed, 10 Mar 2021 20:55:08 +0100
In-Reply-To: <04a7e801-9a55-c926-34ad-3a7665077a4e@microchip.com> (Claudiu
        Beznea's message of "Tue, 9 Mar 2021 08:55:10 +0000")
Message-ID: <87y2euu6lf.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mär 09 2021, Claudiu.Beznea@microchip.com wrote:

> I don't have a SiFive HiFive Unleashed to investigate this. Can you check
> if reverting commits on macb driver b/w 5.10 and 5.11 solves your issues:
>
> git log --oneline v5.10..v5.11 -- drivers/net/ethernet/cadence/
> 1d0d561ad1d7 net: macb: Correct usage of MACB_CAPS_CLK_HW_CHG flag
> 1d608d2e0d51 Revert "macb: support the two tx descriptors on at91rm9200"
> 700d566e8171 net: macb: add support for sama7g5 emac interface
> ec771de654e4 net: macb: add support for sama7g5 gem interface
> f4de93f03ed8 net: macb: unprepare clocks in case of failure
> 38493da4e6a8 net: macb: add function to disable all macb clocks
> daafa1d33cc9 net: macb: add capability to not set the clock rate
> edac63861db7 net: macb: add userio bits as platform configuration
> 9e6cad531c9d net: macb: Fix passing zero to 'PTR_ERR'
> 0012eeb370f8 net: macb: fix NULL dereference due to no pcs_config method
> e4e143e26ce8 net: macb: add support for high speed interface

Unfortunately, that didn't help.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
"And now for something completely different."
