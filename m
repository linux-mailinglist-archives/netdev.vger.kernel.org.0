Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A86081350BF
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 02:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgAIBAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 20:00:09 -0500
Received: from mx133-tc.baidu.com ([61.135.168.133]:19623 "EHLO
        tc-sys-mailedm01.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726758AbgAIBAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 20:00:09 -0500
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm01.tc.baidu.com (Postfix) with ESMTP id 376132040061
        for <netdev@vger.kernel.org>; Thu,  9 Jan 2020 08:59:56 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org
Subject: [PATCH][net-next] flow_dissector: fix document for skb_flow_get_icmp_tci
Date:   Thu,  9 Jan 2020 08:59:56 +0800
Message-Id: <1578531596-6369-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

using correct input parameter name to fix the below warning:

net/core/flow_dissector.c:242: warning: Function parameter or member 'thoff' not described in 'skb_flow_get_icmp_tci'
net/core/flow_dissector.c:242: warning: Excess function parameter 'toff' description in 'skb_flow_get_icmp_tci'

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 net/core/flow_dissector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 2dbbb030fbed..f560b4902060 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -233,7 +233,7 @@ static bool icmp_has_id(u8 type)
  * @skb: sk_buff to extract from
  * @key_icmp: struct flow_dissector_key_icmp to fill
  * @data: raw buffer pointer to the packet
- * @toff: offset to extract at
+ * @thoff: offset to extract at
  * @hlen: packet header length
  */
 void skb_flow_get_icmp_tci(const struct sk_buff *skb,
-- 
2.16.2

