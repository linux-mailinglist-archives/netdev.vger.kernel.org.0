Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436BA33A364
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 08:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbhCNHTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 03:19:40 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:43765 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhCNHTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 03:19:19 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4DyrX3341cz1qs06;
        Sun, 14 Mar 2021 08:19:15 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4DyrX26Xqsz1qqkQ;
        Sun, 14 Mar 2021 08:19:14 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id kh2w0-FB6Dkc; Sun, 14 Mar 2021 08:19:13 +0100 (CET)
X-Auth-Info: eWvXQ3Lwpm1P/x9kl5BzLa1V9xuoSZOfCTBLeNF9IB1Mu5PfC0G9B/OAjqWFIdKx
Received: from hase.home (ppp-46-244-178-11.dynamic.mnet-online.de [46.244.178.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sun, 14 Mar 2021 08:19:13 +0100 (CET)
Received: by hase.home (Postfix, from userid 1000)
        id 60412102A82; Sun, 14 Mar 2021 08:19:12 +0100 (CET)
From:   Andreas Schwab <schwab@linux-m68k.org>
To:     Emil Renner Berthing <emil.renner.berthing@gmail.com>
Cc:     Claudiu.Beznea@microchip.com,
        linux-riscv <linux-riscv@lists.infradead.org>,
        ckeepax@opensource.cirrus.com, andrew@lunn.ch,
        Willy Tarreau <w@1wt.eu>,
        Nicolas Ferre <Nicolas.Ferre@microchip.com>, daniel@0x0f.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        pthombar@cadence.com, Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: macb broken on HiFive Unleashed
References: <87tupl30kl.fsf@igel.home>
        <04a7e801-9a55-c926-34ad-3a7665077a4e@microchip.com>
        <87y2euu6lf.fsf@igel.home>
        <CANBLGcyteTgQ2BgyesrTycpVqpPeYaiUCTEEp=KmPB0TPqK_LQ@mail.gmail.com>
X-Yow:  I'm a GENIUS!  I want to dispute sentence structure with SUSAN SONTAG!!
Date:   Sun, 14 Mar 2021 08:19:11 +0100
In-Reply-To: <CANBLGcyteTgQ2BgyesrTycpVqpPeYaiUCTEEp=KmPB0TPqK_LQ@mail.gmail.com>
        (Emil Renner Berthing's message of "Sat, 13 Mar 2021 22:54:02 +0100")
Message-ID: <87o8fm42z4.fsf@linux-m68k.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mär 13 2021, Emil Renner Berthing wrote:

> As you can see I haven't updated OpenSBI or u-boot in a while

Does it also work if you use the u-boot SPL instead of FSBL?

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
"And now for something completely different."
