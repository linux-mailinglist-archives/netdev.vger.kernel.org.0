Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B142C4BCD
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 01:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729131AbgKZAIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 19:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgKZAIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 19:08:20 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A492C0613D4;
        Wed, 25 Nov 2020 16:08:20 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id j19so167752pgg.5;
        Wed, 25 Nov 2020 16:08:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=te9bOn9gF8hsomOWKkERjKoUWBxmwagdLDi3NRp+Pr4=;
        b=HSc37bPXvJYZJBprBaal6zeRX/BzSnNXJ/7gXDRWnZ6xpwqIMZCONrcoTClhw/2i5G
         Y9XnLuo/kxrbPAg3g98MkwPcuLkGbma1rRNKXCFTz1iS0RgeAcawQ+U/Mjbtzux7VcBi
         KjMh9kBCYYiac/snlWHzaORVZZ06wodx7XUJLrXQ4tsSCj6H0J0AGbbAjKfRarL3A/qB
         Bc8/LywkCJa9pbt3DRXI34q2aQUMqYPUqUC8C21djByYRMIwIGMVDpRzayXJJKz4rtaX
         CazK5q7LLdqL+KvtJPBNz9S6ZWo3jywweJLv65gAIiKmrzORbZy5fwf8UliOQanDD0UB
         ZlRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=te9bOn9gF8hsomOWKkERjKoUWBxmwagdLDi3NRp+Pr4=;
        b=WQlgxb3SykJC3YQCnuQUhygX7gEQait9mMhRZ0TpQUBlx8kyzLGPpQiQlzZt+h6HLN
         nsI4o9u+51fCk3m3qvwYSzVFPCXHMswZGYZN1XxlGR0xhyGOpIG3n3MKv2Ua3MObiBRv
         oGdmbjuzZOb1MOOIVPHAUHan4KmHCDMzewAU5MhtUHCEPTgMBd06/dhy99bwYZkfF6K2
         mWtAfSoZPR8QKEarQ5Q1If2kzJ6fyn9gtHMumH23u2ZuyskZhld/m3u5M4RhknarO54P
         Ac96rIB3CLTD8v6/EC1hA/cl1KtvsqdtKqXl9HQdDyN+kyOLsTnTI5c1rwKrgwDfF6Pm
         lLjA==
X-Gm-Message-State: AOAM533cSYng47yCKkX8UAvos2IX7y3uGfABLQ8eWBRappBnP7IOm5XF
        IpZfR61J1GwB0ILlG0f71LskltwAcZM=
X-Google-Smtp-Source: ABdhPJxy8e51VocK6sV/UtACMtREkXtbDwVKKns9rESp5UPf6oDoZos+aY5V6UFaZYnp370H2jilqQ==
X-Received: by 2002:a17:90b:1057:: with SMTP id gq23mr319679pjb.179.1606349300065;
        Wed, 25 Nov 2020 16:08:20 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:736d:7f42:a4a5:608f])
        by smtp.gmail.com with ESMTPSA id z9sm4234519pji.48.2020.11.25.16.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 16:08:19 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     andrew.hendry@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 2/5] net/lapb: support netdev events
Date:   Wed, 25 Nov 2020 16:08:14 -0800
Message-Id: <20201126000814.12108-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201124093938.22012-3-ms@dev.tdt.de>
References: <20201124093938.22012-3-ms@dev.tdt.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

Since we are going to assume lapb->state would remain in LAPB_STATE_0 when
the carrier is down (as understood by me. Right?), could we add a check in
lapb_connect_request to reject the upper layer's "connect" instruction when
the carrier is down? Like this:

diff --git a/include/linux/lapb.h b/include/linux/lapb.h
index eb56472f23b2..7923b1c6fc6a 100644
--- a/include/linux/lapb.h
+++ b/include/linux/lapb.h
@@ -14,6 +14,7 @@
 #define	LAPB_REFUSED		5
 #define	LAPB_TIMEDOUT		6
 #define	LAPB_NOMEM		7
+#define	LAPB_NOCARRIER		8
 
 #define	LAPB_STANDARD		0x00
 #define	LAPB_EXTENDED		0x01
diff --git a/net/lapb/lapb_iface.c b/net/lapb/lapb_iface.c
index 3c03f6512c5f..c909d8db1bef 100644
--- a/net/lapb/lapb_iface.c
+++ b/net/lapb/lapb_iface.c
@@ -270,6 +270,10 @@ int lapb_connect_request(struct net_device *dev)
 	if (!lapb)
 		goto out;
 
+	rc = LAPB_NOCARRIER;
+	if (!netif_carrier_ok(dev))
+		goto out_put;
+
 	rc = LAPB_OK;
 	if (lapb->state == LAPB_STATE_1)
 		goto out_put;

Also, since we are going to assume the lapb->state would remain in
LAPB_STATE_0 when the carrier is down, are the
"lapb->state == LAPB_STATE_0" checks in carrier-up/device-up event
handling necessary? If they are not necessary, it might be better to
remove them because it may confuse people reading the code.

