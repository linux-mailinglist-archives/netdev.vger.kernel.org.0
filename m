Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D88F4840F3
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 12:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbiADLft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 06:35:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiADLfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 06:35:48 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472A3C061761;
        Tue,  4 Jan 2022 03:35:48 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id gj24so31160697pjb.0;
        Tue, 04 Jan 2022 03:35:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b5E68x2W5zpVerFC629iPQD7zlXfx3x75KC58E34nlo=;
        b=pGnWoRU4I7MjP3aaVygr0ZxBB+smZegv8VsOoJcjtxCKf8+HWcPD6dBZH/vuaQwJ3G
         +Lb3bVfWrjQFKQ71Hgf9F76WlFAeMlCaBeEIenrN8P7CFiYv3WhcymSbVZPjAAELnM48
         haIlp73+Wwqw1rk/yVWHoy0ZXcrEnezn2nYKFHcibhonfLuDumoIrlaCysluzKq9hsi7
         OlqLQAXhTxekq434W2V/zuGMsceeesoFbQZAfRqc19Y/lCbfO/KTYLFqDk9OcSGaKhOG
         agtIJvW97YoT78UwHTdcEgYUTFvhHHM3QtJ/ut1+a3Ha9S+BmEMPWnCBerl0Dqmgpf1x
         CpVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b5E68x2W5zpVerFC629iPQD7zlXfx3x75KC58E34nlo=;
        b=D1neJXaCCJY+hyObD5YjCurEnpPKz7+49PllJY1jh7VamWSab96XU3lnRREevfUYbB
         j9JvWQiPZF9VDB4naUI4K9PU5sk0vE2dRjPUC47MCEBVP4OIHUHrN1M0BOUzpKy6vtN+
         z5IFyahQ7Ini+0ZyFxYAXvJ8U5OIFMSBZOMrRWo3je/0K+ux7ZGAnF+xCxT1DbZEh5zj
         8qHu04EDASomvQMQbmjZOpLp1QGa028W+A5rWWAB3Is7JNkbsiVIFquaGH7D1r9dJwoa
         pI8lxQi7Glp2A/Tw8HhKht/xEcu/QhcCWb6SFDG4/xaNGwdu9xEG/CQiiEQYXVfqPoWG
         PV5g==
X-Gm-Message-State: AOAM5331wlFj2HU9TxUoJl+JSK922RDgzzpN7j3m5l89C3S/AUWEm9nU
        +htYVvTD0NoHu6gu+DBAVi8=
X-Google-Smtp-Source: ABdhPJzjVORuawNQaDII410rm5jd8Vs6ycSv4UGoOffayUfbc11L2LbhS0w/E0lIEQ7ekqBoobgCeg==
X-Received: by 2002:a17:903:234a:b0:148:a3e2:9f47 with SMTP id c10-20020a170903234a00b00148a3e29f47mr48921260plh.119.1641296147879;
        Tue, 04 Jan 2022 03:35:47 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id i9sm33165260pgc.27.2022.01.04.03.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 03:35:47 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     ecree.xilinx@gmail.com
Cc:     habetsm.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>, CGEL ZTE <cgel.zte@gmail.com>
Subject: [PATCH] ethernet/sfc: remove redundant rc variable
Date:   Tue,  4 Jan 2022 11:35:43 +0000
Message-Id: <20220104113543.602221-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

Return value from efx_mcdi_rpc() directly instead
of taking this in another redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
---
 drivers/net/ethernet/sfc/mcdi_port_common.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.c b/drivers/net/ethernet/sfc/mcdi_port_common.c
index c4fe3c48ac46..899cc1671004 100644
--- a/drivers/net/ethernet/sfc/mcdi_port_common.c
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.c
@@ -71,7 +71,6 @@ int efx_mcdi_set_link(struct efx_nic *efx, u32 capabilities,
 		      u32 flags, u32 loopback_mode, u32 loopback_speed)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_SET_LINK_IN_LEN);
-	int rc;
 
 	BUILD_BUG_ON(MC_CMD_SET_LINK_OUT_LEN != 0);
 
@@ -80,9 +79,8 @@ int efx_mcdi_set_link(struct efx_nic *efx, u32 capabilities,
 	MCDI_SET_DWORD(inbuf, SET_LINK_IN_LOOPBACK_MODE, loopback_mode);
 	MCDI_SET_DWORD(inbuf, SET_LINK_IN_LOOPBACK_SPEED, loopback_speed);
 
-	rc = efx_mcdi_rpc(efx, MC_CMD_SET_LINK, inbuf, sizeof(inbuf),
+	return efx_mcdi_rpc(efx, MC_CMD_SET_LINK, inbuf, sizeof(inbuf),
 			  NULL, 0, NULL);
-	return rc;
 }
 
 int efx_mcdi_loopback_modes(struct efx_nic *efx, u64 *loopback_modes)
-- 
2.25.1

