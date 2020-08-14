Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F5E244931
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 13:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbgHNLjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 07:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728055AbgHNLjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 07:39:43 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540D6C061385
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:39:43 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id c19so8215909wmd.1
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MUV+yz+bHDDxU9QUealM8/lB5IQK1oTN3Rz5yVKFYm4=;
        b=l+111kqHdNB0lIDK3r++LA2g+EZA//8R6aznyiwvdp+j0MKetNqHwbb7cuk9RrKa2E
         8JEl3bytLKvZNB/Kxrxwcx0aPjN7M2y+bOQJkVsEiBcXovmpYZgNBqtD6uN8FUb9juC4
         ejvTWSUKwvqTKg/RZkPj8akPf09yu4PUEvPnRRoVS4e5LN87uJ5aMmSjKUKFY9bkIP+I
         mSSQkwqKtAL2BuvfF57rSKTwc30gSoz3RwUrZHckDSPhZpBbmMAtNleFt3ViyH/499aK
         3sVD5bU402VDJaCJNhhN0gQnHRlothsgZqgQA7s3EBeQu5SpL3otQ7BRPB+1QHx7p2qW
         2Dnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MUV+yz+bHDDxU9QUealM8/lB5IQK1oTN3Rz5yVKFYm4=;
        b=D28fxLJDXU6EMtTM1CaTu8a+oQIrl25HeLd9by/zYVqddnYjf0AEp9qmEgQVzwaxhn
         miRI1TbRQEQ9cVe/TKRSsXHl0kmDHSsbfhVbJOEst+Jblb5Mqojn5qpNxou1t43o2Y3w
         zcSZE7jTqb7WTa6X3EXNef7Koi2jFRpnytNLZlK7oaeOgyYwKOzlj4KVJ0/FM8kbi5dC
         fOCaJKtWg5FSPQ5oT5brGnLoSWkQct/+wgfSdqRF5p/AZEloQXohiAGzdfHDEy/35NeQ
         gP5XitzK0iOMghlaAX3AoMUdmm5A/ndM8Qs5+SPVuj9mEiwDNCCmkZri0fF2UqDlEkLh
         zkOQ==
X-Gm-Message-State: AOAM5319awkNZWy58xjYiOIs2r9O2ULSUp2803Axg9yxF4c+yxAz5Gc9
        uJqXCGwL4oY1ttPshHOQ5fNvGw==
X-Google-Smtp-Source: ABdhPJzL3xmyXx+1jDTkp7IuUawasCOHs8oE9JoXge8m6lDvNsUquUCvs2Sem2m06iG2L4QTo3QEZQ==
X-Received: by 2002:a1c:7405:: with SMTP id p5mr2151480wmc.130.1597405182109;
        Fri, 14 Aug 2020 04:39:42 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id 32sm16409129wrh.18.2020.08.14.04.39.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 04:39:41 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: [PATCH 02/30] net: bonding: bond_main: Document 'proto' and rename 'new_active' parameters
Date:   Fri, 14 Aug 2020 12:39:05 +0100
Message-Id: <20200814113933.1903438-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200814113933.1903438-1-lee.jones@linaro.org>
References: <20200814113933.1903438-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/bonding/bond_main.c:329: warning: Function parameter or member 'proto' not described in 'bond_vlan_rx_add_vid'
 drivers/net/bonding/bond_main.c:362: warning: Function parameter or member 'proto' not described in 'bond_vlan_rx_kill_vid'
 drivers/net/bonding/bond_main.c:964: warning: Function parameter or member 'new_active' not described in 'bond_change_active_slave'
 drivers/net/bonding/bond_main.c:964: warning: Excess function parameter 'new' description in 'bond_change_active_slave'

Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Thomas Davis <tadavis@lbl.gov>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/bonding/bond_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 5ad43aaf76e56..a448467d8789a 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -322,6 +322,7 @@ netdev_tx_t bond_dev_queue_xmit(struct bonding *bond, struct sk_buff *skb,
 /**
  * bond_vlan_rx_add_vid - Propagates adding an id to slaves
  * @bond_dev: bonding net device that got called
+ * @proto: network protocol ID
  * @vid: vlan id being added
  */
 static int bond_vlan_rx_add_vid(struct net_device *bond_dev,
@@ -355,6 +356,7 @@ static int bond_vlan_rx_add_vid(struct net_device *bond_dev,
 /**
  * bond_vlan_rx_kill_vid - Propagates deleting an id to slaves
  * @bond_dev: bonding net device that got called
+ * @proto: network protocol ID
  * @vid: vlan id being removed
  */
 static int bond_vlan_rx_kill_vid(struct net_device *bond_dev,
@@ -948,7 +950,7 @@ static bool bond_should_notify_peers(struct bonding *bond)
 /**
  * change_active_interface - change the active slave into the specified one
  * @bond: our bonding struct
- * @new: the new slave to make the active one
+ * @new_active: the new slave to make the active one
  *
  * Set the new slave to the bond's settings and unset them on the old
  * curr_active_slave.
-- 
2.25.1

