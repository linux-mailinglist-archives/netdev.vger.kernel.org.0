Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A922A29BA
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728694AbgKBLqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728614AbgKBLpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:45:30 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917F6C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:45:30 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id n15so14255987wrq.2
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t4Kp5LGeouttAwFs/VHXrMGULx219tqmwLf1j6gGnyc=;
        b=IxN7oIBLixmziOnZEDfpg27SlZeeQzLHDly3rD5PBvgtwybxQOTRJ0dk4s4ZO7bXHR
         aug3rJXvjD9RzjNxoViF2PSD/LHbzVCwu71S9r0EZP4kJcPL1zJGVG1ZF4+/rD1dp6v2
         N5gD2xyA21UGdYU4i1FF+XcjbCXYAteV2AU8rMQ9/3suud0r9Cb/ZFhzorcdE+1PK5As
         EX/rxZ1q2fqjl5clMvK9xKmWbNFYPcKxU3P0OYhbXgKjqz8W6tXAtKwqEtXbM4ZIVMHG
         2viNNszSJcVPikgKJzE1C5gJ/5HrNnyqsFZATzGEaWH0Ucxi1Y3j9HQB7v12b3hmn05w
         FVhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t4Kp5LGeouttAwFs/VHXrMGULx219tqmwLf1j6gGnyc=;
        b=c1c7MjdmcqD+PWbpnyFkKNjZIAMsJNVjcjxXsWi7VpkMze9Pf4TdD5/b/bxva56E8L
         +YxqolqeldqEn9Hs/RlWcBhYmwe130cbf7ZA2jNSR0J/xafwVxD+goU6OQDcxrZHrfkt
         wlslWquq/uHNHIHMEERa8HAIHfjT8yfAOT12cXrHmSRXwk8zyLug7Jn8AWDJNMGa4+sW
         6BlcvAqHab6whpFUasZahmEicMyR8wLY8SWlpjsVShCER0pcJW7XX2aybguMRXyzrZMX
         ORX1DC5vO28cU4IlSubDC5NOnRctyvzY/3//Iw0wYDaebAd8U59S67iw4l8gyD67sSGQ
         sfJw==
X-Gm-Message-State: AOAM533U5O14kAlR+YpZE1AaZSTK3ubM+i/z9W6A2JwBYqxVRMEQp8EM
        L9Tr8+fSjJ84iD1iptFDh3FmPtWreMbMrA==
X-Google-Smtp-Source: ABdhPJwgk09rZHq7NiCiX4EOKV9gPkTQ+xO+kvkTLALfOhOJmvVxUvUQo47QQ3HEgLidB7rTqRzZYg==
X-Received: by 2002:a5d:5449:: with SMTP id w9mr20774903wrv.182.1604317529366;
        Mon, 02 Nov 2020 03:45:29 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id g66sm15545352wmg.37.2020.11.02.03.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:45:28 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net
Cc:     Lee Jones <lee.jones@linaro.org>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org
Subject: [PATCH 07/30] net: fddi: skfp: pmf: Remove defined but unused variable 'ID_sccs'
Date:   Mon,  2 Nov 2020 11:44:49 +0000
Message-Id: <20201102114512.1062724-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102114512.1062724-1-lee.jones@linaro.org>
References: <20201102114512.1062724-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/fddi/skfp/pmf.c:28:19: warning: ‘ID_sccs’ defined but not used [-Wunused-const-variable=]

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/fddi/skfp/pmf.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/fddi/skfp/pmf.c b/drivers/net/fddi/skfp/pmf.c
index 14f10b4cab0fc..563fb7f0b327e 100644
--- a/drivers/net/fddi/skfp/pmf.c
+++ b/drivers/net/fddi/skfp/pmf.c
@@ -24,10 +24,6 @@
 
 #ifndef	SLIM_SMT
 
-#ifndef	lint
-static const char ID_sccs[] = "@(#)pmf.c	1.37 97/08/04 (C) SK " ;
-#endif
-
 static int smt_authorize(struct s_smc *smc, struct smt_header *sm);
 static int smt_check_set_count(struct s_smc *smc, struct smt_header *sm);
 static const struct s_p_tab* smt_get_ptab(u_short para);
-- 
2.25.1

