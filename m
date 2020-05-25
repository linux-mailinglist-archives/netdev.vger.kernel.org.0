Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 012861E06ED
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 08:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388880AbgEYGa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 02:30:26 -0400
Received: from m17616.mail.qiye.163.com ([59.111.176.16]:61732 "EHLO
        m17616.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388631AbgEYGa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 02:30:26 -0400
Received: from ubuntu.localdomain (unknown [58.251.74.227])
        by m17616.mail.qiye.163.com (Hmail) with ESMTPA id 386DF1086E6;
        Mon, 25 May 2020 14:30:22 +0800 (CST)
From:   Wang Wenhu <wenhu.wang@vivo.com>
To:     davem@davemloft.net, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com, Wang Wenhu <wenhu.wang@vivo.com>
Subject: [PATCH] drivers: ipa: print dev_err info accurately
Date:   Sun, 24 May 2020 23:29:51 -0700
Message-Id: <20200525062951.29472-1-wenhu.wang@vivo.com>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZT1VMTUpLS0tKTk1PS0lOQllXWShZQU
        hPN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pkk6Cyo*Fjg8Iy0IPApOQhAZ
        KFYKCUlVSlVKTkJLSENDSUlPTk1DVTMWGhIXVQweFRMOVQwaFRw7DRINFFUYFBZFWVdZEgtZQVlO
        Q1VJTkpVTE9VSUlMWVdZCAFZQUpOTk43Bg++
X-HM-Tid: 0a724a8669f89374kuws386df1086e6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Print certain name string instead of hard-coded "memory" for dev_err
output, which would be more accurate and helpful for debugging.

Signed-off-by: Wang Wenhu <wenhu.wang@vivo.com>
Cc: Alex Elder <elder@kernel.org>
---
 drivers/net/ipa/ipa_clock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
index ddbd687fe64b..749ff5668e37 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_clock.c
@@ -66,8 +66,8 @@ ipa_interconnect_init_one(struct device *dev, const char *name)
 
 	path = of_icc_get(dev, name);
 	if (IS_ERR(path))
-		dev_err(dev, "error %ld getting memory interconnect\n",
-			PTR_ERR(path));
+		dev_err(dev, "error %ld getting %s interconnect\n",
+			PTR_ERR(path), name);
 
 	return path;
 }
-- 
2.17.1

