Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124AD2BC814
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 19:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbgKVSXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 13:23:39 -0500
Received: from smtprelay0152.hostedemail.com ([216.40.44.152]:38070 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727938AbgKVSXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 13:23:37 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 524371802912B;
        Sun, 22 Nov 2020 18:23:34 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:4250:4321:5007:6691:6742:6743:7903:10004:10400:10848:11232:11658:11914:12296:12297:12740:12760:12895:13019:13069:13161:13229:13311:13357:13439:14040:14096:14097:14659:14721:21080:21324:21433:21451:21627:30012:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: match16_380b6892735e
X-Filterd-Recvd-Size: 3051
Received: from XPS-9350.home (unknown [47.151.128.180])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Sun, 22 Nov 2020 18:23:29 +0000 (UTC)
Message-ID: <dec07021e7fc11a02b14c98b713ae2c6e2a4ca00.camel@perches.com>
Subject: Re: [RFC] MAINTAINERS tag for cleanup robot
From:   Joe Perches <joe@perches.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Tom Rix <trix@redhat.com>, Matthew Wilcox <willy@infradead.org>
Cc:     clang-built-linux@googlegroups.com, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        tboot-devel@lists.sourceforge.net, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-acpi@vger.kernel.org,
        devel@acpica.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        netdev@vger.kernel.org, linux-media@vger.kernel.org,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        ecryptfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com, linux-mtd@lists.infradead.org,
        keyrings@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, alsa-devel@alsa-project.org,
        bpf@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-nfs@vger.kernel.org, patches@opensource.cirrus.com
Date:   Sun, 22 Nov 2020 10:23:28 -0800
In-Reply-To: <751803306cd957d0e7ef6a4fc3dbf12ebceaba92.camel@HansenPartnership.com>
References: <20201121165058.1644182-1-trix@redhat.com>
         <20201122032304.GE4327@casper.infradead.org>
         <ddb08a27-3ca1-fb2e-d51f-4b471f1a56a3@redhat.com>
         <20201122145635.GG4327@casper.infradead.org>
         <0819ce06-c462-d4df-d3d9-14931dc5aefc@redhat.com>
         <751803306cd957d0e7ef6a4fc3dbf12ebceaba92.camel@HansenPartnership.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-11-22 at 08:49 -0800, James Bottomley wrote:
> We can enforce sysfs_emit going forwards
> using tools like checkpatch

It's not really possible for checkpatch to find or warn about
sysfs uses of sprintf. checkpatch is really just a trivial
line-by-line parser and it has no concept of code intent.

It just can't warn on every use of the sprintf family.
There are just too many perfectly valid uses.

> but there's no benefit and a lot of harm to
> be done by trying to churn the entire tree

Single uses of sprintf for sysfs is not really any problem.

But likely there are still several possible overrun sprintf/snprintf
paths in sysfs.  Some of them are very obscure and unlikely to be
found by a robot as the logic for sysfs buf uses can be fairly twisty.

But provably correct conversions IMO _should_ be done and IMO churn
considerations should generally have less importance.



