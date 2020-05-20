Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17CE1DBDEE
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 21:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgETTWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 15:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbgETTWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 15:22:41 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74EC0C061A0E;
        Wed, 20 May 2020 12:22:41 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id p30so1886026pgl.11;
        Wed, 20 May 2020 12:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OVMLRI/qYuKHi4wFXwj/y3J+J9HuBJ9GEwbF/G1h7vs=;
        b=vZ8IO5JvkRxbPEL5oIae2LPKd4XKGs0oq6d9USfSK9MbFesburkTyZANdAFl2/YkZb
         m9mIVcA5FPwrpIo3W5NjuIqNAmUDjC5x8dYlUYDcDJb3nrkaT+GxVkNBHKOVX87U49PP
         prMp2CVSQelpUMk0Gg3oY4At+STHy85+PzYR/THKXqL25+UIBad1lu18qT7mWCieV87W
         H8HcFQwF56gZv50eYEcWQb+ckVgjsel6lBzAqKesCERsAmRLUMUxyk/4K9sPNEHJVtmV
         BzqTLNpqMevZr8KANwNxrA5ILhxxtQIP7yr8kHEFYAnFC9kmjYMJseu7z5MBUUyVKlVM
         dvag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OVMLRI/qYuKHi4wFXwj/y3J+J9HuBJ9GEwbF/G1h7vs=;
        b=UStHcV+Fs830YS2pslFqTprmJ0eFydYXUq6SIcnTlJjfC7J0pisff8HGUcOXHlrCGd
         SZsZ9vxa+2aGWAOZunrag68G2z00grcYXEe44hYcEuBnk/TNGcafNE+cQRadvK8Jqo1y
         jxtmcHNTYlAl9mTmNrpBLhRRfvTToyOpz7vV4/G6+ZkNthcksQtUvPkelhXVbqjzm/Ct
         tRmSvlh0Fjakhj61eMfvbjaGtZ5/mX/Kw6SbQv32ACwlvDm7GpdYqRrlYRYChkgBpHhj
         WjwZqdnXedh7KvyW190RyxLGY3QvRkaecjQDer/R8pS6Rfezu3Yl3wBERO1PTM4I0Ktt
         LQww==
X-Gm-Message-State: AOAM530iLQrY6gD38emI9wU31VJaeIAoVR76/1WuAWHoSJZTUxlpJSCo
        qfcXFEXQh/2+kicKi9AzYgU=
X-Google-Smtp-Source: ABdhPJyKrkGByROGfhVaaKME8Vy/7DHu4vmtEFkG/CHCI2prtWxpATDGqiv8/kxH+eYbqS0iCcnfkQ==
X-Received: by 2002:a63:f316:: with SMTP id l22mr5204505pgh.38.1590002561093;
        Wed, 20 May 2020 12:22:41 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id 62sm2762424pfc.204.2020.05.20.12.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 12:22:40 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com,
        Joe Perches <joe@perches.com>
Subject: [PATCH bpf-next v5 15/15] MAINTAINERS, xsk: update AF_XDP section after moves/adds
Date:   Wed, 20 May 2020 21:21:03 +0200
Message-Id: <20200520192103.355233-16-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200520192103.355233-1-bjorn.topel@gmail.com>
References: <20200520192103.355233-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Update MAINTAINERS to correctly mirror the current AF_XDP socket file
layout. Also, add the AF_XDP files of libbpf.

rfc->v1: Sorted file entries. (Joe)

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 MAINTAINERS | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b7844f6cfa4a..087e68b21f9f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18443,8 +18443,12 @@ R:	Jonathan Lemon <jonathan.lemon@gmail.com>
 L:	netdev@vger.kernel.org
 L:	bpf@vger.kernel.org
 S:	Maintained
-F:	kernel/bpf/xskmap.c
+F:	include/net/xdp_sock*
+F:	include/net/xsk_buffer_pool.h
+F:	include/uapi/linux/if_xdp.h
 F:	net/xdp/
+F:	samples/bpf/xdpsock*
+F:	tools/lib/bpf/xsk*
 
 XEN BLOCK SUBSYSTEM
 M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
-- 
2.25.1

