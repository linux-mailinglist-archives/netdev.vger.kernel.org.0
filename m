Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD74279A7
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 11:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730428AbfEWJrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 05:47:13 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42830 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729863AbfEWJrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 05:47:13 -0400
Received: by mail-wr1-f67.google.com with SMTP id l2so5501624wrb.9
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 02:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Sfb0sgvRpWoA5dwvrWDTUMa5fk+uyuZPYj0MtgD3oCU=;
        b=BhePwQgSAqABLZLupJKeS2s82imBpR3bl2duMrAwGTPM9ZsQV8CFHPIU4Om3b64JVI
         XtaIUMDAtkWpqV0mxAVqz1SuLKGyVGdnshaShzyzXMKcOGZfX96fBF7STz6bSI5lTo4Q
         xegHyXk2NKJfojwSo/m1fv9Q56oNFlVEkqo/K7UjiY6n81FcRWx/dOJ3o985WkA4fzoe
         xbhNLVpd2RsAWB5L1GKkwrcK8T34RRV0XWzLfZgHja3MqRn7mFoAo9ybnG//utEGsgUi
         YpAsCMyBDrFC6LKeZVBAAjYyoDPlYAlTUVTLqXzVrHFRoyKG/HlDQxXYKzBWZONFaeCU
         FAwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Sfb0sgvRpWoA5dwvrWDTUMa5fk+uyuZPYj0MtgD3oCU=;
        b=X4N2PBnmIm6g9fz0httCXLRC7oe49f75oih+7eF/SPoSzjnrw9dZZsFLlFOb4MQ7F3
         doNQcltDXsHuMqqKs9jBoE9z6icRSvBxv3Thrpw0Enwu/bA5Yj5IuO2eGBLJCIT6lxcD
         RXrjVjSUrNDW2VUhBfvh7wVGZQcHelfYIT1KQjMFJW7FunGjWFbxAaFExQis16HndWhP
         411hz34RY/OX2867RbOOBWACuv0UG3vw4tJhCcif2UmshFopUtkGaHuVbzL4sCfBxUUw
         bwupRCeBXJkrGxomzuBK80HycNk6aaIyeaDUxUkf7qAUMk2xtCvnKlOe9GIozkKj6qFX
         T1oA==
X-Gm-Message-State: APjAAAX7Hb8RZoXDY8FBkjfMRzarXhI6lQCVFE1+zTjqEdDvB8yraggX
        t8Xsvc/VahXjJOdq3Z0lTB4/AkWE4iY=
X-Google-Smtp-Source: APXvYqw2/KVkvm3DEgtAwCuSrJWijveML6kavWWC7exBUJFYPgHZaxNwpybhV/uuhXX1d3vvvqbn3w==
X-Received: by 2002:adf:ce8e:: with SMTP id r14mr45658424wrn.289.1558604831459;
        Thu, 23 May 2019 02:47:11 -0700 (PDT)
Received: from localhost (ip-89-176-222-123.net.upcbroadband.cz. [89.176.222.123])
        by smtp.gmail.com with ESMTPSA id z21sm9780579wmf.25.2019.05.23.02.47.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 May 2019 02:47:11 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org
Subject: [patch iproute2 1/3] header update
Date:   Thu, 23 May 2019 11:47:08 +0200
Message-Id: <20190523094710.2410-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190523094510.2317-1-jiri@resnulli.us>
References: <20190523094510.2317-1-jiri@resnulli.us>
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

