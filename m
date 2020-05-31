Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3731E9602
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 09:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387412AbgEaHGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 03:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387407AbgEaHGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 03:06:47 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0637EC05BD43
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 00:06:47 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id r7so8301130wro.1
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 00:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=28iXEgTxZGiycTdVsy4Tz/mI6Y6DSr8IpzNq47taE6U=;
        b=QqKi83xeAVIB3Rk4gVswD+kmoCTWZRuU7Lu6+j07fwz2M28nBhd6Hc3QTTOOonKGCT
         1VqlWuHexs8AwTWIwnKXeQQYTyhpQgalQD+5YXjuZy8LwlfJgZgTPVCf1LzAJNEVhhPI
         yvFaqJN0jt8yrhNhzfXzR0TJX1ULzmARbY1UA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=28iXEgTxZGiycTdVsy4Tz/mI6Y6DSr8IpzNq47taE6U=;
        b=St2cisqtfmjzEMz29p2RkuukRetzuGkQEQ6IA6YTs+m06JDdLF8YZSl1plbhrPENF/
         SppCKkHm2C2JqI3lixhZYcO87wWI7Y6siV7YEsgmKAXsHm6aWoPiQ7YO5zC8kJdxr8JK
         ZgKCkQV93BNBQ0xbDQ3jSWQFAFIQuXILLAgAI3rjWWCre2NN2uROgQ9M4bUp0/Y0IXW3
         BP4HH+Usfp1+Vq4pwzjuHiO7YdpmZcSWihKhHKuwKCvyGb2WNtTt7g1WLl7FR3HENIeE
         1iq29ZxW9uKt3AW0Db6cRHjhAInru1CVksaxg+OIEBui8e1LNhBobBDGqs+mXm7Kxzzc
         y1hg==
X-Gm-Message-State: AOAM5302l1gzgTl1554Za8lf8ItOX4Jqc07P9cxujcfxnI1iTjF6Nqt/
        VPmSPmQgzPFnsKg976YvPcCEVNSqBoo=
X-Google-Smtp-Source: ABdhPJwhlRVmuv0eGYBQFMy9+EyETPpK00ik/ueqcyTpRWYPuVBifVtW7eXqsTj+KG2D/6vXvwUFTQ==
X-Received: by 2002:a05:6000:1c8:: with SMTP id t8mr16214736wrx.200.1590908805631;
        Sun, 31 May 2020 00:06:45 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5sm4828731wrr.5.2020.05.31.00.06.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 31 May 2020 00:06:45 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH v3 net-next 3/6] bnxt_en: Use 'enable_live_dev_reset' devlink parameter.
Date:   Sun, 31 May 2020 12:33:42 +0530
Message-Id: <1590908625-10952-4-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When enabled, device will enable the live reset capability in
NVRAM configuration.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 Documentation/networking/devlink/bnxt.rst         | 2 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 6 ++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h | 1 +
 3 files changed, 9 insertions(+)

diff --git a/Documentation/networking/devlink/bnxt.rst b/Documentation/networking/devlink/bnxt.rst
index 3dfd84c..ae0a69d 100644
--- a/Documentation/networking/devlink/bnxt.rst
+++ b/Documentation/networking/devlink/bnxt.rst
@@ -22,6 +22,8 @@ Parameters
      - Permanent
    * - ``msix_vec_per_pf_min``
      - Permanent
+   * - ``enable_live_dev_reset``
+     - Permanent
 
 The ``bnxt`` driver also implements the following driver-specific
 parameters.
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index a812beb..3e1a4ef 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -314,6 +314,8 @@ enum bnxt_dl_param_id {
 	 NVM_OFF_MSIX_VEC_PER_PF_MIN, BNXT_NVM_SHARED_CFG, 7, 4},
 	{BNXT_DEVLINK_PARAM_ID_GRE_VER_CHECK, NVM_OFF_DIS_GRE_VER_CHECK,
 	 BNXT_NVM_SHARED_CFG, 1, 1},
+	{DEVLINK_PARAM_GENERIC_ID_ENABLE_LIVE_DEV_RESET,
+	 NVM_OFF_FW_LIVE_RESET, BNXT_NVM_SHARED_CFG, 1, 1},
 };
 
 union bnxt_nvm_data {
@@ -640,6 +642,10 @@ static int bnxt_dl_msix_validate(struct devlink *dl, u32 id,
 			     BIT(DEVLINK_PARAM_CMODE_PERMANENT),
 			     bnxt_dl_nvm_param_get, bnxt_dl_nvm_param_set,
 			     NULL),
+	DEVLINK_PARAM_GENERIC(ENABLE_LIVE_DEV_RESET,
+			      BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			      bnxt_dl_nvm_param_get, bnxt_dl_nvm_param_set,
+			      NULL),
 };
 
 static const struct devlink_param bnxt_dl_port_params[] = {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
index d5c8bd4..0c786fb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
@@ -39,6 +39,7 @@ static inline void bnxt_link_bp_to_dl(struct bnxt *bp, struct devlink *dl)
 #define NVM_OFF_DIS_GRE_VER_CHECK	171
 #define NVM_OFF_ENABLE_SRIOV		401
 #define NVM_OFF_NVM_CFG_VER		602
+#define NVM_OFF_FW_LIVE_RESET		917
 
 #define BNXT_NVM_CFG_VER_BITS		24
 #define BNXT_NVM_CFG_VER_BYTES		4
-- 
1.8.3.1

