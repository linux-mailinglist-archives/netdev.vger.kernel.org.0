Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E0D3417C3
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 09:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhCSIwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 04:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbhCSIv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 04:51:58 -0400
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4A2C06174A;
        Fri, 19 Mar 2021 01:51:57 -0700 (PDT)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4F1yLf4vCtz1ryXl;
        Fri, 19 Mar 2021 09:51:54 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4F1yLf1zZYz1sP6g;
        Fri, 19 Mar 2021 09:51:54 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id MpU8k5-xFkaL; Fri, 19 Mar 2021 09:51:53 +0100 (CET)
X-Auth-Info: DlswMWnw3C8i5v/0U2HHpEfL8e7xsZsM+rvbYAK5w1NvYv1+pMZ11EtmPpv8SaHo
Received: from igel.home (ppp-46-244-191-242.dynamic.mnet-online.de [46.244.191.242])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri, 19 Mar 2021 09:51:53 +0100 (CET)
Received: by igel.home (Postfix, from userid 1000)
        id D5DAF2C3171; Fri, 19 Mar 2021 09:51:52 +0100 (CET)
From:   Andreas Schwab <schwab@linux-m68k.org>
To:     Yixun Lan <yixun.lan@gmail.com>
Cc:     Claudiu.Beznea@microchip.com, linux-riscv@lists.infradead.org,
        ckeepax@opensource.cirrus.com, andrew@lunn.ch, w@1wt.eu,
        Nicolas.Ferre@microchip.com, daniel@0x0f.com,
        alexandre.belloni@bootlin.com, pthombar@cadence.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: macb broken on HiFive Unleashed
References: <87tupl30kl.fsf@igel.home>
        <04a7e801-9a55-c926-34ad-3a7665077a4e@microchip.com>
        <87o8fhoieu.fsf@igel.home>
        <CALecT5gY1GK774TXyM+zA3J9Q8O90UKMs3bvRk13yg9_+cFO3Q@mail.gmail.com>
X-Yow:  I wonder if I should put myself in ESCROW!!
Date:   Fri, 19 Mar 2021 09:51:52 +0100
In-Reply-To: <CALecT5gY1GK774TXyM+zA3J9Q8O90UKMs3bvRk13yg9_+cFO3Q@mail.gmail.com>
        (Yixun Lan's message of "Fri, 19 Mar 2021 08:28:06 +0000")
Message-ID: <87h7l77cgn.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mär 19 2021, Yixun Lan wrote:

> what's the exact root cause? and any solution?

Try reverting the five commits starting with
732374a0b440d9a79c8412f318a25cd37ba6f4e2.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
"And now for something completely different."
