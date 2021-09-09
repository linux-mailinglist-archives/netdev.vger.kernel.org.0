Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6FF405489
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357052AbhIIM7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:59:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354028AbhIIMxd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:53:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A07463240;
        Thu,  9 Sep 2021 11:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188668;
        bh=AKVDomFsRnKdvnYrhbxmZ6yFQKd1JgkXxvr0D8CliHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YuZSayAPaqXtKZXeub5D84cDBaBbtwF9wraTTfsoOEdeTqhhadP9zCqjt1siSH/CY
         BdgqUipjP659QKM//8HYuUppB2qGJnzURUrHqfoi3fMsWI/dtijHiUGxnsFLWkNzvv
         qJyRPYs9V1PuceaNJqz1cfPEtXutYRHNXY9z1clnBAjS/8DaHhU9POj5xsfa5ENGh1
         HASB+6NCgETSkypKJGaFLs6M88HQvPQRL3jR+XlMJOVfpZqOrPoWnFvcReKPoVH5ue
         7kp5HSZnA9H3xhaV/WoN2pwrBYlzhe4Gxy5oxJdc4dlGLvX/+1pyWFyh9nPUj7Jp1k
         lIWb9pSymsFlA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 17/74] bpf/tests: Fix copy-and-paste error in double word test
Date:   Thu,  9 Sep 2021 07:56:29 -0400
Message-Id: <20210909115726.149004-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115726.149004-1-sashal@kernel.org>
References: <20210909115726.149004-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johan Almbladh <johan.almbladh@anyfinetworks.com>

[ Upstream commit ae7f47041d928b1a2f28717d095b4153c63cbf6a ]

This test now operates on DW as stated instead of W, which was
already covered by another test.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210721104058.3755254-1-johan.almbladh@anyfinetworks.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_bpf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 08d3d59dca17..98074a3bc161 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -4293,8 +4293,8 @@ static struct bpf_test tests[] = {
 		.u.insns_int = {
 			BPF_LD_IMM64(R0, 0),
 			BPF_LD_IMM64(R1, 0xffffffffffffffffLL),
-			BPF_STX_MEM(BPF_W, R10, R1, -40),
-			BPF_LDX_MEM(BPF_W, R0, R10, -40),
+			BPF_STX_MEM(BPF_DW, R10, R1, -40),
+			BPF_LDX_MEM(BPF_DW, R0, R10, -40),
 			BPF_EXIT_INSN(),
 		},
 		INTERNAL,
-- 
2.30.2

