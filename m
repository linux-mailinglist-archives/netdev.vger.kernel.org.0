Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 311A24775B2
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 16:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238414AbhLPPTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 10:19:50 -0500
Received: from smtpbg127.qq.com ([109.244.180.96]:44601 "EHLO smtpbg.qq.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232620AbhLPPTu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 10:19:50 -0500
X-QQ-mid: bizesmtp47t1639667965tb49n6b3
Received: from wangx.lan (unknown [218.88.124.63])
        by esmtp6.qq.com (ESMTP) with 
        id ; Thu, 16 Dec 2021 23:19:17 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000C00A0000000
X-QQ-FEAT: k0yT7W7BRd1oP2mgzKNvYIIHDNH5omNVB0fr6Vf8qSVRWBjiOQog1PJ7oW31H
        N/Ef8adxXS9Mds3iQqoF1pDV4G+XWlz0HkYPHlP54/8ET85Rnx2BpFM+EoGpNHxke0HGWja
        V9GxN2oHPc72MNqOBOofap8aKTcQ3c+0YWZ9TCFhOuThu9x3HribIqkU4WOxiqcRhQ4V8G0
        PciwbMR6AAthPTpvhe3nze0O6ofBbVOzdfZw/R2/vuIN2ukIjTXfNg9uBkDj/Wdvz8LuonL
        qiXe+h5d8ZSDzZNyaBJkDpc9ef8TPU4/sjgq6GALBVvCSJt4HPLXaAQM0lBPawDaRn96V9V
        arP3b0mqJfexnGBkmjH4aLWc/iQS11MWDu7SPR+
X-QQ-GoodBg: 0
From:   Xiang wangx <wangxiang@cdjrlc.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiang wangx <wangxiang@cdjrlc.com>
Subject: [PATCH] net: fix typo in a comment
Date:   Thu, 16 Dec 2021 23:19:16 +0800
Message-Id: <20211216151916.12045-1-wangxiang@cdjrlc.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The double 'as' in a comment is repeated, thus it should be removed.

Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
---
 include/linux/netdevice.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 65117f01d5f2..89d93939063b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1932,7 +1932,7 @@ enum netdev_ml_priv_type {
  *	@udp_tunnel_nic:	UDP tunnel offload state
  *	@xdp_state:		stores info on attached XDP BPF programs
  *
- *	@nested_level:	Used as as a parameter of spin_lock_nested() of
+ *	@nested_level:	Used as a parameter of spin_lock_nested() of
  *			dev->addr_list_lock.
  *	@unlink_list:	As netif_addr_lock() can be called recursively,
  *			keep a list of interfaces to be deleted.
-- 
2.20.1

