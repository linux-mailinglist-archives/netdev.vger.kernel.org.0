Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D518735C5A0
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 13:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240502AbhDLLuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 07:50:39 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:36642 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238164AbhDLLui (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 07:50:38 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4FJn2N0jm6z9tyR2;
        Mon, 12 Apr 2021 13:44:12 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id BvH0PNmN9McC; Mon, 12 Apr 2021 13:44:12 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4FJn2M6bMRz9tyQT;
        Mon, 12 Apr 2021 13:44:11 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id E90698B78E;
        Mon, 12 Apr 2021 13:44:16 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 1sXtALhaLiMZ; Mon, 12 Apr 2021 13:44:16 +0200 (CEST)
Received: from po16121vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 715808B78D;
        Mon, 12 Apr 2021 13:44:16 +0200 (CEST)
Received: by po16121vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id 330B467A06; Mon, 12 Apr 2021 11:44:16 +0000 (UTC)
Message-Id: <34d12a4f75cb8b53a925fada5e7ddddd3b145203.1618227846.git.christophe.leroy@csgroup.eu>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 1/3] powerpc/ebpf32: Fix comment on BPF_ALU{64} | BPF_LSH |
 BPF_K
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Mon, 12 Apr 2021 11:44:16 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace <<== by <<=

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 arch/powerpc/net/bpf_jit_comp32.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
index 003843273b43..ca6fe1583460 100644
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -559,12 +559,12 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 			EMIT(PPC_RAW_SLW(dst_reg, dst_reg, src_reg));
 			EMIT(PPC_RAW_OR(dst_reg_h, dst_reg_h, __REG_R0));
 			break;
-		case BPF_ALU | BPF_LSH | BPF_K: /* (u32) dst <<== (u32) imm */
+		case BPF_ALU | BPF_LSH | BPF_K: /* (u32) dst <<= (u32) imm */
 			if (!imm)
 				break;
 			EMIT(PPC_RAW_SLWI(dst_reg, dst_reg, imm));
 			break;
-		case BPF_ALU64 | BPF_LSH | BPF_K: /* dst <<== imm */
+		case BPF_ALU64 | BPF_LSH | BPF_K: /* dst <<= imm */
 			if (imm < 0)
 				return -EINVAL;
 			if (!imm)
-- 
2.25.0

