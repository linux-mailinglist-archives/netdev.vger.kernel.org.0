Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF12311BB5B
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731273AbfLKSPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:15:33 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:40877 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731242AbfLKSP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 13:15:27 -0500
Received: by mail-yw1-f68.google.com with SMTP id i126so9295324ywe.7;
        Wed, 11 Dec 2019 10:15:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WcxYr9RZCBsnbidLa8eleGOYukmYC7BtU1QAQ3T47uk=;
        b=VmBiBCIVN/9mZ5ewjyFn0SXVBO5g9Kex9cLjyo3xJq+9dqNFK08YN2qa25Rs+lyAio
         QMAoItaqttwy+ykk4s1UteT/EAxUgIF5VCoCuwiHsfsVTKBNadUDfmZRH9FJk3N7Cb6N
         G7TRFWw2AabJkv1w58GKzQ6rZF86Y4sfYfwMTwmPJf97Cha8psc/jQ8PFKgzMbxjDGSJ
         B5+aDAIOiWMt+dsYWOJgs6vpJgdMcNKMAinSxAk/Shh5OIk6MkZz8OKe1QeIMQL2INEm
         PeRRn4w5JMNmvOz4wg+fSt76LDf/7Q7O+Zp5UkIITG2fNRIU4hgF98LitNuo5PIYMqe9
         d+iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WcxYr9RZCBsnbidLa8eleGOYukmYC7BtU1QAQ3T47uk=;
        b=NwdCD7IQPqh/aCLJfI/5kizp+GLG4BITaUZFpRBPXKU3FwQOPrYOrTAGqaRN0xHAzb
         xMf+5H3xDUfduizSxASe/+iJpr0mftMzxLEf3t1AFqWTvy/Jy61MXLigvbszNU9b2yVt
         RVoX0OCXyGqJKPSj7SshDok/1/MkzQkpPYPhLqxiOONd7SN7x3/3uDKcgHnGmyr6Py3T
         X1OlGksRwZwCwwJ1eZmOqZM15/vFFv6V/VHZ/0dpRqcjVMX8OAteORjfLIUiDchrdFZ3
         Fzd7pVn9DaCG7MDkAGt4/9bxH/1UboHkxZrYNxoqisEgCTdqj6vDiu/hqGVJfNNSoRuJ
         //mA==
X-Gm-Message-State: APjAAAVi5A801zgCRfzaZFR7EJSj56qwVfOCk9vbtRgTTLZcLJ55gDWX
        dqYMYne4O8NKYppGOo+ISMiiWuCmmUV27g==
X-Google-Smtp-Source: APXvYqwvjrbh/5FmBwa94ei1z66nQ5R93gCHgVkZdQTEs9tpJL+x1TSQNXy2LWP8oCPoaZ0RVOVX5w==
X-Received: by 2002:a81:f50:: with SMTP id 77mr907958ywp.340.1576088125875;
        Wed, 11 Dec 2019 10:15:25 -0800 (PST)
Received: from karen ([2604:2d80:d68a:cf00:a4bc:8e08:1748:387f])
        by smtp.gmail.com with ESMTPSA id d207sm1298391ywa.62.2019.12.11.10.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 10:15:25 -0800 (PST)
From:   Scott Schafer <schaferjscott@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Scott Schafer <schaferjscott@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 14/23] staging: qlge: Fix WARNING: Unnecessary space before function pointer arguments
Date:   Wed, 11 Dec 2019 12:12:43 -0600
Message-Id: <b80b28a9e4377bbaa8f33e78311302a97c2e5f41.1576086080.git.schaferjscott@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576086080.git.schaferjscott@gmail.com>
References: <cover.1576086080.git.schaferjscott@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

WARNING: Unnecessary space before function pointer arguments in qlge.h

Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
---
 drivers/staging/qlge/qlge.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 9ab4c7ce7714..010d39b4b30d 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -2057,8 +2057,8 @@ enum {
 };
 
 struct nic_operations {
-	int (*get_flash) (struct ql_adapter *);
-	int (*port_initialize) (struct ql_adapter *);
+	int (*get_flash)(struct ql_adapter *);
+	int (*port_initialize)(struct ql_adapter *);
 };
 
 /*
-- 
2.20.1

