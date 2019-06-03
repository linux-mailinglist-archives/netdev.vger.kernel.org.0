Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B73D33134
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 15:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbfFCNhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 09:37:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52862 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbfFCNhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 09:37:01 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hXn8w-0008OS-C3; Mon, 03 Jun 2019 13:36:54 +0000
From:   Colin King <colin.king@canonical.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] bpf: hbm: fix spelling mistake "notifcations" -> "notificiations"
Date:   Mon,  3 Jun 2019 14:36:53 +0100
Message-Id: <20190603133653.18185-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in the help information, fix this.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 samples/bpf/hbm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/hbm.c b/samples/bpf/hbm.c
index 480b7ad6a1f2..bdfce592207a 100644
--- a/samples/bpf/hbm.c
+++ b/samples/bpf/hbm.c
@@ -411,7 +411,7 @@ static void Usage(void)
 	       "    -l         also limit flows using loopback\n"
 	       "    -n <#>     to create cgroup \"/hbm#\" and attach prog\n"
 	       "               Default is /hbm1\n"
-	       "    --no_cn    disable CN notifcations\n"
+	       "    --no_cn    disable CN notifications\n"
 	       "    -r <rate>  Rate in Mbps\n"
 	       "    -s         Update HBM stats\n"
 	       "    -t <time>  Exit after specified seconds (default is 0)\n"
-- 
2.20.1

