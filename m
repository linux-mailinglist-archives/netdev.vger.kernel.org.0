Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B973FD15B
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 04:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241559AbhIACdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 22:33:31 -0400
Received: from mail-m17644.qiye.163.com ([59.111.176.44]:18498 "EHLO
        mail-m17644.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241128AbhIACda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 22:33:30 -0400
Received: from wanjb-virtual-machine.localdomain (unknown [58.213.83.158])
        by mail-m17644.qiye.163.com (Hmail) with ESMTPA id 84318320106;
        Wed,  1 Sep 2021 10:32:32 +0800 (CST)
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] mptcp: Fix duplicated argument in protocol.h
Date:   Wed,  1 Sep 2021 10:32:05 +0800
Message-Id: <20210901023205.5049-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUhPN1dZLVlBSVdZDwkaFQgSH1lBWRpLSxhWSUJOSRpJTEpMSU
        sdVRMBExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktISkNVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Nj46Ejo*HT9NE0gMMEw8HTwp
        NwoaCyxVSlVKTUhLT01ITk5IS09CVTMWGhIXVQwaFRESGhkSFRw7DRINFFUYFBZFWVdZEgtZQVlO
        Q1VJSkhVQ0hVSk5DWVdZCAFZQUpDQkg3Bg++
X-HM-Tid: 0a7b9f336ca8d99akuws84318320106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

./net/mptcp/protocol.h:36:50-73: duplicated argument to & or |

The OPTION_MPTCP_MPJ_SYNACK here is duplicate.
Here should be OPTION_MPTCP_MPJ_ACK.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
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

