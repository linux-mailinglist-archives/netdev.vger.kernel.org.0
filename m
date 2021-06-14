Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984773A5E16
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 10:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbhFNIKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 04:10:22 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:37389 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbhFNIKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 04:10:21 -0400
Received: by mail-wr1-f48.google.com with SMTP id i94so13440579wri.4
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 01:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=39phsr5VP/ZpU8m1TSVmXcxkuikGCcsIjCQO0yGzCCY=;
        b=cuO74sY/ivv7W/YkZwgpMMFoRN2GLdunHBofpuPMs7hIjqtb6Z8ZkSz/D+sQxsWvNb
         Qi2VDyteeNr5BbmSuILP0IbtiUUuVj9i93T7U3nNjKwJ9B1yR8T2cYfVFE9dVvbfmJr1
         aHyXZCJ3i6asZAocDIEUUySGojCL2uqIthsF0gkBCQTbXz834woG7R7lTrIvrfU5P2Wq
         v6a0PBF2yl+aNoSUKw3zxxvk/U0MSLQXAxVNkVdgQjyfSfIgB2aS3x8wqjUFQAX7wNbo
         sDCOAF6E0rCWdEP8zss3Si9SGP7ZOis2MIbAdXXJw7cFdkyi1vytRdwn21HW4eIYuQHE
         wS2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=39phsr5VP/ZpU8m1TSVmXcxkuikGCcsIjCQO0yGzCCY=;
        b=onTX8PMmJLpdfqf88Tt3+bm4EoOf56mBlJgAkPpegSNzMu8VQ8kseDi6EdL6haCFb8
         zK8ddGSEpPqcbt8eCPP15CBh7KnWdRKVysYBlR5RRpqtogL9loMzN/BGJ9hyghTAPHK0
         C6SzM4jmE5uLdP+DQFF+d4BiENF8wn3VU5gbiwO94Q4iLxx67xgGGmcajEMjt8TBItf4
         WNqrIuEyNxN57rn3c2WDyMODqyIQZ24vYuWnnx1T3cvAZ+pU9Jc9DZ21dsmvXvVS7eQB
         +Ti78v7z6VF8vDe7Wyygrz+cE0LHh/1DhxrZQcfQmVygOYz4KtDhzgkso3WhI+X9Vfr6
         UTYg==
X-Gm-Message-State: AOAM531oUGa3ywRd1me8hjWh9IxMQGActdjjWax8eZi4A3DiQEkTNm1I
        q3JNs9pyvZZZOFtUogNzx8Qrfw==
X-Google-Smtp-Source: ABdhPJwrOs9bCkcVEggBXcCm/e4df0kLD5Di9ii3KfbRvdUHTVDATrl+YyGl5gu5STS0l8f1fNwN2Q==
X-Received: by 2002:a05:6000:154c:: with SMTP id 12mr16928657wry.126.1623658023600;
        Mon, 14 Jun 2021 01:07:03 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:85ed:406e:1bc4:a268])
        by smtp.gmail.com with ESMTPSA id r1sm1635052wmh.32.2021.06.14.01.07.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Jun 2021 01:07:03 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, m.chetan.kumar@intel.com, leon@kernel.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH] net: wwan: iosm: Remove DEBUG flag
Date:   Mon, 14 Jun 2021 10:16:40 +0200
Message-Id: <1623658600-21100-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Author forgot to remove that flag.

Fixes: f7af616c632e ("net: iosm: infrastructure")
Reported-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/wwan/iosm/Makefile | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wwan/iosm/Makefile b/drivers/net/wwan/iosm/Makefile
index cdeeb93..4f9f0ae 100644
--- a/drivers/net/wwan/iosm/Makefile
+++ b/drivers/net/wwan/iosm/Makefile
@@ -21,6 +21,3 @@ iosm-y = \
 	iosm_ipc_mux_codec.o
 
 obj-$(CONFIG_IOSM) := iosm.o
-
-# compilation flags
-ccflags-y += -DDEBUG
-- 
2.7.4

