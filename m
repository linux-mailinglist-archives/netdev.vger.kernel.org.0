Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF9736BCB1
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 02:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234612AbhD0Ama (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 20:42:30 -0400
Received: from m12-12.163.com ([220.181.12.12]:45062 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232022AbhD0Ama (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 20:42:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=QKZP24SX5N2Yt0Y0mx
        ulfm78SXUMh/K6XKGcvOfKd00=; b=VtrVWDJp/OUfXK87jurMonJM29YXSIy5TS
        tFB36QfVuCbQ39CyYsLBsAG5xQujet46aYWxQMpyUVfKvfkh3O3zgNZOCi+qAlBK
        l4Ewy1iACzpOHVJ187QY9LlLRXBGBqmGf2E7FI3N7Vg0bHSfGKrR8qyIvVZLqbAT
        VVly4YbzI=
Received: from localhost.localdomain (unknown [101.229.16.77])
        by smtp8 (Coremail) with SMTP id DMCowACn8yiKXYdgUgNhAw--.27679S2;
        Tue, 27 Apr 2021 08:40:50 +0800 (CST)
From:   qhjindev <qhjin_dev@163.com>
To:     pshelar@ovn.org
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org,
        qhjin_dev@163.com
Subject: [PATCH] openvswitch: fix typo
Date:   Tue, 27 Apr 2021 08:40:33 +0800
Message-Id: <20210427004033.944-1-qhjin_dev@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: DMCowACn8yiKXYdgUgNhAw--.27679S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvj4RJUUUUUUUU
X-Originating-IP: [101.229.16.77]
X-CM-SenderInfo: ptkmx0hbgh4qqrwthudrp/1tbi8BKBHFuobjxrzQAAs4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

change 'subsytem' to 'subsystem'

Signed-off-by: qhjindev <qhjin_dev@163.com>
---
 net/openvswitch/vport.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/vport.h b/net/openvswitch/vport.h
index 1eb7495ac5b4..8a930ca6d6b1 100644
--- a/net/openvswitch/vport.h
+++ b/net/openvswitch/vport.h
@@ -20,7 +20,7 @@
 struct vport;
 struct vport_parms;
 
-/* The following definitions are for users of the vport subsytem: */
+/* The following definitions are for users of the vport subsystem: */
 
 int ovs_vport_init(void);
 void ovs_vport_exit(void);
-- 
2.17.1


