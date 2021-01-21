Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CCE2FF275
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 18:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389183AbhAURwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 12:52:40 -0500
Received: from sym2.noone.org ([178.63.92.236]:37134 "EHLO sym2.noone.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388793AbhAURwc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 12:52:32 -0500
X-Greylist: delayed 502 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jan 2021 12:52:31 EST
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 4DM8rD4rKrzvjfn; Thu, 21 Jan 2021 18:43:24 +0100 (CET)
From:   Tobias Klauser <tklauser@distanz.ch>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH bpf-next] bpf: fix typo in scalar{,32}_min_max_rsh comments
Date:   Thu, 21 Jan 2021 18:43:24 +0100
Message-Id: <20210121174324.24127-1-tklauser@distanz.ch>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/bounts/bounds/

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 kernel/bpf/verifier.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 785d25392ead..d0eae51b31e4 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6266,7 +6266,7 @@ static void scalar32_min_max_rsh(struct bpf_reg_state *dst_reg,
 	 * 3) the signed bounds cross zero, so they tell us nothing
 	 *    about the result
 	 * If the value in dst_reg is known nonnegative, then again the
-	 * unsigned bounts capture the signed bounds.
+	 * unsigned bounds capture the signed bounds.
 	 * Thus, in all cases it suffices to blow away our signed bounds
 	 * and rely on inferring new ones from the unsigned bounds and
 	 * var_off of the result.
@@ -6297,7 +6297,7 @@ static void scalar_min_max_rsh(struct bpf_reg_state *dst_reg,
 	 * 3) the signed bounds cross zero, so they tell us nothing
 	 *    about the result
 	 * If the value in dst_reg is known nonnegative, then again the
-	 * unsigned bounts capture the signed bounds.
+	 * unsigned bounds capture the signed bounds.
 	 * Thus, in all cases it suffices to blow away our signed bounds
 	 * and rely on inferring new ones from the unsigned bounds and
 	 * var_off of the result.
-- 
2.30.0

