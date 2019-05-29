Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8B182D406
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 04:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfE2CyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 22:54:17 -0400
Received: from mga12.intel.com ([192.55.52.136]:4925 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbfE2CyR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 22:54:17 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 May 2019 19:54:17 -0700
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 28 May 2019 19:54:15 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hVojG-000IeS-Fm; Wed, 29 May 2019 10:54:14 +0800
Date:   Wed, 29 May 2019 10:54:00 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Zhongzhu Liu <liuzhongzhu@huawei.com>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Weihang Li <liweihang@hisilicon.com>,
        linux-kernel@vger.kernel.org
Subject: [net-next:master 161/171]
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:924:6: sparse:
 sparse: symbol 'hclge_dbg_get_m7_stats_info' was not declared. Should it be
 static?
Message-ID: <201905291024.VVfliT6e%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   602e0f295a91813c9a15938f2a292b9c60a416d9
commit: 33a90e2f20e6c455889a0f41857692221172a5ae [161/171] net: hns3: add support for dump firmware statistics by debugfs
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
        git checkout 33a90e2f20e6c455889a0f41857692221172a5ae
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:32:17: sparse: sparse: cast from restricted __le32
   drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:564:31: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:598:39: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int @@    got restricted __le32unsigned int @@
   drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:598:39: sparse:    expected unsigned int
   drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:598:39: sparse:    got restricted __le32 [usertype] qs_bit_map
   drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:833:30: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:840:33: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:841:30: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:842:31: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:844:33: sparse: sparse: restricted __le16 degrades to integer
>> drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:924:6: sparse: sparse: symbol 'hclge_dbg_get_m7_stats_info' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
