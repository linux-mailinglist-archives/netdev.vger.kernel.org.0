Return-Path: <netdev+bounces-8312-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 29E7C7238E8
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:24:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 911E21C20E9E
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:24:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9F41290E4;
	Tue,  6 Jun 2023 07:20:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE05290E0
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:20:37 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C588E53
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 00:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686036027; x=1717572027;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=mtr0h9VSvF+WISdT9y1UHZ72141SUkMcfTrhzE1QMIg=;
  b=wIDrUNjLzOW37TIyVi/PaHzmFAkEnsHQ01NZvomXOMlr5c071/nz0Spp
   EPChjzToCIb1f6jNCHCfOaU0J0SXsGBOT8qHmYOaiokJhrqquglXHLtr+
   sjIskx/EGb+ULUAs6MZgE+cJObh7zvIuvol6dVBVLHarqXQ3FYNO9Rqkq
   WGqr02TGljMGrcm7uPq+1kK/3SDW+EcBQE1JwbuvGHQLFcuczRDyZIFs9
   PX7y2gPhy/pAN5Zh/OV04YB/2Lv2TxoU14UnmIAvBUKqmBLAM3dUuEXZt
   dfmQ3j43uK3T++JxksLSL+abuyXBQzQchbYuTT4Ou/S+Z5rz4Hlia+Kyq
   g==;
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="155720539"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jun 2023 00:20:26 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 6 Jun 2023 00:20:25 -0700
Received: from [10.205.21.38] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 6 Jun 2023 00:20:24 -0700
From: Daniel Machon <daniel.machon@microchip.com>
Date: Tue, 6 Jun 2023 09:19:46 +0200
Subject: [PATCH iproute2-next v3 11/12] man: dcb: add additional references
 under 'SEE ALSO'
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20230510-dcb-rewr-v3-11-60a766f72e61@microchip.com>
References: <20230510-dcb-rewr-v3-0-60a766f72e61@microchip.com>
In-Reply-To: <20230510-dcb-rewr-v3-0-60a766f72e61@microchip.com>
To: <netdev@vger.kernel.org>
CC: <dsahern@kernel.org>, <stephen@networkplumber.org>, <petrm@nvidia.com>,
	<UNGLinuxDriver@microchip.com>, <daniel.machon@microchip.com>, Petr Machata
	<me@pmachata.org>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add dcb-apptrust and dcb-rewr to the 'SEE ALSO' section of the dcb
manpage.

Reviewed-by: Petr Machata <me@pmachata.org>
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 man/man8/dcb.8 | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/man/man8/dcb.8 b/man/man8/dcb.8
index 24944b73816b..a1d6505e93b4 100644
--- a/man/man8/dcb.8
+++ b/man/man8/dcb.8
@@ -140,10 +140,12 @@ Exit status is 0 if command was successful or a positive integer upon failure.
 
 .SH SEE ALSO
 .BR dcb-app (8),
+.BR dcb-apptrust (8),
 .BR dcb-buffer (8),
 .BR dcb-ets (8),
 .BR dcb-maxrate (8),
-.BR dcb-pfc (8)
+.BR dcb-pfc (8),
+.BR dcb-rewr (8)
 .br
 
 .SH REPORTING BUGS

-- 
2.34.1


