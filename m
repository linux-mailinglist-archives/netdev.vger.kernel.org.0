Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5662CD4DB
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 12:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730302AbgLCLpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 06:45:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48503 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbgLCLpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 06:45:38 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kkn2a-0006ah-UJ; Thu, 03 Dec 2020 11:44:53 +0000
From:   Colin King <colin.king@canonical.com>
To:     Mariusz Dudek <mariuszx.dudek@intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] samples/bpf: Fix spelling mistake "recieving" -> "receiving"
Date:   Thu,  3 Dec 2020 11:44:52 +0000
Message-Id: <20201203114452.1060017-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in an error message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 samples/bpf/xdpsock_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 0fee7f3aef3c..9553c7c47fc4 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1570,7 +1570,7 @@ recv_xsks_map_fd(int *xsks_map_fd)
 
 	err = recv_xsks_map_fd_from_ctrl_node(sock, xsks_map_fd);
 	if (err) {
-		fprintf(stderr, "Error %d recieving fd\n", err);
+		fprintf(stderr, "Error %d receiving fd\n", err);
 		return err;
 	}
 	return 0;
-- 
2.29.2

