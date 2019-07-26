Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0DC976E81
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 18:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbfGZQG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 12:06:56 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38066 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbfGZQGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 12:06:55 -0400
Received: by mail-ed1-f65.google.com with SMTP id r12so18931118edo.5
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 09:06:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=8/1fGLsJMEy6BJn2mp9UogFdQ5EhYRWbUheR/xtFTzc=;
        b=rqUOsEJYTbNXD/p6GiOKQ5iFEbPZl3yI7oreb4RLnEXk+l7goNzP2EHbawVDt7AxUO
         zYsiNPyRVl70yJxN2IodJs+i8tvLWvndWgETdje43ZOG8JkCzC1VpNN1chrHHK5MmKM3
         L6mtKvCiHBQ+CgUE2DYgkXbHw0UrzcOMvb0MLlpnp9T020MQUy+d76gZDmS4RuSL2wQ8
         GZNkF+5F8eeH+tw/QuPcjgz2E1bea3snu9ZCuOXjd2Q1u6Y6gpMLRpotAp5poqnFkoX8
         L2B9kWARvehUGmNpbW4v82SvwA2RL3by6J1IgQwnV1RGL0ppv+CiDNSXJPJ677gG8SyZ
         e7OQ==
X-Gm-Message-State: APjAAAVngdypvzczAxesNDQn+Xg+/Yr+0BzNJiJyNAoCa+mjffLWWWpB
        RyqCsz92RehWhkMjxcYheTlR9Q==
X-Google-Smtp-Source: APXvYqwttDuUE/l0RyvOCBPknBxTFsV6/8KLlyzlHOgp24HQDcK5VsOYB4hdPgxJxh2WLW3rcPav3Q==
X-Received: by 2002:a50:a943:: with SMTP id m3mr81431227edc.190.1564157214147;
        Fri, 26 Jul 2019 09:06:54 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id w6sm5857892edq.81.2019.07.26.09.06.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 09:06:53 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8E6661800C8; Fri, 26 Jul 2019 18:06:52 +0200 (CEST)
Subject: [PATCH bpf-next v5 1/6] include/bpf.h: Remove map_insert_ctx() stubs
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Yonghong Song <yhs@fb.com>
Date:   Fri, 26 Jul 2019 18:06:52 +0200
Message-ID: <156415721232.13581.13120224208737507294.stgit@alrua-x1>
In-Reply-To: <156415721066.13581.737309854787645225.stgit@alrua-x1>
References: <156415721066.13581.737309854787645225.stgit@alrua-x1>
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

