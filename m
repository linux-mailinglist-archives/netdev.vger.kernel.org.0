Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE15E34A113
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 06:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbhCZFhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 01:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbhCZFhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 01:37:12 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C66C0613AA;
        Thu, 25 Mar 2021 22:37:12 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id g8so2414686qvx.1;
        Thu, 25 Mar 2021 22:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6kyG/hi4xMzB4ONd2/d1F0KtKO1/sY3sOs1ymP76/Vs=;
        b=gLcxXXsLYIMNm7eCFHIMBWGXiOUfYZWPxTIH5wdDD1oF5ZiYT6FSUKBcIBJ+UJelZg
         hzoCxgyIHQ2C9I31cVgZxMcOPiknvX4VPHjeGBdamUbEvfG+zamRnjCozejnmjvx2C69
         B1NtkIavzq+OOv3iKl3CLSs9IghX/DdlZllzijR0fDgLx3rzdl6sIgGm3ej4y48DDAAu
         ElmwnS4udqoXdFZqgcIw3UcotzAH5Nuh9OGpovDMaABqFTffzHF7tNihlMpEvlcD6QZy
         gusGnj+QuGOdAcSrhMlUA/br8o9LamFgsyBxZuhLrc+rRqee22Xwlysz+nY1jFSJ3HXL
         WWBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6kyG/hi4xMzB4ONd2/d1F0KtKO1/sY3sOs1ymP76/Vs=;
        b=UapevZm7/fIV6vk4aXLhLR5vxckp3CmlI3X97bxH8hEsqpb94afYd4Ungp8JvjI/tI
         Vpw8n/nly5cRLTByFShpEUtG3zgg1x01EmjYH4KqddZgis6vJalBWXSm9hhro7DpvhsC
         1ck1qdIXwy00p/SX3ObfIJ12WK6jGkx7VjX+11bJXZ68/72TjH/TWu03sDisrj8B2sE7
         aL3taPfaz4chdOxZjIcpjSijgfwWaueG2FtLEJ+lX2zsXq3XIfqlCM5JbGqCd9CnyLI7
         zH8ysQzwxPD/DLENq08Ca7acnrkrr8Qn8bZlInvpRs3U0Yte9BxPoEK9/rjA+QKVp+pR
         8w3w==
X-Gm-Message-State: AOAM5306QVVAFkIj1X/DM0YLKgOSEwDSjtthKpSQ26lhp7IZDJK/apHq
        mXapl3Ka02GRwRZbKzzpTHc=
X-Google-Smtp-Source: ABdhPJwv0Fr0elnTJneHFMjLnzkyQ+3oPupNtvCxb82fI67DaeDZsYwC9xy4h2ilgNK/vVmcoxNTrg==
X-Received: by 2002:a0c:b218:: with SMTP id x24mr11560217qvd.55.1616737031541;
        Thu, 25 Mar 2021 22:37:11 -0700 (PDT)
Received: from localhost.localdomain ([37.19.198.107])
        by smtp.gmail.com with ESMTPSA id c7sm2363165qtv.48.2021.03.25.22.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 22:37:11 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, unixbhaskar@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org
Subject: [PATCH V2] fddi: skfp: Rudimentary spello fixes
Date:   Fri, 26 Mar 2021 11:04:55 +0530
Message-Id: <20210326053456.17792-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/autohorized/authorized/
s/recsource/resource/
s/measuered/measured/
s/authoriziation/authorization/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 Changes from V1:
 David said the patch didn't applied cleanly,so recreate it.
 Randy found out a glitch in changelog text, fixed it.

 drivers/net/fddi/skfp/h/smt.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/fddi/skfp/h/smt.h b/drivers/net/fddi/skfp/h/smt.h
index a0dbc0f57a55..8d104f13e2c3 100644
--- a/drivers/net/fddi/skfp/h/smt.h
+++ b/drivers/net/fddi/skfp/h/smt.h
@@ -411,7 +411,7 @@ struct smt_p_reason {
 #define SMT_RDF_ILLEGAL 0x00000005	/* read only (PMF) */
 #define SMT_RDF_NOPARAM	0x6		/* parameter not supported (PMF) */
 #define SMT_RDF_RANGE	0x8		/* out of range */
-#define SMT_RDF_AUTHOR	0x9		/* not autohorized */
+#define SMT_RDF_AUTHOR	0x9		/* not authorized */
 #define SMT_RDF_LENGTH	0x0a		/* length error */
 #define SMT_RDF_TOOLONG	0x0b		/* length error */
 #define SMT_RDF_SBA	0x0d		/* SBA denied */
@@ -450,7 +450,7 @@ struct smt_p_version {

 struct smt_p_0015 {
 	struct smt_para	para ;		/* generic parameter header */
-	u_int		res_type ;	/* recsource type */
+	u_int		res_type ;	/* resource type */
 } ;

 #define	SYNC_BW		0x00000001L	/* Synchronous Bandwidth */
@@ -489,7 +489,7 @@ struct smt_p_0017 {
 struct smt_p_0018 {
 	struct smt_para	para ;		/* generic parameter header */
 	int		sba_ov_req ;	/* total sync bandwidth req for overhead*/
-} ;					/* measuered in bytes per T_Neg */
+} ;					/* measured in bytes per T_Neg */

 /*
  * P19 : SBA Allocation Address
@@ -562,7 +562,7 @@ struct smt_p_fsc {
 #define FSC_TYPE2	2		/* Special A/C indicator forwarding */

 /*
- * P00 21 : user defined authoriziation (see pmf.c)
+ * P00 21 : user defined authorization (see pmf.c)
  */
 #define SMT_P_AUTHOR	0x0021

--
2.26.2

