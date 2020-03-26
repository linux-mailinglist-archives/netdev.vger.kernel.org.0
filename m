Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC6C8193897
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbgCZG3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:29:42 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:45228 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbgCZG3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 02:29:41 -0400
Received: by mail-wr1-f44.google.com with SMTP id t7so6255190wrw.12
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 23:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=J907FcpDgXW1N7dOZm4k1RpqG8OmdQYV+6AhbaGIPqI=;
        b=Kv2H0XwkpuddnHHZtvbdxl/+jkSiKqMfFFFt++h8IsAMF7+MP5losKlkiV2iqJwz+E
         c1W3m9W+NWlw6JmlWH7+5+szFV+3Vb9asAxG7Dq9AnifpCJekEIMff8xtMVeVBv8MLkf
         7iS+wkofcQvT1jQJCcNvvR1BEYg9semrUyjR8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=J907FcpDgXW1N7dOZm4k1RpqG8OmdQYV+6AhbaGIPqI=;
        b=eAvrf7B8En8xQUiSABZONTSAfvLNB4fwXrR/Whmakc+N0pdZeqr2FCFSeImZJ1RsbR
         uZKjJOrRSGnZSU6yLivOIxHx4x8G33OZXfyPKGpN4jq6zhH3y7jxfIoJ3eSBkHaeyWQs
         3KGrNf5cSqgpWp6c+uhTnZ5gWWuEIVb/q766oBojqMfzHoxilVIjW7EGQjgjxOzOQP3j
         gmwNhex2Sqd1XA+QoAINuCtRlfsXWlYJ7FFRQRjka5KxzTsqbWRGDeNDi/prDgSg0gaA
         X2kg4gXCFUChv+pInprVRPBqsYwQLXPaxokw9gGuonvQQfAKvCdjEFdY1ucsZ0U35Ijf
         lY0A==
X-Gm-Message-State: ANhLgQ0H/FQ/f4i+wgGIRuKr13lzUEQ4RJV2B+WPduMr7e6RYpLANdNp
        XUvGEMxFcHqqx0f9w9UARwmLjg==
X-Google-Smtp-Source: ADFU+vtYiRTxb5ceJZOMi3b/Mtjs2bF5LydW8jnm2c30FCwyRGfZDTBDjiIqv4HU5th/x3XpP3uZqQ==
X-Received: by 2002:a05:6000:a:: with SMTP id h10mr7949939wrx.226.1585204179864;
        Wed, 25 Mar 2020 23:29:39 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id y200sm2106768wmc.20.2020.03.25.23.29.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Mar 2020 23:29:39 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH v2 net-next 1/7] devlink: Add macro for "fw.api" to info_get cb.
Date:   Thu, 26 Mar 2020 11:56:58 +0530
Message-Id: <1585204021-10317-2-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1585204021-10317-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1585204021-10317-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add definition and documentation for the new generic info "fw.api".
"fw.api" specifies the version of the software interfaces between
driver and overall firmware.

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jiri Pirko <jiri@mellanox.com>
Cc: Jacob Keller <jacob.e.keller@intel.com>
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

