Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2053DA9DE
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 19:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbhG2RR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 13:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbhG2RRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 13:17:54 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE43C0613CF;
        Thu, 29 Jul 2021 10:17:50 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id v21so11978173ejg.1;
        Thu, 29 Jul 2021 10:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JB/DoU40ESIrOFunQUsIHRQomgO4Ed+VenLxH4GaIlQ=;
        b=aGeoblt3mr847LkaX2TBzh4UKBId8SraCEEhmyIF5KyurX18SknN841B+3WmPA0/pY
         l0ZlWyMCpxWByYUnsaTRDYJtAMiEV3jfpVJY+c3ROVuhXi+krpPdD1kh9mQIttMMQAFS
         qSNxEh2ky7hn4bZcQqxvYctBll40f+qbK3x8Hq0GRi/UQ8Wul45mKcz5qDhhziMJUxDp
         RJ4JC8o2cQ5OQp+DvAy/SC0RmwQAdFKsdX0dc/ROCfT5QSxxSowYVFR9M2XDEZu+4khA
         t5ZtSOwWMramUZMtjDDTkoAg9zl9US8RDN+kI1zfceDkNfgNEv6d1JAgM61zIeDeQNJc
         Gr+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JB/DoU40ESIrOFunQUsIHRQomgO4Ed+VenLxH4GaIlQ=;
        b=e5LtNKaxlvgQn1PKM5gtbQ0WQGNi/PRWnhXJQKfeSyeFIRA54eacND34DS0OLBT3On
         /fDya+x5M0BiCsncOGPWrISN8EWllZTJk0WpgOYi7QL7l/qoY21Y2DdVK1frRI2a5sYp
         emL7vXNpOUf+h/tJRveqxNhR0ixVmxdDN9geOm68j6fD+rsGthzdtOJqp14rv2aPJI8I
         dV+dMPOO5zxXaBGrPsa0ZpkE5ZO4G6NBqOEaN7TCY9jGJQ1UXwgIMJ7kQW2MJDINvmEq
         t6BLpYcK7rIbcq2L56Z4C7Wp9TmclkcCpGWw/gPK73vdFvk5OSNIS9YehXk+nxgJlhEZ
         2+nA==
X-Gm-Message-State: AOAM530i85aIN7G+4KLtUorkHtafm2GVEBJmWvkD22q7b4kBoWeXcFYM
        4G/GxJLfOGDCLyt4CttxbTECwfGuqao=
X-Google-Smtp-Source: ABdhPJzm8eQJQJwudq+qp/9n4Er1hPckOu53uFqtmke16WsQ1CkGybc9k8p3bpMtOWv09C/B/2Ll0A==
X-Received: by 2002:a17:906:b34c:: with SMTP id cd12mr5694992ejb.104.1627579068573;
        Thu, 29 Jul 2021 10:17:48 -0700 (PDT)
Received: from yoga-910.localhost ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id df14sm1451612edb.90.2021.07.29.10.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 10:17:48 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     corbet@lwn.net, netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 1/9] dpaa2-switch: rename dpaa2_switch_tc_parse_action to specify the ACL
Date:   Thu, 29 Jul 2021 20:18:53 +0300
Message-Id: <20210729171901.3211729-2-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729171901.3211729-1-ciorneiioana@gmail.com>
References: <20210729171901.3211729-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Until now, the dpaa2_switch_tc_parse_action() function was used for all
the supported tc actions since all of them were implemented by adding
ACL table entries. In the next commits, the dpaa2-switch driver will
gain mirroring support which is not using the same HW feature.

Make sure that we specify the ACL in the function name so that we make
it clear that it's only used for specific actions.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../freescale/dpaa2/dpaa2-switch-flower.c        | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
index f9451ec5f2cb..639efb3edeec 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
@@ -339,10 +339,10 @@ dpaa2_switch_acl_tbl_remove_entry(struct dpaa2_switch_acl_tbl *acl_tbl,
 	return 0;
 }
 
-static int dpaa2_switch_tc_parse_action(struct ethsw_core *ethsw,
-					struct flow_action_entry *cls_act,
-					struct dpsw_acl_result *dpsw_act,
-					struct netlink_ext_ack *extack)
+static int dpaa2_switch_tc_parse_action_acl(struct ethsw_core *ethsw,
+					    struct flow_action_entry *cls_act,
+					    struct dpsw_acl_result *dpsw_act,
+					    struct netlink_ext_ack *extack)
 {
 	int err = 0;
 
@@ -403,8 +403,8 @@ int dpaa2_switch_cls_flower_replace(struct dpaa2_switch_acl_tbl *acl_tbl,
 		goto free_acl_entry;
 
 	act = &rule->action.entries[0];
-	err = dpaa2_switch_tc_parse_action(ethsw, act,
-					   &acl_entry->cfg.result, extack);
+	err = dpaa2_switch_tc_parse_action_acl(ethsw, act,
+					       &acl_entry->cfg.result, extack);
 	if (err)
 		goto free_acl_entry;
 
@@ -459,8 +459,8 @@ int dpaa2_switch_cls_matchall_replace(struct dpaa2_switch_acl_tbl *acl_tbl,
 		return -ENOMEM;
 
 	act = &cls->rule->action.entries[0];
-	err = dpaa2_switch_tc_parse_action(ethsw, act,
-					   &acl_entry->cfg.result, extack);
+	err = dpaa2_switch_tc_parse_action_acl(ethsw, act,
+					       &acl_entry->cfg.result, extack);
 	if (err)
 		goto free_acl_entry;
 
-- 
2.31.1

