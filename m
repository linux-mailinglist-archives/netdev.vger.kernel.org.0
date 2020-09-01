Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A4C259E02
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 20:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730160AbgIASUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 14:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730207AbgIASUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 14:20:40 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A92DC06124F
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 11:20:39 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id q3so944051pls.11
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 11:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TufAMw+f1qFVrYcW7BKTj+Sl1ZnH8GKlIrdTG0Corss=;
        b=jPI44HmCIjol70NF+O5AoeRMK4+B4wVftxXeuium3X/zYyftpBeMqf8x2IviamZUqi
         pjqerJpY6hg25g4NRcYNrDeQfC9U5UVgvZFYpkurHX/Svbn/CM4AZe/UUsLkZq3tW+Nu
         BuSq/64wn+ZnX0KuoREvJ+siaih3/bbi57pkhj5qF2ROg6rdRv5zLeydPCoieDu5bH8b
         5HomVrNYdLs5HS4dWdWQZOYmLvCUGE1Mft3Hi6pVbAs84xI1J0lXozdJHEXOcX4pxsi9
         kQV8dQTGbh4pZ7hgNMsuI/64JAjQFNTHpmt02jpxVbwlp093B1ZV40ynNKqbQJmyfWvS
         uOMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TufAMw+f1qFVrYcW7BKTj+Sl1ZnH8GKlIrdTG0Corss=;
        b=oMfWjj3E2gkV2M6iN0voejOVp0TTrpzF07U9670laSfLL9AR6XvTaUluldoCZYN8gz
         AyjIQkfRvJNIr+dDppBSIr3dxxYRbe50H7qQiKzrsfdEmne0TajySc5Wrn0+Easgjbsj
         AcIcb5PjKjSlwaGL2UB5clhFhK7/Fo5cF85UM8felS/tEb40Fqw69E6IdLRjfWHuptqh
         89rQfx2YWjbqwBBL58EBT37nRAYFJ4QWaErqMKZFnVA7fumS7ONAJ27itcFvVIQGc9ys
         a9s3bcwYaXbSMX9AyLqK27L56UXAPRD8jK6hziJAhEFoYb7CkB7D2LtU2L33yKIxcZc/
         ReDg==
X-Gm-Message-State: AOAM530iRWHobDkJY/JshrK8UNyx0CVjfmHcfH1gVGQ3gv1TgKgIkWkh
        ocjOkFa7IVrAuggQrryZIABEZu0fa3XZBg==
X-Google-Smtp-Source: ABdhPJy8BN1BsedfiABbmsT6coVAeojFJqYGOVl+KAEhkb42DzD0vi/AJtQHpgKCyB91ZlB8mRDp4Q==
X-Received: by 2002:a17:902:8bc3:: with SMTP id r3mr2467682plo.238.1598984438733;
        Tue, 01 Sep 2020 11:20:38 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id j81sm2747086pfd.213.2020.09.01.11.20.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Sep 2020 11:20:38 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 6/6] ionic: clarify boolean precedence
Date:   Tue,  1 Sep 2020 11:20:24 -0700
Message-Id: <20200901182024.64101-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200901182024.64101-1-snelson@pensando.io>
References: <20200901182024.64101-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add parenthesis to clarify a boolean usage.

Pointed out in https://lore.kernel.org/lkml/202008060413.VgrMuqLJ%25lkp@intel.com/

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 00aad7168915..0d14659fbdfd 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -298,8 +298,8 @@ static void ionic_get_pauseparam(struct net_device *netdev,
 
 	pause_type = lif->ionic->idev.port_info->config.pause_type;
 	if (pause_type) {
-		pause->rx_pause = pause_type & IONIC_PAUSE_F_RX ? 1 : 0;
-		pause->tx_pause = pause_type & IONIC_PAUSE_F_TX ? 1 : 0;
+		pause->rx_pause = (pause_type & IONIC_PAUSE_F_RX) ? 1 : 0;
+		pause->tx_pause = (pause_type & IONIC_PAUSE_F_TX) ? 1 : 0;
 	}
 }
 
-- 
2.17.1

