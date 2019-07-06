Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 511CF60F81
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 10:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbfGFIrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 04:47:18 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35308 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfGFIrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 04:47:18 -0400
Received: by mail-ed1-f67.google.com with SMTP id w20so9828447edd.2
        for <netdev@vger.kernel.org>; Sat, 06 Jul 2019 01:47:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Rq3Plkl93st1Ieiv0imh6VKfQGGnzAsqSffovy0ZcN0=;
        b=YWSoQBaFkQ4BExncc5pW2u4pXLJQq9JKyGyQ03wpU8FQc/jIboMIHjrFwncMWuC70N
         JK/8ql6ba8ZG+N5CE4B1EN6q9nxDOsEwQBbls1T4bgv28zoaa30C4thlGIKA3Z4N7wDw
         nMuexdSjRFIy8Rk2e6ivFKyewi2AUAnewVkxqClgrPb6Bdd0EtWakmSI4YPnNWhwRDFA
         sZE5j8GxWNvc0UCd+AcdD4N6+l1iKeZoTfBlBLhu5UEGqvcClMEV7/0RRYlOChF6n+vE
         xxXETcXRl+L3j9n1ZpAjCB+vCi3E7NuApYp4hQltRHT7SBRX0dOh9OMMMQCcXD5JTmdk
         XBOQ==
X-Gm-Message-State: APjAAAUuPURDv8JZqyNHSAeuXP7y7wlS0qqw5GOzq3SdGZF2saTXDd+5
        a3SLLMv2rucUKdXEWoCM6U7VaA==
X-Google-Smtp-Source: APXvYqydIC1rJnQG3bDMSXCvl/7iAF48lWUmdnzpZrWjY4YaMj6IKeWzRajF8Ns9xHKI9gqaRGrQWg==
X-Received: by 2002:a50:f982:: with SMTP id q2mr8912985edn.270.1562402836820;
        Sat, 06 Jul 2019 01:47:16 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id c16sm3470299edc.58.2019.07.06.01.47.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 06 Jul 2019 01:47:16 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BF3AA1800C7; Sat,  6 Jul 2019 10:47:15 +0200 (CEST)
Subject: [PATCH bpf-next v2 1/6] include/bpf.h: Remove map_insert_ctx() stubs
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Sat, 06 Jul 2019 10:47:15 +0200
Message-ID: <156240283571.10171.11997723639222073086.stgit@alrua-x1>
In-Reply-To: <156240283550.10171.1727292671613975908.stgit@alrua-x1>
References: <156240283550.10171.1727292671613975908.stgit@alrua-x1>
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

