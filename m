Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEDD211FEE4
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 08:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfLPHRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 02:17:33 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43279 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfLPHRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 02:17:32 -0500
Received: by mail-pf1-f195.google.com with SMTP id h14so3193202pfe.10;
        Sun, 15 Dec 2019 23:17:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O679z1ZNxZm1L7wwDCHgL10vvD38qF9e8GlEICfZy6k=;
        b=Sc/pUz/25KvSJzvdDVeJN2CMw/zO/3uatM88TdcrA0sh/cE2N5620lS2Aw6zmfl/rE
         4qPI6iTn5faaMdrUUydZ0HGknTyQQYa0hFxjWwnDxWCeNCRHUDXUqviwlhN6nhWE878V
         uBju3a4P5kTguMLB0EqE095N+SxXWV57DlCyrDjlLpq2vjACHBZPOgm1Ps9Hkvpb6e0S
         Ghu/eG5hb4zr0JxQJWKeZj9sc2nZrDD+RsJ4RZi8kqNeGvta3E4ggAvSqPwEmzjmQuo/
         Fa5KdAgKvVpWKfIkynf/5PxCqRi2e47sEgyTLkfanskXM3wAWGCXkzQNy1oA6QQ45pPW
         l1TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O679z1ZNxZm1L7wwDCHgL10vvD38qF9e8GlEICfZy6k=;
        b=m1G52PFszrhMf64sZ8NBcqJSv7c0/Gu9sC5z2cP5WXza5TNFj+CYX2xtBXc4vJVHVe
         HikVvn6S8ErVDKZQgUx05QPqz36CAN+4BS6z9ygdGbQuom+qIPp2gJtwncK1zawyaEuF
         HZds7XOJobLrtG38DNTmlgvZtF6NGZbbCXt1DtWnt0zwEkrtWoa5BkvtdFryTxFwUvYl
         z4ceQ8viG4OvQXnTHn/v31vXU913Q8UPQeVYp0MrVP0IGv7lAS106XjamEP1uhwgcRF1
         QVjjJabse0D2rQGRRxEoYmW1pmwyGi1VYd/4RejZjnAC627vfxuJOxVRDWkWu17MNa2C
         Lsmg==
X-Gm-Message-State: APjAAAXFCnE82Oj5+i5uFDLJyir3W7+3UJRYfiAm6Plkfif0qXInp3r4
        +2MqKBbdWzy0WxXbHQiWu70=
X-Google-Smtp-Source: APXvYqwTVIRmt/U52KL4OHTAMdEvkbuz1YvFg9Z4bE2uqiu5ZP/ZLlv45MEYAQJERla8zIgzu+2ibQ==
X-Received: by 2002:aa7:9839:: with SMTP id q25mr14665848pfl.161.1576480652144;
        Sun, 15 Dec 2019 23:17:32 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id q7sm20875486pfb.44.2019.12.15.23.17.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 23:17:31 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf] samples/bpf: reintroduce missed build targets
Date:   Mon, 16 Dec 2019 16:16:19 +0900
Message-Id: <20191216071619.25479-1-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add xdp_redirect and per_socket_stats_example in build targets.
They got removed from build targets in Makefile reorganization.

Fixes: 1d97c6c2511f ("samples/bpf: Base target programs rules on Makefile.target")
Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 samples/bpf/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 1fc42ad8ff49..8003d2823fa8 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -38,6 +38,8 @@ tprogs-y += tc_l2_redirect
 tprogs-y += lwt_len_hist
 tprogs-y += xdp_tx_iptunnel
 tprogs-y += test_map_in_map
+tprogs-y += per_socket_stats_example
+tprogs-y += xdp_redirect
 tprogs-y += xdp_redirect_map
 tprogs-y += xdp_redirect_cpu
 tprogs-y += xdp_monitor
-- 
2.21.0

