Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB05C40D7D9
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 12:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236992AbhIPKxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 06:53:02 -0400
Received: from smtpbg604.qq.com ([59.36.128.82]:37194 "EHLO smtpbg604.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235487AbhIPKxA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 06:53:00 -0400
X-QQ-mid: bizesmtp44t1631789491t5arkjjj
Received: from localhost.localdomain (unknown [180.113.36.229])
        by esmtp6.qq.com (ESMTP) with 
        id ; Thu, 16 Sep 2021 18:51:24 +0800 (CST)
X-QQ-SSF: 0100000000800020B000000A0000000
X-QQ-FEAT: q+EIYT+FhZoEyFn1ILsRlikLkfivFXO3ci2ss10+GGCuB1aitqVHGpdaZ5BLR
        ePCxsDu+YhgdQqhrqTaDvd7oseRlmsAxbLLUugEOid0HDKMdNekjoigI1GFFqZrLc85JPr8
        MMEItRwLy8sAaivtrVi6snnaa3NcrFw9R+3f+i13YHmh3xFGqMHJSgXbYHdsxCWEzH5DBSr
        IKf1JfRqQ4/bgMPpMR1HEDlprfwmtoPUWMHqgsVecIzHIO55NbnFe2khMXcAKLZKRWys9MQ
        UUrFAX8n8eVKd+y12kZW3ylopxia+TuEzz+Kl6o3vCbpXB7e2dg3cWc6rwZ4iHtemPat2zl
        LMKwPQtlkaqBZFjkYjyHeSY2z7vnQ==
X-QQ-GoodBg: 0
From:   Xiang wangx <wangxiang@cdjrlc.com>
To:     shuah@kernel.org
Cc:     bongsu.jeon@samsung.com, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiang wangx <wangxiang@cdjrlc.com>
Subject: [PATCH] selftests: nci: fix grammatical errors
Date:   Thu, 16 Sep 2021 18:51:22 +0800
Message-Id: <20210916105122.12523-1-wangxiang@cdjrlc.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Should not use unsigned expression compared with zero

Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
---
 tools/testing/selftests/nci/nci_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
index e1bf55dabdf6..162c41e9bcae 100644
--- a/tools/testing/selftests/nci/nci_dev.c
+++ b/tools/testing/selftests/nci/nci_dev.c
@@ -746,7 +746,7 @@ int read_write_nci_cmd(int nfc_sock, int virtual_fd, const __u8 *cmd, __u32 cmd_
 		       const __u8 *rsp, __u32 rsp_len)
 {
 	char buf[256];
-	unsigned int len;
+	int len;
 
 	send(nfc_sock, &cmd[3], cmd_len - 3, 0);
 	len = read(virtual_fd, buf, cmd_len);
-- 
2.20.1

