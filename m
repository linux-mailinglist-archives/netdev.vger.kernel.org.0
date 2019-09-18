Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C862B642C
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 15:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729812AbfIRNRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 09:17:06 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43315 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbfIRNRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 09:17:05 -0400
Received: by mail-pf1-f193.google.com with SMTP id a2so4446370pfo.10
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 06:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=bheKpMhi6WMtyBjNwbfCg8EdkhQNlJmf+07VFEf1QwQ=;
        b=TSP1ZwdhcEdxitzLsrYK71aOMFSd5nqd7fuEGDgiR87Gl+avQkjl4dxAcwaLB4MbWS
         nU6HPk0ZB7kgSQ4vaI0yp21jFztXCSPUhefw80XFmAUdBcodXQ3WrqO2gpltcNM6v1WQ
         y4FOhIDCEAmYO+PwSrYXug2OK/3fCbiOZRelQbxKV3OmuNsmf9uZP49FO3ksHZxpwKuv
         J23ZvbERZTDsH7Gzg9LVPiffnppb6TSp5rDxEehl1bg/8MQ4fcb5Itf9GQVUhRRpWxMh
         gFoXAwdmVQ01BdOk3goZWYCbBZ05Pph2IPhusMm3ANzLAzD7IgGq+6vpk1nfHrw6ItOy
         3Xmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bheKpMhi6WMtyBjNwbfCg8EdkhQNlJmf+07VFEf1QwQ=;
        b=rkTwBOX0oaDKvC9NWZN6LRWVd0v/aKsUgqbzvtPLZatCTrMqGLQRtEgTgfzN1LloxN
         PiqzOJH8CwTAxcWOgqoaY7hj+++Ed0X6OGr9Vs7YTxQv5G/1OVMEiEWHgRhGstPvWHmR
         QADi15Jxh3g6EperBQ+bj4tojQA3zM5uR7y/TultTjnS9S/lWBk16Dh1FLpIW2NOh3N6
         g4yLpJC6LymZCGLXVqUTYr0gksCHAngvGScWcAiu6rBYEUQfoE919OXqTCJNP+ykZPVt
         IZBcs2q8xTQrDeBI1dt0wt3wrBDPYCBgZvXHdG+i9G3ibTwGJGuNqtK4EsKU80GDmOR+
         jLwQ==
X-Gm-Message-State: APjAAAXRublyCprNU1qQjNqdMt8Yhs39wQ7UXwmXkKLhUMYDHR+yWJnf
        2owssNWAsXYC9wmNClIvRdE=
X-Google-Smtp-Source: APXvYqyZrDao4r5FKof4oYHwX/mjM7CuL9d81Rgp4TOZtDtAuJ/rwYo1rqOlc910UqKscEGswA1KYg==
X-Received: by 2002:a62:1d12:: with SMTP id d18mr4160274pfd.53.1568812624938;
        Wed, 18 Sep 2019 06:17:04 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1951:77d6:2136:ec81:40ab:9b7b])
        by smtp.gmail.com with ESMTPSA id u18sm4672426pge.69.2019.09.18.06.17.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 18 Sep 2019 06:17:04 -0700 (PDT)
From:   Aliasgar Surti <aliasgar.surti500@gmail.com>
X-Google-Original-From: Aliasgar Surti
To:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org
Cc:     Aliasgar Surti <aliasgar.surti500@gmail.com>
Subject: [PATCH] drivers:staging:qlge: Removed unnecessary variable
Date:   Wed, 18 Sep 2019 18:46:36 +0530
Message-Id: <1568812596-25926-1-git-send-email-aliasgar.surti500@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aliasgar Surti <aliasgar.surti500@gmail.com>

coccicheck reported warning for unnecessary variable used.
This patch fixes the same by removing the variable and
returning value directly.

Signed-off-by: Aliasgar Surti <aliasgar.surti500@gmail.com>
---
 drivers/staging/qlge/qlge_dbg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 31389ab..5599525 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -389,7 +389,6 @@ static int ql_get_xgmac_regs(struct ql_adapter *qdev, u32 *buf,
 
 static int ql_get_ets_regs(struct ql_adapter *qdev, u32 *buf)
 {
-	int status = 0;
 	int i;
 
 	for (i = 0; i < 8; i++, buf++) {
@@ -402,7 +401,7 @@ static int ql_get_ets_regs(struct ql_adapter *qdev, u32 *buf)
 		*buf = ql_read32(qdev, CNA_ETS);
 	}
 
-	return status;
+	return 0;
 }
 
 static void ql_get_intr_states(struct ql_adapter *qdev, u32 *buf)
-- 
2.7.4

