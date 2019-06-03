Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4357F33BE0
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 01:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfFCXYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 19:24:17 -0400
Received: from mga04.intel.com ([192.55.52.120]:11687 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbfFCXYN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 19:24:13 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jun 2019 16:24:13 -0700
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 03 Jun 2019 16:24:11 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hXwJG-000E3f-Sv; Tue, 04 Jun 2019 07:24:10 +0800
Date:   Tue, 4 Jun 2019 07:23:10 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Xue Chaojing <xuechaojing@huawei.com>
Cc:     kbuild-all@01.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoshaokai@huawei.com, cloud.wangxiaoyun@huawei.com,
        xuechaojing@huawei.com, chiqijun@huawei.com, wulike1@huawei.com
Subject: Re: [PATCH net-next v3] hinic: add LRO support
Message-ID: <201906040753.bqwbqtxT%lkp@intel.com>
References: <20190603043536.4970-1-xuechaojing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603043536.4970-1-xuechaojing@huawei.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xue,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Xue-Chaojing/hinic-add-LRO-support/20190604-035042
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/net/ethernet/huawei/hinic/hinic_main.c:375:5: sparse: sparse: symbol 'hinic_rx_configure' was not declared. Should it be static?
--
>> drivers/net/ethernet/huawei/hinic/hinic_port.c:469:5: sparse: sparse: symbol 'hinic_set_rx_lro' was not declared. Should it be static?
>> drivers/net/ethernet/huawei/hinic/hinic_port.c:497:5: sparse: sparse: symbol 'hinic_set_rx_lro_timer' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
