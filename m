Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E418824CF39
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 09:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbgHUHXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 03:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727841AbgHUHQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 03:16:51 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BAB5C061386
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:16:51 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id f7so1028266wrw.1
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jOm2zcmBlBaWvVWKVoK4VDO5au3ZDq1ZZipeMA7blRo=;
        b=OtFgP01eaZb7/23GqnLTNn5IWnxAJYw4KItiK8c8b4fcUGXygHRwR04/Ov07OppKub
         9LW3D3fGihN1jlD7K5zkLMwY4HDiHqj7eIwaUiDbo1AzraI35rMxgakzH0cYrqAxSgQ+
         yVoZq43cEY5X+K88wYniZJp/J8ys8iNowsiz2eEYprlPI3D+DjmPYML5Yb88WOg59eDC
         GNOEh+Srgw5tV8SZtw2fO1yrFHwDG6DNj5Gk16TL7Y7srVUe5KR/rgXQB/HpXC4vIM+G
         WX60mkYVnDaGkEk5LVvGejbDWWsBbHdN5B7CC82tJZi3OxQXHc/l+jFuYmrBNjOwa6/3
         +fqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jOm2zcmBlBaWvVWKVoK4VDO5au3ZDq1ZZipeMA7blRo=;
        b=CHjQAGRHvaCbV08YXADNDodqa2Tr1Cn/91SBNTY8/8i3+lcrwvMmecYbR82BpeK1FB
         kVlqNywfkLHEwNvmXhj58T3vH0X/dcvfMmZacZKss7PrvHeKZQxdYf/3/LDNpwW92zsP
         Oa8KrGrB2YgW1+7dn4/jHPmEkUaCzpNFJGHd8Td7yunTz+4HTv3yS1FHzFg/fGBN/wn1
         nJNdQkpyRxnFYJdI2Uqfc86JiFWdV3NHW+405SuZT+Q5+HT00DpC+hMUbywdb79Pugk8
         D61jqQVjAyYppxYDUdflzO8HBHHE7ZzeFNrC/+hHrhpw/WhGT0SjEg6CgzByoKZvqo80
         Pq5g==
X-Gm-Message-State: AOAM533ZKpGkVPBI+hAWW/ZVYVn4sA+jptViksPD5vobvygo6E2eE9W1
        ouFc+zR0GgIFgdFDwKu5utsKKQ==
X-Google-Smtp-Source: ABdhPJz+Fi6kNfEa5apWxt2K8QCXkkDuhqgmLTS13m1rl/rorzM5V2bYJUS2rXdWvf6A6MhNVJOHmg==
X-Received: by 2002:a5d:660d:: with SMTP id n13mr1414546wru.52.1597994210118;
        Fri, 21 Aug 2020 00:16:50 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id y24sm2667957wmi.17.2020.08.21.00.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 00:16:49 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>
Subject: [PATCH 02/32] wireless: rsi: rsi_91x_mac80211: Add description for function param 'sta'
Date:   Fri, 21 Aug 2020 08:16:14 +0100
Message-Id: <20200821071644.109970-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821071644.109970-1-lee.jones@linaro.org>
References: <20200821071644.109970-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/rsi/rsi_91x_mac80211.c:1021: warning: Function parameter or member 'sta' not described in 'rsi_mac80211_set_key'

Cc: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Siva Rebbagondla <siva8118@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index ce223e680cba6..16025300cddb3 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -1009,6 +1009,7 @@ static int rsi_hal_key_config(struct ieee80211_hw *hw,
  * @hw: Pointer to the ieee80211_hw structure.
  * @cmd: enum set_key_cmd.
  * @vif: Pointer to the ieee80211_vif structure.
+ * @sta: Pointer to the ieee80211_sta structure.
  * @key: Pointer to the ieee80211_key_conf structure.
  *
  * Return: status: 0 on success, negative error code on failure.
-- 
2.25.1

