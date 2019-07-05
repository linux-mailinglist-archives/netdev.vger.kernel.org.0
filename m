Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D022A60B3D
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 19:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfGER4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 13:56:53 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37391 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfGER4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 13:56:52 -0400
Received: by mail-ed1-f67.google.com with SMTP id w13so8590704eds.4
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 10:56:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Rq3Plkl93st1Ieiv0imh6VKfQGGnzAsqSffovy0ZcN0=;
        b=s7fyyFS8nvl5dpOC9FXKUGCkiD7AhQGKYuvWQTQ4M423wKAFVPPf7fi3s3jtGjOVPQ
         Nl+mPP/Usvfc84IVi01QXMma4lqZKpB7XvXI4VOwmW1CoLBOinc1llsCQ9w4MKPFTSMk
         WVVFZgs78IFODEdjkG3FUffPOWVxuE5g/aPMEGQgjHYlvKS4skFvQ841fR9RXhk/rPwG
         vOpYJHxYNibT8Glwzflyulcx8uhuBUpYQFVaGL27wCmREA4gYre+GlVlJQH63Ezd30oH
         DuXhuRPedGvPoiki3ezZDM5eSOnLT6Z3B9Mq6n0N1ki92qzI/64XDG6vjb+2V4cYldSp
         rWOw==
X-Gm-Message-State: APjAAAUs1qP5oywp66MMts3ozTjwM/23XG/5wIjV7oZVlWtq3prk3Gf0
        p+yv2UExCcXYVNH5HUq/p40otQm6DXE=
X-Google-Smtp-Source: APXvYqxMgs56U1Z358tvHloEgoJhPrsY9TQGZrVJBmQMtZT/yncRs3i2thkCzFzpoYkXez3nAitXEw==
X-Received: by 2002:a17:906:b35a:: with SMTP id cd26mr4628515ejb.86.1562349410881;
        Fri, 05 Jul 2019 10:56:50 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id o18sm2829092edq.18.2019.07.05.10.56.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 10:56:49 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 641D6181CE7; Fri,  5 Jul 2019 19:56:48 +0200 (CEST)
Subject: [PATCH bpf-next 1/3] include/bpf.h: Remove map_insert_ctx() stubs
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 05 Jul 2019 19:56:48 +0200
Message-ID: <156234940826.2378.16075570559473871837.stgit@alrua-x1>
In-Reply-To: <156234940798.2378.9008707939063611210.stgit@alrua-x1>
References: <156234940798.2378.9008707939063611210.stgit@alrua-x1>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

When we changed the device and CPU maps to use linked lists instead of
bitmaps, we also removed the need for the map_insert_ctx() helpers to keep
track of the bitmaps inside each map. However, it seems I forgot to remove
the function definitions stubs, so remove those here.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/bpf.h |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 18f4cc2c6acd..bfdb54dd2ad1 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -713,7 +713,6 @@ struct xdp_buff;
 struct sk_buff;
 
 struct bpf_dtab_netdev *__dev_map_lookup_elem(struct bpf_map *map, u32 key);
-void __dev_map_insert_ctx(struct bpf_map *map, u32 index);
 void __dev_map_flush(struct bpf_map *map);
 int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
@@ -721,7 +720,6 @@ int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
 			     struct bpf_prog *xdp_prog);
 
 struct bpf_cpu_map_entry *__cpu_map_lookup_elem(struct bpf_map *map, u32 key);
-void __cpu_map_insert_ctx(struct bpf_map *map, u32 index);
 void __cpu_map_flush(struct bpf_map *map);
 int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
@@ -801,10 +799,6 @@ static inline struct net_device  *__dev_map_lookup_elem(struct bpf_map *map,
 	return NULL;
 }
 
-static inline void __dev_map_insert_ctx(struct bpf_map *map, u32 index)
-{
-}
-
 static inline void __dev_map_flush(struct bpf_map *map)
 {
 }
@@ -834,10 +828,6 @@ struct bpf_cpu_map_entry *__cpu_map_lookup_elem(struct bpf_map *map, u32 key)
 	return NULL;
 }
 
-static inline void __cpu_map_insert_ctx(struct bpf_map *map, u32 index)
-{
-}
-
 static inline void __cpu_map_flush(struct bpf_map *map)
 {
 }

