Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE6B48142F
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 15:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240390AbhL2Oob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 09:44:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236856AbhL2Ooa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 09:44:30 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36DEC061574;
        Wed, 29 Dec 2021 06:44:30 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id g2so18665136pgo.9;
        Wed, 29 Dec 2021 06:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J1BnpWyg6Q8Toki1+JSbzbJgN5C0a+8hlDW35pc8kRM=;
        b=RDFQkxEr9DsNWyTuoYuBUQD6hnMeCyMKIHJ6tiE8T1PjYFIsEPvgiFsTAZwfL+TV++
         Y8/QQaf7QOegA1b5Y4jVfZQ+1gGERj/VabomvY/BV3boXk4H6iMdRhPlT+LmN1hVTXk/
         TITQ0vAJCWiTI0iySFbyHA+z9fIFoH/eYo6DDvfvKEwSxYx4sRpOrEZbp8P522qcDKjC
         H+TLHrzYSst5//Ke2XifbNxpk1Xc3f4ZwCvtzQ2Q3wpDskT0DEWEEV2MlbxHd0Eb/j+R
         AT58jgwRlSAhlN9PtkHgUcWEOMOTbaHhdTbBay0jewExeMiGmZyM+9rIza2qy6iNFGqo
         fyZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J1BnpWyg6Q8Toki1+JSbzbJgN5C0a+8hlDW35pc8kRM=;
        b=OAotZ1F2qeZ6HIjLb9505kTOyLgBznxKZusN9T4UiT8Us185rIVjS/e13ICAnJZ1tt
         FIcUJbFNQBRa8153VeMNZ5v5Z24PD4fJ6xdWgiSJvJZ2lBJs3hHTnMnmjnp2TJ6G05fH
         GMkpMPOeIEn9UxpQO/UjVuU/Fr3f6H/hmA1lFFEEiJktDLy4gwaXpHoaeZnKk7p+VZ+D
         9mqPtbrPjMSWzQ7UITXpd8m67XKYi98RDB9GpdQKCXF1G0UVlxcUalgbXqFTVeItdIuG
         LzNoBPp2cBWL2ARbw1pg/DwAG01BpBmDnSobExTFKFVR4BqLCeTonkliUDOjuj9S7erN
         z3gg==
X-Gm-Message-State: AOAM530AwDKR9AF4BkB6UGQbI13I3ENLENtxRw0Lk+T2syTbaL2YKfPI
        TMj01u2Nj4abmqeNYWMiQPTiUjT+Npy+Y8Fg
X-Google-Smtp-Source: ABdhPJwb1cEy6kw+pSaYjeaEx2SBs13FEoks3awYQilV/yQWu29YXIIA57l26SVykihLBSThbJ+OzA==
X-Received: by 2002:aa7:88c4:0:b0:4bb:5a48:9801 with SMTP id k4-20020aa788c4000000b004bb5a489801mr27182190pff.67.1640789070160;
        Wed, 29 Dec 2021 06:44:30 -0800 (PST)
Received: from localhost.localdomain ([123.58.219.222])
        by smtp.gmail.com with ESMTPSA id q22sm25596292pfk.27.2021.12.29.06.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 06:44:29 -0800 (PST)
From:   Leon Huayra <hffilwlqm@gmail.com>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Leon Huayra <hffilwlqm@gmail.com>
Subject: [PATCH] fix a comment typo of bpf lpm_trie
Date:   Wed, 29 Dec 2021 22:44:22 +0800
Message-Id: <20211229144422.70339-1-hffilwlqm@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix a comment typo of trie_update_elem() in kernel/bpf/lpm_trie.c

Signed-off-by: Leon Huayra <hffilwlqm@gmail.com>
---
 kernel/bpf/lpm_trie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index 423549d2c..5763cc7ac 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -412,7 +412,7 @@ static int trie_update_elem(struct bpf_map *map,
 		rcu_assign_pointer(im_node->child[1], node);
 	}
 
-	/* Finally, assign the intermediate node to the determined spot */
+	/* Finally, assign the intermediate node to the determined slot */
 	rcu_assign_pointer(*slot, im_node);
 
 out:
-- 
2.34.1

