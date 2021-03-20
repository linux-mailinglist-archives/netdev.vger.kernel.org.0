Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF04342E11
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 16:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbhCTP5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 11:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbhCTP5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 11:57:16 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51690C061763
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 08:57:15 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id v3so10864976ilj.12
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 08:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dqBAhnvQZBZS9R5OnlTX21fRiOb56RVD97okeY10dMw=;
        b=goyrhVJuCTasQ8dNYdkm58sZiQT3GQITChYTvN2McOENcEIZeBs2mFwXWOT6yvhC/T
         C5FOfj2aOGJKVVmmycTNgkjkfDMI5lrB5TWCZatHmQ0NiC4a8+kpIv7TkwdFG9qtN3PD
         R8PCjmz5wvp9PmF/hbdLZv3HDqXo+HBrnaRWTj2FrelpFY6x22QT3c894GgwuXAwN0ZL
         cL/+aUWAf6EwKbMcVL2hpqP+IlSkokRvaCHMH07AIGPYjnoow2GFonCR1yN0EIVnQPta
         03kDdf7H8/R9onwvMrczwzUuTvJ2xLMY7nKq+KdenEta5g3mAJKO2GY3q5Yg67SfwX5L
         IQ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dqBAhnvQZBZS9R5OnlTX21fRiOb56RVD97okeY10dMw=;
        b=iheraDKy+4ohZ17svUwD8Jz8TK7Komuy3auyXc+cMedlL67HfrxpN4G8AZ+2sv2r2T
         UvDxf/neYN9VM5SlzOmPDGH/jdoITA7b5BoS4zNWkC9zMKPSg92mFYv5pyHeTB+bPa4G
         oYZVjLx4a/Ft2m3shPXObbf4MisTLFOXr3fEPSg78asoM5Yy9+nsjx5coMpSZHRKz0Qu
         EJDfbmd80YVm1nEoztl6bbkC0Ns1mk2vLo8hG7a2G30zbP3ypX2EHcypkKqGuDB3fA+u
         q5U+ivAs8gNjTdFRJgbNrLc1VWq7tf0Uo+06emqgyfV6EbhmxjHFYoK8cbmBgwHP8Rok
         CnbA==
X-Gm-Message-State: AOAM531YzEQ/cdS3zCytEvYOj2nmpJVBSiigVF2mpdawvc8SQls63xFp
        ahP5McsF6iQqcwl3DndCLzmrCQ==
X-Google-Smtp-Source: ABdhPJwwVix7RL6+20UUgmsWf1UcterDbeGl+FlROZ7Yn+dlv7c89I6e877wj8NeNbwsstmt3MyZ+A==
X-Received: by 2002:a92:cccb:: with SMTP id u11mr6323434ilq.44.1616255834829;
        Sat, 20 Mar 2021 08:57:14 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id n16sm4501698ilq.71.2021.03.20.08.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 08:57:14 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/5] net: ipa: update some comments in "ipa_data.h"
Date:   Sat, 20 Mar 2021 10:57:07 -0500
Message-Id: <20210320155707.2009962-6-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210320155707.2009962-1-elder@linaro.org>
References: <20210320155707.2009962-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix/expand some comments in "ipa_data.h".

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data.h | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index caf9b3f9577eb..7816583fc14aa 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -18,8 +18,9 @@
  * Boot-time configuration data is used to define the configuration of the
  * IPA and GSI resources to use for a given platform.  This data is supplied
  * via the Device Tree match table, associated with a particular compatible
- * string.  The data defines information about resources, endpoints, and
- * channels.
+ * string.  The data defines information about how resources, endpoints and
+ * channels, memory, clocking and so on are allocated and used for the
+ * platform.
  *
  * Resources are data structures used internally by the IPA hardware.  The
  * configuration data defines the number (or limits of the number) of various
@@ -75,10 +76,10 @@ struct ipa_qsb_data {
  *
  * A GSI channel is a unidirectional means of transferring data to or
  * from (and through) the IPA.  A GSI channel has a ring buffer made
- * up of "transfer elements" (TREs) that specify individual data transfers
- * or IPA immediate commands.  TREs are filled by the AP, and control
- * is passed to IPA hardware by writing the last written element
- * into a doorbell register.
+ * up of "transfer ring elements" (TREs) that specify individual data
+ * transfers or IPA immediate commands.  TREs are filled by the AP,
+ * and control is passed to IPA hardware by writing the last written
+ * element into a doorbell register.
  *
  * When data transfer commands have completed the GSI generates an
  * event (a structure of data) and optionally signals the AP with
@@ -264,7 +265,7 @@ struct ipa_resource_data {
  * @imem_addr:		physical address of IPA region within IMEM
  * @imem_size:		size in bytes of IPA IMEM region
  * @smem_id:		item identifier for IPA region within SMEM memory
- * @imem_size:		size in bytes of the IPA SMEM region
+ * @smem_size:		size in bytes of the IPA SMEM region
  */
 struct ipa_mem_data {
 	u32 local_count;
@@ -307,14 +308,14 @@ struct ipa_clock_data {
  * @endpoint_count:	number of entries in the endpoint_data array
  * @endpoint_data:	IPA endpoint/GSI channel data
  * @resource_data:	IPA resource configuration data
- * @mem_count:		number of entries in the mem_data array
- * @mem_data:		IPA-local shared memory region data
+ * @mem_data:		IPA memory region data
+ * @clock_data:		IPA clock and interconnect data
  */
 struct ipa_data {
 	enum ipa_version version;
-	u32 qsb_count;		/* # entries in qsb_data[] */
+	u32 qsb_count;		/* number of entries in qsb_data[] */
 	const struct ipa_qsb_data *qsb_data;
-	u32 endpoint_count;	/* # entries in endpoint_data[] */
+	u32 endpoint_count;	/* number of entries in endpoint_data[] */
 	const struct ipa_gsi_endpoint_data *endpoint_data;
 	const struct ipa_resource_data *resource_data;
 	const struct ipa_mem_data *mem_data;
-- 
2.27.0

