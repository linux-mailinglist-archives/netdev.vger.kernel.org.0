Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20BC4444918
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 20:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhKCTlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 15:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbhKCTlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 15:41:08 -0400
Received: from todd.t-8ch.de (todd.t-8ch.de [IPv6:2a01:4f8:c010:41de::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61C0C061203;
        Wed,  3 Nov 2021 12:38:31 -0700 (PDT)
From:   =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1635968309;
        bh=6UveaCiY5lEvYXN6JGXdADIUn/LKhv5DoYE3zqBHiK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uYaijVwttTj8d/enqJEuVcpwLPkGn4c7KAjRgvaCBsq3TsR9/xshZs5hHnz5dFqBY
         uGuMdIkBS81WYeQOtEIEZpu7s017BA8j10GkvIXgCtdnvMOsLWEV1PEJGPhD1a4qEF
         4Phu0XsrPvHDP0MOs8NBXGjQdvgg4yXSSwtVwYfI=
To:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Stabellini <stefano@aporeto.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] 9p/xen: autoload when xenbus service is available
Date:   Wed,  3 Nov 2021 20:38:22 +0100
Message-Id: <20211103193823.111007-4-linux@weissschuh.net>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211103193823.111007-1-linux@weissschuh.net>
References: <20211103193823.111007-1-linux@weissschuh.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 net/9p/trans_xen.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index e264dcee019a..9c4c565f92e4 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -561,6 +561,7 @@ static void p9_trans_xen_exit(void)
 }
 module_exit(p9_trans_xen_exit);
 
+MODULE_ALIAS("xen:9pfs");
 MODULE_AUTHOR("Stefano Stabellini <stefano@aporeto.com>");
 MODULE_DESCRIPTION("Xen Transport for 9P");
 MODULE_LICENSE("GPL");
-- 
2.33.1

