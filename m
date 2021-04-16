Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46BE3618B2
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 06:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237368AbhDPESj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 00:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234757AbhDPESj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 00:18:39 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B999C061574
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 21:18:15 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id k18so21677576oik.1
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 21:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lcbznpfr1wxV/oVXgZ+RgdQUz/+TLYs6IfimcLkDkmI=;
        b=Jw8Rj3VYNEwjWpmvACtaIIuNW3RtxoBZPKU+xdf+6/0pHMUeOcMrE7svjtnOnvzTHt
         +SgotPC0uN8wC3vVcj1in18cW3UZpDqzBuEv2BOzYO6G0EE62IxEu663V9l6iVIw7sKL
         lryd0DnF8DYhdt4t7TWPPThOkQ30ZaIPXod/zd9AAxfxABl1/2Mte2dz8DJT/i2GwuA5
         2tny0FzelcPUMxBN3bwVvB0KH2mqzdBlxAByStAN1PaYTwTHH/qQIYMFGabwkjirYL6Z
         wa1wXO3WGxLoz5BOt9KQcIeY8N4auoMTrAfbjvzUyvFYxNiRS1ubNkxVtwYFdVK2xV9N
         1NMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lcbznpfr1wxV/oVXgZ+RgdQUz/+TLYs6IfimcLkDkmI=;
        b=NF6EnJp2VtxL4HzhNS9HFrfIV3J58hovzINIojVs62lA/OcF5XPr/JzEuK39aXGuHy
         agxmM05ZUnlFF6jnNsrbgLuIp1h4C5suauDU7OIwzY8vql16Q6GwEcN41h5MQFDuXSCS
         jlMAFgYqm2tgBBv2Q4x5CJN40hHsvi/aK2MWrzv17543ukj6TBibHHCGudsopTYWgnFc
         DrvV9IFGoXRDOQAeAsYzWsvQQEyPnA4vewrPBcGDcUHdVJo+zmXgSVaBHCemPZxnnWYg
         jOCaYuZceLssBVzs7UHMSjIvQRJJqBzWbxv1aE8cChGMEzfobRaBlvyb1B87lzYzk32y
         Fbtg==
X-Gm-Message-State: AOAM532NK9WgrLjT+yJHvbgLiX7yf2h5R9ebf+TpceRcJiNBMPpL49Lk
        l6QUGQh64jtW05zFJZk0ljjjlpccVnUWyw==
X-Google-Smtp-Source: ABdhPJx6gTpTyAIKX8D5LDUGUBoKZSoJq/dS2/UwEdtWgw2bqoasGnqPU9zQYyw9hxhzVEgMwsokBg==
X-Received: by 2002:aca:ad52:: with SMTP id w79mr5005710oie.148.1618546694495;
        Thu, 15 Apr 2021 21:18:14 -0700 (PDT)
Received: from pear.attlocal.net ([2600:1700:271:1a80:a4e5:44b2:432c:7b26])
        by smtp.gmail.com with ESMTPSA id w7sm1105373ote.52.2021.04.15.21.18.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Apr 2021 21:18:14 -0700 (PDT)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>
Subject: [PATCH net] MAINTAINERS: update my email
Date:   Thu, 15 Apr 2021 23:18:13 -0500
Message-Id: <20210416041813.13895-1-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update my email and change myself to Reviewer.

Signed-off-by: Lijun Pan <lijunp213@gmail.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 795b9941c151..ea76d35757bf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8521,9 +8521,9 @@ F:	drivers/pci/hotplug/rpaphp*
 
 IBM Power SRIOV Virtual NIC Device Driver
 M:	Dany Madden <drt@linux.ibm.com>
-M:	Lijun Pan <ljp@linux.ibm.com>
 M:	Sukadev Bhattiprolu <sukadev@linux.ibm.com>
 R:	Thomas Falcon <tlfalcon@linux.ibm.com>
+R:	Lijun Pan <lijunp213@gmail.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/ibm/ibmvnic.*
-- 
2.23.0

