Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8C0CDEF71
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 16:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729062AbfJUO0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 10:26:19 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37264 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfJUO0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 10:26:18 -0400
Received: by mail-wr1-f68.google.com with SMTP id e11so5532308wrv.4
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 07:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4RmJbgCmgVPbYCPzuUTfQz9NNPDbBcCcEPPNGTwWR6k=;
        b=N0W1CtFTD0l2dj8+DTzweGMG/ONvRzkW9dQ1KiUHtFoIbOC1ZGAeMTlDXzVF2/WhBY
         X6JIDshdul9C+D6t/ZAN6BOcp+2/AUdIDpxpjOictYnmEHlAkvnAqetkriw5S9IkpTAF
         8+k/0TT4MbB2EIIrIuobI3CWWvcgKaKLoTawb4zsLUJfSU6ZphvvLsdLGyggm2T5UJbM
         7U9g0WPmHfy3+tlM/eMzApMsJY0TRhXR6aZWqTSLAS6luLuGHnggOLkUS+MBYE8fwsAW
         aVFawAcQUApLX3zo/kvDNkG3XV05yDieIDO4WrV5aBluPN0neVp5B2KG+hjHNDoOBJUI
         D0pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4RmJbgCmgVPbYCPzuUTfQz9NNPDbBcCcEPPNGTwWR6k=;
        b=WxExK1EH2kT0vrBkDfZoMx3HY/bNvxizsmp1FKgMftFZoRk1h+dao1aC3s0M1baZbh
         SxTdAXGrmU2t+quBinTMsCdRI1waA4FWcY+DqoXIX5/Mshw//zJbp4b05jhJeY80kRVw
         /+aFwqLXRnS7nBoN9DPHoM3Q1JuIoui7oKh7Sore3ljvAuert2moY0mZHc4pxOPcM0Qg
         ziuuh29IY3qqJKwLqhy9DG1B3tzWXjbB5HuuVsPC3B+zGo/5yKDLx3+VsPBf0eCGS1d8
         6iBpR00Ubnq80/cgA8ieE/YQemUslLalvOkcQHuc9PkKAmv6eylei0IFxyEp66SS7cFP
         2uUg==
X-Gm-Message-State: APjAAAVgUNNvw8kL0OZQ+/LanMEGwHQHgsJW5MEEggPAWAO4Hx35M9p7
        Z8VQxthTIhxxCKfcU2S8ZoBmG6tfX84=
X-Google-Smtp-Source: APXvYqxXCADjt2xeMb8GJ5q4LUKSo+m1J1e0fiW/HzksfO99RcpMqJAyCdZhPtlHkIEM//AUQ9DC7A==
X-Received: by 2002:a05:6000:11d2:: with SMTP id i18mr21074491wrx.109.1571667975668;
        Mon, 21 Oct 2019 07:26:15 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id f17sm3265184wrs.66.2019.10.21.07.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 07:26:15 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com, andrew@lunn.ch,
        mlxsw@mellanox.com
Subject: [patch net-next v3 1/3] netdevsim: change name of fib rules resource
Date:   Mon, 21 Oct 2019 16:26:11 +0200
Message-Id: <20191021142613.26657-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191021142613.26657-1-jiri@resnulli.us>
References: <20191021142613.26657-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

To be aligned with upcoming formatting restrictions, change the name of
the resource to "fib_rules".

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v2->v3:
- new patch
---
 drivers/net/netdevsim/dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 468e157a7cb1..cb908960842b 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -154,7 +154,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 		return err;
 	}
 
-	err = devlink_resource_register(devlink, "fib-rules", (u64)-1,
+	err = devlink_resource_register(devlink, "fib_rules", (u64)-1,
 					NSIM_RESOURCE_IPV4_FIB_RULES,
 					NSIM_RESOURCE_IPV4, &params);
 	if (err) {
@@ -180,7 +180,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 		return err;
 	}
 
-	err = devlink_resource_register(devlink, "fib-rules", (u64)-1,
+	err = devlink_resource_register(devlink, "fib_rules", (u64)-1,
 					NSIM_RESOURCE_IPV6_FIB_RULES,
 					NSIM_RESOURCE_IPV6, &params);
 	if (err) {
-- 
2.21.0

