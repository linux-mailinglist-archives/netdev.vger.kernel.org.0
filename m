Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 121A93493C
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 15:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfFDNox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 09:44:53 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38985 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbfFDNox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 09:44:53 -0400
Received: by mail-wm1-f66.google.com with SMTP id z23so108612wma.4
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 06:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Sfb0sgvRpWoA5dwvrWDTUMa5fk+uyuZPYj0MtgD3oCU=;
        b=Pu7zOhWLMT/kIGWVog9b9JKv5Snh9LRjRNJ5qs3CYpF0awMz8nqdhx4XfPBkiNllgK
         ITcSW1t1zfyNBXEeSKmgav/07pbVtPUrKWNCqA56WLGuD8piykipFdnBgoQze6+EK8L8
         4wpmOVCHidlts0j/Qs6JISBxU0QUt/Q2Y91LABcwyaflUgcUBS0r9nDk+3Uv2lR1NoiI
         lmANfU+N5f6ukssQYHr6MaflV0bFLzLc0q4FnnSDttpvPes4cFzBvxhftNG4n8UQBXis
         dknQIneXhUTfkRLVBL7aRJaQUQN6WeEuubbYwUzevm0NrVc4SHwHrth1d4EEiEMwJVly
         Xefg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Sfb0sgvRpWoA5dwvrWDTUMa5fk+uyuZPYj0MtgD3oCU=;
        b=laVQrwSJywATVW+fTNEJULNY/CGp2+ia7bhxKu/NGzz2Ff3xNZp51u4nBSbHr9Sd5j
         RAlqtZ3noGbsYMRjy/TO79v2bCjFlgjhz9MdDLZEr7Dc13ckqAFPZ228NDHnLqNNqv5I
         58ZTUuqHIKpkykgWEOCwA1gWRvz9R03s/VxQTWwB4rMlzNiEwPqDT0EtAKZp489sKDfF
         dQCJGa/aFWHsiGziNvKEPbRscpqxSOMfa2unLrpwjaztWpkPxTIv0X0b5XdKeCzpyNeS
         UzysRILghPotuJNwgl7JfffOZrgFtCETfc4bB2cs+dxo5NVdIfonHp+t11W+xbjWPIV/
         CNLA==
X-Gm-Message-State: APjAAAVyPf8lFeQpsODsXSkoVxNw0lSrkgGmlV3kLA8xKGbFw8ZHWV6y
        Aw6M9vP6lVjv5cbriIAFWnlaB3E+eMbdww==
X-Google-Smtp-Source: APXvYqybyWEkuzOEq1W9C6qafJP5tgSR0DiZxsHRvg1Y6kTT3qNhLycFNDOp0F/rzRA3tVJ4nxBJ9w==
X-Received: by 2002:a1c:7a15:: with SMTP id v21mr18303407wmc.82.1559655891007;
        Tue, 04 Jun 2019 06:44:51 -0700 (PDT)
Received: from localhost (ip-62-245-91-87.net.upcbroadband.cz. [62.245.91.87])
        by smtp.gmail.com with ESMTPSA id t14sm19277349wrr.33.2019.06.04.06.44.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 06:44:50 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: [patch net-next v3 1/3] header update
Date:   Tue,  4 Jun 2019 15:44:48 +0200
Message-Id: <20190604134450.2839-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190604134044.2613-1-jiri@resnulli.us>
References: <20190604134044.2613-1-jiri@resnulli.us>
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

