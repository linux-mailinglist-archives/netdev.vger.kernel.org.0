Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3574A76E0
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 00:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfICWXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 18:23:52 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:44769 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfICWXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 18:23:52 -0400
Received: by mail-pf1-f201.google.com with SMTP id b204so4984412pfb.11
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 15:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=+PCvSOkvySdWxOAJeySwLu3Fy1OiB15fqDnVbwKlIag=;
        b=qS3pG4Ke205Cz4lU2fIMU8nWWTJ8t2as68GAJkrkJ1i37AY1tNZMcn5UpM3RF7MENe
         QqGa31NuhXtorP3lnuqI+YtVnxbHuwoFbopkYQSQZIz0UcOPCFPyfqAIZ6i7CcvyoSMC
         E/fTnk2F8SVYLZcKyc5gPZqwa4wturG4ZrcImqEnhXR0xkmmErRaty2F6KbJ09W88Nv6
         uMmgDNR0RCt6nv2onrhhzMI93cwr93V8rYcLMqKy0VHRMRvmWMy00+sBK/1KTxp5c86K
         gpnyRFIP/rHdqtc89hRLTVrsHA6LHL6BOZj7tmnpW0EmQ2lbjQ4cEbWzEvebjEIdBbTr
         8wFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=+PCvSOkvySdWxOAJeySwLu3Fy1OiB15fqDnVbwKlIag=;
        b=EmQLlbQXOc0wdNeHHD/vcrhPA3fQltXSxVs0kzIU0b1qag+xrNPyLt1X1ChQgUMho0
         +Ki4QvFuowpAxaDuTocYSXLxgoyJYyktnR+HmTsy6xIYJKlo3QDm/GfwAUNi1NINV+M0
         e3t5dbnpo/ghJiJljPrgjQm96cIq+qSc7jtjw+H26E4gY78Jv2KHEK06s5vl3gdJE8Ih
         mQeiR8pvAXnZ/JGpB+GOWoCQ8wLBfw5hAYoWlDSC7tBzdDr+cMMYO18uiE5eGF4uJEW7
         DWwrx/+MJEEaUwtwNeQ6xDE88fcMMj3Nx5WcHLykLk5T2BixGjT5KCZN+m4XLysZGftR
         Jr3A==
X-Gm-Message-State: APjAAAWmN69bF2Tse1FpLFq9wUIXnFjEjEPXRxAGPK+83EMOTYm3urqq
        Xcj5nzumN/r9tCYFRrFHfSS2TSWBtkT7
X-Google-Smtp-Source: APXvYqxAAc4HdeiZ6eQP+fKw1JNSLP+M3gfPQWQibaGz4LPlLosNOhf/qVzV9gmkpuGd6wLeSMjQjgb6lhZW
X-Received: by 2002:a63:a011:: with SMTP id r17mr9498033pge.219.1567549431056;
 Tue, 03 Sep 2019 15:23:51 -0700 (PDT)
Date:   Tue,  3 Sep 2019 15:23:46 -0700
Message-Id: <20190903222346.42583-1-moritzf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH v2] net: fixed_phy: Add forward declaration for struct gpio_desc;
From:   Moritz Fischer <moritzf@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com, davem@davemloft.net,
        Moritz Fischer <mdf@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moritz Fischer <mdf@kernel.org>

Add forward declaration for struct gpio_desc in order to address
the following:

./include/linux/phy_fixed.h:48:17: error: 'struct gpio_desc' declared inside parameter list [-Werror]
./include/linux/phy_fixed.h:48:17: error: its scope is only this definition or declaration, which is probably not what you want [-Werror]

Fixes: 71bd106d2567 ("net: fixed-phy: Add
fixed_phy_register_with_gpiod() API")
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Moritz Fischer <mdf@kernel.org>
---
 include/linux/phy_fixed.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/phy_fixed.h b/include/linux/phy_fixed.h
index 1e5d86ebdaeb..52bc8e487ef7 100644
--- a/include/linux/phy_fixed.h
+++ b/include/linux/phy_fixed.h
@@ -11,6 +11,7 @@ struct fixed_phy_status {
 };
 
 struct device_node;
+struct gpio_desc;
 
 #if IS_ENABLED(CONFIG_FIXED_PHY)
 extern int fixed_phy_change_carrier(struct net_device *dev, bool new_carrier);
-- 
2.23.0.187.g17f5b7556c-goog

