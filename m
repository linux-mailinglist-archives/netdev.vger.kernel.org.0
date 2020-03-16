Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0B711868C5
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 11:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730529AbgCPKQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 06:16:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56018 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730495AbgCPKQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 06:16:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584353809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=fhlaLu41fKjyJCaBA5i8hSKMaPVLJFPaihSlC46nwKY=;
        b=dOKpNlJHddpeGBN/ENrS7vjmFhlOmcqRJjPeuRCeV4d/tVEUZ2OiZkvSPiV0giVBpzZbtm
        n7W68DaYFrhxEna1TIH6trHUVQ5tJVHca2puHGH+cshTSUdPC1yV//V/Oh7q+45trOHzgR
        e9PshnPmpQurvtp0w9nEfsRFr8C5ZzQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-AePaLJR-PCK92IBJf6eNrg-1; Mon, 16 Mar 2020 06:16:46 -0400
X-MC-Unique: AePaLJR-PCK92IBJf6eNrg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C0D7477;
        Mon, 16 Mar 2020 10:16:45 +0000 (UTC)
Received: from [192.168.122.1] (ovpn-200-32.brq.redhat.com [10.40.200.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4389F972D3;
        Mon, 16 Mar 2020 10:16:39 +0000 (UTC)
Subject: [PATCH net-next] i40e: trivial fixup of comments in i40e_xsk.c
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org
Cc:     =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org
Date:   Mon, 16 Mar 2020 11:16:38 +0100
Message-ID: <158435379870.2479973.8293720099992666964.stgit@carbon>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The comment above i40e_run_xdp_zc() was clearly copy-pasted from
function i40e_xsk_umem_setup, which is just above.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c |    4 +---
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


