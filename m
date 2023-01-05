Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6F7165E93B
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 11:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbjAEKqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 05:46:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233312AbjAEKqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 05:46:17 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411B33D9C5;
        Thu,  5 Jan 2023 02:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672915576; x=1704451576;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=U8LnAyyxclqqkYhlYb2StTe+iBOYKxsAOmUMcZm54a4=;
  b=fgil5kr7UrdvX7GQ/nvLKg5nyQO3bxVVdb/xh+UkOFHxZW1KBa9Ko/8R
   zc2lOmmvOfEQ7XIQMPaqLUWXUR6i6lYo8ggy/u2nqKDsBKHXw/Yx6g7Dx
   5Jrk/0E+PYt8QldiEGNPrfTf2sIBFY6NdWglnrNINMA+HJmPKjhme6dbK
   1WjEWjsDRd7qvVdMFpN9QuLurv0Aw6bp6mT64bs8QH02LSa6cBwIeGSlj
   Rhk7UhEc3s/onrMSqEw2kob4zgRDnzW8LKWNwt4jUef7xO1DxQKw93/mU
   9WlW8hsacYwP5zKc2vfrv+8oumurxqQ7OcXYDIjY1Tw7rIyuLAjOj92Vp
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="302544576"
X-IronPort-AV: E=Sophos;i="5.96,302,1665471600"; 
   d="scan'208";a="302544576"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2023 02:46:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="763085620"
X-IronPort-AV: E=Sophos;i="5.96,302,1665471600"; 
   d="scan'208";a="763085620"
Received: from lkp-server02.sh.intel.com (HELO f1920e93ebb5) ([10.239.97.151])
  by fmsmga002.fm.intel.com with ESMTP; 05 Jan 2023 02:46:14 -0800
Received: from kbuild by f1920e93ebb5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pDNlF-0001ZU-2Q;
        Thu, 05 Jan 2023 10:46:13 +0000
Date:   Thu, 05 Jan 2023 18:46:12 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:pending-fixes] BUILD SUCCESS
 2d3ca5d07c8e43c0bdb602fad9396b140f7b9857
Message-ID: <63b6aa74.lKZwZVorLOORJWbo%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git pending-fixes
branch HEAD: 2d3ca5d07c8e43c0bdb602fad9396b140f7b9857  Merge branch 'for-linux-next-fixes' of git://anongit.freedesktop.org/drm/drm-misc

Unverified Warning (likely false positive, please contact us if interested):

drivers/net/ethernet/mellanox/mlx5/core/health.c:701 mlx5_fw_fatal_reporter_err_work() warn: inconsistent returns '&dev->intf_state_mutex'.

Warning ids grouped by kconfigs:

gcc_recent_errors
`-- i386-randconfig-m021-20230102
    `-- drivers-net-ethernet-mellanox-mlx5-core-health.c-mlx5_fw_fatal_reporter_err_work()-warn:inconsistent-returns-dev-intf_state_mutex-.

elapsed time: 724m

configs tested: 66
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arc                                 defconfig
alpha                               defconfig
x86_64                            allnoconfig
powerpc                           allnoconfig
s390                                defconfig
s390                             allmodconfig
s390                             allyesconfig
sh                               allmodconfig
mips                             allyesconfig
powerpc                          allmodconfig
m68k                             allyesconfig
m68k                             allmodconfig
ia64                             allmodconfig
alpha                            allyesconfig
arc                              allyesconfig
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                           rhel-8.3-bpf
x86_64                           rhel-8.3-syz
x86_64                         rhel-8.3-kunit
x86_64                           rhel-8.3-kvm
x86_64                              defconfig
arm                                 defconfig
x86_64                               rhel-8.3
i386                                defconfig
x86_64                           allyesconfig
arm                              allyesconfig
arm64                            allyesconfig
x86_64                          rhel-8.3-func
x86_64                    rhel-8.3-kselftests
i386                             allyesconfig
i386                 randconfig-a004-20230102
i386                 randconfig-a003-20230102
i386                 randconfig-a002-20230102
arc                  randconfig-r043-20230105
s390                 randconfig-r044-20230105
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005
i386                          randconfig-a014
i386                          randconfig-a012
i386                          randconfig-a016
riscv                randconfig-r042-20230105
x86_64                        randconfig-a013
x86_64                        randconfig-a011
x86_64                        randconfig-a015
x86_64                        randconfig-a004
x86_64                        randconfig-a002
x86_64                        randconfig-a006

clang tested configs:
x86_64                          rhel-8.3-rust
arm                  randconfig-r046-20230105
i386                          randconfig-a002
i386                          randconfig-a013
i386                          randconfig-a004
hexagon              randconfig-r041-20230105
i386                          randconfig-a006
hexagon              randconfig-r045-20230105
i386                          randconfig-a015
i386                          randconfig-a011
x86_64                        randconfig-a014
x86_64                        randconfig-a012
x86_64                        randconfig-a016
x86_64                        randconfig-a001
x86_64                        randconfig-a003
x86_64                        randconfig-a005
x86_64                        randconfig-k001

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
