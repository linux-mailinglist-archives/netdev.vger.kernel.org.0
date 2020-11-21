Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5EA2BC0DE
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 18:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgKURKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 12:10:19 -0500
Received: from smtprelay0130.hostedemail.com ([216.40.44.130]:44438 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726281AbgKURKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 12:10:17 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id C09E2837F24A;
        Sat, 21 Nov 2020 17:10:14 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:967:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1801:2198:2199:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4043:4321:4605:5007:6117:6119:6742:6743:7809:7875:8660:9010:9025:10004:10400:10848:11232:11473:11658:11783:11914:12043:12295:12297:12555:12663:12679:12740:12895:12986:13148:13230:13439:13845:13894:14181:14659:14721:21080:21324:21451:21627:21811:21939:21987:30012:30054:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: crook72_110ffeb27355
X-Filterd-Recvd-Size: 4090
Received: from XPS-9350.home (unknown [47.151.128.180])
        (Authenticated sender: joe@perches.com)
        by omf05.hostedemail.com (Postfix) with ESMTPA;
        Sat, 21 Nov 2020 17:10:09 +0000 (UTC)
Message-ID: <2105f0c05e9eae8bee8e17dcc5314474b3c0bc73.camel@perches.com>
Subject: Re: [RFC] MAINTAINERS tag for cleanup robot
From:   Joe Perches <joe@perches.com>
To:     trix@redhat.com, clang-built-linux@googlegroups.com
Cc:     linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, tboot-devel@lists.sourceforge.net,
        kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-acpi@vger.kernel.org, devel@acpica.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-media@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-wireless@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        ecryptfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com, linux-mtd@lists.infradead.org,
        keyrings@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, alsa-devel@alsa-project.org,
        bpf@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-nfs@vger.kernel.org, patches@opensource.cirrus.com
Date:   Sat, 21 Nov 2020 09:10:08 -0800
In-Reply-To: <20201121165058.1644182-1-trix@redhat.com>
References: <20201121165058.1644182-1-trix@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-11-21 at 08:50 -0800, trix@redhat.com wrote:
> A difficult part of automating commits is composing the subsystem
> preamble in the commit log.  For the ongoing effort of a fixer producing
> one or two fixes a release the use of 'treewide:' does not seem appropriate.
> 
> It would be better if the normal prefix was used.  Unfortunately normal is
> not consistent across the tree.
> 
> So I am looking for comments for adding a new tag to the MAINTAINERS file
> 
> 	D: Commit subsystem prefix
> 
> ex/ for FPGA DFL DRIVERS
> 
> 	D: fpga: dfl:

I'm all for it.  Good luck with the effort.  It's not completely trivial.

From a decade ago:

https://lore.kernel.org/lkml/1289919077.28741.50.camel@Joe-Laptop/

(and that thread started with extra semicolon patches too)

> Continuing with cleaning up clang's -Wextra-semi-stmt

> diff --git a/Makefile b/Makefile
[]
> @@ -1567,20 +1567,21 @@ help:
>  	 echo  ''
>  	@echo  'Static analysers:'
>  	@echo  '  checkstack      - Generate a list of stack hogs'
>  	@echo  '  versioncheck    - Sanity check on version.h usage'
>  	@echo  '  includecheck    - Check for duplicate included header files'
>  	@echo  '  export_report   - List the usages of all exported symbols'
>  	@echo  '  headerdep       - Detect inclusion cycles in headers'
>  	@echo  '  coccicheck      - Check with Coccinelle'
>  	@echo  '  clang-analyzer  - Check with clang static analyzer'
>  	@echo  '  clang-tidy      - Check with clang-tidy'
> +	@echo  '  clang-tidy-fix  - Check and fix with clang-tidy'

A pity the ordering of the code below isn't the same as the above.

> -PHONY += clang-tidy clang-analyzer
> +PHONY += clang-tidy-fix clang-tidy clang-analyzer
[]
> -clang-tidy clang-analyzer: $(extmod-prefix)compile_commands.json
> +clang-tidy-fix clang-tidy clang-analyzer: $(extmod-prefix)compile_commands.json
>  	$(call cmd,clang_tools)
>  else
> -clang-tidy clang-analyzer:
> +clang-tidy-fix clang-tidy clang-analyzer:

[]

> diff --git a/scripts/clang-tools/run-clang-tools.py b/scripts/clang-tools/run-clang-tools.py
[]
> @@ -22,43 +22,57 @@ def parse_arguments():
[]
>      parser.add_argument("type",
> -                        choices=["clang-tidy", "clang-analyzer"],
> +                        choices=["clang-tidy-fix", "clang-tidy", "clang-analyzer"],

etc...

