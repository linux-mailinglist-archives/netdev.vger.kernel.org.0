Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E47434892A
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 07:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhCYGgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 02:36:33 -0400
Received: from mail-m17637.qiye.163.com ([59.111.176.37]:43826 "EHLO
        mail-m17637.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhCYGgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 02:36:23 -0400
Received: from wanjb-virtual-machine.localdomain (unknown [36.152.145.182])
        by mail-m17637.qiye.163.com (Hmail) with ESMTPA id B8E4D98047A;
        Thu, 25 Mar 2021 14:36:04 +0800 (CST)
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Wan Jiabing <wanjiabing@vivo.com>, oss-drivers@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net
Subject: [PATCH] drivers: net: ethernet: struct sk_buff is declared duplicately
Date:   Thu, 25 Mar 2021 14:35:55 +0800
Message-Id: <20210325063559.853282-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZTRlJTB5PQ09JT01LVkpNSk1NTk9KTU5LTU9VEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pgw6Ggw6ED8WQz5KLCs#UTkp
        SDQwChdVSlVKTUpNTU5PSk1OSElMVTMWGhIXVQwaFRESGhkSFRw7DRINFFUYFBZFWVdZEgtZQVlI
        TVVKTklVSk9OVUpDSVlXWQgBWUFKTUxLNwY+
X-HM-Tid: 0a786818e3ebd992kuwsb8e4d98047a
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct sk_buff has been declared. Remove the duplicate.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_app.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_app.h b/drivers/net/ethernet/netronome/nfp/nfp_app.h
index 76d13af46a7a..3e9baff07100 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_app.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_app.h
@@ -18,7 +18,6 @@ struct netdev_bpf;
 struct netlink_ext_ack;
 struct pci_dev;
 struct sk_buff;
-struct sk_buff;
 struct nfp_app;
 struct nfp_cpp;
 struct nfp_pf;
-- 
2.25.1

