Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD63291921
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 21:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbgJRTGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 15:06:55 -0400
Received: from smtprelay0246.hostedemail.com ([216.40.44.246]:51812 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726249AbgJRTGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 15:06:53 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 70CB3100E7B40;
        Sun, 18 Oct 2020 19:06:49 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:967:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2525:2553:2561:2564:2682:2685:2692:2828:2859:2905:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:6119:6742:6743:7903:8957:8985:9025:10004:10400:10848:11232:11658:11914:12043:12295:12297:12438:12555:12740:12760:12895:12986:13069:13072:13311:13357:13439:14096:14097:14181:14659:14721:14777:21080:21347:21433:21451:21627:21811:21819:30003:30012:30022:30034:30054:30083:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: year67_630d5f827230
X-Filterd-Recvd-Size: 3209
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf09.hostedemail.com (Postfix) with ESMTPA;
        Sun, 18 Oct 2020 19:06:42 +0000 (UTC)
Message-ID: <18981cad4ac27b4a22b2e38d40bd112432d4a4e7.camel@perches.com>
Subject: Re: [Ocfs2-devel] [RFC] treewide: cleanup unreachable breaks
From:   Joe Perches <joe@perches.com>
To:     Matthew Wilcox <willy@infradead.org>, trix@redhat.com
Cc:     linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        clang-built-linux@googlegroups.com, linux-iio@vger.kernel.org,
        nouveau@lists.freedesktop.org, storagedev@microchip.com,
        dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org,
        keyrings@vger.kernel.org, linux-mtd@lists.infradead.org,
        ath10k@lists.infradead.org, MPT-FusionLinux.pdl@broadcom.com,
        linux-stm32@st-md-mailman.stormreply.com,
        usb-storage@lists.one-eyed-alien.net,
        linux-watchdog@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvdimm@lists.01.org, amd-gfx@lists.freedesktop.org,
        linux-acpi@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        industrypack-devel@lists.sourceforge.net,
        linux-pci@vger.kernel.org, spice-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-nfc@lists.01.org, linux-pm@vger.kernel.org,
        linux-can@vger.kernel.org, linux-block@vger.kernel.org,
        linux-gpio@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-amlogic@lists.infradead.org,
        openipmi-developer@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org, patches@opensource.cirrus.com,
        bpf@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-power@fi.rohmeurope.com
Date:   Sun, 18 Oct 2020 12:06:40 -0700
In-Reply-To: <20201018185943.GM20115@casper.infradead.org>
References: <20201017160928.12698-1-trix@redhat.com>
         <20201018185943.GM20115@casper.infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-10-18 at 19:59 +0100, Matthew Wilcox wrote:
> On Sat, Oct 17, 2020 at 09:09:28AM -0700, trix@redhat.com wrote:
> > clang has a number of useful, new warnings see
> > https://urldefense.com/v3/__https://clang.llvm.org/docs/DiagnosticsReference.html__;!!GqivPVa7Brio!Krxz78O3RKcB9JBMVo_F98FupVhj_jxX60ddN6tKGEbv_cnooXc1nnBmchm-e_O9ieGnyQ$ 
> 
> Please get your IT department to remove that stupidity.  If you can't,
> please send email from a non-Red Hat email address.

I didn't get it this way, neither did lore.
It's on your end.

https://lore.kernel.org/lkml/20201017160928.12698-1-trix@redhat.com/

> I don't understand why this is a useful warning to fix.

Precision in coding style intent and code minimization
would be the biggest factors IMO.

> What actual problem is caused by the code below?

Obviously none.


