Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBFE7D3B72
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 10:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbfJKInR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 04:43:17 -0400
Received: from ivanoab7.miniserver.com ([37.128.132.42]:42928 "EHLO
        www.kot-begemot.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfJKInR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 04:43:17 -0400
Received: from tun252.jain.kot-begemot.co.uk ([192.168.18.6] helo=jain.kot-begemot.co.uk)
        by www.kot-begemot.co.uk with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1iIqVw-000807-VH; Fri, 11 Oct 2019 08:43:09 +0000
Received: from jain.kot-begemot.co.uk ([192.168.3.3])
        by jain.kot-begemot.co.uk with esmtp (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1iIqVu-0007Pk-AL; Fri, 11 Oct 2019 09:43:08 +0100
From:   Anton Ivanov <anton.ivanov@cambridgegreys.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, yhs@fb.com,
        netdev@vger.kernel.org,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>
Subject: [PATCH] xdp: Trivial, fix spelling in function description
Date:   Fri, 11 Oct 2019 09:43:03 +0100
Message-Id: <20191011084303.28418-1-anton.ivanov@cambridgegreys.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.0
X-Spam-Score: -1.0
X-Clacks-Overhead: GNU Terry Pratchett
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
---
 net/core/xdp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index d7bf62ffbb5e..20781ad5f9c3 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -386,7 +386,7 @@ EXPORT_SYMBOL_GPL(xdp_rxq_info_reg_mem_model);
 
 /* XDP RX runs under NAPI protection, and in different delivery error
  * scenarios (e.g. queue full), it is possible to return the xdp_frame
- * while still leveraging this protection.  The @napi_direct boolian
+ * while still leveraging this protection.  The @napi_direct boolean
  * is used for those calls sites.  Thus, allowing for faster recycling
  * of xdp_frames/pages in those cases.
  */
-- 
2.20.1

