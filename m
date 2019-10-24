Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAD1E2785
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 02:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391836AbfJXAt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 20:49:26 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:41014 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407738AbfJXAtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 20:49:22 -0400
Received: by mail-pf1-f175.google.com with SMTP id q7so13973486pfh.8
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 17:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UL4YoAgVjljaV9SpY3P+fcAsvdORWO94x8YI79oYmRA=;
        b=QS1X/uyI73ouhqjrimE/VE4AfGKOPBPwXzPLx3uAB8XOgC2yy5YGTvyCt5cA8uTs3S
         tH5lWf3xWhcBsJiufFiXR/m5+AZXUKn2mrfsxk+ooaGO3aLMihPHtJSjOp+eqpfZBMCW
         slMnDF2hup30NeKZ58rShxG4FoQb1GJ9kbqQTjPGna31YIysN3TBA6YbaBZhE8zafUh5
         l2bWCA32wpJFQ1Eqo/nMl9JYgDxdtDl422uBpVlguxZhqh+zc2uIwpXbrGP7d1tOv6aT
         OwfkXe/2MhGXi1hGwQ86M4Ui1dzk2ro50nRht22niA5w/IQvSG1Sz4AQZCwrJpoLEEgS
         NMzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UL4YoAgVjljaV9SpY3P+fcAsvdORWO94x8YI79oYmRA=;
        b=BdQ4n5CXo/0jXpZNApYn8DNlunHSFbVPwds6DEiBNUYWibdhH10TlV09LGpHZA7tc7
         iO+zi31AEXchId0m2pBdrY/jd607RWweP8NxMQe1YYcnAMW7n1LN3mj05jWFipx0djI4
         b1q9ele+e+eGilJPIitWa+KlnfDHCWq+M/hAFDg8URmY6pFKYce3K+/QGtjBXTjXEqJh
         EDEkrme8TACAm/QCGc5wvGfwBppUMq6r/2lTqoQQQIQpuNLKeCOJv+0nSzpoiF+rskOr
         zsx6sH12zJz5YoueyqUzfRYoJavbxIY2B2HKRyN/QOXoC5PxdsVu+k4OGQo/O1OiK06A
         L3TA==
X-Gm-Message-State: APjAAAV7CBqAQV0bmDxO5fc9eXw6g2Wl41/EOU2HjaOlr72Zzagn3q0z
        oNQKdRuo1G7TnsZM9ZpF4Rv33wRFRoy4Nw==
X-Google-Smtp-Source: APXvYqwWHRBWKsRoW9ueEQKh137+KcEv6hEFIbaXwdrX8ZlXsEa3M0En4ryKWVlspb7LV6UxzkNDKQ==
X-Received: by 2002:a63:4e09:: with SMTP id c9mr12698105pgb.98.1571878161370;
        Wed, 23 Oct 2019 17:49:21 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id b3sm24696440pfd.125.2019.10.23.17.49.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2019 17:49:20 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 6/6] ionic: update driver version
Date:   Wed, 23 Oct 2019 17:49:00 -0700
Message-Id: <20191024004900.6561-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191024004900.6561-1-snelson@pensando.io>
References: <20191024004900.6561-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 5b013250f8c3..98e102af7756 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -12,7 +12,7 @@ struct ionic_lif;
 
 #define IONIC_DRV_NAME		"ionic"
 #define IONIC_DRV_DESCRIPTION	"Pensando Ethernet NIC Driver"
-#define IONIC_DRV_VERSION	"0.15.0-k"
+#define IONIC_DRV_VERSION	"0.18.0-k"
 
 #define PCI_VENDOR_ID_PENSANDO			0x1dd8
 
-- 
2.17.1

