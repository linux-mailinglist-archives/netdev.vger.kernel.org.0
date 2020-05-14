Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEEFC1D2A5F
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 10:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgENIib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 04:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726196AbgENIia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 04:38:30 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D03C061A0C;
        Thu, 14 May 2020 01:38:30 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id a4so986562pgc.0;
        Thu, 14 May 2020 01:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bFQHmMlHHcwUStjNmfU6XXDKqYEB7JfBFL8YRcOFE5Y=;
        b=l4kbmRg3TZaBaqFedsPo6sWl8pAUGL767KYqZjTasjfjd+8kZep+2G+JvKqlI7NrWG
         BHFKhXLo3MLO1YWjJ+zs+L4XeDZzWGSu+kcUf9BpKq8VK3M+9UIhsYQmTv3GJ+KhHtFY
         fLqE0uq/H6KMAFRcCmc/wKY5F1kW8aSqPO0JflqAQbFTFJ+7ODKFJwZobCQE0BkIRcBU
         dhb14frTtJ5retIV9KF2eL80qxliTEQyFlA3qdKEBtzQGuDoAbpBokBCdrVhkhHoyAwH
         IWf+Txe9AOMfYB/eh5JaNyWcDXxDpMK8zCan1EhoXmU5XzqJ2giJl95EzmRL+utPpxp1
         7WUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bFQHmMlHHcwUStjNmfU6XXDKqYEB7JfBFL8YRcOFE5Y=;
        b=QtIuNmYXLvcve6iVOWamysp/HjAC3IfBXt6pKoAEEH1hG+ZxNWbRPVGyCMyJxLfCnc
         w6gT7LTCjSr5xJzlXcBkIBcz8Zx7Wo4BLJ5f4UnRnCOYiYl3iOUbP8vrk7LokOM3NscX
         ZsefnnRpMRzIIEEInrdnBZcrMG17LsFQ1xZrLXJGyIcAm5DfvQuC69zFGkmWjRL6QBv7
         jy7F1H+sJ9pDWKp5o3jyHBIwZmNDgjTN7mofKl2xSz8PGHKNRI5B6EiHknRdSRzkMN7U
         9fUj2Ua/YepYwQrxR1d2Nnke/N+/zrj9Dap5y6XhMkfk4L2p0dmxjJJZkXHOlxioROht
         2f4A==
X-Gm-Message-State: AOAM533CK2ydIOYLKwGgsp5Z+jDdst5zQdO/YPLHC+/+l+uwcadi1gpH
        WQX1CC3ycjDzT4Tqna6pUqk=
X-Google-Smtp-Source: ABdhPJz9IILWRazR0Ni6Nxf/7GLcPMUhjen42/p9duqPbvTSjY4Qa59VGTFtYEasMxV0RCpYvYpqRQ==
X-Received: by 2002:a63:4d5e:: with SMTP id n30mr3073846pgl.154.1589445510199;
        Thu, 14 May 2020 01:38:30 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.42])
        by smtp.gmail.com with ESMTPSA id k4sm1608058pgg.88.2020.05.14.01.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 01:38:29 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com,
        Joe Perches <joe@perches.com>
Subject: [PATCH bpf-next v2 14/14] MAINTAINERS, xsk: update AF_XDP section after moves/adds
Date:   Thu, 14 May 2020 10:37:10 +0200
Message-Id: <20200514083710.143394-15-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200514083710.143394-1-bjorn.topel@gmail.com>
References: <20200514083710.143394-1-bjorn.topel@gmail.com>
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

