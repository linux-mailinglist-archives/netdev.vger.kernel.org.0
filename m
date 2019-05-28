Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 688A02C5BC
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 13:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbfE1LuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 07:50:24 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52921 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfE1LuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 07:50:24 -0400
Received: by mail-wm1-f66.google.com with SMTP id y3so2569069wmm.2
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 04:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Sfb0sgvRpWoA5dwvrWDTUMa5fk+uyuZPYj0MtgD3oCU=;
        b=Sp4s3tN7Wb8R5wP2giVyrq7eE2ZW+3sk40xL1HJc+YWR79mLyusoeOWKN0MfN3zs1K
         q3wuj5QkSsz02ojkqEsnCjihB5kmy2X5wsnZWJQmMEBEKR9DNcO1LGciwy4XAwHAlgdE
         c6n/qzjKgNZuZicSs/NhnN6D/TDEI2v/GQ4etlOf+itUrWeX8eDmMFoql7fCkfg1xFk7
         dluP6laVQZb3EYz2sSR0nTFCNqt/MPp0Kr9FkQHI8Ea7GXwHNgasPfGNy5SMUKn2uqIH
         /DmBmEP12YFY4t6oPuHOQWFHtcT/o6WaRECjq/GXCCeeJV3/1t8icDlXQ2FyAiVKcofX
         wLqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Sfb0sgvRpWoA5dwvrWDTUMa5fk+uyuZPYj0MtgD3oCU=;
        b=Cog9xqnPGgZwy8/DLmIRHRTUdht5mZ2y7Co0RZzNnMX+6qLRd4C0axdlFQvbnp3na0
         z7ak3oUiq+XmBi275CxIbxxtX0PSnVxUg7LvAJZ3JesUBiREGIhZqngRCcK6L7tYC5Wl
         zjwU6NrExBPfrVa8ZQtKC8WumdWQeicCo/3ZFrQSbeLpx4Osa39u/A2YhFeLKtjM6L2I
         VB+7BIeQiuS/kPu/mxv/V8rQhjeqIvEL+gHMvUqivTs3BBrIsGCr1ZKIptGYZEpB7NFV
         AvCIGAF4I7bIHSLX7ABKlAq/gI/U1j2btoeo9BgmVvIf42H+ho3TT/EnuYP/wusdpmCz
         6Gmw==
X-Gm-Message-State: APjAAAWZafW2L1SBGNEkrdJY5AuuKtJcRxpxz01uc/84AK4bkXWbmAHc
        8QTtbSUPiBF+XZZzmcSDQSDXQ+ijMwA=
X-Google-Smtp-Source: APXvYqwFMv0mFVj0eF6gYIsDJPCIPeh5CjPv+sl7uA6sfeGmdmJZbZzbOpdN6ptRx3MF870dvx2Z3Q==
X-Received: by 2002:a1c:700c:: with SMTP id l12mr2949759wmc.170.1559044222781;
        Tue, 28 May 2019 04:50:22 -0700 (PDT)
Received: from localhost (ip-89-177-126-215.net.upcbroadband.cz. [89.177.126.215])
        by smtp.gmail.com with ESMTPSA id j7sm10914688wrt.31.2019.05.28.04.50.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 May 2019 04:50:22 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: [patch net-next v2 1/3] header update
Date:   Tue, 28 May 2019 13:50:19 +0200
Message-Id: <20190528115021.2063-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190528114846.1983-1-jiri@resnulli.us>
References: <20190528114846.1983-1-jiri@resnulli.us>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 include/uapi/linux/devlink.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 3b6a9e6be3ac..6544824a0b97 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -104,6 +104,8 @@ enum devlink_command {
 	DEVLINK_CMD_HEALTH_REPORTER_DUMP_CLEAR,
 
 	DEVLINK_CMD_FLASH_UPDATE,
+	DEVLINK_CMD_FLASH_UPDATE_END,		/* notification only */
+	DEVLINK_CMD_FLASH_UPDATE_STATUS,	/* notification only */
 
 	/* add new commands above here */
 	__DEVLINK_CMD_MAX,
@@ -331,6 +333,9 @@ enum devlink_attr {
 
 	DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME,	/* string */
 	DEVLINK_ATTR_FLASH_UPDATE_COMPONENT,	/* string */
+	DEVLINK_ATTR_FLASH_UPDATE_STATUS_MSG,	/* string */
+	DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE,	/* u64 */
+	DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL,	/* u64 */
 
 	/* add new attributes above here, update the policy in devlink.c */
 
-- 
2.17.2

