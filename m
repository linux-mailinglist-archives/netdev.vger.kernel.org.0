Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C912FFA8E
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 03:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbhAVCjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 21:39:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbhAVCfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 21:35:32 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD98C0617A9
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 18:34:12 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id l23so686648qtq.13
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 18:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1kDimXzA9M9PWHfsqDnWeDFT1MG/Xxfjg/ovLBDA4+c=;
        b=qAj/VV4Lrl8K+W4pjf254aWoi5EfYLj0YKA6oao5JlTjig5hlRgAI2cGjPgWmqZgFY
         LFeSMCW+sd90dt/vsqN8J++wdLKvW7dEkBPw6mQmxoUPBHQNIVZAn6Fw27r4t4yIxQNe
         RSjZfk5rT+Aj3cKCsYQbizUo9e46Hti2LqTGvOq9Ua91pCCzkPZ/llHTwO37yEaUWuNF
         RBKzqmWDC1Nz1J5r/ma2c3wleiy1wQUFC/DE4c6NXiBW+5G2xw8/o/XoX2GssNUW/Hz8
         DdAHRUUCb1Hwin50B48SQnzhiABzUG+RCKgxf8KCugYYs3d+uJMZKLNzBlaGaSju+SRR
         sX0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1kDimXzA9M9PWHfsqDnWeDFT1MG/Xxfjg/ovLBDA4+c=;
        b=LeJnvyG7/MsMEUTnohtWWakgsTpDk2AjBwmwa4DF9VmfBz27pU2bCAq6prSpKkEVwl
         xOEvM/p9mLikTq+IFGBDFPXUSuZj6eBRHdq3HHRZOzTcfkfC+Ceja2d/kUqkkVzl2Kpo
         QUlf5BiQAneNDJw9fPWRzgnR7TTwETLL2LCvNnYXj7wMHaj12xjvQfjgFIpLlPrCKJkq
         CEr/4UWlBsfTkhMc3saRGnucfzWibWT8mrRxayhuY7L4EWaw8DO6/f9roHSt8eNDQr2X
         jYFA2wlXQRaLEvDk1mz69oR3586doSJvPm3PORanZEHtPFpvTDDlDGzzmJ897fUHeOQK
         OeAg==
X-Gm-Message-State: AOAM5318no9cSLJcYcnaCX08YY+QVOHSDV8cdWwOrwutYii/CmUVLFh5
        HmBJqjroJ186cuc4CDXC2RPt6g==
X-Google-Smtp-Source: ABdhPJwYZGOnnyliQde+cwXundXxy/2FHbW2RABsQKlFRqW5EKcyGzrypdbPAT/yTsLipBiZRuL1Cg==
X-Received: by 2002:aed:32a7:: with SMTP id z36mr2577143qtd.251.1611282851670;
        Thu, 21 Jan 2021 18:34:11 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id m13sm4846025qtu.93.2021.01.21.18.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 18:34:11 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     rui.zhang@intel.com, daniel.lezcano@linaro.org,
        davem@davemloft.net, kuba@kernel.org, luciano.coelho@intel.com
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-pm@vger.kernel.org, amitk@kernel.org,
        nathan.errera@intel.com
Subject: [PATCH v2 3/3] Documentation: driver-api: thermal: Remove thermal_notify_framework from documentation
Date:   Thu, 21 Jan 2021 21:34:06 -0500
Message-Id: <20210122023406.3500424-4-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210122023406.3500424-1-thara.gopinath@linaro.org>
References: <20210122023406.3500424-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since thermal_notify_framework is no longer supported/implemented
remove the entry from sysfs-api.rst.
---
 Documentation/driver-api/thermal/sysfs-api.rst | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/Documentation/driver-api/thermal/sysfs-api.rst b/Documentation/driver-api/thermal/sysfs-api.rst
index e7520cb439ac..d5b6ca812873 100644
--- a/Documentation/driver-api/thermal/sysfs-api.rst
+++ b/Documentation/driver-api/thermal/sysfs-api.rst
@@ -743,17 +743,7 @@ This function returns the thermal_instance corresponding to a given
 {thermal_zone, cooling_device, trip_point} combination. Returns NULL
 if such an instance does not exist.
 
-4.3. thermal_notify_framework
------------------------------
-
-This function handles the trip events from sensor drivers. It starts
-throttling the cooling devices according to the policy configured.
-For CRITICAL and HOT trip points, this notifies the respective drivers,
-and does actual throttling for other trip points i.e ACTIVE and PASSIVE.
-The throttling policy is based on the configured platform data; if no
-platform data is provided, this uses the step_wise throttling policy.
-
-4.4. thermal_cdev_update
+4.3. thermal_cdev_update
 ------------------------
 
 This function serves as an arbitrator to set the state of a cooling
-- 
2.25.1

