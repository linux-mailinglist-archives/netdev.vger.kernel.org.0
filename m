Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D75F405729
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357650AbhIINbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 09:31:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358412AbhIINHT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 09:07:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1CB1632AD;
        Thu,  9 Sep 2021 12:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188832;
        bh=Nx0ZaIFP3TLnzMwyfec1HeaE3b6x+KqrJO6HnXkTTww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ha7CZykjcaW5uowiiCXxsYdrEJcSa1PiwMNiY1MmRypn0BE/nhM7WgwO+A7Y8iWlI
         I1JH612n6IBPXRnNh/cKlBVs8Q8xHEf0QO9Phudh1WGSBnKpGG3Xr6/32IJvB+vp3d
         qBCls+etkR+rPX3xQoZdHWV0p+guxjY6XH4tPlRsuvos21/QWllr99yt8D+gbgJUNT
         8EXL7akeEL0oN4i2dJaKFYx/mV3KRgoAdLu1h+YSpWS8lBk2Bdvv5izz+LY9m06J+Y
         rhvDdMHgqELiSv7sUi4JhkWepNSCSmScSR/5TU8yGQ3wEtwTLCN6OItSpUBE1OFxHK
         IoqocOYcAT5BQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 13/48] bpf/tests: Fix copy-and-paste error in double word test
Date:   Thu,  9 Sep 2021 07:59:40 -0400
Message-Id: <20210909120015.150411-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909120015.150411-1-sashal@kernel.org>
References: <20210909120015.150411-1-sashal@kernel.org>
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
index 960d4d627361..ed2ebf677457 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -4295,8 +4295,8 @@ static struct bpf_test tests[] = {
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

