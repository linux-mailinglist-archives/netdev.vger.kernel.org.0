Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5161DAF4F
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 11:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgETJtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 05:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgETJtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 05:49:50 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33ECFC061A0E;
        Wed, 20 May 2020 02:49:50 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ci21so992171pjb.3;
        Wed, 20 May 2020 02:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OVMLRI/qYuKHi4wFXwj/y3J+J9HuBJ9GEwbF/G1h7vs=;
        b=GE3R50FFzi3Txqcx8u2WH1++xpjwluyfKgq087IHiuBteWVNOcqo0n7N6TL1tDUDGB
         ckHOu9EhLKQxS5uJpqhKTpASSY+iEe9yBsvULHLCDpshh3N+/Z4sF17wQgjBYnEDmfcM
         N/WP/P26mbTzJlTxS00k5tBYY4xro8qg/5syYtO5XXDHFXcoWujGCIU8mh/isJkxVCR6
         I8AZV2J85BdumuRpndrP65vRDgaUeO/QDwChUoKLG3tXU34eWbFc6/4rBGN3ik2m3EPw
         C7/DiFB+UFk7MBvp1e/mh8dWtyCy/H34YYURrrdsdD6E1CtQ5oYWlSlixhdKY6tmrcPn
         nA9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OVMLRI/qYuKHi4wFXwj/y3J+J9HuBJ9GEwbF/G1h7vs=;
        b=qPeYHhqfh6EmKWGIDG8wEgW6B4/U9bfPmwtpuJPzltAR3ISGsumLDRMqUCJHesKBwa
         waT8+7JYd9VjRbPd80rrdr9aZzPfGDmI1cBSoRo0TgTMinqF2p+5de5yXRBtciPC8Oim
         oTv16BXZMRPvTjhXRkpkMpeOMitV0DJoTXeXlgYfP/gsTbaaDG9+Z2biH7ODoW3osTd4
         mg0drhBxAXIjYIyIGBLQ0MfFevKl+leraETeDV/c9p0ibWw2CxRqWxkjvP4tPS2k8xgy
         F7WvxsopS27+vmSo5QPO12wFJdTGGGqxIgDcA3j0UhCgQ+31aOcJEYyvuxNucYkMHxEJ
         99Xg==
X-Gm-Message-State: AOAM5306a7M3AUjUqSwdRF07PyQBJSvQvmsnj9zxxqO2cuv3j3x1JtI1
        EOnPsduD01EQLeiUiYtIUmE=
X-Google-Smtp-Source: ABdhPJzO6ap5q3fwyXpEEnpcw20a7uylqEyDpd4h1gEvkB0D+mmf6DXN81vKBAnMZaqoF8YNCCT6jw==
X-Received: by 2002:a17:90a:1d1:: with SMTP id 17mr4328297pjd.211.1589968189779;
        Wed, 20 May 2020 02:49:49 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id c124sm1707494pfb.187.2020.05.20.02.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 02:49:48 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com,
        Joe Perches <joe@perches.com>
Subject: [PATCH bpf-next v4 15/15] MAINTAINERS, xsk: update AF_XDP section after moves/adds
Date:   Wed, 20 May 2020 11:47:42 +0200
Message-Id: <20200520094742.337678-16-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200520094742.337678-1-bjorn.topel@gmail.com>
References: <20200520094742.337678-1-bjorn.topel@gmail.com>
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

