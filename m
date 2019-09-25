Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF839BDB33
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 11:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731564AbfIYJin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 05:38:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57720 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727370AbfIYJin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 05:38:43 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iD3kp-0002pc-A2; Wed, 25 Sep 2019 09:38:35 +0000
From:   Colin King <colin.king@canonical.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bpf: clean up indentation issue
Date:   Wed, 25 Sep 2019 10:38:35 +0100
Message-Id: <20190925093835.19515-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a statement that is indented one level too deeply,
remove the extraneous tab.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 kernel/bpf/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 722d38e543e9..29c7c06c6bd6 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -2332,7 +2332,7 @@ static int btf_enum_check_kflag_member(struct btf_verifier_env *env,
 		if (BITS_PER_BYTE_MASKED(struct_bits_off)) {
 			btf_verifier_log_member(env, struct_type, member,
 						"Member is not byte aligned");
-				return -EINVAL;
+			return -EINVAL;
 		}
 
 		nr_bits = int_bitsize;
-- 
2.20.1

