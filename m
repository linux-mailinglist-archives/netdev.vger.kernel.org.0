Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE7BD7E595
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 00:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730348AbfHAWZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 18:25:52 -0400
Received: from mga07.intel.com ([134.134.136.100]:14634 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728885AbfHAWZv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 18:25:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Aug 2019 15:25:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,335,1559545200"; 
   d="scan'208";a="324384861"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 01 Aug 2019 15:25:49 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/11][pull request] 100GbE Intel Wired LAN Driver Updates 2019-08-01
Date:   Thu,  1 Aug 2019 15:25:37 -0700
Message-Id: <20190801222548.15975-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series for fm10k, by Jake Keller, reduces the scope of local variables
where possible.

The following are changes since commit a8e600e2184f45c40025cbe4d7e8893b69378a9f:
  Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Jacob Keller (11):
  fm10k: reduce scope of the err variable
  fm10k: reduce scope of *p local variable
  fm10k: reduce the scope of qv local variable
  fm10k: reduce the scope of local err variable
  fm10k: reduce the scope of the q_idx local variable
  fm10k: reduce the scope of the tx_buffer variable
  fm10k: reduce the scope of the err variable
  fm10k: reduce the scope of the local i variable
  fm10k: reduce the scope of the local msg variable
  fm10k: reduce the scope of the result local variable
  fm10k: reduce scope of the ring variable

 drivers/net/ethernet/intel/fm10k/fm10k_dcbnl.c   | 6 +++---
 drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c | 9 ++++-----
 drivers/net/ethernet/intel/fm10k/fm10k_iov.c     | 5 +++--
 drivers/net/ethernet/intel/fm10k/fm10k_main.c    | 9 +++++----
 drivers/net/ethernet/intel/fm10k/fm10k_mbx.c     | 6 ++++--
 drivers/net/ethernet/intel/fm10k/fm10k_netdev.c  | 8 ++++----
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c     | 9 +++++----
 drivers/net/ethernet/intel/fm10k/fm10k_pf.c      | 3 +--
 8 files changed, 29 insertions(+), 26 deletions(-)

-- 
2.21.0

