Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76BB914A14F
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgA0J51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:57:27 -0500
Received: from mail-pj1-f50.google.com ([209.85.216.50]:50610 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727520AbgA0J50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 04:57:26 -0500
Received: by mail-pj1-f50.google.com with SMTP id r67so2760668pjb.0
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 01:57:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4YDICnezYM4QBas9xM5NTN4WIcTOzMBDSTQr9YZpi9E=;
        b=CquaVzR1f8aUfmxTsFKW9OwGXy2WfrhHrmVOzJxbCeq2OYqcXfEpCE+XNyLr4diKTJ
         PbmL8KBFRi1JI02TDeM7l0Xp32J6l/eJm6uCUOwGqbqxHml+ZtGBrsHntZliMSPz8x2F
         VD7PoY0mdooTU/k3P3bknGxa6U+BSEC7ZIYms=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4YDICnezYM4QBas9xM5NTN4WIcTOzMBDSTQr9YZpi9E=;
        b=LNuL2xU/mdizgVOgtEl9aFuxZwqUEKNsnQucAFj2DZ1eJ0SRh7XFkVWFPlt3iEMUpF
         1B5fRBHP/MhWqc0O44o9ETNkbXJVZ+5Nlk33KQsX1f+97m93k59ZnKCssEMtDp6RNw1p
         +8+rhowk/GO0pJ1b+0il0E566Qq1+ETVPByRWHkSsO5oTjh78uPOARs1aVtHL1ROAs7m
         /JLCLhtvxham/+RGp6conwYOtUPhmpxSDkkbgDEDcETNCeOrVEyCL/8U6PwGPzVKwufl
         AeHqJeMn+gzQCZQIX/8aV4MPumFO0SPYuDIbfFLSKTbRX/H/oZcWTxGplUT7ulS8GYk4
         v8yQ==
X-Gm-Message-State: APjAAAWYtE37LjSowb2bZrdDv6vD7sHtYydJBtTA0QSneaxHfOXsr0D9
        +zq0ntQNu8KZgmmWdzy/qkOm/w==
X-Google-Smtp-Source: APXvYqzJg9di/Yu682RWgAZqcvqKHBBGtHk/UpAvVtYK5CXqA7ielx8Cr+vGmYSsCzP3VU0eHt36lQ==
X-Received: by 2002:a17:90a:e982:: with SMTP id v2mr13776925pjy.53.1580119045388;
        Mon, 27 Jan 2020 01:57:25 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r3sm15232594pfg.145.2020.01.27.01.57.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jan 2020 01:57:25 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 13/15] devlink: add macro for "fw.roce"
Date:   Mon, 27 Jan 2020 04:56:25 -0500
Message-Id: <1580118987-30052-14-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
References: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Add definition and documentation for the new generic info "fw.roce".

v2: Remove board.nvm_cfg since fw.psid is similar.

Cc: Jiri Pirko <jiri@mellanox.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 Documentation/networking/devlink/devlink-info.rst | 6 ++++++
 include/net/devlink.h                             | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-info.rst b/Documentation/networking/devlink/devlink-info.rst
index 0385f15..70981dd 100644
--- a/Documentation/networking/devlink/devlink-info.rst
+++ b/Documentation/networking/devlink/devlink-info.rst
@@ -92,3 +92,9 @@ fw.psid
 -------
 
 Unique identifier of the firmware parameter set.
+
+fw.roce
+-------
+
+RoCE firmware version which is responsible for handling roce
+management.
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 5e46c24..ce5cea4 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -487,6 +487,8 @@ enum devlink_param_generic_id {
 #define DEVLINK_INFO_VERSION_GENERIC_FW_NCSI	"fw.ncsi"
 /* FW parameter set id */
 #define DEVLINK_INFO_VERSION_GENERIC_FW_PSID	"fw.psid"
+/* RoCE FW version */
+#define DEVLINK_INFO_VERSION_GENERIC_FW_ROCE	"fw.roce"
 
 struct devlink_region;
 struct devlink_info_req;
-- 
2.5.1

