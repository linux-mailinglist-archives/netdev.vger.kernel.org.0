Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C70D2130668
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 08:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgAEHOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 02:14:22 -0500
Received: from mga05.intel.com ([192.55.52.43]:54704 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgAEHOW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jan 2020 02:14:22 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jan 2020 23:14:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,397,1571727600"; 
   d="scan'208";a="302607341"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga001.jf.intel.com with ESMTP; 04 Jan 2020 23:14:20 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/15][pull request] 1GbE Intel Wired LAN Driver Updates 2020-01-04
Date:   Sat,  4 Jan 2020 23:14:05 -0800
Message-Id: <20200105071420.3778982-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to the igc driver only.

Sasha does some housekeeping on the igc driver to remove forward
declarations that are not needed after re-arranging several functions.

The following are changes since commit 4460985fac06f8e0e5bd4b86dcef49ada451583c:
  Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Sasha Neftin (15):
  igc: Remove no need declaration of the igc_clean_tx_ring
  igc: Remove no need declaration of the igc_power_down_link
  igc: Remove no need declaration of the igc_set_default_mac_filter
  igc: Remove no need declaration of the igc_configure
  igc: Remove no need declaration of the igc_alloc_mapped_page
  igc: Remove no need declaration of the igc_set_interrupt_capability
  igc: Remove no need declaration of the igc_set_rx_mode
  igc: Remove no need declaration of the igc_configure_msix
  igc: Remove no need declaration of the igc_irq_enable
  igc: Remove no need declaration of the igc_irq_disable
  igc: Remove no need declaration of the igc_free_q_vectors
  igc: Remove no need declaration of the igc_free_q_vector
  igc: Remove no need declaration of the igc_assign_vector
  igc: Remove no need declaration of the igc_write_itr
  igc: Remove no need declaration of the igc_sw_init

 drivers/net/ethernet/intel/igc/igc_main.c | 3617 ++++++++++-----------
 1 file changed, 1799 insertions(+), 1818 deletions(-)

-- 
2.24.1

