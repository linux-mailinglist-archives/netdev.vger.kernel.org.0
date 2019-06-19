Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA0A34BE0D
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 18:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729973AbfFSQ1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 12:27:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60382 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfFSQ1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 12:27:52 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hddR1-0000l7-4Q; Wed, 19 Jun 2019 16:27:43 +0000
From:   Colin King <colin.king@canonical.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] libbpf: fix spelling mistake "conflictling" -> "conflicting"
Date:   Wed, 19 Jun 2019 17:27:42 +0100
Message-Id: <20190619162742.985-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are several spelling mistakes in pr_warning messages. Fix these.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 tools/lib/bpf/libbpf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 4259c9f0cfe7..68f45a96769f 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1169,7 +1169,7 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
 			pr_debug("map '%s': found key_size = %u.\n",
 				 map_name, sz);
 			if (map->def.key_size && map->def.key_size != sz) {
-				pr_warning("map '%s': conflictling key size %u != %u.\n",
+				pr_warning("map '%s': conflicting key size %u != %u.\n",
 					   map_name, map->def.key_size, sz);
 				return -EINVAL;
 			}
@@ -1197,7 +1197,7 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
 			pr_debug("map '%s': found key [%u], sz = %lld.\n",
 				 map_name, t->type, sz);
 			if (map->def.key_size && map->def.key_size != sz) {
-				pr_warning("map '%s': conflictling key size %u != %lld.\n",
+				pr_warning("map '%s': conflicting key size %u != %lld.\n",
 					   map_name, map->def.key_size, sz);
 				return -EINVAL;
 			}
@@ -1212,7 +1212,7 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
 			pr_debug("map '%s': found value_size = %u.\n",
 				 map_name, sz);
 			if (map->def.value_size && map->def.value_size != sz) {
-				pr_warning("map '%s': conflictling value size %u != %u.\n",
+				pr_warning("map '%s': conflicting value size %u != %u.\n",
 					   map_name, map->def.value_size, sz);
 				return -EINVAL;
 			}
@@ -1240,7 +1240,7 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
 			pr_debug("map '%s': found value [%u], sz = %lld.\n",
 				 map_name, t->type, sz);
 			if (map->def.value_size && map->def.value_size != sz) {
-				pr_warning("map '%s': conflictling value size %u != %lld.\n",
+				pr_warning("map '%s': conflicting value size %u != %lld.\n",
 					   map_name, map->def.value_size, sz);
 				return -EINVAL;
 			}
-- 
2.20.1

