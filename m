Return-Path: <netdev+bounces-5419-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CA7171135F
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:13:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5703A281602
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:13:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A390D23D53;
	Thu, 25 May 2023 18:11:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E6819532
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:11:14 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22EE512C
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 11:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685038272; x=1716574272;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=VIqgeqTE41QWhNjlhHHHMfj2IZeaAiOoVx9OgelY3zU=;
  b=gbq/YFq811A08zypnSXJoE3Yl7YfGmK4VbKAk5/XXEXETJlqEbL0HEXY
   zL9HS59OEqOs15X2aW99NnI2y0yzUjx7+RZl8mflhiNf1r0QztuwtkVUO
   L5qNlnRVtOc3SJKES3YlI/qmRdUOZ2tuE+797ntfrjzLAS+KCKgGMDebE
   k7nMfbNnDP3IFsMzzMSGYfT2V5PZ2sZAFjTVF8p60TjAxv47224njoKM4
   cCea3ynZADRLsiYFb25tNuBTq1IGmOYOYbvB2RE1hx/s2ZQvrGmW79yQN
   oyazeF6/Jj7dEc8f4zn0+KqgjlmjdjDbH5Z2lx6dZu9pjmpuI5PmF9/TS
   w==;
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="215499952"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 May 2023 11:11:12 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 25 May 2023 11:11:10 -0700
Received: from [10.205.21.38] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 25 May 2023 11:11:09 -0700
From: Daniel Machon <daniel.machon@microchip.com>
Date: Thu, 25 May 2023 20:10:27 +0200
Subject: [PATCH iproute2-next v2 7/8] man: dcb: add additional references
 under 'SEE ALSO'
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20230510-dcb-rewr-v2-7-9f38e688117e@microchip.com>
References: <20230510-dcb-rewr-v2-0-9f38e688117e@microchip.com>
In-Reply-To: <20230510-dcb-rewr-v2-0-9f38e688117e@microchip.com>
To: <netdev@vger.kernel.org>
CC: <dsahern@kernel.org>, <stephen@networkplumber.org>, <petrm@nvidia.com>,
	<UNGLinuxDriver@microchip.com>, <daniel.machon@microchip.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
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


