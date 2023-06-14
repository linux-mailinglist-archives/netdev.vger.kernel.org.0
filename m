Return-Path: <netdev+bounces-10659-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0489B72F98F
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:44:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 361D41C204FD
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 09:44:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CEF06131;
	Wed, 14 Jun 2023 09:44:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42797612F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 09:44:17 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7B61BF7;
	Wed, 14 Jun 2023 02:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=1bTrGHwTGx8AoaffIHsoOzDc5pn8iydJ8fNJSHAyI8U=; b=eE641eTx1M25Z13+CfWphO6tiM
	Y6iHVc6HdtgORSY6acmlPjfvosffhpsW/RvzT/slR0ct3CTllDyA3DyIVK8oYvojZzU0uu3G5bTij
	wa3fl9yOEUPcBwxPznlc9XLVa83p2yla7BvO1vEWRRPk1/4sy5TPRl+TBo5b6ntq1BGxv3VaHu40B
	m4o9EZej81EgxgnBNmB7VxSrvzZWigXKSaVF3YDrL5v4rN3ndo2B8o2bBOU7rzrnkH1aCmpy5Jcwn
	HENiBUrZ8I316lhSd6E/cosF1mP5FLqWXSr84o0H06PzI7dGtWKgS+1tN4bMOAgQo1jhuSVMQtUz0
	gmb1UGLw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59466)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q9N2x-0001QR-M7; Wed, 14 Jun 2023 10:44:11 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q9N2v-0000K4-0A; Wed, 14 Jun 2023 10:44:09 +0100
Date: Wed, 14 Jun 2023 10:44:08 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+96a7f60bd78d03b6b991@syzkaller.appspotmail.com>,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
	Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: [syzbot] [net?] Internal error in ipvlan_get_L3_hdr
Message-ID: <ZImL6P7Nt2MufaVW@shell.armlinux.org.uk>
References: <00000000000057008505fe11fd2c@google.com>
 <CACT4Y+ZJBoU_QU0DMuH_rCRm8Cu-4jGr8hBpuBozyzhdghjFZg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+ZJBoU_QU0DMuH_rCRm8Cu-4jGr8hBpuBozyzhdghjFZg@mail.gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 10:49:16AM +0200, Dmitry Vyukov wrote:
> On Wed, 14 Jun 2023 at 09:35, syzbot
> <syzbot+96a7f60bd78d03b6b991@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    33f2b5785a2b Merge tag 'drm-fixes-2023-06-09' of git://ano..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1749d065280000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=869b244dcd5d983c
> > dashboard link: https://syzkaller.appspot.com/bug?extid=96a7f60bd78d03b6b991
> > compiler:       arm-linux-gnueabi-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > userspace arch: arm
> 
> +arm maintainers
> 
> #syz set subsystems: arm
> 
> ip6_output() is recursed 9 times in the stack.
> 
> Eric pointed out that:
> 
> #define MAX_NEST_DEV 8
> #define XMIT_RECURSION_LIMIT    8
> 
> So net stack can legitimately do this recursion and arm stack is 2x
> smaller than x86_64 stack (8K instead of 16K).
> 
> Should arm stack be increased? Or MAX_NEST_DEV/XMIT_RECURSION_LIMIT
> reduced for arm?

Do we guarantee that order-2 allocations will succeed on a 4k page-
sized system? It seems it would be a doubling of the chances of
failure.

Another solution would be to use vmalloc, but then I'd start to
worry about vmalloc space. With a 16k vmalloc allocation (plus
guard page and alignment) that'll be 32k per thread, and 32k
threads would be 512M, which for a 3G:1G user/kernel split is
too way too big, so I don't think vmalloc is an option.

Is there nothing that net can do to reduce its stack usage?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

