Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391191F29B2
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387697AbgFIADW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:03:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731225AbgFHXVv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:21:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E34A20842;
        Mon,  8 Jun 2020 23:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658510;
        bh=za9EyI3o5uaFj1FcFu/tNsgXVP1mJnijVnQloGQKC8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0QWkDq//IfWdyHXzYu7A2xomoT1iponN6USptM6G49qEdIGy59BwDrpSqcDvHqWj7
         Q2+BO6dp6oo+NurjVyFOEzsyNcmwmS1n2x+yI8Pr0d9g2eCV3PJJD000QHfw51FKzV
         bN1omiVfWHEQfcni5tCQN5aC/UtnZ/2T6+ggaPh4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alan Maguire <alan.maguire@oracle.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 140/175] selftests/bpf: CONFIG_IPV6_SEG6_BPF required for test_seg6_loop.o
Date:   Mon,  8 Jun 2020 19:18:13 -0400
Message-Id: <20200608231848.3366970-140-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alan Maguire <alan.maguire@oracle.com>

[ Upstream commit 3c8e8cf4b18b3a7034fab4c4504fc4b54e4b6195 ]

test_seg6_loop.o uses the helper bpf_lwt_seg6_adjust_srh();
it will not be present if CONFIG_IPV6_SEG6_BPF is not specified.

Fixes: b061017f8b4d ("selftests/bpf: add realistic loop tests")
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/1590147389-26482-2-git-send-email-alan.maguire@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 5dc109f4c097..b9601f13cf03 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -25,6 +25,7 @@ CONFIG_XDP_SOCKETS=y
 CONFIG_FTRACE_SYSCALLS=y
 CONFIG_IPV6_TUNNEL=y
 CONFIG_IPV6_GRE=y
+CONFIG_IPV6_SEG6_BPF=y
 CONFIG_NET_FOU=m
 CONFIG_NET_FOU_IP_TUNNELS=y
 CONFIG_IPV6_FOU=m
-- 
2.25.1

