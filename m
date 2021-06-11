Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B45C3A3962
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 03:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbhFKBuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 21:50:51 -0400
Received: from mail-m975.mail.163.com ([123.126.97.5]:41262 "EHLO
        mail-m975.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbhFKBuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 21:50:51 -0400
X-Greylist: delayed 909 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jun 2021 21:50:50 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=RfdB9
        tWXj/0u5slrh/pTsGjDY40XZRxXML2/XdGZTUc=; b=ZnahpEM7bL86T6zYM6Lc0
        fB5MpZcseC28RQnhSCOcgrS0nAhdpIe+vO5EN8P1NsNdN9Pto+JTU7z83EcZC32b
        u8dQHhHMhNnf6HFR8BdxiUEjtbVh4AIak365xYqiPR1kSfcnVbY4pTXtnxbrJqka
        vpGLYYu3VZiOwaPY404k/c=
Received: from ubuntu.localdomain (unknown [103.220.76.197])
        by smtp5 (Coremail) with SMTP id HdxpCgDHetVvvcJgtiDYHQ--.65S2;
        Fri, 11 Jun 2021 09:33:38 +0800 (CST)
From:   13145886936@163.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>
Subject: [PATCH] net: devres: Correct a grammatical error
Date:   Fri, 11 Jun 2021 09:33:33 +0800
Message-Id: <20210611013333.12843-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HdxpCgDHetVvvcJgtiDYHQ--.65S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Xr4DtryUXw4DZF18Gw1ftFb_yoW3CFc_Jw
        1Fkrn7Xw4rJw1I9w45Zr4rZr42yw40qFW8Kwn7XFZ5t34UX395G395Zr4agF4vgr17Ar9x
        u3Z8Jr45K34a9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8epBDUUUUU==
X-Originating-IP: [103.220.76.197]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/xtbBzhKug1QHM2xPCQAAs7
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

Correct a grammatical error.

Signed-off-by: gushengxian <gushengxian@yulong.com>
---
 net/devres.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/devres.c b/net/devres.c
index 1f9be2133787..5ccf6ca311dc 100644
--- a/net/devres.c
+++ b/net/devres.c
@@ -60,7 +60,7 @@ static int netdev_devres_match(struct device *dev, void *this, void *match_data)
  *	@ndev: device to register
  *
  *	This is a devres variant of register_netdev() for which the unregister
- *	function will be call automatically when the managing device is
+ *	function will be called automatically when the managing device is
  *	detached. Note: the net_device used must also be resource managed by
  *	the same struct device.
  */
-- 
2.25.1

