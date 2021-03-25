Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0963489D8
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 08:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbhCYHJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 03:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhCYHIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 03:08:45 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23FFC06174A;
        Thu, 25 Mar 2021 00:08:44 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id i9so856831qka.2;
        Thu, 25 Mar 2021 00:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fAaFyGmcLp/6mN6SbzcCVOr5euR0ZFtFGN0hhuRKlK4=;
        b=bpGBlCIgmy+04lV1TeMp4a/L4t1ONubZta2ECn7fWMa7X4OHY91OUXQn3YUh8yS/TH
         xKIAzsPrBCS/ZrF/wr17lmcWmOea1hKTGvuMN7nGY7hTKxTrbSkIxodZlw3KyjwIRk6H
         TniGcnaZhWdMnvnwX2wzw1giXDrfgusjIZRnnRLAb1i9BFoI2/dWANdR4sKFQ7Gg1lvN
         BON/ISAyr31KpSKBBFyMrrcLC4qrc2t5X5ZWI/Hvmod4oskUj1MpJuN8MRmvfphLTLVv
         GwlB/uI2eWluAKctGGmC2X43sjjNSWGYwzsZ9yBFLElYuDw2DJRGpjanPgm4+mwNBqQr
         iafw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fAaFyGmcLp/6mN6SbzcCVOr5euR0ZFtFGN0hhuRKlK4=;
        b=Gn2FkmdnbqrsrSoslCTZr+ZSOpPCtjc5NI4aUvvAF6iC3dPtj+bIsfNgL39lTmYjck
         t9B3NwO2CFc0WODIWIOe8Pfqrod7FE9DeOxgoVVxnb9BSnmfRsvef0XBl8SjvevEDDsd
         42SoJO2SpboJg/FBbyqS541z7cG87y6v8fsKf6atV6sVQaKP0nVn8qMpWx97qPf861UI
         LNwttfgemp8TN8oHhOlsGww21xlEzpau/3W+jgrttQYEDy9KNzdIlnqCHH2KRhPMjj9e
         9/K98Z3b1U8dJV5CNyG8F0jafriQMCBiTS87YEIbX8o3fs+9TSIPScm8Cd38kqysSAPI
         LdpQ==
X-Gm-Message-State: AOAM530+2DdWY1oOtm83NItoerKreUgwAdifbGws9/xTckuA6DEFXP8H
        tyVF6N4969Ep/i6T4WOZF74=
X-Google-Smtp-Source: ABdhPJwSwWVYqgxA+X1qLW4aAuinqdxUpbBODRiMfLkfPqZpbdZicWQnpaQrF61yjfEjO9g2dc+/ig==
X-Received: by 2002:a37:a74e:: with SMTP id q75mr6683630qke.165.1616656124124;
        Thu, 25 Mar 2021 00:08:44 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.54])
        by smtp.gmail.com with ESMTPSA id 7sm3628957qkm.64.2021.03.25.00.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 00:08:43 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, unixbhaskar@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org
Subject: [PATCH] fddi: skfp: Rudimentary spello fixes
Date:   Thu, 25 Mar 2021 12:38:35 +0530
Message-Id: <20210325070835.32041-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/autohorized/authorized/
s/recsource/resource/
s/measuered/measured/
sauthoriziation/authorization/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
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
2.30.1

