Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A43E42D8B
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 19:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409552AbfFLRat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 13:30:49 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:56530 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409548AbfFLRas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 13:30:48 -0400
Received: by mail-pg1-f202.google.com with SMTP id w31so11771399pgk.23
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 10:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4JPge5G2892WNESlZ4eKnrVnH6/giL39WrMPoTXaExc=;
        b=h5ro5SJSnYzly27OdyE30z6LzTma1LfkgfmjQgh0ex07SM0R4CD8A54tdyKC+Xi+ej
         qM6TgeX24RNNPtcXMnryV6SNqePdy6DqDJCAWv1jlKhlZq0tCHQmlIqDKDyO5l2HX8zl
         rTMoFZtpxRzF2alb51rReatA6TefokA51mk2dEPkRY+BfUu9PedZ9oXJSTkn/hIhTJAa
         vnYaEuGd/hyVdI5z0hsLPb+nV/sUX0c3rZ7emIA++iDd62Y94+lgZRlYDTq/O3zAhJLY
         6HXs4wQfFiOCLBkLLSWOBzCpo52eawcLd8I9H1VmcipR4XTOUkFrevWSewhdyCiK7VEk
         uvtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4JPge5G2892WNESlZ4eKnrVnH6/giL39WrMPoTXaExc=;
        b=GZE2pPssMY/kenmsh8xdCOkYugmMFQEQQUuCBUCrEUFXMB5qZkk0/bA1VnJ7qqqei5
         bBgyLQCaMKyY6wSI+IJAf0k9fbHM34AruGXUolit0R94XDLtN1YAk5WUd7StQGR3vsCS
         vhoLebjut6y/obZk+tgr2rIyRQpvaXlu1arJDQ/6orSsHbzeJ3mwVuTWRbwC+Xg/wK7q
         xSBBW9be6mPsczQuqaOj6+AZcg3W2lDhfJ9BJxUL20wROH0RZ9i7QoKDQsvjfzvCgTQR
         f2eOZLBkY1TQ0OFqkAdO7T4prmbdhIBS3VAV9yJMWP13f14yRyxxnuort4Tqj0KZLWhv
         kO4w==
X-Gm-Message-State: APjAAAXuVpKLgzVe6P7bwYsBiwjLimtpd+6j1RDm6sweGFrGYczOJTZC
        xtpaaaAjQ0eYjUAOC3LqfTXpkZdnNna80vIUvjBDQN36wVvrNZodkXMdIo4gLvWOgZiyqm8qP+k
        QdNjwYfydQmUSvNlzMniE2BDBNAvV2v+9CfHIaR2hYnduKvLVoEIKWg==
X-Google-Smtp-Source: APXvYqyANjMixR1tbGgJel7+CTGj1C+KeoiYGS1TEl5Ypy6xE9mZe2jqZyRjazQiFsS4LGrx0W3wktU=
X-Received: by 2002:a63:2c50:: with SMTP id s77mr25809188pgs.175.1560360647932;
 Wed, 12 Jun 2019 10:30:47 -0700 (PDT)
Date:   Wed, 12 Jun 2019 10:30:39 -0700
In-Reply-To: <20190612173040.61944-1-sdf@google.com>
Message-Id: <20190612173040.61944-3-sdf@google.com>
Mime-Version: 1.0
References: <20190612173040.61944-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH bpf-next 3/4] bpf/tools: sync bpf.h
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>, Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add sk to struct bpf_sock_addr and struct bpf_sock_ops.

Cc: Martin Lau <kafai@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/include/uapi/linux/bpf.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index ae0907d8c03a..d0a23476f887 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3247,6 +3247,7 @@ struct bpf_sock_addr {
 	__u32 msg_src_ip6[4];	/* Allows 1,2,4-byte read an 4-byte write.
 				 * Stored in network byte order.
 				 */
+	__bpf_md_ptr(struct bpf_sock *, sk);
 };
 
 /* User bpf_sock_ops struct to access socket values and specify request ops
@@ -3298,6 +3299,7 @@ struct bpf_sock_ops {
 	__u32 sk_txhash;
 	__u64 bytes_received;
 	__u64 bytes_acked;
+	__bpf_md_ptr(struct bpf_sock *, sk);
 };
 
 /* Definitions for bpf_sock_ops_cb_flags */
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

