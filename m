Return-Path: <netdev+bounces-4401-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8EB770C574
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 20:43:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C72B2810D0
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 18:43:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED347171A9;
	Mon, 22 May 2023 18:41:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E121C171D1
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 18:41:42 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E6A10C
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 11:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684780900; x=1716316900;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=VIqgeqTE41QWhNjlhHHHMfj2IZeaAiOoVx9OgelY3zU=;
  b=FasEsJVJBhMzvpweo87JHh46Nzfx5A8Ht2ziKhA80YFP42gTMilbT5/1
   gRej3WS1mWQ/los707NoCf561p8X9k2lOWJtlD2OFNZAje2fmGVh5/B+k
   duVI+swZCdYH4N0unrbVV6MoHlK02BueLIfKcncL8VnP08H+SB683IDXe
   8CCiJrCnIpSEyOYACmDZB53WUj5U51N9A+taxrjET2Djgl9HG+kqYvdP9
   A8lJFMmJWSkE0Xz+K+ez8US7CER1+Nzn+01+FWzIfI/1qdLMlUIGnjgTJ
   QQ4qu3HoFi5E+oL/UP27ZQJxRZ0VcbGeMfvOFEotIAiEbmWeWIcwB75/V
   w==;
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="214969742"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 May 2023 11:41:40 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 22 May 2023 11:41:38 -0700
Received: from [10.205.21.38] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 22 May 2023 11:41:36 -0700
From: Daniel Machon <daniel.machon@microchip.com>
Date: Mon, 22 May 2023 20:41:11 +0200
Subject: [PATCH iproute2-next 8/9] man: dcb: add additional references
 under 'SEE ALSO'
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20230510-dcb-rewr-v1-8-83adc1f93356@microchip.com>
References: <20230510-dcb-rewr-v1-0-83adc1f93356@microchip.com>
In-Reply-To: <20230510-dcb-rewr-v1-0-83adc1f93356@microchip.com>
To: <netdev@vger.kernel.org>
CC: <dsahern@kernel.org>, <stephen@networkplumber.org>, <petrm@nvidia.com>,
	<UNGLinuxDriver@microchip.com>, <daniel.machon@microchip.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add dcb-apptrust and dcb-rewr to the 'SEE ALSO' section of the dcb
manpage.

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


