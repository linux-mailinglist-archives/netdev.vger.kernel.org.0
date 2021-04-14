Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D227D35F60D
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 16:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348468AbhDNORX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 10:17:23 -0400
Received: from m12-16.163.com ([220.181.12.16]:58067 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348303AbhDNORW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 10:17:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=2p7xN
        dQVAt+VJI8mut/3TIEyzUuatnLRUtisnz6PIMI=; b=EPzx6A3QbQGpzXabrRMhH
        X16vYz4paLYhxx1bmlywEdOzCe9d/xUYxiGHXzNedxyB83Or+wNBHD9G+J36HPC6
        x0gq3NahHu9uidK7TpJ9xP1HMyfUtFIUesO6u8RrgKFa6fFoWrL+Whb6uIhKvTcU
        RaWL7a4k+537BOpjTVsFnE=
Received: from COOL-20201210PM.ccdomain.com (unknown [218.94.48.178])
        by smtp12 (Coremail) with SMTP id EMCowAAHD+88+XZgletMlg--.578S2;
        Wed, 14 Apr 2021 22:16:31 +0800 (CST)
From:   zuoqilin1@163.com
To:     shuah@kernel.org, andrii@kernel.org, kafai@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        zuoqilin <zuoqilin@yulong.com>
Subject: [PATCH] tools/testing: Remove unused variable
Date:   Wed, 14 Apr 2021 22:16:39 +0800
Message-Id: <20210414141639.1446-1-zuoqilin1@163.com>
X-Mailer: git-send-email 2.28.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EMCowAAHD+88+XZgletMlg--.578S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZFWfJr48tF43Jw1xGFW8Xrb_yoW3ZrbEvr
        4IgrykuF4ku343Jr13GwnxurZYvw4j9rWDGFW8Wa43tws8u3W5KFn5Crn7J34rWrZ8GasF
        ganYkF93Cr4UGjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU80fO7UUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 52xr1xpolqiqqrwthudrp/1tbiZQJ0iV8ZN04rRAACsI
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zuoqilin <zuoqilin@yulong.com>

Remove unused variable "ret2".

Signed-off-by: zuoqilin <zuoqilin@yulong.com>
---
 tools/testing/selftests/bpf/progs/test_tunnel_kern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
index ba6eadf..e7b6731 100644
--- a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
@@ -396,7 +396,7 @@ int _ip6vxlan_get_tunnel(struct __sk_buff *skb)
 SEC("geneve_set_tunnel")
 int _geneve_set_tunnel(struct __sk_buff *skb)
 {
-	int ret, ret2;
+	int ret;
 	struct bpf_tunnel_key key;
 	struct geneve_opt gopt;
 
-- 
1.9.1


