Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7181D92CF
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 10:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728703AbgESI6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 04:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgESI6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 04:58:48 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9719CC061A0C;
        Tue, 19 May 2020 01:58:48 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id cx22so1033519pjb.1;
        Tue, 19 May 2020 01:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OVMLRI/qYuKHi4wFXwj/y3J+J9HuBJ9GEwbF/G1h7vs=;
        b=GWbC0S/crlnP0VkfhlE6a/BMB1lNLTzpyIAGwPMVD3MldszgkjZ+RcdZ4OTO8O8cKF
         puyAoSljYlBihIWBKlrgNBUPDwzTH9RaAErkNW8Pp9vWrreefAkB99oxoFUWbq9dK6yi
         EuU1QAL6j3RhosDuwwafE22hOhNcGxOyvep2CgvTJOAtSWBt9bjRaDrRM9Q49KoAfxzb
         a1kemTKQ9ezI3vgESMpCCQkDau8fQg+j/kjMpYLULJgRLmIk6J8QCEPaAIDDSDeV97VO
         7ICkFrpqD76t+hIL0cuOxQtAvgPRHNJYUtawnlEttKB5XaPVpiGS6mmQ3vynDMM/0PZb
         9CDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OVMLRI/qYuKHi4wFXwj/y3J+J9HuBJ9GEwbF/G1h7vs=;
        b=E59G+gUjSyh7dv05EIbH4Dfog82JMy4htYYVpWvqNLsj44uJ5pJk0cSmgjVcf93bSz
         3lAWJbPbt9+vMbST4dlyO8lJu51H8U65w0KCrEuX1R1eyXotLCCQYJt2JWnJ9mxEqV7a
         +S7kUP3i8KcJylrM1HkCb7hUZJ6Yub9/FUHMzhl8CVWY4MR/qaQJDRZi46UiH/nG8xWY
         RfN7xpGtIGj0JDIJX6oLDCprvK5kR3lxUtbiBEJfN2s52k6rtWywp5L7Y/jQYXHvyiM+
         JLavkkYGQms9O4328FHS+vEtnWKhoE4j90ZM4BRa/VzdyPAGE2t3KpVCzdGKqLAOjPVK
         zeXg==
X-Gm-Message-State: AOAM531JRd0akUKl7FIePl0NhTA4wyk/fkrhwkpAsTc5HpK8gtTux9gR
        94fpUwaorU3JEjw9GpUkTS0Dos9LvXnXxYB4
X-Google-Smtp-Source: ABdhPJzjbqwUILfNXlgi9g3hByo3oaAAnB6D+2z434GTMzEpIDoe6uiHdNog6d3gKdQz/SIXd4NbpQ==
X-Received: by 2002:a17:902:a584:: with SMTP id az4mr11518935plb.201.1589878728163;
        Tue, 19 May 2020 01:58:48 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.45])
        by smtp.gmail.com with ESMTPSA id k18sm5765748pfg.217.2020.05.19.01.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 01:58:47 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com,
        Joe Perches <joe@perches.com>
Subject: [PATCH bpf-next v3 15/15] MAINTAINERS, xsk: update AF_XDP section after moves/adds
Date:   Tue, 19 May 2020 10:57:24 +0200
Message-Id: <20200519085724.294949-16-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200519085724.294949-1-bjorn.topel@gmail.com>
References: <20200519085724.294949-1-bjorn.topel@gmail.com>
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

