Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E777193E8C
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 13:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbgCZMEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 08:04:38 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:44668 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727841AbgCZMEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 08:04:38 -0400
Received: by mail-wr1-f42.google.com with SMTP id m17so7390994wrw.11
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 05:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VuRbPNlCIMP3t93wAWjdG1iK3phauZwFNn810BiXTrw=;
        b=b8R1O805nRMgXgQg45uiRE8y0lVtva0VFEW6rlsQPIwqCBJ5o6hYmIY8u1UVCr1fEG
         TYZxvy+BdKQ75RiMfQuE//Z3jVxsR0oDd6caF81eGCdAlVyK1ryPUSHGa0CWLVAx/jzT
         V6G5vRN31NIbDoqW8sUriJPo2siHrlGKOKzcs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VuRbPNlCIMP3t93wAWjdG1iK3phauZwFNn810BiXTrw=;
        b=KEnfEn8hapfW75wB3XKnPXRr2jGsgVfsLi5Z2BOHivirvcQMTLj2td429UBWHkMdqD
         J4z+3gYfZEcvvbjcF56utwK8pSibwkkMEz+liQ6rbX5cey2gnikVVlWqaSwsFc+eTy1W
         x6oWV7WLtXLXlmdeN9ThqA5AyXVgoddEhkqd4t8b/A7wBvRnGESS9eEiI601wjYG2yDW
         7kOiHfjqxJIdbAaeXWFFLUYqloYpIEH9UpRU8eY5DUFzxlkvmAExAsiQ3Zl4keddoxkA
         y1zks9Mk0UshvKVs+JMCO8YD9F4oftro7qrrXxqjRwfNR2kzNRw+rkUwB3dXO585KY4b
         FRtQ==
X-Gm-Message-State: ANhLgQ2QlgQ0HbY5qp31eqwJizjFP8uaJpACVS9apBEjSomebeoGs8pn
        kGCGDquf/X1T4Iq40yE7oQwm0A==
X-Google-Smtp-Source: ADFU+vuBJ7/AU+L/vIvxT8tGu1NghXxcXjmOUB6QC1tZ03PmSdqYJ9lm8IM69cbH2lb1GlXPPTLlbg==
X-Received: by 2002:adf:c651:: with SMTP id u17mr9491673wrg.40.1585224275896;
        Thu, 26 Mar 2020 05:04:35 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id k84sm3316637wmk.2.2020.03.26.05.04.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Mar 2020 05:04:35 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH v3 net-next 1/5] devlink: Add macro for "fw.api" to info_get cb.
Date:   Thu, 26 Mar 2020 17:32:34 +0530
Message-Id: <1585224155-11612-2-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1585224155-11612-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1585224155-11612-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add definition and documentation for the new generic info "fw.api".
"fw.api" specifies the version of the software interfaces between
driver and overall firmware.

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
v1->v2: Rename macro to "fw.api" from "drv.spec".
---
 Documentation/networking/devlink/devlink-info.rst | 6 ++++++
 include/net/devlink.h                             | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-info.rst b/Documentation/networking/devlink/devlink-info.rst
index e5e5e89..650e2c0e3 100644
--- a/Documentation/networking/devlink/devlink-info.rst
+++ b/Documentation/networking/devlink/devlink-info.rst
@@ -150,6 +150,12 @@ fw
 Overall firmware version, often representing the collection of
 fw.mgmt, fw.app, etc.
 
+fw.api
+------
+
+Overall firmware interface specification version of the software interfaces
+between driver and firmware.
+
 fw.mgmt
 -------
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 37230e2..d51482f 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -478,6 +478,8 @@ enum devlink_param_generic_id {
 
 /* Overall FW version */
 #define DEVLINK_INFO_VERSION_GENERIC_FW		"fw"
+/* Overall FW interface specification version */
+#define DEVLINK_INFO_VERSION_GENERIC_FW_API	"fw.api"
 /* Control processor FW version */
 #define DEVLINK_INFO_VERSION_GENERIC_FW_MGMT	"fw.mgmt"
 /* Data path microcode controlling high-speed packet processing */
-- 
1.8.3.1

