Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999B83F31CA
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 18:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbhHTQz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 12:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232622AbhHTQzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 12:55:54 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFC2C061756
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 09:55:16 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id j9so5847738qvt.4
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 09:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fu4+PEWQ87vZiGjl7KyFUYdCMwiriMEkc4k2Dmlg/B4=;
        b=VzHxr9UNasgH57nLhpyqdoT7BsV8FtGUDcODwDSC8y+6G5eR/8iJAbxujLDlNt5bA9
         3Lkq5pyGU8/GJS9En20Gp7I5QzTYa/4HXoWEzy/6ptrDXpPwqXXlO0Aql+eoWmJ6CQe7
         8LThirTSIa56j22hbgxUBirUrdEJze8z2NeHY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fu4+PEWQ87vZiGjl7KyFUYdCMwiriMEkc4k2Dmlg/B4=;
        b=Wh2mPUnWhfU9jQD01irEBIPU2tKaLW3xb5JcjG7JrqlnnZdZEW6v8Rhp21MJ7kUpaB
         aVrPSzT7zHDCf+uM5uDLsn/9LoGOY3PfVn+j6XFdamWIeqet2JZt1HU0mFt+lJH6Pqvz
         FQdxR+i589Dm6SkbPM9sVGagvuaiGQDTkA4bxSrcfu78i+/R5OqJZ+Ufo/XWoxV6FzYW
         la/hy5YQ6hqKAVS4wPT77TFwEFo4tHJ+MiXOm1uK3O+w0SzhJGG2NvamM1fO/W9d2KWg
         cTkfipfb584R8x5RI1j28Hl92H6RS5gh8JHBWKi/nfoBLlZFycfuHXfufoAEwWPfEE/z
         CA8A==
X-Gm-Message-State: AOAM531RK1H9wsZh35eksZgiLrP7Sc47zVu6jbQZYPL26p1aVZ3NLr+A
        WejlDt1FFUK+dx56pnlLsRxTaP/G2DpNfAKFNKsxQMmHF01tqT+g2cBLUNAPLrizeZz+vZvGO+N
        wqvKEvO5rbAvFIletRPCCsD+2KJRWGDKcODgFKEhs/jbTrKlNMfMv3zsMYamkhbJWY+rpow==
X-Google-Smtp-Source: ABdhPJzZBTlctaNaVMbW+4RGXpIBuCVcZSyPu+S+4slyxlVE7q2VJPN5Yib5nDGfvSkJBChqoadLhg==
X-Received: by 2002:a0c:ef84:: with SMTP id w4mr20937176qvr.34.1629478514711;
        Fri, 20 Aug 2021 09:55:14 -0700 (PDT)
Received: from localhost.localdomain ([191.91.81.196])
        by smtp.gmail.com with ESMTPSA id p22sm3369044qkj.16.2021.08.20.09.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 09:55:14 -0700 (PDT)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauriciov@microsoft.com>
Subject: [PATCH bpf-next] libbpf: remove unused variable
Date:   Fri, 20 Aug 2021 11:55:11 -0500
Message-Id: <20210820165511.72890-1-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mauricio Vásquez <mauriciov@microsoft.com>

Fixes: ddc7c3042614 ("libbpf: implement BPF CO-RE offset relocation algorithm")

Signed-off-by: Mauricio Vásquez <mauriciov@microsoft.com>
---
 tools/lib/bpf/relo_core.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git tools/lib/bpf/relo_core.c tools/lib/bpf/relo_core.c
index 4016ed492d0c..52d8125b7cbe 100644
--- tools/lib/bpf/relo_core.c
+++ tools/lib/bpf/relo_core.c
@@ -417,13 +417,6 @@ static int bpf_core_match_member(const struct btf *local_btf,
 				return found;
 		} else if (strcmp(local_name, targ_name) == 0) {
 			/* matching named field */
-			struct bpf_core_accessor *targ_acc;
-
-			targ_acc = &spec->spec[spec->len++];
-			targ_acc->type_id = targ_id;
-			targ_acc->idx = i;
-			targ_acc->name = targ_name;
-
 			*next_targ_id = m->type;
 			found = bpf_core_fields_are_compat(local_btf,
 							   local_member->type,
-- 
2.25.1

