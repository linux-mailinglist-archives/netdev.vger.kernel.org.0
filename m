Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D8833F573
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 17:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbhCQQ1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 12:27:02 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:57652 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232414AbhCQQ04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 12:26:56 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4F0wXX6rD2z1qsk3;
        Wed, 17 Mar 2021 17:26:52 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4F0wXX3vJcz1r1M6;
        Wed, 17 Mar 2021 17:26:52 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id YctD_oGOxMZg; Wed, 17 Mar 2021 17:26:51 +0100 (CET)
X-Auth-Info: BJPL6qEHkuCb/9sVqThKDNGIxTNx8BWVAwSlhxULn3r36wRUu7V3tpRzX+a9DVs/
Received: from igel.home (ppp-46-244-172-178.dynamic.mnet-online.de [46.244.172.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Wed, 17 Mar 2021 17:26:51 +0100 (CET)
Received: by igel.home (Postfix, from userid 1000)
        id B287B2C30DD; Wed, 17 Mar 2021 17:26:49 +0100 (CET)
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
X-Yow:  Do I hear th' SPINNING of various WHIRRING, ROUND, and WARM
 WHIRLOMATICS?!
Date:   Wed, 17 Mar 2021 17:26:49 +0100
In-Reply-To: <04a7e801-9a55-c926-34ad-3a7665077a4e@microchip.com> (Claudiu
        Beznea's message of "Tue, 9 Mar 2021 08:55:10 +0000")
Message-ID: <87o8fhoieu.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It turned out to be a broken clock driver.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
"And now for something completely different."
