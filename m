Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBE70126883
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 18:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfLSR5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 12:57:41 -0500
Received: from mta-p8.oit.umn.edu ([134.84.196.208]:48026 "EHLO
        mta-p8.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbfLSR5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 12:57:40 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p8.oit.umn.edu (Postfix) with ESMTP id 47f02q323Jz9vcwg
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 17:57:39 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p8.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p8.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Ax0inqPAypPz for <netdev@vger.kernel.org>;
        Thu, 19 Dec 2019 11:57:39 -0600 (CST)
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com [209.85.219.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p8.oit.umn.edu (Postfix) with ESMTPS id 47f02q1kz7z9vcww
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 11:57:39 -0600 (CST)
Received: by mail-yb1-f199.google.com with SMTP id k190so4662544yba.15
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 09:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JwhEB9Dx/uNy1TVdO49rVoEq5ZejBIq7czTQQQLig8s=;
        b=lnNs6bUqQMHO46MODGi8ofRYuxKCRllWB9uUhsAii4PrWq7hDLXNvFVWddmE7b5fZM
         QMSDklstNrnK4/yQx7TvERwZxyaKKokRInOc60mcqaM6KxftlMUgQOStiTvK03hcteEr
         kMA9IcFyvBV8DBKy2/Iw+lB39gS9HQvsHzQzepVnt3bzSVzYK3/rG9PGm9oCXfubn3vR
         RZ8p+YaQ2Yf9GwgwCQ2kiD15kgrndZlyV5ReOSVUMHv7Ko/qC+4Mu/sKy+7lbzVhNiDS
         Hp/87ZOQXytfDuM7UKINhjo3pgrg2IsQ0Iptl5Z6P+wQ/IHi25NMJukl8m0Ov9zxJvu+
         NfTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JwhEB9Dx/uNy1TVdO49rVoEq5ZejBIq7czTQQQLig8s=;
        b=pPXSt13fOdJsvXE3k/iDM+1x7eRhusrnV4FoilzN+LdA/5yxx/4mUJLPEN5U7GEJ5T
         gKKz7u0q5s5zbxnaRnLC0usuCSY5pxm3hkSZYw7MzPE23FUkG6PvgUHi4n3ZhDoosUal
         TlNq1cJ3l+5wGidGWiGbkdEHotR+aInDv3ZyPj0J7QdwRWwIIopx5ywvB1PXzz4QsSR3
         ihjy/8qb7rQ5O/K9++yzdmQfg5912ijhQkBp8he+NeyGGeKOHM6KQiZRA16SSuDuZtXO
         vMWvB1dvTA7SjKZ1kT5k9e9xcNYRFaRljbpbhBlAb+NO4Tl0fBP5Ub3iTLPtgoe4WBjG
         0u7Q==
X-Gm-Message-State: APjAAAX7yXHBejt30haufQJmqyRnqxNob36xqXtRi9zUiS0b86a+AlYk
        6T+5JgQx6lnwT7lewAVIvG2PsD9ww/NjlH5c8/9JdM6K2vZDDEIIxyJe2tBVv2cYNA9QTskoavX
        KB0AvsC8itPAoqwsfiwmE
X-Received: by 2002:a25:b90b:: with SMTP id x11mr6879870ybj.209.1576778258892;
        Thu, 19 Dec 2019 09:57:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqzWDaNWBG5H41EBU0zpbzx1n8BLa+vrYWT6O5GRRJeRzqsTKXTrWzE1ZCgYvEuQfNM14QrUaQ==
X-Received: by 2002:a25:b90b:: with SMTP id x11mr6879838ybj.209.1576778258545;
        Thu, 19 Dec 2019 09:57:38 -0800 (PST)
Received: from cs-u-syssec1.dtc.umn.edu (cs-u-syssec1.cs.umn.edu. [128.101.106.66])
        by smtp.gmail.com with ESMTPSA id l39sm2831320ywk.36.2019.12.19.09.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 09:57:38 -0800 (PST)
From:   Aditya Pakki <pakki001@umn.edu>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] bpf: Remove unnecessary assertion on fp_old
Date:   Thu, 19 Dec 2019 11:57:35 -0600
Message-Id: <20191219175735.19231-1-pakki001@umn.edu>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The two callers of bpf_prog_realloc - bpf_patch_insn_single and
bpf_migrate_filter dereference the struct fp_old, before passing
it to the function. Thus assertion to check fp_old is unnecessary
and can be removed.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
v1: Remove the check on fp_old altogether, as suggested by
Daniel Borkmann and Alexei Starovoitov.
---
 kernel/bpf/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 49e32acad7d8..ca010b783687 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -222,8 +222,6 @@ struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
 	u32 pages, delta;
 	int ret;
 
-	BUG_ON(fp_old == NULL);
-
 	size = round_up(size, PAGE_SIZE);
 	pages = size / PAGE_SIZE;
 	if (pages <= fp_old->pages)
-- 
2.20.1

