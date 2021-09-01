Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67073FD1B3
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 05:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241529AbhIADUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 23:20:38 -0400
Received: from mail-m17644.qiye.163.com ([59.111.176.44]:9478 "EHLO
        mail-m17644.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbhIADUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 23:20:37 -0400
Received: from wanjb-virtual-machine.localdomain (unknown [58.213.83.158])
        by mail-m17644.qiye.163.com (Hmail) with ESMTPA id 74E483201D0;
        Wed,  1 Sep 2021 11:19:38 +0800 (CST)
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] [v3] mptcp: Fix duplicated argument in protocol.h
Date:   Wed,  1 Sep 2021 11:19:32 +0800
Message-Id: <20210901031932.7734-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUhPN1dZLVlBSVdZDwkaFQgSH1lBWUIdGU5WQ0MaSkkaSRgaHU
        JLVRMBExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktISkNVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Kzo6OCo5Pj8BKUgjTQIeQxQu
        FhIwCyJVSlVKTUhLT01NSExCS0tNVTMWGhIXVQwaFRESGhkSFRw7DRINFFUYFBZFWVdZEgtZQVlO
        Q1VJSkhVQ0hVSk5DWVdZCAFZQUlKQ0s3Bg++
X-HM-Tid: 0a7b9f5e8b96d99akuws74e483201d0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:
./net/mptcp/protocol.h:36:50-73: duplicated argument to & or |

The OPTION_MPTCP_MPJ_SYNACK here is duplicate.
Here should be OPTION_MPTCP_MPJ_ACK.

Fixes: 74c7dfbee3e18 ("mptcp: consolidate in_opt sub-options fields in a bitmask")
Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
Changelog:
v2:
- Add a Fixes-tag.
v3:
- Make Fixes-tag to be a single line.
---
 net/mptcp/protocol.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index d7aba1c4dc48..64c9a30e0871 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -34,7 +34,7 @@
 #define OPTIONS_MPTCP_MPC	(OPTION_MPTCP_MPC_SYN | OPTION_MPTCP_MPC_SYNACK | \
 				 OPTION_MPTCP_MPC_ACK)
 #define OPTIONS_MPTCP_MPJ	(OPTION_MPTCP_MPJ_SYN | OPTION_MPTCP_MPJ_SYNACK | \
-				 OPTION_MPTCP_MPJ_SYNACK)
+				 OPTION_MPTCP_MPJ_ACK)
 
 /* MPTCP option subtypes */
 #define MPTCPOPT_MP_CAPABLE	0
-- 
2.25.1

