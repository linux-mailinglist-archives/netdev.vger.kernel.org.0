Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35C71E1807
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 01:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388455AbgEYXAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 19:00:48 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:50566 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbgEYXAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 19:00:47 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 126B083640;
        Tue, 26 May 2020 11:00:44 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1590447644;
        bh=Xne4K3RqtbPnQ+ea6EEqddntF/BSLVnRXKCdz++ZUVs=;
        h=From:To:Cc:Subject:Date;
        b=DcdiVSV3snOO/4jZNyhqgCNWHeF4pdzEY1zcS148Xn/nLJzz3fN1BxyeP4BIgJJeu
         +Sj06htHFGOyozp7Sn6aRpkW5O0YT1rkCcLLeA3ss5slwXQKnnbXaH8JFzo8En9u0u
         Rc9+bCwmKuswhePWY1+bXHz69Aq/JBb2OSA0EVet9UtXa7s+2QM8MIo1oJzxRNzHrV
         vzUH9aWJw3TAoTcStnBMXRxsGr4K4I68HpBm87VqOBjPAvk1Hix5bNARSDQ4l1A3Wm
         DKvzsXPxtvtWSV3q5bKfpIb0TrAKyuKCagqjQlpGW0jAc3btnlg9ztzhGBZRGKGmAJ
         Geakiq5O7jNOw==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5ecc4e180000>; Tue, 26 May 2020 11:00:44 +1200
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id 10F2813ED4B;
        Tue, 26 May 2020 11:00:39 +1200 (NZST)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 0535228006C; Tue, 26 May 2020 11:00:40 +1200 (NZST)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH] bpf: Fix spelling in comment
Date:   Tue, 26 May 2020 11:00:24 +1200
Message-Id: <20200525230025.14470-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change 'handeled' to 'handled'.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---
 kernel/bpf/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 916f5132a984..1ff8e73e9b12 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1543,7 +1543,7 @@ static u64 __no_fgcse ___bpf_prog_run(u64 *regs, co=
nst struct bpf_insn *insn, u6
=20
 		/* ARG1 at this point is guaranteed to point to CTX from
 		 * the verifier side due to the fact that the tail call is
-		 * handeled like a helper, that is, bpf_tail_call_proto,
+		 * handled like a helper, that is, bpf_tail_call_proto,
 		 * where arg1_type is ARG_PTR_TO_CTX.
 		 */
 		insn =3D prog->insnsi;
--=20
2.25.1

