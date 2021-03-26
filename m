Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F6C34B298
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhCZXQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbhCZXQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:16:26 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F535C0613B1;
        Fri, 26 Mar 2021 16:16:26 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id m7so5405567qtq.11;
        Fri, 26 Mar 2021 16:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cm10GGdyWZtnDl0+G0KuOKzTFOV/zfC7KJnkTQznRig=;
        b=qyBUV+W9NBdE67rSlOew2QE5uTL9EveZK9pO97+JlHnohsKCIUhrFNs9lYEXJnAN3o
         OHa6yu513jTm6R2OZfLNy2rWuA4arJlxHbMGi1C5+xQ2J3vYJgysdnR5NDrRY6Fl+aVW
         To+lnGYPNrFf/zezDcZTVi/4jjAjH1mNNvoYfR/4eZaVn+FesjrzXWcOkQWBOXlnj2A6
         sBSkrE9t+DFMAMizG9S/LOclqp9OMXTI0yWzfdh3N6xnS1Qs0g2H2yWiBgwafFpEo5Wb
         o6rfIwkjYMK7OTWFq/uNqS124ApIIKPnbDK6qfwRlLTxn0Ox7GU87YkPI5PxlqsNNekk
         xAtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cm10GGdyWZtnDl0+G0KuOKzTFOV/zfC7KJnkTQznRig=;
        b=LTjfLsx/nr6u3rCpihK3FqwVtTZ1dWM0GRHsj3O9vvST4J853MXu2o8HEXRB0wEul3
         6UFz64yS1BN3X3t9hCvZX8Gvq+jsRmtmr8UZpSLiUPnawmXL98oCDN6Zx+dTjWUVi2of
         uZQBDAEr1h2ozQvJBwzUtBrO1dW9um4/CG0NIcq6zdmbDv96SZaqUBq+9G+pxwcoyGIZ
         85UU+bFb0e3OruN4yl64A4rbir7MP8nHWAffSOizB9yuawuDvWhqhdrljr2NOSXGpmwl
         LZtXZ4a1c+62hljFyiOV+OA7JrdIKlNguyQuxPDB0zUpronxUzcNuv9yucwoW3zKFlFc
         OXbw==
X-Gm-Message-State: AOAM5337D3Vine/zAmDP6qzJSkFT3fWBuAK8quoe8JwFlj0rSnjwZw6J
        3rrLadwOjmZldB8mflTBMqg=
X-Google-Smtp-Source: ABdhPJzB1UdSmkM41U9oFSZxqj65gb7Y5zsnF6NyssOfYXXavvrL5yymUvPGYKErdqFVXkKSi/pRcQ==
X-Received: by 2002:ac8:5684:: with SMTP id h4mr14276323qta.61.1616800585455;
        Fri, 26 Mar 2021 16:16:25 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:16:24 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH] ipv4: tcp_lp.c: Couple of typo fixes
Date:   Sat, 27 Mar 2021 04:42:39 +0530
Message-Id: <20210326231608.24407-4-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/resrved/reserved/
s/within/within/

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

