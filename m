Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC06A40D2E9
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 07:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhIPFwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 01:52:33 -0400
Received: from smtpbg587.qq.com ([113.96.223.105]:49437 "EHLO smtpbg587.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231293AbhIPFwc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 01:52:32 -0400
X-QQ-mid: bizesmtp54t1631771465t8hhry8y
Received: from localhost.localdomain (unknown [182.148.15.91])
        by esmtp6.qq.com (ESMTP) with 
        id ; Thu, 16 Sep 2021 13:50:52 +0800 (CST)
X-QQ-SSF: 0100000000800010B000000A0000000
X-QQ-FEAT: Gq6/1HjPYVUeBdoHG0ZxohswL4L2+PDzoEGGnAVGNedqpbgwL3oVOsK0gjt77
        CrOpRicoI6etNu5aFd3H6T5+bC8ChE4beDOWl66ZbUIyawtmS5z82A+i1eyXJgAwRK9yd8R
        MW/2gMXPb+kXzNimHIUo+CfaihhZz9tAqsA5V3Ev+cRrsIdYzR/oKGOzG9jkOy29nJAhirA
        4Qb9G7Boxv+tcDOqyN5/b+UFxJYhqapn/BifYrKWKzpzBKlERptKTRqzH20TXyoKi7y0I3t
        531s6AKowqsOAmgfYbvxDrcBjx7cdlPKp7BoiCe9THyvFARrN0sLRpS2xirFd07U5rLPCSW
        mJ2R/cj
X-QQ-GoodBg: 0
From:   Xiang wangx <wangxiang@cdjrlc.com>
To:     netdev@vger.kernel.org
Cc:     Xiang wangx <wangxiang@cdjrlc.com>
Subject: [PATCH] selftests: nci: use int replace unsigned int
Date:   Thu, 16 Sep 2021 13:50:45 +0800
Message-Id: <20210916055045.60032-1-wangxiang@cdjrlc.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam3
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

