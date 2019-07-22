Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9AB76FF02
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 13:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730031AbfGVLww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 07:52:52 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40366 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730022AbfGVLww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 07:52:52 -0400
Received: by mail-ed1-f67.google.com with SMTP id k8so40326022eds.7
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 04:52:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=8/1fGLsJMEy6BJn2mp9UogFdQ5EhYRWbUheR/xtFTzc=;
        b=DuQi/5lu8N2OYuTijqsFFSIue04G4AVzt6CKnZDxga1kxQRwEePuIFGuYEqV8Eq9P4
         DFAks/PkygMiKuPFIgdYkAHQ1RIxaJDeIYrXdYGhMt2mCSo7JSQN9vpiSzgmT3sGoMT0
         t2Gez7/FufLPam2pRwoaAfy8CBKxeyMgHWwPRjF4Mlq58iiHkHZzZBLFiRzT2IQuuS5S
         vsdgCP4zqFsyVm3YMIeNkm8xX6vXP5MGJeabKYSqsNTOYLwMmMbvxZl6jkgiigCMbnXp
         93vbk7MMhJnqjaLcQ+Aea5FnBy/C5cel7L8LXcGMd8rjRr+Yoxrx4ZUFxlu5Mx7dMIQz
         hHyw==
X-Gm-Message-State: APjAAAXkGp90Mz8yK/R/70AXod9mT4TMUzKZTlpdEGaeu2+G4NkkeZRS
        GGHDsR1BXqJvUdcM4HzRfeDvhw==
X-Google-Smtp-Source: APXvYqxHwxebdo3O19nBh2td2npDFwUVxfugceX+rvlQ7eWnHTtST6tx+PoLMOQrb4hD1LXHxlFyJw==
X-Received: by 2002:aa7:ca54:: with SMTP id j20mr60296946edt.50.1563796370854;
        Mon, 22 Jul 2019 04:52:50 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id c48sm11343534edb.10.2019.07.22.04.52.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 04:52:49 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 78411181CE8; Mon, 22 Jul 2019 13:52:48 +0200 (CEST)
Subject: [PATCH bpf-next v4 1/6] include/bpf.h: Remove map_insert_ctx() stubs
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Yonghong Song <yhs@fb.com>
Date:   Mon, 22 Jul 2019 13:52:48 +0200
Message-ID: <156379636830.12332.8775214007034338356.stgit@alrua-x1>
In-Reply-To: <156379636786.12332.17776973951938230698.stgit@alrua-x1>
References: <156379636786.12332.17776973951938230698.stgit@alrua-x1>
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
Acked-by: Yonghong Song <yhs@fb.com>
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

