Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4E83FC2B9
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 08:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbhHaGZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 02:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbhHaGZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 02:25:34 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72719C061575;
        Mon, 30 Aug 2021 23:24:39 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id c6so837145pjv.1;
        Mon, 30 Aug 2021 23:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sj6jAE8z2I5y47qYO4qFv6Ruox2LdAIrHUhiT++ikm4=;
        b=s8Zrf78dcjdFv3hci9c/uqAlSVFsFuBzOxyHG0zKit21DBphcGWvdXtg8beDzyb5gp
         4QtNGwOROoE3DadIiVc7s3Y6TVfe+od0OnOuG/0Jitake7KGVbGF7gxvRekGhKwhKv+E
         vNUvI4+UWASDHVpxDQ2TA5Yx6w0YFF5l9gESyjiLBav/QffYU95eshlrIgMkoUM3Bpme
         YyWo+UQg6KDpWj9xP3hXKD+myuzxO+qycNycwMvFumHcolHZImO+7uX2QUekqfse47pe
         PqNl0lSZDmRvi8cSfkzHEH1tILiZ9ucYcUhURav2rvneiQC6SMTJnLfunIRa9QUoBQk9
         XX/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sj6jAE8z2I5y47qYO4qFv6Ruox2LdAIrHUhiT++ikm4=;
        b=iGG1ITAtuT1jBWlx8NsHolM8R+c+Ny79kghQc0PB4pXeICuAJvvwWd/iZVcPRySveq
         55GS6saxxqeSuDc4KhQku+vWGoEmRhQfovY7jRADUkmQMHc8SWZ2j7SbW+WSEdUWhCdx
         1jk3a7C1RikFgpRN2T/ggIqIycgeH0YGdLbtwQmHm+RlZkZie1gIye+Vh+48KAKtAq77
         Y2oWZO+Jf415ompra3f9Np7xJlaQQg2FJnnUVSbw9bw7K2tIQVo0Pt8Q6BtFdf7z7cYn
         13EzcIpMCB9W/mJanSJqDFxQ3A42+D9VeVuk3zBwQ4EcwrqgI7+2IiZUyUY4/txMuE9E
         CxKQ==
X-Gm-Message-State: AOAM533AzLNyp5N0ifK4ZB1DLz9zrumRRcP3cxnmtg/edYJz73yaSBii
        czeLxKWpz0uX1V/lY+0TKco=
X-Google-Smtp-Source: ABdhPJxbfOiRrt6366HpAMk/MuSv4bgCbU7WBtfmkaifBi19s+87lOdLNrMkJH7euV8ZqXFkoYCtDg==
X-Received: by 2002:a17:902:b48b:b029:12c:59b:dc44 with SMTP id y11-20020a170902b48bb029012c059bdc44mr3183701plr.47.1630391078988;
        Mon, 30 Aug 2021 23:24:38 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id n22sm16585841pff.57.2021.08.30.23.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 23:24:38 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     rajur@chelsio.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chi Minghao <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] cxgb4: remove unneeded variable
Date:   Mon, 30 Aug 2021 23:22:54 -0700
Message-Id: <20210831062255.13113-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chi Minghao <chi.minghao@zte.com.cn>

Fix the following coccicheck REVIEW:
./drivers/net/ethernet/chelsio/cxgb4/t4_hw.c:3266:5-8 REVIEW Unneeded
variable

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Chi Minghao <chi.minghao@zte.com.cn>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 5e8ac42ac6ab..c986a414414b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -3263,8 +3263,6 @@ int t4_get_scfg_version(struct adapter *adapter, u32 *vers)
  */
 int t4_get_version_info(struct adapter *adapter)
 {
-	int ret = 0;
-
 	#define FIRST_RET(__getvinfo) \
 	do { \
 		int __ret = __getvinfo; \
@@ -3280,7 +3278,7 @@ int t4_get_version_info(struct adapter *adapter)
 	FIRST_RET(t4_get_vpd_version(adapter, &adapter->params.vpd_vers));
 
 	#undef FIRST_RET
-	return ret;
+	return 0;
 }
 
 /**
-- 
2.25.1

