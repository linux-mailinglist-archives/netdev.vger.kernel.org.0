Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE141C872D
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 12:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbgEGKoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 06:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725900AbgEGKoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 06:44:21 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8E2C061A10;
        Thu,  7 May 2020 03:44:20 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id w65so2813349pfc.12;
        Thu, 07 May 2020 03:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bFQHmMlHHcwUStjNmfU6XXDKqYEB7JfBFL8YRcOFE5Y=;
        b=AXJGxb8tfuLMPb7qMZwoK7U09+JCMcqKoZfQG6lafeCRW0hnczvQigdk+2cg9F8Whl
         7TJXMt2abyCUiIy/2M9HWKeKTxVhm6jsrpUHxmplE+MIJj9OpYbPFsbw8sA6ZqW25rZK
         4HY+uNTPDUfp59HadZJ7w2EicQBsRqN6mKePZuo9cp8vHaMIDber9Xy0K0w/CoMpNg3p
         4sdGLt3r0FkwSZpaZuke+s0o7NDA/+h13fgr1NuCpdAa3v+YMDNqXjFSoUoYEY2DZJcV
         Y4S46ItKFNkEhhf3BxHN049J4Ut+13KQiTTSP5A11H0l0U5zLsdiwA+yAurVrrTmqcLO
         WXyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bFQHmMlHHcwUStjNmfU6XXDKqYEB7JfBFL8YRcOFE5Y=;
        b=tplvOIBaJ44QZIxSkUnD+SiJwe7QkUrBPCHF5np9GDazuc9TGvG5S3XmcLkYAhCmQ+
         +rQt8FTG671oPix+KVnUEtOUN0AZn0pEH7iA4SO9ixlNPXQ05giLAO1XI4mrIF6MI0S6
         PdsBtzXvurxoODyhyJnCUjH3LSlSh3VSrVKAbuTgi7PnkAv4wdPM6VUAUsEgExBsiHf7
         gV7eaZKcnHP7/SzvSn1q07smT8w3FNIAN2r3a8sAwT0svfPnmvbbebfPB90mbhQOO9JN
         e2/3DR0EvZv/whJwd8eZCN87uy+rN265EK0LmhxTdxd+xyLl2UG/LvUf85EvWDy9BEAZ
         97/A==
X-Gm-Message-State: AGi0PuaRt+O9JrS8B0obSqw03ncm9Ox4U7Y+HbG++bMov4CLbf65gCjS
        Xy3VV8wbXv4Su24SuXxs9xA=
X-Google-Smtp-Source: APiQypKu2EY+5rnudVsc+vqfbWZ1IARULo/OOxzvoQgq3KNzLdT5N+HAt7RmFtIzY52wGvjuZmU47Q==
X-Received: by 2002:aa7:9f5a:: with SMTP id h26mr13489016pfr.281.1588848260373;
        Thu, 07 May 2020 03:44:20 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id j14sm7450673pjm.27.2020.05.07.03.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 03:44:19 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com,
        Joe Perches <joe@perches.com>
Subject: [PATCH bpf-next 14/14] MAINTAINERS, xsk: update AF_XDP section after moves/adds
Date:   Thu,  7 May 2020 12:42:52 +0200
Message-Id: <20200507104252.544114-15-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200507104252.544114-1-bjorn.topel@gmail.com>
References: <20200507104252.544114-1-bjorn.topel@gmail.com>
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
index db7a6d462dff..79e2bb1280e6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18451,8 +18451,12 @@ R:	Jonathan Lemon <jonathan.lemon@gmail.com>
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

