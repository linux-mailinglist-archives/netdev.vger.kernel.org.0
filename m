Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3457527B79A
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgI1XNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbgI1XNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 19:13:42 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCF5C05BD12
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 16:04:54 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id u19so2929524ion.3
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 16:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vZ9KWQct8b79VV+T3ZHp62HwU/9rxwxAuHKFKCuD9EQ=;
        b=DDXAB9xCfez4AA+dSUJmDYm3LKOywC/AOuGaptQMxarCyvmOujjdrnj5NF2AWQ53BC
         L8gdzLBFAs4J5c8xQ4aI9POyyVLQGDCt5KxB9sp8BhxQ9Yz0qvfx+wA9DliGxSCJ06eG
         zdg/QXSQK+ZD4FHQs40VVoejQseCIk5GIlgNHYBus4ZWLxQTAOdDAMoA/jemVVMPrZwg
         vulPL932UbMAVN/XVgtThcJmBWk1bxOk+48HZgFVi+NtfFvb48sqke3Jr1qCtSFvk8qw
         nk+digqGMJvhdsYzXvRYUMf641bl24yLzOamtIBjHhKws8K1UFqhU4CrMR9hHtvZVtJD
         p/ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vZ9KWQct8b79VV+T3ZHp62HwU/9rxwxAuHKFKCuD9EQ=;
        b=DQfqKY/6ZSvzxqIg2G396DyDF4aUn3n3GjD5j3g/1WYGOKRv6AcrvfY/cuz4uuJjaG
         kug//SrAStJDbr2OW2FO4k97RBnvBJAY+lbos+KYHi4eH2N0MCwFUxJvEm+JSyNWTJjL
         EvPmRKxfOutITesg9VzKcoZv6vdymCFkGqqLLOuV6cTmudrR62j24EJiOU41KViYZ9qX
         4mt/SVJyXra78T98LCNluX4e9n7W59gUiQXTo01dpc7FDMbtsjaku5kyLhkHydKudj1s
         oW9hiwfyK2K6vPxNQzAVs/2plzUGOSRS+cmSEVevw7yEW4j23VTLpQ/tGPNaCGcID7BJ
         Y2mw==
X-Gm-Message-State: AOAM533becpyvc3aw6qAAdT3Sjljo1ARTq2FECQJACUcyx5mQ269B5Mr
        AhHSB9gYMcNYcarxxrlK6paf/g==
X-Google-Smtp-Source: ABdhPJynjPfUqJcqGOExpfd29WkeUqlFabElW2BpYaIXZxU7JnJ2GQ2NkNsSoBbO2LUbZqH+BHwepQ==
X-Received: by 2002:a02:8782:: with SMTP id t2mr748376jai.56.1601334294251;
        Mon, 28 Sep 2020 16:04:54 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id 137sm1009039ioc.20.2020.09.28.16.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 16:04:53 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 04/10] net: ipa: remove unused status structure field masks
Date:   Mon, 28 Sep 2020 18:04:40 -0500
Message-Id: <20200928230446.20561-5-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200928230446.20561-1-elder@linaro.org>
References: <20200928230446.20561-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of the field masks used for fields in a status structure are
unused.  Remove their definitions; we can add them back again when
we actually use them to handle arriving status messages.  These are
warned about if "W=2" is added to the build command.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index df7cd791bb408..24d688e3cd93a 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -69,36 +69,9 @@ struct ipa_status {
 };
 
 /* Field masks for struct ipa_status structure fields */
-
-#define IPA_STATUS_SRC_IDX_FMASK		GENMASK(4, 0)
-
 #define IPA_STATUS_DST_IDX_FMASK		GENMASK(4, 0)
-
-#define IPA_STATUS_FLAGS1_FLT_LOCAL_FMASK	GENMASK(0, 0)
-#define IPA_STATUS_FLAGS1_FLT_HASH_FMASK	GENMASK(1, 1)
-#define IPA_STATUS_FLAGS1_FLT_GLOBAL_FMASK	GENMASK(2, 2)
-#define IPA_STATUS_FLAGS1_FLT_RET_HDR_FMASK	GENMASK(3, 3)
-#define IPA_STATUS_FLAGS1_FLT_RULE_ID_FMASK	GENMASK(13, 4)
-#define IPA_STATUS_FLAGS1_RT_LOCAL_FMASK	GENMASK(14, 14)
-#define IPA_STATUS_FLAGS1_RT_HASH_FMASK		GENMASK(15, 15)
-#define IPA_STATUS_FLAGS1_UCP_FMASK		GENMASK(16, 16)
-#define IPA_STATUS_FLAGS1_RT_TBL_IDX_FMASK	GENMASK(21, 17)
 #define IPA_STATUS_FLAGS1_RT_RULE_ID_FMASK	GENMASK(31, 22)
 
-#define IPA_STATUS_FLAGS2_NAT_HIT_FMASK		GENMASK_ULL(0, 0)
-#define IPA_STATUS_FLAGS2_NAT_ENTRY_IDX_FMASK	GENMASK_ULL(13, 1)
-#define IPA_STATUS_FLAGS2_NAT_TYPE_FMASK	GENMASK_ULL(15, 14)
-#define IPA_STATUS_FLAGS2_TAG_INFO_FMASK	GENMASK_ULL(63, 16)
-
-#define IPA_STATUS_FLAGS3_SEQ_NUM_FMASK		GENMASK(7, 0)
-#define IPA_STATUS_FLAGS3_TOD_CTR_FMASK		GENMASK(31, 8)
-
-#define IPA_STATUS_FLAGS4_HDR_LOCAL_FMASK	GENMASK(0, 0)
-#define IPA_STATUS_FLAGS4_HDR_OFFSET_FMASK	GENMASK(10, 1)
-#define IPA_STATUS_FLAGS4_FRAG_HIT_FMASK	GENMASK(11, 11)
-#define IPA_STATUS_FLAGS4_FRAG_RULE_FMASK	GENMASK(15, 12)
-#define IPA_STATUS_FLAGS4_HW_SPECIFIC_FMASK	GENMASK(31, 16)
-
 #ifdef IPA_VALIDATE
 
 static void ipa_endpoint_validate_build(void)
-- 
2.20.1

