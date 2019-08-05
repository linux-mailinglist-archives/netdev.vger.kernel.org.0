Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9ECD8178F
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 12:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbfHEKwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 06:52:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32810 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbfHEKwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 06:52:15 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1huab5-0007uq-Qh; Mon, 05 Aug 2019 10:52:11 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH]][next] selftests: nettest: fix spelling mistake: "potocol" -> "protocol"
Date:   Mon,  5 Aug 2019 11:52:11 +0100
Message-Id: <20190805105211.27229-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in an error messgae. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 tools/testing/selftests/net/nettest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index 9278f8460d75..83515e5ea4dc 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -1627,7 +1627,7 @@ int main(int argc, char *argv[])
 				args.protocol = pe->p_proto;
 			} else {
 				if (str_to_uint(optarg, 0, 0xffff, &tmp) != 0) {
-					fprintf(stderr, "Invalid potocol\n");
+					fprintf(stderr, "Invalid protocol\n");
 					return 1;
 				}
 				args.protocol = tmp;
-- 
2.20.1

