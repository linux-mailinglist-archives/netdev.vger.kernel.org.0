Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61CC2A29CA
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbgKBLra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:47:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728693AbgKBLqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:46:02 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CA6C0401C4
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:45:56 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id s9so14199918wro.8
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QwG68V9MoarwqZHiGt0L1iQ02kmf6AVMeQn4KDmuzCk=;
        b=QsVFsIkmbkm8kUDo4iMhPtRk0lqsVk/OO+HtLIKaS/d/HE3DjqR0ZMAG3Pa/3oBJB6
         4kZ2OYOrhDtBapWw/onwlsgS5vDEdirqO0uO053mbPSOkKaZtgHIzme5+KLlIjpzvX8p
         LrlYKdFqub0FqXYShTqL1wUhJ3pMfZyMmF5Y5ULT1vwc0tfZQAKP6X1iOPpFrwAQMtBc
         UGAtxqwR9lw7lqxoeA2QS16bhpjSlGFcPCSeJOCBTEKJTZe2Fov/5uxB7LvjpldTNwiA
         x60ehNrybDS3SbjLeQqsk6OdaozmELdwQCUA/CQP94A71eA+XFL8A0OSBHwxV3Eo4pmj
         tj+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QwG68V9MoarwqZHiGt0L1iQ02kmf6AVMeQn4KDmuzCk=;
        b=oxWZ00ESchPCHWm4x3hWC5JVAsvipXYzsQjWT5lBQnIZm+4XrLHpJvR2Uz/k7NDu1v
         VkAmIdeGyG1tG12I3cgmfTay+pNLPKrtCZeqVT0lWujTXYJi7qd7FZBDxOCHM69E/95f
         tCwTSpGL15TOcA/0xx+GEm3PBbfghyXRUxkPGMZRTe0sPv7RiCxGazzYemtOFjqG0ZNe
         x++yQGuLchURntxmaE0exsQtKKJHi5ZkVwgiwYpoOlSOMqccVUs05YsS4tkrlGKo9jaq
         BhlyIk7OfU+3AqXV16qM+6+EbWYzPDtZYVm3VQljVswxgSnHUfJF2mnhn0vZTleflo0J
         y82Q==
X-Gm-Message-State: AOAM530quQN7SKBxTFFDxTJeZMXJ/x58XzU2FsByRk8B2pe84JgrvZd6
        zs322C3ZWFSp2pI879BLhyel/A==
X-Google-Smtp-Source: ABdhPJy2EACqzIzHB9Q+zHtwKZLr8whwEeebgXGyZL/f0jkbsJlckM9ox4cmxubumfYqpabDdHTcBg==
X-Received: by 2002:a5d:4001:: with SMTP id n1mr20205511wrp.426.1604317555130;
        Mon, 02 Nov 2020 03:45:55 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id g66sm15545352wmg.37.2020.11.02.03.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:45:54 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net
Cc:     Lee Jones <lee.jones@linaro.org>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 29/30] net: net_failover: Correct parameter name 'standby_dev'
Date:   Mon,  2 Nov 2020 11:45:11 +0000
Message-Id: <20201102114512.1062724-30-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102114512.1062724-1-lee.jones@linaro.org>
References: <20201102114512.1062724-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/net_failover.c:711: warning: Function parameter or member 'standby_dev' not described in 'net_failover_create'
 drivers/net/net_failover.c:711: warning: Excess function parameter 'dev' description in 'net_failover_create'

Cc: Sridhar Samudrala <sridhar.samudrala@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/net_failover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index fb182bec8f062..2a4892402ed8c 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -697,7 +697,7 @@ static struct failover_ops net_failover_ops = {
 /**
  * net_failover_create - Create and register a failover instance
  *
- * @dev: standby netdev
+ * @standby_dev: standby netdev
  *
  * Creates a failover netdev and registers a failover instance for a standby
  * netdev. Used by paravirtual drivers that use 3-netdev model.
-- 
2.25.1

