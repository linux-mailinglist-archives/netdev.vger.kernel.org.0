Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A341334B2AA
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhCZXR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbhCZXQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:16:59 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79EFFC0613AA;
        Fri, 26 Mar 2021 16:16:59 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id y5so6963991qkl.9;
        Fri, 26 Mar 2021 16:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=McAgNR//ZZOSE4RTlME+7zIMYVZ67kdO9uVaupZQzno=;
        b=uV5V1Hb/lDygXxGSWDk7xpPwZ2UMS5qBFLvy3jsZhRkm2T9+yC0RQhrgdrIzwSFSwt
         wyXCNm0h2q2EoCnpEGWAUwehAqfZgdDKJbVBGMd1bgqfu3lfVJVnqLTnDwJmRmI3uM3i
         Gayrc4baevvg5KyPS0IXCfw+LqzQC8DbOmHUFPax5saKjm85nHD8LOp7Co5v6JuoE++z
         kP5wKyGyChQjUCuzjXyu3k/duqZ29GmbXmi/UXQRBy49ns0aNOdgHJxtPo1kJM1/PDMy
         bU6yHH7RpMe8+ECmD3BcIJXHs1l2KkPUPj0rz5X0I60XtFOSsABDdkM0/ylScGvJtHwE
         B+9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=McAgNR//ZZOSE4RTlME+7zIMYVZ67kdO9uVaupZQzno=;
        b=DLOGDZrlWYasMSN6+MKP+kskQTaXXXxetayOP2KHTxb2Uf9OestbHOR5Bh9906QMQw
         OoKP0w20zaD2/ps28y3HYv2I1QQEpu7WjNQE5kKQkDNgT8AGUbOJJRs+bxoT1tdiIw8J
         KICchh9du8+B6TQsO8Mq6dgkFNscmo5V/CcVl+Zwhu9pwWsCvXHgd+XZyFBWLu7lEjDT
         0Rnb0MKNMP1HVLOeKZi9wV+Ka3X+Qh0QQOk5zpG/PqmC7pfqyYplU7q2x9KDsxvLn68m
         OJ1ziCi0ilopbA9N5O6Wv4swJQI2T86SnGYZRW/ARONVeqWaqBvjHHa3XkMO/XpUhrP0
         SrRQ==
X-Gm-Message-State: AOAM530njN3eW32Spb0W33o14yY/mAXYo0OFKDBNSK4qcnjvJYsHjYsW
        ICluSUHWnbsRHHoQ60W7z/Y=
X-Google-Smtp-Source: ABdhPJwwGQBYeuhPTaW7aJ8R09LJ578B1fsNwJAd2V4GotJNu8+8JvRYNEXUNsCL5vHKpG8Ey2qD3A==
X-Received: by 2002:a05:620a:102f:: with SMTP id a15mr16018504qkk.87.1616800618831;
        Fri, 26 Mar 2021 16:16:58 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:16:58 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH] netfilter: ipvs: A spello fix
Date:   Sat, 27 Mar 2021 04:42:48 +0530
Message-Id: <20210326231608.24407-13-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/registerd/registered/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/netfilter/ipvs/ip_vs_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 0c132ff9b446..128690c512df 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2398,7 +2398,7 @@ static int __net_init __ip_vs_init(struct net *net)
 	if (ipvs == NULL)
 		return -ENOMEM;

-	/* Hold the beast until a service is registerd */
+	/* Hold the beast until a service is registered */
 	ipvs->enable = 0;
 	ipvs->net = net;
 	/* Counters used for creating unique names */
--
2.26.2

