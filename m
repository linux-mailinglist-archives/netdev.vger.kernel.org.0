Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5AF34B2DD
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbhCZXU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbhCZXTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:19:02 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7710AC0613B8;
        Fri, 26 Mar 2021 16:18:30 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id 7so6971383qka.7;
        Fri, 26 Mar 2021 16:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oYkFKFWuW44yCKvQyPU/6giEb6xhcpVvFGK6kNxzbVE=;
        b=K3iFhodvOUpUNMFRs+s14Md4gFuhvH2X4CmzGXr6b/nt7vcf3ziWlckF5g8Y92MLLe
         eMMhayg9eVMJtBGwPE2i3Ca0WZXeKJkHHQOSfVj57GEy64jm2VB0jW7sixHLp0DjBub5
         hu/Yt/c7nFV1qcC5l5y7h0hBijKtcGc7DPWEQg4ctByZkFRLT59MKJOasvHuf1O4BhMG
         Z9BT60w5oMRRFk6ku/TZrY8c7Bo84aLef2ruKRLVqCDHEdIQj39omHV24CR7KSgvHDPk
         oAE/aAy/4wiF6M7bgm74WR8xH58A0YVSgOLyjWB2/ErhhVOYaDNztPbXOOoik9s6a20E
         4Raw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oYkFKFWuW44yCKvQyPU/6giEb6xhcpVvFGK6kNxzbVE=;
        b=VzPLNnKg268zrAInK1HCdaq3LkvM6i/kD0f90W5jckSmcf53Q0iN2hGqXdVHRmVKbP
         BPDsAFO0AYNZOvlqve8Gabl4pgBkgLUwVJ8E6OpNC0Jtb4ccQXbdjF6xtvBh3ys1i1ph
         2wG4MRQ9GP0FLh9lFKsU+fd6Ir4+9Yo2l6SyAlqRIB3/tb6Y1M+ZFBQaLeklhF1kv0Lz
         TL9pdjGorUlMypg0P5vmUOEBMr0EhLGQ+sWNqjvmjYdqiggdxqOzl39Bu2Q66Xx5Ahrs
         OUJRF9DPn4M3p7bUmoKdSEKyaBJvyLM/lqCw2+qbAJQr9+l5TL9p5jQxJa8j4wX8nvJL
         134A==
X-Gm-Message-State: AOAM532LHoT8Srfv5E+Whz6Riye8ziSPmMkr7chGQYw/JnHRZtpChoVg
        PbeBWarB20Lj22VF5f9mlZE=
X-Google-Smtp-Source: ABdhPJzyfatRZeQuBJmASeUxDeoyxWQa9kBpvlQFehbvG+ek77DirSkctruuWL8ExT/qbBt00PMI4w==
X-Received: by 2002:a05:620a:553:: with SMTP id o19mr15574784qko.491.1616800709824;
        Fri, 26 Mar 2021 16:18:29 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:18:29 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH 19/19] ipv4: tcp_lp.c: Couple of typo fixes
Date:   Sat, 27 Mar 2021 04:43:12 +0530
Message-Id: <e14726284b419e249106e84203e43ce18da21d5b.1616797633.git.unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/resrved/reserved/
s/whithin/within/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/ipv4/tcp_lp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_lp.c b/net/ipv4/tcp_lp.c
index e6459537d4d2..82b36ec3f2f8 100644
--- a/net/ipv4/tcp_lp.c
+++ b/net/ipv4/tcp_lp.c
@@ -63,7 +63,7 @@ enum tcp_lp_state {
  * @sowd: smoothed OWD << 3
  * @owd_min: min OWD
  * @owd_max: max OWD
- * @owd_max_rsv: resrved max owd
+ * @owd_max_rsv: reserved max owd
  * @remote_hz: estimated remote HZ
  * @remote_ref_time: remote reference time
  * @local_ref_time: local reference time
@@ -305,7 +305,7 @@ static void tcp_lp_pkts_acked(struct sock *sk, const struct ack_sample *sample)

 	/* FIXME: try to reset owd_min and owd_max here
 	 * so decrease the chance the min/max is no longer suitable
-	 * and will usually within threshold when whithin inference */
+	 * and will usually within threshold when within inference */
 	lp->owd_min = lp->sowd >> 3;
 	lp->owd_max = lp->sowd >> 2;
 	lp->owd_max_rsv = lp->sowd >> 2;
--
2.26.2

