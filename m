Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89DD240554F
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358754AbhIINJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 09:09:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357490AbhIINBD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 09:01:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD10B6140A;
        Thu,  9 Sep 2021 11:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188760;
        bh=YtbVEEC4Fc8VxrXVU+a9hOu8LZW9VwEKLu2s/O2098E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZIZbwVNLKBkz7yBiFZ1lsG/Qppa4lMuGxBFJYuHDV46NG0MI2p4RSwLkNPn9xGLjM
         sq24PbqOyumWELQGdqm59nYoFXRST/wkXKnc5gkOBwHN+9OghCG5i3Oc8AzTwsljX7
         orOqAuV1yzPDulhgcAXjaa0FntzHMx5khO4hWzQ92PHfOYsETEuokDz4HEk7wa2KX6
         sOXfxdxl3Q2KbVMHlCCQkEkQtNDjHyK2c7vfoVgs10/06NDvT86FJlIcQcJCBgFSOw
         /rwpdEP1qpv/wGFggjBhk04ZSgJZT6hwBdK3pd+qeaCnvBwb/E4qzb9NwI9jFgnc7T
         HIXtINbYpjX/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 15/59] bpf/tests: Fix copy-and-paste error in double word test
Date:   Thu,  9 Sep 2021 07:58:16 -0400
Message-Id: <20210909115900.149795-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115900.149795-1-sashal@kernel.org>
References: <20210909115900.149795-1-sashal@kernel.org>
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
index 75ebf2bbc2ee..4aa88ba8238c 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -4395,8 +4395,8 @@ static struct bpf_test tests[] = {
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

