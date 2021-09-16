Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A02940D91B
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 13:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238317AbhIPLyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 07:54:10 -0400
Received: from smtpbg587.qq.com ([113.96.223.105]:42011 "EHLO smtpbg587.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238405AbhIPLyK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 07:54:10 -0400
X-QQ-mid: bizesmtp51t1631793164tc1lhp8d
Received: from localhost.localdomain (unknown [180.113.36.229])
        by esmtp6.qq.com (ESMTP) with 
        id ; Thu, 16 Sep 2021 19:52:33 +0800 (CST)
X-QQ-SSF: 0100000000800030B000000A0000000
X-QQ-FEAT: dKvkn8qoLrG12dQ3LGYEKofR9s+KyHHoYz8f5GLuMcHfk3KEUBCV0jbaC/XKw
        xwospsK9oL0tI6pAzoH1ij4fUqYipsxY7FnbFwB3mje5qpk4mPaArs1Nx/TN0lSJsuo30Z3
        bFLaNKYCSkA6NTwhfMBPOhGicBsJCzLz4Cld2MrHFqhhZhmIRreYDYOg6DFT4VP77JYgd2f
        VSfv7zA5DSCuNOdmqcA+VCP8Olj0GmhogrqKGN3Gc73pN+ykGptNk8ArWQ35APBRTvQnoMS
        ygwxQkTswBzFt18l9bBz9y4Zom8evE+pXphuimIAI07MNacOUmkQU6aS8MxheqhI4NaP+hj
        c8L/nFWBsSme8v6nfban+890oyq2A==
X-QQ-GoodBg: 0
From:   Xiang wangx <wangxiang@cdjrlc.com>
To:     bongsu.jeon@samsung.com
Cc:     shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiang wangx <wangxiang@cdjrlc.com>
Subject: [PATCH v2] selftests: nci: replace unsigned int with int
Date:   Thu, 16 Sep 2021 19:52:12 +0800
Message-Id: <20210916115212.24246-1-wangxiang@cdjrlc.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Should not use comparison of unsigned expressions < 0

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

