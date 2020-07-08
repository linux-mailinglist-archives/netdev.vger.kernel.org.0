Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A478219275
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 23:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgGHVYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 17:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgGHVYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 17:24:33 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268FBC061A0B;
        Wed,  8 Jul 2020 14:24:33 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id e11so43127933qkm.3;
        Wed, 08 Jul 2020 14:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FVKlHGclMG+5g9LsvCjwR+crIgaigZMQlcw6o5VC/d0=;
        b=Dm9yzue0JCJDgD0vCdDvqtaFMKqgyO7w9y7H0//ubAjWRm0/3O8D2wlD2f5NVZ8yTc
         eGzE2ffhucQx0pr1kV6XrXojEz5vMhjy/LMhxlQlNLQ3ec5Dvs0YoOYRpD6f+NhJjXWG
         R8KvhV6o762LbWAi6ovr+prNm+e5tetaoUmnMGF+Fv5P6jX1467Ke2BM3eVpefqtGj+j
         +giKgr5YdfC+mETp7mNQ10Vc2uBtef7ggmNo6KsGCgwvZ76opB+7AANjrma7aJCCdk3e
         JiV+iI6YfPVILQV5pRfBSW9S5wYhXX6CYs4gwDeYXpY0tioLAE44kC0DOpRsx8ojtOiB
         AQWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FVKlHGclMG+5g9LsvCjwR+crIgaigZMQlcw6o5VC/d0=;
        b=sxiR3TJJW0kbpEMVdXtanwl50Fn+R08M7TVXekRhWdYZdi0DYTS+xbrboAFDDfdN2N
         IL6llhpti1w9FDWu/mULHFD03wwyxXxGOOnVvJNqjUNC7+LthZazVHsmbMoiR5ET/UYk
         kGXPlt+Sq39i/hWl8SBulY7nB8Fo76TR+bt31mZfedD4Fy2/kHOmBOh2GG6eHvKlc/8Z
         QZyGp1aXy8JRlrGLh+B2iHSArPj7kuJdONVvmSv3BMtOcpjSDyNGSm5eSJ1vgCI1HgyC
         Y/ZJbMGm7oIjbHSCAiMJdj990NsjU9KapvloSePN5qkYYPmj61yzKCeaHR07TZVbTiYb
         BfQQ==
X-Gm-Message-State: AOAM532uDW75FFnIGGDskNO9sbrOOo4FQ48VUdERkV82jLvA0f6D0TGZ
        geG5gigsNk9CbBPWVMHp5Qw=
X-Google-Smtp-Source: ABdhPJwlSKZaNFppArHFpMJfVylTjkE/5sIgKqFmM1F2IKM7vAaIPt3CMq/yvTaRVJMSWatBNPwgyA==
X-Received: by 2002:a37:4fd1:: with SMTP id d200mr20626474qkb.163.1594243472177;
        Wed, 08 Jul 2020 14:24:32 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:482:92b:9d6d:2996:7c26:fb1d])
        by smtp.gmail.com with ESMTPSA id f54sm1165848qte.76.2020.07.08.14.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 14:24:31 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     davem@davemloft.net
Cc:     dmurphy@ti.com, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, Fabio Estevam <festevam@gmail.com>
Subject: [PATCH net-next 1/2] dt-bindings: dp83867: Fix the type of device
Date:   Wed,  8 Jul 2020 18:24:21 -0300
Message-Id: <20200708212422.7599-1-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DP83867 is an Ethernet PHY, not a charger, so fix the documentation
accordingly.

Fixes: 74ac28f16486 ("dt-bindings: dp83867: Convert DP83867 to yaml")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 Documentation/devicetree/bindings/net/ti,dp83867.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/ti,dp83867.yaml b/Documentation/devicetree/bindings/net/ti,dp83867.yaml
index 554dcd7a40a9..c6716ac6cbcc 100644
--- a/Documentation/devicetree/bindings/net/ti,dp83867.yaml
+++ b/Documentation/devicetree/bindings/net/ti,dp83867.yaml
@@ -24,7 +24,7 @@ description: |
   IEEE 802.3 Standard Media Independent Interface (MII), the IEEE 802.3 Gigabit
   Media Independent Interface (GMII) or Reduced GMII (RGMII).
 
-  Specifications about the charger can be found at:
+  Specifications about the Ethernet PHY can be found at:
     https://www.ti.com/lit/gpn/dp83867ir
 
 properties:
-- 
2.17.1

