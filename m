Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504633FD7ED
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237483AbhIAKpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234901AbhIAKpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 06:45:41 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5A7C061575
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 03:44:44 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a25so5618997ejv.6
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 03:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DphME6vVe6uaARHbGU8sm8LAhDS1rD9BcL1RtEF6enM=;
        b=ytfZmWlmMVH3+04WZTKjhurRdt9BLgD1tcANgT/GNno25/2rX+BXtyTiuQbCCBnQFf
         NoZhKad18TaD/rXbroAzbr0+DCqaePt6aM0OFfiJVVaCslXNls0wb0O0liMDlm0oTQ0p
         P1U2AUdKEkhJTwh1uzGs/cVrdqW/X5WoqlV4AahoP4EjfmGO/O/T+fE08NibiNW+52Nl
         Cqg8CufRPDRuguCg4fQuf/TDcJFH79LBsEHvWIYO+WyFWUa447hQP8TVI0KQpTnaVQGM
         D2M9daxLV0R/4VlWhjUlYjbYR0OQBHKXcFNHOASlPHPpaWsuedeN0lQGn3w5JGxL3OO8
         PSiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DphME6vVe6uaARHbGU8sm8LAhDS1rD9BcL1RtEF6enM=;
        b=ayQUQST3eRDbx7AKSQO5w0YQk0t/PZrsnTCrtK2G573Q2jFEzb/5BIesnwDYuVY4LD
         CQcuJvzaHeXBbO0aZSWSZ19DwsNdAvQKslsWDjlRWcEeP1js3zrhMy9VoWU3o9Io7exP
         Kbnnvo0kpLLnwuqIFO5o5Ksiqr9JLpD9yoo88jm7/3uovZJrLFw5MctpXsWiouQrpmY1
         r+graO/BcZyks2LybSeVd6MLqxvsW6+LdS6bqLewnKuV7DJczTOIUrjyRIbQzxNemd8i
         IzWjzWFZDxXdTr6yOf4GNLgIT4egaS8zFT99m5kYyMcnJtvFtrUQmLrziyMqMKb3Qgy+
         xzwA==
X-Gm-Message-State: AOAM532MCkY4UfvEzEHpGbSF4vkHuDXctl59BntkN5GSTxVdmaKxtfIq
        5IH+7SyQO0KzLkEmuorO+9dMONq40EFEsnN/
X-Google-Smtp-Source: ABdhPJwRo/ClhSvj3oB4KLxtMULj4twqmmqx5oQDk3wBV2BqvTy5uji9KvJBBT4nQFJxuPZvF5iRiA==
X-Received: by 2002:a17:906:ca1:: with SMTP id k1mr36761955ejh.369.1630493082035;
        Wed, 01 Sep 2021 03:44:42 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s2sm9850752ejx.23.2021.09.01.03.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 03:44:41 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com, stephen@networkplumber.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2] man: ip-link: remove double of
Date:   Wed,  1 Sep 2021 13:44:36 +0300
Message-Id: <20210901104436.1164963-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Remove double "of".

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 man/man8/ip-link.8.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 572bed872eed..80aa03a63ab2 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -2383,7 +2383,7 @@ may be either
 .B 0
 to disable multicast routers on this port,
 .B 1
-to let the system detect the presence of of routers (this is the default),
+to let the system detect the presence of routers (this is the default),
 .B 2
 to permanently enable multicast traffic forwarding on this port or
 .B 3
-- 
2.31.1

