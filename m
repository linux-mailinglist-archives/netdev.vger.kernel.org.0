Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F92404A4D
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 13:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240533AbhIILp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 07:45:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239687AbhIILoR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 07:44:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B6A061209;
        Thu,  9 Sep 2021 11:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187749;
        bh=muu/jGLTtttFmQjtnPa4AwWkhKRn8IA8zQIhSyPmmys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tY8rX5/xcwtCxWdl3lGLnBeRWuvOLO0O0737AZ8ZuCaoWa9GddiWErqSu5tHi/CDf
         /BtDoa9xge0kxDnmdxt6WJRxDL16LTxh3kMebSdNRHvGJ51KzpQxwAgk9GQEm7DTwB
         QgPBatUInFDjp7zpHWmbE0Q4HLT88mVaqq4WoVTdR1bqTi2FBF9MmBKlMY4S5BIRbD
         y02OpFz+DQTI+g9NfLbKc6a8qDAQqgIDpet5lZCXFUo3CHjEz8BU870IbmkJgx6JZv
         ljoLNU9a7VjTi81YhhVVmf3XbYlozPWDdR+AiKgReHiKGoyFe+ZFpQ5xZZR0yeLFO4
         LHZvr+WfAHS2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 064/252] bpf/tests: Fix copy-and-paste error in double word test
Date:   Thu,  9 Sep 2021 07:37:58 -0400
Message-Id: <20210909114106.141462-64-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
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
index d500320778c7..1c5299cb3f19 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -4286,8 +4286,8 @@ static struct bpf_test tests[] = {
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

