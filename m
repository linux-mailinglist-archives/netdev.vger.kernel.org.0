Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD4FC195423
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 10:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgC0Jg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 05:36:56 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:45279 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgC0Jg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 05:36:56 -0400
Received: by mail-wr1-f43.google.com with SMTP id t7so10508331wrw.12
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 02:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=J6ORlKyGxaeRqj6NVCJMTDNSIGYQzFY44o2e9Ni2CYM=;
        b=Yr/MAs2rf4gp++5A9Q42NX9OgWZZT6bpZZ105kF5FA2pA7aYkeT20t0TV1FDUJ6w4c
         o7nmLPH1YauXlu9BYPJmtzYB48RNJBdWVMQWzomqoHJhliy0kywpcXDSHFD01UgZ03Fv
         JFQQ4fYAJV9G09rL7CPaqzaov9t2sg6/EHgG8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=J6ORlKyGxaeRqj6NVCJMTDNSIGYQzFY44o2e9Ni2CYM=;
        b=BWJDE43b4xv151G50bIFY3vHn9tXJ/KHbqvTG3BBruzkL21sVXFwQJFe5IAEbIXThZ
         m9FmPAoCnozkFazQJyvP+luNFxqvMNhk4zmGwA0g4/gMz1TaruuYPZ3IENzn8kmiIVkW
         cesnyF9zDSqPG864JNAl9LhTfSGikbbtoWHcJQvryRbIRCwGb3ObBqMtZQJwF1jzzmki
         Tt1kCFPKulR56zDlOg9cKAlPd9kH4sT/4hdO8xWgzirOkAYZ3RA1DycdU5Z0zVglN7em
         t23gP+XCln55/rr8I3dfwpHvWhwEjuEm6IdG0jfa/mKxfdIWmaeQM7yv7/iYofg6reGb
         jbRA==
X-Gm-Message-State: ANhLgQ3Eh5ZkhjXGsSGswOySkLIeBdwnqMUJcijLrEdYNZsAzj6+ErhX
        SvnYabP/ouy07P0m7WXd6zwDnQ==
X-Google-Smtp-Source: ADFU+vsR6asJFz1f4kpZ8/QXAUWGGEkER/OR//WMQHX1F1Cp62GmEjWh3c66dksWXvXTf22ouK70UQ==
X-Received: by 2002:a5d:4401:: with SMTP id z1mr13833667wrq.259.1585301814084;
        Fri, 27 Mar 2020 02:36:54 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id g186sm7607450wmg.36.2020.03.27.02.36.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Mar 2020 02:36:53 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH v4 net-next 1/6] devlink: Add macro for "fw.mgmt.api" to info_get cb.
Date:   Fri, 27 Mar 2020 15:04:51 +0530
Message-Id: <1585301692-25954-2-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1585301692-25954-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1585301692-25954-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add definition and documentation for the new generic info
"fw.mgmt.api". This macro specifies the version of the software
interfaces between driver and firmware.

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jacob Keller <jacob.e.keller@intel.com>
Cc: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
v1->v2: Rename macro to "fw.api" from "drv.spec".
---
v3->v4: Rename "fw.api" to "fw.mgmt.api", to make it more common
across all vendors.
---
 Documentation/networking/devlink/devlink-info.rst | 6 ++++++
 include/net/devlink.h                             | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-info.rst b/Documentation/networking/devlink/devlink-info.rst
index e5e5e89..3fe1140 100644
--- a/Documentation/networking/devlink/devlink-info.rst
+++ b/Documentation/networking/devlink/devlink-info.rst
@@ -157,6 +157,12 @@ Control unit firmware version. This firmware is responsible for house
 keeping tasks, PHY control etc. but not the packet-by-packet data path
 operation.
 
+fw.mgmt.api
+-----------
+
+Firmware interface specification version of the software interfaces between
+driver and firmware.
+
 fw.app
 ------
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index a1a02cd5..3be5034 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -481,6 +481,8 @@ enum devlink_param_generic_id {
 #define DEVLINK_INFO_VERSION_GENERIC_FW		"fw"
 /* Control processor FW version */
 #define DEVLINK_INFO_VERSION_GENERIC_FW_MGMT	"fw.mgmt"
+/* FW interface specification version */
+#define DEVLINK_INFO_VERSION_GENERIC_FW_MGMT_API	"fw.mgmt.api"
 /* Data path microcode controlling high-speed packet processing */
 #define DEVLINK_INFO_VERSION_GENERIC_FW_APP	"fw.app"
 /* UNDI software version */
-- 
1.8.3.1

