Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64E91B18C9
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgDTVva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:51:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:15830 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727063AbgDTVv1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 17:51:27 -0400
IronPort-SDR: Xj9IfsPsrx5D2Q7bv+6zJamM/MzCjViASNAdq/eb6A1QFC7H8rW3pRtA3tKJHLK/hYbmetDDqL
 6+mARRgK9RyQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 14:51:27 -0700
IronPort-SDR: SW+NtS5/uvMkUz0sQlPzQUNomqkOpEWnYCCjui88e8BieTGiCnDcTt4zcEQkZ9sInk3OB8N0II
 IjWSXsUasOcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,407,1580803200"; 
   d="scan'208";a="245500095"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 20 Apr 2020 14:51:23 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id C961E190; Tue, 21 Apr 2020 00:51:22 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jeremy Linton <jeremy.linton@arm.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 0/5] net: bcmgenet: Clean up after ACPI enablement
Date:   Tue, 21 Apr 2020 00:51:16 +0300
Message-Id: <20200420215121.17735-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ACPI enablement series had missed some clean ups that would have been done
at the same time. Here are these bits.

In v2:
- return dev_dbg() calls to avoid spamming logs when probe is deferred (Florian)
- added Ack (Florian)
- combined two, earlier sent, series together
- added couple more patches

Andy Shevchenko (5):
  net: bcmgenet: Drop ACPI_PTR() to avoid compiler warning
  net: bcmgenet: Drop useless OF code
  net: bcmgenet: Use devm_clk_get_optional() to get the clocks
  net: bcmgenet: Use get_unligned_beXX() and put_unaligned_beXX()
  net: bcmgenet: Drop too many parentheses in bcmgenet_probe()

 .../net/ethernet/broadcom/genet/bcmgenet.c    | 49 +++++++------------
 1 file changed, 18 insertions(+), 31 deletions(-)

-- 
2.26.1

