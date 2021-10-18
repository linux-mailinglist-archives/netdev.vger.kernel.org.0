Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7350643127D
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 10:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbhJRIya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 04:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhJRIya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 04:54:30 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F8BC06161C;
        Mon, 18 Oct 2021 01:52:13 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id v8so10057561pfu.11;
        Mon, 18 Oct 2021 01:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aX1q/AvHGc/Ra4hlspkIptp953jBTj0mEFehIhWjIL0=;
        b=mv95BUttY3Twdp8VdBJeJahB8S4PuvrKVHCyt4C9mk3dbVx3vIWWGpGIRA+6vOUWYe
         32G8gtooP1UZQFemNm+NPC/BAGUED96odO+GE8uSz7loWSNYCqQgcQPK51+zhCbqmIR7
         Qunj2Nu5AMJ31868ndoUit1HS+SnAqAVWnxf8o9Gzz1AvvnVqTFM6wfssEiVvLeQGd3j
         R8b6OSnfo9TSa328tGUv9b7UhB79mkT0O26BkZeFhj8mN//pxoBVTJxXG908z8uBEn6I
         mU1rjdevv8oHajf/Rw+kVhCbduPHcGj1zJ8wdusrIYGPugLZlZjdCveR9T2AzJ2ole5v
         3AWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aX1q/AvHGc/Ra4hlspkIptp953jBTj0mEFehIhWjIL0=;
        b=EYNVOVY593Y40G9E+lGwUp1xwfg1WrQUtCeBtpCPYws9fKlbQPBuSbphfmMopG/6Od
         pYCAEtmw5I1oP75OPHx/hOVvLmmMpbtDeCtmuqebdTbgX8z/Ix8ZWrVyZRshIeTrAyFh
         ekZyiAuwS/fHvLZ9h3s5xuHM/Z4QH9YbYx0IC5RNEsitwZgOSIq77aAV34LO9k+B9o3i
         iwUmtnenPGxCmitS+uR2UWvLyUhD+rPWM9ZOqDVJzPaqelOtp9zGr0RvhU1VZ+1gOnKR
         Vd2KNHMbJWnJ8yu+uqlg5Sg+gHi9iBU4nq2wq/ZdVeZdMZCnbarn3Udla5SDVIhrAaVE
         7sjQ==
X-Gm-Message-State: AOAM533cpyLjB2G0C5yeqMtM8YHOMkC8D4qnXidISd7+HtXT3oUHf/Rj
        7ZbvJzyq/rd0PgiS8BAZg/+T9SBbmFU=
X-Google-Smtp-Source: ABdhPJyhQ7NMuZyr34/zlZTEzOCiI+/4eJIRggsI208CsRGSQnd1yr99LMHGCLzpTEjcjRT2pgUNPA==
X-Received: by 2002:a63:955b:: with SMTP id t27mr14014269pgn.391.1634547133191;
        Mon, 18 Oct 2021 01:52:13 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id h4sm12173838pgn.6.2021.10.18.01.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 01:52:12 -0700 (PDT)
From:   luo penghao <cgel.zte@gmail.com>
X-Google-Original-From: luo penghao <luo.penghao@zte.com.cn>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] e1000e: Remove redundant statement
Date:   Mon, 18 Oct 2021 08:51:54 +0000
Message-Id: <20211018085154.853744-1-luo.penghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This assignment statement is meaningless, because the statement
will execute to the tag "set_itr_now".

The clang_analyzer complains as follows:

drivers/net/ethernet/intel/e1000e/netdev.c:2552:3 warning:

Value stored to 'current_itr' is never read.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index ff8672a..21ec716 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -2549,7 +2549,6 @@ static void e1000_set_itr(struct e1000_adapter *adapter)
 
 	/* for non-gigabit speeds, just fix the interrupt rate at 4000 */
 	if (adapter->link_speed != SPEED_1000) {
-		current_itr = 0;
 		new_itr = 4000;
 		goto set_itr_now;
 	}
-- 
2.15.2


