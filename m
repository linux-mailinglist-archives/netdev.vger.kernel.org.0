Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0292913CC
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 21:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439277AbgJQTAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 15:00:15 -0400
Received: from smtprelay0208.hostedemail.com ([216.40.44.208]:36586 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2439239AbgJQTAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 15:00:13 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 15895182CED2A;
        Sat, 17 Oct 2020 19:00:10 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:967:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1434:1437:1515:1516:1518:1535:1542:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2525:2553:2561:2564:2682:2685:2693:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4470:4823:5007:6117:6742:6743:7576:7903:8660:8792:8957:9010:9025:9108:10004:10400:10450:10455:11232:11658:11914:12043:12050:12295:12296:12297:12438:12555:12663:12740:12760:12895:12986:13138:13148:13230:13231:13439:14096:14097:14181:14659:14721:19904:19999:21080:21324:21451:21627:21939:21990:30029:30034:30054:30070:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: jewel08_4005cbe27228
X-Filterd-Recvd-Size: 5179
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Sat, 17 Oct 2020 19:00:02 +0000 (UTC)
Message-ID: <503af4a57ca6daeb3e42a9be136dcd21e6d6e23d.camel@perches.com>
Subject: Re: [Cocci] [RFC] treewide: cleanup unreachable breaks
From:   Joe Perches <joe@perches.com>
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     trix@redhat.com, linux-kernel@vger.kernel.org,
        cocci <cocci@systeme.lip6.fr>, alsa-devel@alsa-project.org,
        clang-built-linux@googlegroups.com, linux-iio@vger.kernel.org,
        nouveau@lists.freedesktop.org, storagedev@microchip.com,
        dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org,
        keyrings@vger.kernel.org, linux-mtd@lists.infradead.org,
        ath10k@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        usb-storage@lists.one-eyed-alien.net,
        linux-watchdog@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvdimm@lists.01.org, amd-gfx@lists.freedesktop.org,
        linux-acpi@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        industrypack-devel@lists.sourceforge.net,
        linux-pci@vger.kernel.org, spice-devel@lists.freedesktop.org,
        MPT-FusionLinux.pdl@broadcom.com, linux-media@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-nfc@lists.01.org,
        linux-pm@vger.kernel.org, linux-can@vger.kernel.org,
        linux-block@vger.kernel.org, linux-gpio@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-amlogic@lists.infradead.org,
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
Date:   Sat, 17 Oct 2020 12:00:01 -0700
In-Reply-To: <alpine.DEB.2.22.394.2010172016370.9440@hadrien>
References: <20201017160928.12698-1-trix@redhat.com>
         <f530b7aeecbbf9654b4540cfa20023a4c2a11889.camel@perches.com>
         <alpine.DEB.2.22.394.2010172016370.9440@hadrien>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-10-17 at 20:21 +0200, Julia Lawall wrote:
> On Sat, 17 Oct 2020, Joe Perches wrote:
> > On Sat, 2020-10-17 at 09:09 -0700, trix@redhat.com wrote:
> > > From: Tom Rix <trix@redhat.com>
> > > 
> > > This is a upcoming change to clean up a new warning treewide.
> > > I am wondering if the change could be one mega patch (see below) or
> > > normal patch per file about 100 patches or somewhere half way by collecting
> > > early acks.
> > > 
> > > clang has a number of useful, new warnings see
> > > https://clang.llvm.org/docs/DiagnosticsReference.html
> > > 
> > > This change cleans up -Wunreachable-code-break
> > > https://clang.llvm.org/docs/DiagnosticsReference.html#wunreachable-code-break
> > > for 266 of 485 warnings in this week's linux-next, allyesconfig on x86_64.
> > 
> > Early acks/individual patches by subsystem would be good.
> > Better still would be an automated cocci script.
> 
> Coccinelle is not especially good at this, because it is based on control
> flow, and a return or goto diverts the control flow away from the break.
> A hack to solve the problem is to put an if around the return or goto, but
> that gives the break a meaningless file name and line number.  I collected
> the following list, but it only has 439 results, so fewer than clang.  But
> maybe there are some files that are not considered by clang in the x86
> allyesconfig configuration.
> 
> Probably checkpatch is the best solution here, since it is not
> configuration sensitive and doesn't care about control flow.

Likely the clang compiler is the best option here.

It might be useful to add -Wunreachable-code-break to W=1
or just always enable it if it isn't already enabled.

diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index 95e4cdb94fe9..3819787579d5 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -32,6 +32,7 @@ KBUILD_CFLAGS += $(call cc-option, -Wunused-but-set-variable)
 KBUILD_CFLAGS += $(call cc-option, -Wunused-const-variable)
 KBUILD_CFLAGS += $(call cc-option, -Wpacked-not-aligned)
 KBUILD_CFLAGS += $(call cc-option, -Wstringop-truncation)
+KBUILD_CFLAGS += $(call cc-option, -Wunreachable-code-break)
 # The following turn off the warnings enabled by -Wextra
 KBUILD_CFLAGS += -Wno-missing-field-initializers
 KBUILD_CFLAGS += -Wno-sign-compare

(and thank you Tom for pushing this forward)

checkpatch can't find instances like:

	case FOO:
		if (foo)
			return 1;
		else
			return 2;
		break;

As it doesn't track flow and relies on the number
of tabs to be the same for any goto/return and break;

checkpatch will warn on:

	case FOO:
		...
		goto bar;
		break;


