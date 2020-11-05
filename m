Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 709D32A881C
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732099AbgKEU35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbgKEU35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 15:29:57 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3B8C0613CF;
        Thu,  5 Nov 2020 12:29:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=zdWW6brH1+DGRjR+miSgwIS5XWmxKhqw6LUMWKo+45c=; b=aM9sv2b8xov6sHzl6Whn4c9UzA
        VIwEGx7ktjptspRFy26iS4e+CnMUr6M3hRuAWOs0cHuc9Qgpom0G+GdEL1m5RR6bxQcFnKO/klj0a
        Fsyc+FEm2oQI79BIoW4zOEP9Z9rhN/612lpN0hv2lJwt1IyCsJo4ohaYo8TeJQv7BqgdFLNDogi/7
        YJohBJVTXxXxwwb6Gq1Q2+hen282mACEynxr5h+qOp26cMGijnwhDIteDcIh+CWbj9QDlFVlAqDUx
        OBTvi6LdmkhefLfXtmYVQngofDd2Hq2pT4efnDaZ6jTPsFq133p3BZEns3PJd0ZvOyvRciNkddTIr
        NFEOeDMg==;
Received: from [2601:1c0:6280:3f0::60d5]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kaltH-00057o-SK; Thu, 05 Nov 2020 20:29:52 +0000
Subject: Re: linux-next: Tree for Nov 5
 [drivers/net/ethernet/stmicro/stmmac/dwmac-thead.ko]
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Lin Lei <linlei@linux.alibaba.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20201105170604.6588a06e@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <1890051c-f317-af83-7cba-ff858c6d1f5c@infradead.org>
Date:   Thu, 5 Nov 2020 12:29:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201105170604.6588a06e@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/20 10:06 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20201104:
> 
> The drm-intel-fixes tree lost its build failure.
> 
> The drm-msm tree gained conflicts against the drm and drm-misc trees.
> 
> The mfd tree gained a build failure so I used the version from
> next-20201104.
> 
> The pinctrl tree lost its build failure.
> 
> The akpm-current tree gained a build failure for which I reverted
> a commit.
> 
> Non-merge commits (relative to Linus' tree): 3085
>  3498 files changed, 376683 insertions(+), 40297 deletions(-)
> 
> ----------------------------------------------------------------------------
> 
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> (patches at http://www.kernel.org/pub/linux/kernel/next/ ).  If you
> are tracking the linux-next tree using git, you should not use "git pull"
> to do so as that will try to merge the new linux-next release with the
> old one.  You should use "git fetch" and checkout or reset to the new
> master.
> 
> You can see which trees have been included by looking in the Next/Trees
> file in the source.  There are also quilt-import.log and merge.log
> files in the Next directory.  Between each merge, the tree was built
> with a ppc64_defconfig for powerpc, an allmodconfig for x86_64, a
> multi_v7_defconfig for arm and a native build of tools/perf. After
> the final fixups (if any), I do an x86_64 modules_install followed by
> builds for x86_64 allnoconfig, powerpc allnoconfig (32 and 64 bit),
> ppc44x_defconfig, allyesconfig and pseries_le_defconfig and i386, sparc
> and sparc64 defconfig and htmldocs. And finally, a simple boot test
> of the powerpc pseries_le_defconfig kernel in qemu (with and without
> kvm enabled).
> 
> Below is a summary of the state of the merge.
> 
> I am currently merging 327 trees (counting Linus' and 85 trees of bug
> fix patches pending for the current merge release).
> 
> Stats about the size of the tree over time can be seen at
> http://neuling.org/linux-next-size.html .
> 
> Status of my local build tests will be at
> http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.
> 
> Thanks to Randy Dunlap for doing many randconfig builds.  And to Paul
> Gortmaker for triage and bug fixes.
> 

on x86_64:

CONFIG_STMMAC_ETH=m
# CONFIG_STMMAC_PLATFORM is not set
CONFIG_DWMAC_INTEL=m
CONFIG_STMMAC_PCI=m

dwmac-thead.c is always built but it seems to expect (require) that
stmmac_platform.c is also always built, but the latter has a Kconfig
option that can be (is) disabled, resulting in build errors:

ERROR: modpost: "stmmac_pltfr_pm_ops" [drivers/net/ethernet/stmicro/stmmac/dwmac-thead.ko] undefined!
ERROR: modpost: "stmmac_pltfr_remove" [drivers/net/ethernet/stmicro/stmmac/dwmac-thead.ko] undefined!
ERROR: modpost: "stmmac_remove_config_dt" [drivers/net/ethernet/stmicro/stmmac/dwmac-thead.ko] undefined!
ERROR: modpost: "stmmac_probe_config_dt" [drivers/net/ethernet/stmicro/stmmac/dwmac-thead.ko] undefined!
ERROR: modpost: "stmmac_get_platform_resources" [drivers/net/ethernet/stmicro/stmmac/dwmac-thead.ko] undefined!


-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
