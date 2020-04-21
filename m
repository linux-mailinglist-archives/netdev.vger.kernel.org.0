Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19FE51B1B5C
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 03:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgDUBth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 21:49:37 -0400
Received: from mga17.intel.com ([192.55.52.151]:47086 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbgDUBtg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 21:49:36 -0400
IronPort-SDR: PEgwYn/3+8gocdbfd/2NclxPD7xvFzTWyGtjRGxW8KPFc64WbMxEt4z7WO1kAzk5vzFDyjp036
 y9MqNclcT4yw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 18:49:35 -0700
IronPort-SDR: j4yP0kFm+gTJTFbPdgDrffODRiowiamFAQPupy+sGIGIe/bw5zlsHc3I5U+q967VbJBqQXb9i4
 WUAVVmPwKE6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,408,1580803200"; 
   d="scan'208";a="291449662"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga008.jf.intel.com with ESMTP; 20 Apr 2020 18:49:35 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 2/4] i40e: trivial fixup of comments in i40e_xsk.c
Date:   Mon, 20 Apr 2020 18:49:30 -0700
Message-Id: <20200421014932.2743607-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200421014932.2743607-1-jeffrey.t.kirsher@intel.com>
References: <20200421014932.2743607-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

The comment above i40e_run_xdp_zc() was clearly copy-pasted from
function i40e_xsk_umem_setup, which is just above.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 0b7d29192b2c..30dfb0d3d185 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -184,8 +184,6 @@ int i40e_xsk_umem_setup(struct i40e_vsi *vsi, struct xdp_umem *umem,
  * @rx_ring: Rx ring
  * @xdp: xdp_buff used as input to the XDP program
  *
- * This function enables or disables a UMEM to a certain ring.
- *
  * Returns any of I40E_XDP_{PASS, CONSUMED, TX, REDIR}
  **/
 static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
@@ -474,7 +472,7 @@ void i40e_zca_free(struct zero_copy_allocator *alloc, unsigned long handle)
 }
 
 /**
- * i40e_construct_skb_zc - Create skbufff from zero-copy Rx buffer
+ * i40e_construct_skb_zc - Create skbuff from zero-copy Rx buffer
  * @rx_ring: Rx ring
  * @bi: Rx buffer
  * @xdp: xdp_buff
-- 
2.25.3

