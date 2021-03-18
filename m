Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF177340ED4
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 21:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbhCRUGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 16:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232955AbhCRUGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 16:06:01 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C08BC06174A;
        Thu, 18 Mar 2021 13:06:01 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id x2so543214qkd.9;
        Thu, 18 Mar 2021 13:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2y9HfcFyxnlJ0vOuI5rVwOm7yRLf7/xC+C5q7QuSfos=;
        b=mzVdO+rrrHrcUKhDbRkJ/4B7WZN1mdcso/wZW3i2zHR83kqi96bHtamqtEc3EIzNOp
         t0dcgUZMoXfQYxSSU0NeJLe6EfUJK7DzQEmfITQg23MthIbvYRkH0oLA7lcFJOXZC+sG
         OprHBiO9rRUpM3QqJLhR6A5byfYughhPGiyFrpffBCvdIghtmGAZ9m9AApiiJP02/aIZ
         2yjMHl72jFwIGRIKxs59/ZV90YFEooZQurLfM6LqUkpy3HMZThPjxQ4amsIn20UePP/A
         30Yg+Ov+JOz7y3A3KDwfB16Ca2L2BNh4zstMknyqBwnHsLMQe2MhFHi4MNmW8lu0V56+
         J5zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2y9HfcFyxnlJ0vOuI5rVwOm7yRLf7/xC+C5q7QuSfos=;
        b=ns8+NOA4W9LFsERtWzDLk1IXu3CtaaQ3GXwG9Tj5fdQs9lpVr317nPu1G8ZZUN0dJF
         uzA1vjBVXpsr5g6ddN+hfQ3mMQbIuJIdqoKJADF1xTMBHHkhrqQ1e/FYz9FGeSSc2g5Q
         VKT7zQCiRirGpc+RMXpDOvyXepxiE7SWjjnJF0pfzcK8zlwBT3Gc6a/z9xzcbwtmx6pb
         R5stO1gndL/i/SdXUM9qZ0EpJeROk7sW9+qc+arBKXE1Td4DSGkUh+4MsmpM+HrRbjYq
         6XWFnIcHg77BzHX/jofy+ZtmuuUlV2IRdJOMVBoGeCYNuwBc5FWQ4yR1N7A8fiBvkqJt
         KSmA==
X-Gm-Message-State: AOAM531BBcnujHq4ClQ9wlQSTfnSkNbdc95KgrVB6gdsXSgpOGpJKKD3
        q6YzwMUIGtztM8kPYehhgV1HMGDnUzQffiAS
X-Google-Smtp-Source: ABdhPJw34Hv1PplPWN9eXkxYJqdI8d8GkJpAU5xQLyJvFFFOGkG7RUxokgvSkcEWHnHA4gVUv/7xmw==
X-Received: by 2002:a37:94b:: with SMTP id 72mr6169307qkj.94.1616097960661;
        Thu, 18 Mar 2021 13:06:00 -0700 (PDT)
Received: from localhost.localdomain ([37.19.198.63])
        by smtp.gmail.com with ESMTPSA id 131sm2727068qkl.74.2021.03.18.13.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 13:06:00 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, unixbhaskar@gmail.com,
        christophe.jaillet@wanadoo.fr, vaibhavgupta40@gmail.com,
        gustavoars@kernel.org, yuehaibing@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org
Subject: [PATCH V2] Fix a typo
Date:   Fri, 19 Mar 2021 01:33:42 +0530
Message-Id: <20210318200342.17084-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/serisouly/seriously/

...and the sentence construction.

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 Changes from V1:
  Mentioned changes incorporated...sentence construction.

 drivers/net/ethernet/sun/sungem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index 58f142ee78a3..9790656cf970 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -1674,8 +1674,8 @@ static void gem_init_phy(struct gem *gp)
 	if (gp->pdev->vendor == PCI_VENDOR_ID_APPLE) {
 		int i;

-		/* Those delay sucks, the HW seem to love them though, I'll
-		 * serisouly consider breaking some locks here to be able
+		/* Those delays sucks, the HW seems to love them though, I'll
+		 * seriously consider breaking some locks here to be able
 		 * to schedule instead
 		 */
 		for (i = 0; i < 3; i++) {
--
2.26.2

