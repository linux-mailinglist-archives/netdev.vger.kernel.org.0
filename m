Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E7F1E7500
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 06:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgE2EkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 00:40:07 -0400
Received: from mga03.intel.com ([134.134.136.65]:40323 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgE2EkG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 00:40:06 -0400
IronPort-SDR: iYzJc+TqYZUgcCw7DqDDevl6QPp6w0VmS2/XFK5Kq+oFDaFrHTHgb45MLjKhHcyx+pIT+/YiW/
 muGtwT0lVdHg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 21:40:05 -0700
IronPort-SDR: finhbkgznRP30WlOJ4BRDsGVX8Zw8JFiokBh+s42HfvBpGevzEm9IEQawuqKNwFr9xqzLC0XHm
 k7Qbo4HW+hlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="414850895"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 28 May 2020 21:40:05 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 02/17] i40e: trivial fixup of comments in i40e_xsk.c
Date:   Thu, 28 May 2020 21:39:49 -0700
Message-Id: <20200529044004.3725307-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529044004.3725307-1-jeffrey.t.kirsher@intel.com>
References: <20200529044004.3725307-1-jeffrey.t.kirsher@intel.com>
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
index f3953744c505..7276580cbe64 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -139,8 +139,6 @@ int i40e_xsk_umem_setup(struct i40e_vsi *vsi, struct xdp_umem *umem,
  * @rx_ring: Rx ring
  * @xdp: xdp_buff used as input to the XDP program
  *
- * This function enables or disables a UMEM to a certain ring.
- *
  * Returns any of I40E_XDP_{PASS, CONSUMED, TX, REDIR}
  **/
 static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
@@ -224,7 +222,7 @@ bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count)
 }
 
 /**
- * i40e_construct_skb_zc - Create skbufff from zero-copy Rx buffer
+ * i40e_construct_skb_zc - Create skbuff from zero-copy Rx buffer
  * @rx_ring: Rx ring
  * @xdp: xdp_buff
  *
-- 
2.26.2

