Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0905C2DA37A
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 23:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502030AbgLNWgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 17:36:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39541 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439277AbgLNWg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 17:36:28 -0500
Received: from cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net ([80.193.200.194] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kowRQ-0007kT-F7; Mon, 14 Dec 2020 22:35:40 +0000
From:   Colin King <colin.king@canonical.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] selftests/bpf: fix spelling mistake "tranmission" -> "transmission"
Date:   Mon, 14 Dec 2020 22:35:39 +0000
Message-Id: <20201214223539.83168-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are two spelling mistakes in output messages. Fix these.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 014dedaa4dd2..1e722ee76b1f 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -715,7 +715,7 @@ static void worker_pkt_dump(void)
 		int payload = *((uint32_t *)(pkt_buf[iter]->payload + PKT_HDR_SIZE));
 
 		if (payload == EOT) {
-			ksft_print_msg("End-of-tranmission frame received\n");
+			ksft_print_msg("End-of-transmission frame received\n");
 			fprintf(stdout, "---------------------------------------\n");
 			break;
 		}
@@ -747,7 +747,7 @@ static void worker_pkt_validate(void)
 			}
 
 			if (payloadseqnum == EOT) {
-				ksft_print_msg("End-of-tranmission frame received: PASS\n");
+				ksft_print_msg("End-of-transmission frame received: PASS\n");
 				sigvar = 1;
 				break;
 			}
-- 
2.29.2

