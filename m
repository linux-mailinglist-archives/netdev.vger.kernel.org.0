Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246DE33174D
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 20:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhCHTav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 14:30:51 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:47034 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231380AbhCHTaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 14:30:39 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4DvT2h6nBtz1qs0p;
        Mon,  8 Mar 2021 20:30:36 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4DvT2h1kCGz1r1MM;
        Mon,  8 Mar 2021 20:30:36 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id cl5ab6GjaR9i; Mon,  8 Mar 2021 20:30:35 +0100 (CET)
X-Auth-Info: PggnRC1U8X6v26ElHBvfHF0XfyNGljdktgHw+hS7EGtM5kU/rPFSXSjx3wo4wT+l
Received: from igel.home (ppp-46-244-182-153.dynamic.mnet-online.de [46.244.182.153])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Mon,  8 Mar 2021 20:30:35 +0100 (CET)
Received: by igel.home (Postfix, from userid 1000)
        id 6E1FB2C37BA; Mon,  8 Mar 2021 20:30:34 +0100 (CET)
From:   Andreas Schwab <schwab@linux-m68k.org>
To:     linux-riscv@lists.infradead.org
Subject: macb broken on HiFive Unleashed
CC:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Andrew Lunn <andrew@lunn.ch>, Willy Tarreau <w@1wt.eu>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Daniel Palmer <daniel@0x0f.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Parshuram Thombare <pthombar@cadence.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Yow:  Who wants some OYSTERS with SEN-SEN an' COOL WHIP?
Date:   Mon, 08 Mar 2021 20:30:34 +0100
Message-ID: <87tupl30kl.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One of the changes to the macb driver between 5.10 and 5.11 has broken
the SiFive HiFive Unleashed.  These are the last messages before the
system hangs:

[   12.468674] libphy: Fixed MDIO Bus: probed
[   12.746518] macb 10090000.ethernet: Registered clk switch 'sifive-gemgxl-mgmt'
[   12.753119] macb 10090000.ethernet: GEM doesn't support hardware ptp.
[   12.760178] libphy: MACB_mii_bus: probed
[   12.881792] MACsec IEEE 802.1AE
[   12.944426] macb 10090000.ethernet eth0: Cadence GEM rev 0x10070109 at 0x10090000 irq 16 (70:b3:d5:92:f1:07)

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
"And now for something completely different."
