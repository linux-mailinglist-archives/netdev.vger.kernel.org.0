Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBA2219277
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 23:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgGHVYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 17:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgGHVYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 17:24:36 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B99FC061A0B;
        Wed,  8 Jul 2020 14:24:36 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id c30so39192550qka.10;
        Wed, 08 Jul 2020 14:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KHQ5iKe0jq8WM/GNa7lpcyF4GfRdcF49A/sQnJx33+A=;
        b=h+Hn5mDG3YDTR0wRtwbL9cfjNvX5SdNeKvN20biY6Phc8KMCp251P8GdBNzKhXaWXN
         eMWMmN/PhWC1091WUYsr0s79UFzFaRzyx270N56dfkLMGPhbSx1HVqy7Q3f9ZUVChuuD
         M5oExPf0V2zUVMvp7BeZVdSRpG1pkniO/8p67UeoQ3ytqvFAAnmILhbU+/ZPAv3bHQjd
         IQL//IUvNSFFa+qKoee/KIyoAjjvLaldtnaAnTxt+xVogxWEuL8E/L7cOQzBljISpRN0
         vzE6MJ+n+nQamCcjKH0CeuG/TV8PZrQBBL5FT7nedzvHv1lNkQUBmSg9Fv6GUT4b33rd
         Wfxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KHQ5iKe0jq8WM/GNa7lpcyF4GfRdcF49A/sQnJx33+A=;
        b=rf/hjYnjQ/IVrCluOLYGkvqZIk5mN6ZjdAiO7IdYUnG2ebpB92K16POMz7aou8AP6b
         kqAENNGbxDsoqDwx88k1ZMe78NLD9cwT4J5uk6FqnDkG3GxmHAAqBqtGs7Ed/Z6gGrwF
         suXWsBi7szvx1qrhjdaPsEE57qFIiokqvC87ZC6AZGQoAo2pyl05DHEyS2byezmEWfBb
         yVRJDBUkceD/mR+IpcGTgsXCrqVFwaNpeLz5RosRFNeGYluauY91APBfXJWch1lKpnPq
         xke/iSRv4pzaKCiyAs9/uYsKkx+AD6mRTYu5wgml5WuHru6YI/n8YUTHnPCeI2hxdQQi
         mfZA==
X-Gm-Message-State: AOAM530jygopUHkZ4NRvo0qakR+rR0f51Cl3e4fCDhv1cbl6L0VivF/C
        XAAjc07k+G0SJACKtxPVZOg=
X-Google-Smtp-Source: ABdhPJz07cDeFqFR6QOObECZvAUgG5FOAMcQrXwEzIUFWtbKSid0LxB7SXZaCSh+fLs8+4m16tkrjQ==
X-Received: by 2002:a37:b206:: with SMTP id b6mr59195318qkf.22.1594243475232;
        Wed, 08 Jul 2020 14:24:35 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:482:92b:9d6d:2996:7c26:fb1d])
        by smtp.gmail.com with ESMTPSA id f54sm1165848qte.76.2020.07.08.14.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 14:24:34 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     davem@davemloft.net
Cc:     dmurphy@ti.com, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, Fabio Estevam <festevam@gmail.com>
Subject: [PATCH net-next 2/2] dt-bindings: dp83869: Fix the type of device
Date:   Wed,  8 Jul 2020 18:24:22 -0300
Message-Id: <20200708212422.7599-2-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200708212422.7599-1-festevam@gmail.com>
References: <20200708212422.7599-1-festevam@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DP83869 is an Ethernet PHY, not a charger, so fix the documentation
accordingly.

Fixes: 4d66c56f7efe ("dt-bindings: net: dp83869: Add TI dp83869 phy")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 Documentation/devicetree/bindings/net/ti,dp83869.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/ti,dp83869.yaml b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
index 71e90a3e4652..cf40b469c719 100644
--- a/Documentation/devicetree/bindings/net/ti,dp83869.yaml
+++ b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
@@ -24,7 +24,7 @@ description: |
   conversions.  The DP83869HM can also support Bridge Conversion from RGMII to
   SGMII and SGMII to RGMII.
 
-  Specifications about the charger can be found at:
+  Specifications about the Ethernet PHY can be found at:
     http://www.ti.com/lit/ds/symlink/dp83869hm.pdf
 
 properties:
-- 
2.17.1

