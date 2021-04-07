Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD87C35600C
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347475AbhDGAQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:16:52 -0400
Received: from mta-p8.oit.umn.edu ([134.84.196.208]:36452 "EHLO
        mta-p8.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347481AbhDGAQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 20:16:34 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p8.oit.umn.edu (Postfix) with ESMTP id 4FFPrr0BGZz9wKs7
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 00:09:16 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p8.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p8.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id JKp24EpdkeXN for <netdev@vger.kernel.org>;
        Tue,  6 Apr 2021 19:09:15 -0500 (CDT)
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p8.oit.umn.edu (Postfix) with ESMTPS id 4FFPrq5XbWz9v904
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 19:09:15 -0500 (CDT)
DMARC-Filter: OpenDMARC Filter v1.3.2 mta-p8.oit.umn.edu 4FFPrq5XbWz9v904
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-p8.oit.umn.edu 4FFPrq5XbWz9v904
Received: by mail-io1-f70.google.com with SMTP id u23so14050829ioc.4
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 17:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U106F34psccI0z0WK0my8RMdv+H4P8eVWUK1e/YtHmw=;
        b=R7dj6M09QAZ0+Hx2gj69szBZZo0vfF27O2fStj0J4qyaWncVF7t65Icb8kyTIcHhTo
         fnnlySyHTscBHrJzhN4Q3O2R7R7AHt6ubZ1r4AolMFI8NYT9r2223zetgC5FHwT83mYC
         i7iQ8v/zb6yErRb6kFJZnSGKwlu9T7yrXvnyw6UnHupcQ2t4zIp+u5IxWjYCMZXmTsXz
         XkE34Zp0QgiWLz9e9dr7TZEfqzuoQAPR27CtkUM/YbIS32tZD1RjGSQYRq7rkkqgF2iv
         QIgWjn96jfVP/hqFVouDKxgqnoFHW8eP605xrG7EKqMY78gV12OukqBkWhSEuqLR7IvA
         chbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U106F34psccI0z0WK0my8RMdv+H4P8eVWUK1e/YtHmw=;
        b=nY3o1ziS1aj9enImoqeq251pXywLLg8Izk/DSqkDuEFeApeZJPR0vlEssrP2KUhblU
         M6WthIJZqa+V3q2ovxsZYzsWEWOSy6g064pQQH8LEmein0auHZZMjAHtqTJzqQ+UbdxK
         8/b1JfzjJim/wMIcas5clluuQPWveGU3JRoDmglC8tSexZhMHH5twEMlhWAIQdnYPLRP
         Yc+WXxN8nzSuEcam48KmdY8jlFsyo1CdOVr9FCNKZluIFV0LV9cOMHhjxznVVHItx05E
         7gwVb20O7ggCH/rqLTU60wPIMfFsHqQKiG4KcOGoP/Lo0Fnbqnk+0j9maRnQOtxHb3Vz
         4tIg==
X-Gm-Message-State: AOAM532elNlazmgzRhFrhBGnKogGioIzZO4Va2mMq2jXVpFvYGW2VRos
        AnF1JSo+DVzgJwDLO7yHIO/wsgZv1+AN6PXNCVvHVInJ3uwPH5RCfV79QU+N9CVLCoLw6AOpjGu
        rdpcs6ZFxbUttVkXCxYYu
X-Received: by 2002:a92:c7d2:: with SMTP id g18mr647812ilk.220.1617754155453;
        Tue, 06 Apr 2021 17:09:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2hgxNMUYYy9q8hnatKJtH920+OSUloSvGVSjVTL5uWSwLiAAx3qpbF0F18q1EbAOhOQDx4w==
X-Received: by 2002:a92:c7d2:: with SMTP id g18mr647793ilk.220.1617754155241;
        Tue, 06 Apr 2021 17:09:15 -0700 (PDT)
Received: from syssec1.cs.umn.edu ([2607:ea00:101:3c74:6ecd:6512:5d03:eeb6])
        by smtp.googlemail.com with ESMTPSA id h8sm1271850ilo.21.2021.04.06.17.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 17:09:15 -0700 (PDT)
From:   Aditya Pakki <pakki001@umn.edu>
To:     pakki001@umn.edu
Cc:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/rds: Avoid potential use after free in rds_send_remove_from_sock
Date:   Tue,  6 Apr 2021 19:09:12 -0500
Message-Id: <20210407000913.2207831-1-pakki001@umn.edu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of rs failure in rds_send_remove_from_sock(), the 'rm' resource
is freed and later under spinlock, causing potential use-after-free.
Set the free pointer to NULL to avoid undefined behavior.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 net/rds/message.c | 1 +
 net/rds/send.c    | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index 071a261fdaab..90ebcfe5fe3b 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -180,6 +180,7 @@ void rds_message_put(struct rds_message *rm)
 		rds_message_purge(rm);
 
 		kfree(rm);
+		rm = NULL;
 	}
 }
 EXPORT_SYMBOL_GPL(rds_message_put);
diff --git a/net/rds/send.c b/net/rds/send.c
index 985d0b7713ac..fe5264b9d4b3 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -665,7 +665,7 @@ static void rds_send_remove_from_sock(struct list_head *messages, int status)
 unlock_and_drop:
 		spin_unlock_irqrestore(&rm->m_rs_lock, flags);
 		rds_message_put(rm);
-		if (was_on_sock)
+		if (was_on_sock && rm)
 			rds_message_put(rm);
 	}
 
-- 
2.25.1

