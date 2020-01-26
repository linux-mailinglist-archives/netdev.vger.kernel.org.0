Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 619AE149DB9
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 00:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgAZXaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 18:30:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:11038 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726382AbgAZXaY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 18:30:24 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jan 2020 15:30:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,367,1574150400"; 
   d="scan'208";a="428836350"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 26 Jan 2020 15:30:20 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1ivrMB-00084s-IH; Mon, 27 Jan 2020 07:30:19 +0800
Date:   Mon, 27 Jan 2020 07:30:02 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Michal Kalderon <michal.kalderon@marvell.com>
Cc:     kbuild-all@lists.01.org, michal.kalderon@marvell.com,
        ariel.elior@marvell.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 net-next 05/13] qed: Use dmae to write to widebus
 registers in fw_funcs
Message-ID: <202001270754.oucihd3X%lkp@intel.com>
References: <20200123105836.15090-6-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200123105836.15090-6-michal.kalderon@marvell.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on linus/master v5.5-rc7 next-20200121]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Michal-Kalderon/qed-Utilize-FW-8-42-2-0/20200125-055253
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 9bbc8be29d66cc34b650510f2c67b5c55235fe5d
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-153-g47b6dfef-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/net/ethernet/qlogic/qed/qed_dev.c:910:9: sparse: sparse: invalid assignment: &=
>> drivers/net/ethernet/qlogic/qed/qed_dev.c:910:9: sparse:    left side has type restricted __le32
>> drivers/net/ethernet/qlogic/qed/qed_dev.c:910:9: sparse:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_dev.c:910:9: sparse: sparse: invalid assignment: |=
>> drivers/net/ethernet/qlogic/qed/qed_dev.c:910:9: sparse:    left side has type restricted __le32
>> drivers/net/ethernet/qlogic/qed/qed_dev.c:910:9: sparse:    right side has type unsigned long long
--
>> drivers/net/ethernet/qlogic/qed/qed_hw.c:413:20: sparse: sparse: restricted __le32 degrades to integer
   drivers/net/ethernet/qlogic/qed/qed_hw.c:420:20: sparse: sparse: restricted __le32 degrades to integer
   drivers/net/ethernet/qlogic/qed/qed_hw.c:432:13: sparse: sparse: restricted __le32 degrades to integer
   drivers/net/ethernet/qlogic/qed/qed_hw.c:438:20: sparse: sparse: restricted __le32 degrades to integer
   drivers/net/ethernet/qlogic/qed/qed_hw.c:449:13: sparse: sparse: restricted __le32 degrades to integer
   drivers/net/ethernet/qlogic/qed/qed_hw.c:455:13: sparse: sparse: restricted __le32 degrades to integer
   drivers/net/ethernet/qlogic/qed/qed_hw.c:739:22: sparse: sparse: restricted __le32 degrades to integer
--
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1056:9: sparse:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1056:9: sparse: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1056:9: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1056:9: sparse:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1354:9: sparse: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1354:9: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1354:9: sparse:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1354:9: sparse: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1354:9: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1354:9: sparse:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1355:9: sparse: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1355:9: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1355:9: sparse:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1355:9: sparse: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1355:9: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1355:9: sparse:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1358:17: sparse: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1358:17: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1358:17: sparse:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1358:17: sparse: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1358:17: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1358:17: sparse:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1359:17: sparse: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1359:17: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1359:17: sparse:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1359:17: sparse: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1359:17: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1359:17: sparse:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1360:17: sparse: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1360:17: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1360:17: sparse:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1360:17: sparse: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1360:17: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1360:17: sparse:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1361:17: sparse: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1361:17: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1361:17: sparse:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1361:17: sparse: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1361:17: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1361:17: sparse:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1362:17: sparse: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1362:17: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1362:17: sparse:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1362:17: sparse: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1362:17: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1362:17: sparse:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1363:17: sparse: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1363:17: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1363:17: sparse:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1363:17: sparse: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1363:17: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1363:17: sparse:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1365:17: sparse: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1365:17: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1365:17: sparse:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1365:17: sparse: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1365:17: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1365:17: sparse:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1366:17: sparse: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1366:17: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1366:17: sparse:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1366:17: sparse: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1366:17: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1366:17: sparse:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1367:17: sparse: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1367:17: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1367:17: sparse:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1367:17: sparse: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1367:17: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1367:17: sparse:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1369:17: sparse: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1369:17: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1369:17: sparse:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1369:17: sparse: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1369:17: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1369:17: sparse:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1370:17: sparse: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1370:17: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1370:17: sparse:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1370:17: sparse: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1370:17: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1370:17: sparse:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1372:17: sparse: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1372:17: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1372:17: sparse:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1372:17: sparse: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1372:17: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1372:17: sparse:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1373:17: sparse: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1373:17: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1373:17: sparse:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1373:17: sparse: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1373:17: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1373:17: sparse:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1375:17: sparse: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1375:17: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1375:17: sparse:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1375:17: sparse: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1375:17: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1375:17: sparse:    right side has type unsigned long long
>> drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1388:21: sparse: sparse: incorrect type in assignment (different base types)
>> drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1388:21: sparse:    expected restricted __le32 [addressable] [usertype] lo
>> drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1388:21: sparse:    got unsigned int
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1389:21: sparse: sparse: incorrect type in assignment (different base types)
>> drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1389:21: sparse:    expected restricted __le32 [addressable] [usertype] hi
>> drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1389:21: sparse:    got int
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1430:23: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1430:23: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1430:23: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1430:23: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1430:23: sparse: sparse: cast to restricted __be32
   drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c:1430:23: sparse: sparse: cast to restricted __be32
--
>> drivers/net/ethernet/qlogic/qed/qed_init_ops.c:218:9: sparse: sparse: invalid assignment: &=
>> drivers/net/ethernet/qlogic/qed/qed_init_ops.c:218:9: sparse:    left side has type restricted __le32
>> drivers/net/ethernet/qlogic/qed/qed_init_ops.c:218:9: sparse:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:218:9: sparse: sparse: invalid assignment: |=
>> drivers/net/ethernet/qlogic/qed/qed_init_ops.c:218:9: sparse:    left side has type restricted __le32
>> drivers/net/ethernet/qlogic/qed/qed_init_ops.c:218:9: sparse:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:239:33: sparse: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:240:20: sparse: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:253:16: sparse: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:310:20: sparse: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:326:24: sparse: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:330:24: sparse: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:342:29: sparse: sparse: cast to restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:343:29: sparse: sparse: cast to restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:375:16: sparse: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:401:16: sparse: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:410:17: sparse: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:410:17: sparse: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:466:22: sparse: sparse: cast to restricted __le16
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:471:24: sparse: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:479:20: sparse: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:480:23: sparse: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:508:28: sparse: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:531:25: sparse: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:531:25: sparse: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:531:25: sparse: sparse: cast to restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_init_ops.c:531:25: sparse: sparse: cast to restricted __le32
--
>> drivers/net/ethernet/qlogic/qed/qed_sriov.c:355:9: sparse: sparse: invalid assignment: &=
>> drivers/net/ethernet/qlogic/qed/qed_sriov.c:355:9: sparse:    left side has type restricted __le32
>> drivers/net/ethernet/qlogic/qed/qed_sriov.c:355:9: sparse:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_sriov.c:355:9: sparse: sparse: invalid assignment: |=
>> drivers/net/ethernet/qlogic/qed/qed_sriov.c:355:9: sparse:    left side has type restricted __le32
>> drivers/net/ethernet/qlogic/qed/qed_sriov.c:355:9: sparse:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_sriov.c:575:35: sparse: sparse: incorrect type in argument 3 (incompatible argument 3 (different base types))
   drivers/net/ethernet/qlogic/qed/qed_sriov.c:575:35: sparse:    expected int ( *[usertype] cb )( ... )
   drivers/net/ethernet/qlogic/qed/qed_sriov.c:575:35: sparse:    got int ( * )( ... )
   drivers/net/ethernet/qlogic/qed/qed_sriov.c:1229:9: sparse: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_sriov.c:1229:9: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_sriov.c:1229:9: sparse:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_sriov.c:1229:9: sparse: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_sriov.c:1229:9: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_sriov.c:1229:9: sparse:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_sriov.c:4029:39: sparse: sparse: cast from restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_sriov.c:4029:70: sparse: sparse: restricted __le32 degrades to integer
   drivers/net/ethernet/qlogic/qed/qed_sriov.c:4107:9: sparse: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_sriov.c:4107:9: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_sriov.c:4107:9: sparse:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_sriov.c:4107:9: sparse: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_sriov.c:4107:9: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_sriov.c:4107:9: sparse:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_sriov.c:4108:9: sparse: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_sriov.c:4108:9: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_sriov.c:4108:9: sparse:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_sriov.c:4108:9: sparse: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_sriov.c:4108:9: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_sriov.c:4108:9: sparse:    right side has type unsigned long long

vim +910 drivers/net/ethernet/qlogic/qed/qed_dev.c

   867	
   868	static int
   869	qed_llh_access_filter(struct qed_hwfn *p_hwfn,
   870			      struct qed_ptt *p_ptt,
   871			      u8 abs_ppfid,
   872			      u8 filter_idx,
   873			      struct qed_llh_filter_details *p_details)
   874	{
   875		struct qed_dmae_params params = {0};
   876		u32 addr;
   877		u8 pfid;
   878		int rc;
   879	
   880		/* The NIG/LLH registers that are accessed in this function have only 16
   881		 * rows which are exposed to a PF. I.e. only the 16 filters of its
   882		 * default ppfid. Accessing filters of other ppfids requires pretending
   883		 * to another PFs.
   884		 * The calculation of PPFID->PFID in AH is based on the relative index
   885		 * of a PF on its port.
   886		 * For BB the pfid is actually the abs_ppfid.
   887		 */
   888		if (QED_IS_BB(p_hwfn->cdev))
   889			pfid = abs_ppfid;
   890		else
   891			pfid = abs_ppfid * p_hwfn->cdev->num_ports_in_engine +
   892			    MFW_PORT(p_hwfn);
   893	
   894		/* Filter enable - should be done first when removing a filter */
   895		if (!p_details->enable) {
   896			qed_fid_pretend(p_hwfn, p_ptt,
   897					pfid << PXP_PRETEND_CONCRETE_FID_PFID_SHIFT);
   898	
   899			addr = NIG_REG_LLH_FUNC_FILTER_EN + filter_idx * 0x4;
   900			qed_wr(p_hwfn, p_ptt, addr, p_details->enable);
   901	
   902			qed_fid_pretend(p_hwfn, p_ptt,
   903					p_hwfn->rel_pf_id <<
   904					PXP_PRETEND_CONCRETE_FID_PFID_SHIFT);
   905		}
   906	
   907		/* Filter value */
   908		addr = NIG_REG_LLH_FUNC_FILTER_VALUE + 2 * filter_idx * 0x4;
   909	
 > 910		SET_FIELD(params.flags, QED_DMAE_PARAMS_DST_PF_VALID, 0x1);
   911		params.dst_pfid = pfid;
   912		rc = qed_dmae_host2grc(p_hwfn,
   913				       p_ptt,
   914				       (u64)(uintptr_t)&p_details->value,
   915				       addr, 2 /* size_in_dwords */,
   916				       &params);
   917		if (rc)
   918			return rc;
   919	
   920		qed_fid_pretend(p_hwfn, p_ptt,
   921				pfid << PXP_PRETEND_CONCRETE_FID_PFID_SHIFT);
   922	
   923		/* Filter mode */
   924		addr = NIG_REG_LLH_FUNC_FILTER_MODE + filter_idx * 0x4;
   925		qed_wr(p_hwfn, p_ptt, addr, p_details->mode);
   926	
   927		/* Filter protocol type */
   928		addr = NIG_REG_LLH_FUNC_FILTER_PROTOCOL_TYPE + filter_idx * 0x4;
   929		qed_wr(p_hwfn, p_ptt, addr, p_details->protocol_type);
   930	
   931		/* Filter header select */
   932		addr = NIG_REG_LLH_FUNC_FILTER_HDR_SEL + filter_idx * 0x4;
   933		qed_wr(p_hwfn, p_ptt, addr, p_details->hdr_sel);
   934	
   935		/* Filter enable - should be done last when adding a filter */
   936		if (p_details->enable) {
   937			addr = NIG_REG_LLH_FUNC_FILTER_EN + filter_idx * 0x4;
   938			qed_wr(p_hwfn, p_ptt, addr, p_details->enable);
   939		}
   940	
   941		qed_fid_pretend(p_hwfn, p_ptt,
   942				p_hwfn->rel_pf_id <<
   943				PXP_PRETEND_CONCRETE_FID_PFID_SHIFT);
   944	
   945		return 0;
   946	}
   947	

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
