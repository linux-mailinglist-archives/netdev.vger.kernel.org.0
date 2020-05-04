Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1A71C3871
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 13:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbgEDLiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 07:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728398AbgEDLiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 07:38:55 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A6AC061A0E;
        Mon,  4 May 2020 04:38:55 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id hi11so3646113pjb.3;
        Mon, 04 May 2020 04:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bHq/Ud0G1CXt66/tn0cXJV9yUD2uWwBv/9RpvgD41Cs=;
        b=SunD0SarsEh9bJ1eBVMXEA59Ouaxue1qlzo4hZckHNspiJjRfm1f0nYY/9j4vLLwUV
         OB+Kv3lthS9KbWBMAYiBb3gjqwg9dUn5VknO44MnrceyDYjfwN9OfaFdKotGUpb36uup
         Iya35cVftdGIGPaxjrXzaOal3z2bvY3eCZLa2EX0cpNJkRnmsyKtx1mQ4BN3p+XC/48A
         IgzzddhPZ+YbX6jr2RRatPd80ct5sDsOnZK/m6ak56IJkJgqvpa4ilWvrYnE9kCaKccr
         1GpAHwdIr/3JxbCHMwlOkYN7w9Zw+GqzKDU8jgc95n3J0ARbulxqHeH5pS1ovsFUSVQp
         eprA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bHq/Ud0G1CXt66/tn0cXJV9yUD2uWwBv/9RpvgD41Cs=;
        b=frv8Uq6W+krZYo3p9AcenFjhaAq3Q3zyBUiXM/jHMtlz5pFMbED76XC+g9gsVaos1A
         NvlXUaYiXqZ0JHYrMvNDVV2pxd8XSFa5FhSARkIesmKesU1sSuO/O0Bk5xmRQRWKrt99
         YXKdG/LT8Gtf+AcEkCSdXCAasp8+8mpkZJx+i+aPop5IJcqI5wFhKf59eGrOypYtbv9D
         yBmIH+6oJieOF95yXJ8JEZqL3Z+86EIyz1G7yWIyF2NsTf1ycsoqhkGyhndAw2f7PxFQ
         jGsq2SVbf/ZURvinhJVBacmKH3Ckc24U48/P275sIDNPOTpvZ6jWulMR8mHrsuRCkeqL
         5v/Q==
X-Gm-Message-State: AGi0PuaE1UJ9jQx7YyXLJbCo/Qne0iV8xYZKSJjYBktd5ZIpit9dyTsA
        LwDOrFN06iUVNMiwxzLNiB4=
X-Google-Smtp-Source: APiQypIGDIR+ZNYWkOVWsIwkC9xGUW6Nbhpc1F+3Nt4rAbZHpQI1F3uanys7C9R4qCWxxgXGydr+CA==
X-Received: by 2002:a17:90b:3887:: with SMTP id mu7mr17397672pjb.168.1588592334274;
        Mon, 04 May 2020 04:38:54 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id x185sm8650789pfx.155.2020.05.04.04.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 04:38:53 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com
Subject: [RFC PATCH bpf-next 13/13] MAINTAINERS, xsk: update AF_XDP section after moves/adds
Date:   Mon,  4 May 2020 13:37:15 +0200
Message-Id: <20200504113716.7930-14-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200504113716.7930-1-bjorn.topel@gmail.com>
References: <20200504113716.7930-1-bjorn.topel@gmail.com>
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

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 MAINTAINERS | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index db7a6d462dff..4b992c684562 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18451,8 +18451,12 @@ R:	Jonathan Lemon <jonathan.lemon@gmail.com>
 L:	netdev@vger.kernel.org
 L:	bpf@vger.kernel.org
 S:	Maintained
-F:	kernel/bpf/xskmap.c
 F:	net/xdp/
+F:	include/net/xdp_sock*
+F:	include/net/xsk_buffer_pool.h
+F:	include/uapi/linux/if_xdp.h
+F:	tools/lib/bpf/xsk*
+F:	samples/bpf/xdpsock*
 
 XEN BLOCK SUBSYSTEM
 M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
-- 
2.25.1

