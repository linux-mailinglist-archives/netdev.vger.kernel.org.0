Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECF5256A25
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 22:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbgH2UeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 16:34:07 -0400
Received: from smtprelay0042.hostedemail.com ([216.40.44.42]:60978 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728464AbgH2UeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Aug 2020 16:34:05 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 4AD2918225DF6;
        Sat, 29 Aug 2020 20:34:03 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2110:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3872:3874:4184:4321:5007:6691:6742:6743:10004:10400:10848:11232:11658:11914:12048:12297:12663:12740:12760:12895:13069:13311:13357:13439:14180:14181:14659:14721:21060:21080:21433:21627:30054:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: head85_181739b27081
X-Filterd-Recvd-Size: 3499
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Sat, 29 Aug 2020 20:33:57 +0000 (UTC)
Message-ID: <b64a4cb0ee68fee01973616e5ef0f299ac191f6d.camel@perches.com>
Subject: Re: sysfs output without newlines
From:   Joe Perches <joe@perches.com>
To:     Denis Efremov <efremov@linux.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Alex Dewar <alex.dewar90@gmail.com>
Cc:     York Sun <york.sun@nxp.com>, Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Alex Dubov <oakad@yahoo.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Douglas Miller <dougmill@linux.ibm.com>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Kai =?ISO-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mark Brown <broonie@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Pete Zaitcev <zaitcev@redhat.com>, linux-edac@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-i3c@lists.infradead.org, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-usb@vger.kernel.org
Date:   Sat, 29 Aug 2020 13:33:56 -0700
In-Reply-To: <4cd6275c-6e95-3aeb-9924-141f62e00449@linux.com>
References: <0f837bfb394ac632241eaac3e349b2ba806bce09.camel@perches.com>
         <4cd6275c-6e95-3aeb-9924-141f62e00449@linux.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-08-29 at 23:23 +0300, Denis Efremov wrote:
> Hi,
> 
> On 8/29/20 9:23 PM, Joe Perches wrote:
> > While doing an investigation for a possible treewide conversion of
> > sysfs output using sprintf/snprintf/scnprintf, I discovered
> > several instances of sysfs output without terminating newlines.
> > 
> > It seems likely all of these should have newline terminations
> > or have the \n\r termination changed to a single newline.
> 
> I think that it could break badly written scripts in rare cases.

Maybe.

Is sysfs output a nominally unchangeable api like seq_?
Dunno.  seq_ output is extended all the time.

I think whitespace isn't generally considered part of
sscanf type input content awareness.

> > Anyone have any objection to patches adding newlines to these
> > in their original forms using sprintf/snprintf/scnprintf?
> 
> I'm not sure about existing cases, but I think it's a good
> checkpatch.pl warning for new patches. It should be 
> possible to check sysfs_emit() calls.

Eventually, yes.

cheers, Joe

