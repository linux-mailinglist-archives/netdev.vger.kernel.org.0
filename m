Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A3544D3C0
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 10:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbhKKJIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 04:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbhKKJIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 04:08:54 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E8FC061766;
        Thu, 11 Nov 2021 01:06:05 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id z6so5081001pfe.7;
        Thu, 11 Nov 2021 01:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KpOAFMNjh0s5tcyNo8DYQ5ka2hkVxOnnrkGeHw7Uvhw=;
        b=duwMUDVon6KiQ1mxjDWrn2GXPxuZzSM6FJe3QD/BJ7Jk4mex4apDbkCFm7KzE8czLH
         XDsNlWuAKEhOdv3Hn1umIhJkjZiqs6rtr4b/gW+u63UbqqYYl1ljftYTaJjqMmd3VBcq
         QFWuhEVNF2WomJClYgnUbGIPpsugOv5ist2Yk+11nSZ+PQL1FWk6Bj4a4iAN1Fh+XMKj
         avtbGTvNj+pfTNz5C2Rdn4ETIQzvRh5czRjRm9wMBVA2G9YyUxiL+mn8C5kZZMyjHttD
         zhMvCEYiUgn1LznujFjC3JrRMOTLBkYcfKc5YNKo89GAl6VYggypgSNNb8EPjNUKLavG
         f/Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KpOAFMNjh0s5tcyNo8DYQ5ka2hkVxOnnrkGeHw7Uvhw=;
        b=5PZ8Xo2rPPOD8k84aZeH0zjwDNj5LTi6aUCAVOlGCSxo13bZ26NCcaXvsaCaKe3ORg
         6VU5hfeyoQI7NGWD6BK8a7SxTUHeWldD7WkGlWKJZ30y5YU2ngP8JLcitByS4hSvgwl8
         9qENflPcD6O5LqAZ6fmmO5AT4wQpA1eyEuYk4RTEthq6twHF4gVU3hxgGvVlq5TdiAST
         EVfCz0UN7nL3nza1g6ohXE7kYEazKdz8w1nvptWhowmuObhJhjWcXVS1abUlMzNU58n2
         0zf0pTh5IZyldXWyYOC3EPwQRrvgiAMQ8bHZ7FjYH8lNB0bCLNJIRHOkzLKTgBa2qdWJ
         iaww==
X-Gm-Message-State: AOAM530Ps0rwDE9lYV9EiVGLMzhPgv553ZP0OBSQFl4vpXNsQ5+EhRvR
        2hfk21pj+T0Hrzip5z9Z0ZRGe+Nkq1c=
X-Google-Smtp-Source: ABdhPJwWKerb4kjmdY19cwx0Thw11bY7zQ4ZeIflmMBVBm+EM9XX9GzD6HdCPL3iIa8LdnBHSceLlA==
X-Received: by 2002:a05:6a00:b83:b0:49f:b555:1183 with SMTP id g3-20020a056a000b8300b0049fb5551183mr5426900pfj.32.1636621565302;
        Thu, 11 Nov 2021 01:06:05 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id e187sm2197788pfe.181.2021.11.11.01.06.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 01:06:05 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: luo.penghao@zte.com.cn
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux] e1000e: Delete redundant variable definitions
Date:   Thu, 11 Nov 2021 09:05:55 +0000
Message-Id: <20211111090555.158828-1-luo.penghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: luo penghao <luo.penghao@zte.com.cn>

The local variable is not used elsewhere in the function

The clang_analyzer complains as follows:

drivers/net/ethernet/intel/e1000e/ptp.c:241:19 warning

Value stored to 'hw' during its initialization is never read

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
---
 drivers/net/ethernet/intel/e1000e/ptp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ptp.c b/drivers/net/ethernet/intel/e1000e/ptp.c
index eb5c014..e6dcac9 100644
--- a/drivers/net/ethernet/intel/e1000e/ptp.c
+++ b/drivers/net/ethernet/intel/e1000e/ptp.c
@@ -238,7 +238,6 @@ static void e1000e_systim_overflow_work(struct work_struct *work)
 {
 	struct e1000_adapter *adapter = container_of(work, struct e1000_adapter,
 						     systim_overflow_work.work);
-	struct e1000_hw *hw = &adapter->hw;
 	struct timespec64 ts;
 	u64 ns;
 
-- 
2.15.2


