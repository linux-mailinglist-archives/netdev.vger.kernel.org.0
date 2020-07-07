Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED87E217BE3
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 01:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbgGGXsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 19:48:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:15272 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728530AbgGGXsL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 19:48:11 -0400
IronPort-SDR: gxVJ1B6AY3ARQd2GGoXCCrk8/AXTqsmfvd1fWG6qgbkF1gWOppWPmWXIpbva7XchncYx1WV9zz
 kNcc/AOx5qbw==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="135949649"
X-IronPort-AV: E=Sophos;i="5.75,325,1589266800"; 
   d="scan'208";a="135949649"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 16:48:10 -0700
IronPort-SDR: kLcvBYUgx/TFWRvnwvTf+W5HOZuev5Lb0RgIfyR16dOmOvM5U1UOjey0C/COkg3Nasmup5qlN4
 JIA8WmT6Pw2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,325,1589266800"; 
   d="scan'208";a="483684030"
Received: from vapadgao-mobl.amr.corp.intel.com ([10.251.143.88])
  by fmsmga005.fm.intel.com with ESMTP; 07 Jul 2020 16:48:10 -0700
From:   Andre Guedes <andre.guedes@intel.com>
To:     netdev@vger.kernel.org
Cc:     intel-wired-lan@lists.osuosl.org
Subject: [PATCH ethtool 0/4] Add support for IGC driver
Date:   Tue,  7 Jul 2020 16:47:56 -0700
Message-Id: <20200707234800.39119-1-andre.guedes@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This patch series adds support for parsing registers dumped by the IGC driver.
For now, the following registers are parsed:

	* Receive Address Low (RAL)
	* Receive Address High (RAH)
	* Receive Control (RCTL)
	* VLAN Priority Queue Filter (VLANPQF)
	* EType Queue Filter (ETQF)

More registers should be parsed as we need/enable them.

Cheers,
Andre

Andre Guedes (4):
  Add IGC driver support
  igc: Parse RCTL register fields
  igc: Parse VLANPQF register fields
  igc: Parse ETQF registers

 Makefile.am |   3 +-
 ethtool.c   |   1 +
 igc.c       | 283 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 internal.h  |   3 +
 4 files changed, 289 insertions(+), 1 deletion(-)
 create mode 100644 igc.c

-- 
2.26.2

