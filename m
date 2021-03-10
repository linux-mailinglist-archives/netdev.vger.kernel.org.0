Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A75334C03
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 23:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbhCJWyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 17:54:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233992AbhCJWyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 17:54:02 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92953C061574;
        Wed, 10 Mar 2021 14:54:01 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id p8so42101104ejb.10;
        Wed, 10 Mar 2021 14:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4uV+qg2CjOKVdh2/NJUj9nvCWYeZPYQ96C2PXBxbl7A=;
        b=hUZp8t8t4c8cx4X1d6YapLxX7wrGUJ5nyldG5IBa8ucjiqNvwVngHLfWeZZ+YDigff
         d1+mpmV2/7BWX0g2m5UrrFRQweWoqSSXvz4NKDHUNbw8xyADpUtbeC5yuT8FrgXm1q4i
         uSdE+oDyhaV+aaCmwzs4+mSVWp3GwUVfhxF9DGjZL0yokg7QmRFloZj0ksFxS5FGhwPn
         OkMtv5p/44fPDlfjokVnNnCSWjvIB2lK7CDw8gZn4aeOhHAJfjtvFyGw2ul7e03vn7tB
         aaQhZq6X5FAsX7N3IgANG7YgkQEJe7cnxeTS6qHXFArjpbp8vLTv52w70l5pi2OY/EcQ
         NlTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4uV+qg2CjOKVdh2/NJUj9nvCWYeZPYQ96C2PXBxbl7A=;
        b=IEqLUkraYEH+AqCgoO/XOaiMsVE1d0wwZwYe99+Z++e6G41sjaBDkQMNm7JbXGnE+F
         HajQjobp9UcNKQY/5StFd/YDqOIILyWEIQDdGK03fsJT0lJXE3brUrtD0hG1u+GFHA8C
         fPxVm+9lXh/Qi0+5+fjyPwuGS6/h4aqOLprOWO8RR3rXlS9Fe7zi+7WIiTZqBL5FUrjM
         KqFEGlkBuPkEwSZs86ep2AwxfGWG8XrYH1ny2HLqvzev3YxotvwfxmxSRnP/yoLCq+ix
         n92+XDKc2MsPfB8gEUd42tN+V6LRMAH6ayqROdWOcjy3PYl2T/28/M1e2tuRWH/Yq66s
         jgPA==
X-Gm-Message-State: AOAM5329CZWY+ahrRtXYQZNbvPZfRIKteY0Y34kAnVT2DNvZKBUtc3lM
        7PE+yKDD9X/ACf3i0Bc5rLc=
X-Google-Smtp-Source: ABdhPJyaAnTp7x7iKvjJZApEFOzaSp/DCzIsyv9o/+hc9ww1iAAg2jboxcriTikoI+YBzUbtdozUZg==
X-Received: by 2002:a17:906:5689:: with SMTP id am9mr188173ejc.298.1615416840346;
        Wed, 10 Mar 2021 14:54:00 -0800 (PST)
Received: from localhost.localdomain ([37.19.198.80])
        by smtp.gmail.com with ESMTPSA id z17sm403447eju.27.2021.03.10.14.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:53:59 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, unixbhaskar@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org
Subject: [PATCH] net: fddi: skfp: Mundane typo fixes throughout the file smt.h
Date:   Thu, 11 Mar 2021 04:21:23 +0530
Message-Id: <20210310225123.4676-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Few spelling fixes throughout the file.

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
2.26.2

