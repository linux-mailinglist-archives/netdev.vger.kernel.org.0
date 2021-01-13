Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5CA72F5031
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 17:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbhAMQmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 11:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727753AbhAMQmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 11:42:10 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9A7C061795
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 08:41:30 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id d13so2792290wrc.13
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 08:41:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eNUEY9r+/kJx3A9XN2sXZ9yQ1dazqcofsQCJKx0aAEk=;
        b=lKnNESIIN0ln8gRM/0Nd7xLqt0+rBUXIRfPuzMUHQwXW/FmZO+cyC3/G7slwyDbB/p
         I3u7zQHEW3OP93YTNVN6q8N3MnEg163SRUz4gyiccytEpv+G+n6sxr8LNPlfdk901TBU
         DCecTXblcXx0Z0UePkMlkNLGGAo92jEDqvK4rBztzRGDIT46PmqpgEBd8VIRidIUJh0R
         5PN46ZA24585MQ5Q09uMDQQV8/BQ6VPMtexKnVebSdIYwaXvcvyFYqtSMkkZJ2EVziNC
         sgymPz4bssn66yyEMmFcbMWI90UuCBr7Qza8rweqmmL9YdPQSA6BUoHIpAg6zQlE822g
         GFSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eNUEY9r+/kJx3A9XN2sXZ9yQ1dazqcofsQCJKx0aAEk=;
        b=pWcjXKbdasNbrJ7IC1HlHvH7HX+DINxZvGUll15pAb5qvwbsAVN9O9jAVSLcSmO+QK
         4+8RWjaVpIs9GDHQcAWqUHAkWL93zT94LtzYt+iVXpp8CTUdLxplSdhhq+qnkE9VUnzY
         9RLk+3w9rxRvq1cC32ELENK/4QF68Iw6O0cp4Vx7jxLX5nsqdcYmqv4qqtnlIEkaFdGy
         plZCxXVXufMz2Tn78HcrWlfp681nQm0rcfWvpMe2bba/abWWMPXydoHoD3r2zrI28H7M
         QWr5BA53Kdx4NDapIaTswKmmq8mgojt2ti9D5fXzzWIKjTW5eERxOfSeGegBwt/BI4Dm
         pSGQ==
X-Gm-Message-State: AOAM532b7MF76u4VfCtP2C31mJ6JGVxRY9+66OG0mdUULAXuM4IoIOvt
        3WiXtXSrLWj9pVqEkEsAcI4Dxw==
X-Google-Smtp-Source: ABdhPJzbkqtb9gDlyamEY6GXDbkaBcgQuwPHPrARCA/53an32IHF5fjwl09an3bYpkuXbqXb4/ERGw==
X-Received: by 2002:a5d:4307:: with SMTP id h7mr3529307wrq.353.1610556089109;
        Wed, 13 Jan 2021 08:41:29 -0800 (PST)
Received: from dell.default ([91.110.221.229])
        by smtp.gmail.com with ESMTPSA id t16sm3836510wmi.3.2021.01.13.08.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 08:41:28 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Erik Stahlman <erik@vt.edu>,
        Peter Cammaert <pc@denkart.be>,
        Daris A Nevil <dnevil@snmc.com>,
        Russell King <rmk@arm.linux.org.uk>, netdev@vger.kernel.org
Subject: [PATCH 1/7] net: ethernet: smsc: smc91x: Fix function name in kernel-doc header
Date:   Wed, 13 Jan 2021 16:41:17 +0000
Message-Id: <20210113164123.1334116-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210113164123.1334116-1-lee.jones@linaro.org>
References: <20210113164123.1334116-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/ethernet/smsc/smc91x.c:2200: warning: Function parameter or member 'dev' not described in 'try_toggle_control_gpio'
 drivers/net/ethernet/smsc/smc91x.c:2200: warning: Function parameter or member 'desc' not described in 'try_toggle_control_gpio'
 drivers/net/ethernet/smsc/smc91x.c:2200: warning: Function parameter or member 'name' not described in 'try_toggle_control_gpio'
 drivers/net/ethernet/smsc/smc91x.c:2200: warning: Function parameter or member 'index' not described in 'try_toggle_control_gpio'
 drivers/net/ethernet/smsc/smc91x.c:2200: warning: Function parameter or member 'value' not described in 'try_toggle_control_gpio'
 drivers/net/ethernet/smsc/smc91x.c:2200: warning: Function parameter or member 'nsdelay' not described in 'try_toggle_control_gpio'

Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Erik Stahlman <erik@vt.edu>
Cc: Peter Cammaert <pc@denkart.be>
Cc: Daris A Nevil <dnevil@snmc.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/ethernet/smsc/smc91x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc/smc91x.c
index 56c36798cb111..abd083efbfd74 100644
--- a/drivers/net/ethernet/smsc/smc91x.c
+++ b/drivers/net/ethernet/smsc/smc91x.c
@@ -2192,7 +2192,7 @@ MODULE_DEVICE_TABLE(of, smc91x_match);
 
 #if defined(CONFIG_GPIOLIB)
 /**
- * of_try_set_control_gpio - configure a gpio if it exists
+ * try_toggle_control_gpio - configure a gpio if it exists
  * @dev: net device
  * @desc: where to store the GPIO descriptor, if it exists
  * @name: name of the GPIO in DT
-- 
2.25.1

