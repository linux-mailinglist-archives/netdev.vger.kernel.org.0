Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA90D40D9DF
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 14:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239507AbhIPM0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 08:26:22 -0400
Received: from smtpbg128.qq.com ([106.55.201.39]:39858 "EHLO smtpbg587.qq.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235816AbhIPM0U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 08:26:20 -0400
X-QQ-mid: bizesmtp32t1631795092to1nkx5k
Received: from localhost.localdomain (unknown [180.113.36.229])
        by esmtp6.qq.com (ESMTP) with 
        id ; Thu, 16 Sep 2021 20:24:44 +0800 (CST)
X-QQ-SSF: 0100000000800030B000000A0000000
X-QQ-FEAT: gSGF8h2+s1IADEzB2CCwyyD6/XD9p1aGVRPyyJchy5+VAf++gx9oqFzn3LG1A
        CovWeQ/XIp3aG7oPPk4Ps1jbU+32qjHlyeXKxVUHtvnuvWkjvDfSbH90uWaDy8dQHLuMSpv
        vNzwDh/hHz7HlfZ55OI7tCUfq+KrL7lHOFqDTqcREgOaFdMeN6UFpkAnhmIzrNfWNJSJZjU
        EpTFKN0GgJEKuBpOKbDMZnv9wlzycrdiXoJ0ukyqKQgWD1GNV9Jj3MKTPbMxMeFX+lK2tZz
        yLl1klhtXNq/zJG9PnEprBe+xC4bg3x18gtBJL1kuxjAuVfs/TFi65ZxH7MXSgXVIsmjoZ1
        RcaAag2WLBTbgy4uZh2mI+k2RzfAw==
X-QQ-GoodBg: 0
From:   Xiang wangx <wangxiang@cdjrlc.com>
To:     bongsu.jeon@samsung.com
Cc:     shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiang wangx <wangxiang@cdjrlc.com>
Subject: [PATCH v3] selftests: nci: replace unsigned int with int
Date:   Thu, 16 Sep 2021 20:24:42 +0800
Message-Id: <20210916122442.14732-1-wangxiang@cdjrlc.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Should not use comparison of unsigned expressions < 0.

Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
---

Changes since v1
* Change commit log

Changes since v2
* Change commit log

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

