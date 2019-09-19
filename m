Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5B9AB8278
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 22:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390413AbfISUbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 16:31:46 -0400
Received: from smtp.duncanthrax.net ([89.31.1.170]:49170 "EHLO
        smtp.duncanthrax.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387854AbfISUbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 16:31:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=duncanthrax.net; s=dkim; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date;
        bh=a6NdcU33Bx4aQeV3CboJshOFL1ALJJW5J50WL/j+jj0=; b=PVsxZf+gY1CJZuDx2pQvZDM3Dq
        Ekwc9dtM4eCc5MxEIHXSSALJYFoFmNJL/86yi+1Zfcvxaeq+3O4WfMMLnBbThKAOj4yC1vmHC+8pb
        YTUwWPLV33v5FxTNE8l2Uz+uyKWN/LgCkJ3vTzN0nDGQm3TcE0JZF8tRr0xCI9UJn+vU=;
Received: from hsi-kbw-046-005-233-221.hsi8.kabel-badenwuerttemberg.de ([46.5.233.221] helo=t470p.stackframe.org)
        by smtp.eurescom.eu with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.86_2)
        (envelope-from <svens@stackframe.org>)
        id 1iB35S-00028A-Cx; Thu, 19 Sep 2019 22:31:34 +0200
Date:   Thu, 19 Sep 2019 22:31:32 +0200
From:   Sven Schnelle <svens@stackframe.org>
To:     Helge Deller <deller@gmx.de>
Cc:     John David Anglin <dave.anglin@bell.net>,
        Arlie Davis <arlied@google.com>, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: Re: Bug report (with fix) for DEC Tulip driver (de2104x.c)
Message-ID: <20190919203132.GA9107@t470p.stackframe.org>
References: <CAK-9enMxA68mRYFG=2zD02guvCqe-aa3NO0YZuJcTdBWn5MPqg@mail.gmail.com>
 <20190917212844.GJ9591@lunn.ch>
 <CAK-9enOx8xt_+t6-rpCGEL0j-HJGm=sFXYq9-pgHQ26AwrGm5Q@mail.gmail.com>
 <df0f961d-2d53-63e3-8087-6f0b09e14317@bell.net>
 <f71e9773-5cfb-f20b-956f-d98b11a5d4a7@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f71e9773-5cfb-f20b-956f-d98b11a5d4a7@gmx.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Sep 18, 2019 at 07:56:16AM +0200, Helge Deller wrote:
> On 18.09.19 00:51, John David Anglin wrote:
> > On 2019-09-17 5:36 p.m., Arlie Davis wrote:
> >> Likewise, I'm at a loss for testing with real hardware. It's hard to
> >> find such things, now.
> > How does de2104x compare to ds2142/43?  I have a c3750 with ds2142/43 tulip.  Helge
> > or some others might have a machine with a de2104x.
> 
> The machines we could test are
> * a C240 with a DS21140 tulip chip (Sven has one),

My C240 identifies as C240+:

[    0.000000] model 9000/782/C240+

which has a 21143 (verified by looking at the board):

root@c240:/# lspci -kvvnn -s 00:14.0
00:14.0 Ethernet controller [0200]: Digital Equipment Corporation DECchip 21142/43 [1011:0019] (rev 30)
	Subsystem: Hewlett-Packard Company DECchip 21142/43 [103c:104f]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 255 (5000ns min, 10000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 23
	Region 0: I/O ports at 0080 [size=128]
	Region 1: Memory at f2802000 (32-bit, non-prefetchable) [size=128]
	Expansion ROM at f2f80000 [disabled] [size=256K]
	Kernel driver in use: tulip

Regards
Sven
