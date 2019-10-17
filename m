Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADE5ADB5EB
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503267AbfJQSWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:22:23 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33388 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503219AbfJQSWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:22:19 -0400
Received: by mail-pg1-f196.google.com with SMTP id i76so1837708pgc.0
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FGAZe6VmyGfURZZFK8uSiZz7+1AA13mBjsuy49ESpLw=;
        b=AdRv8EIXpav3wHVuLQBIzdTHvrWXXzkI6oMrFSrLeOU6Z5ud2WrMUXBsFlhrSWtEQJ
         SLdY7pQqE93fZ/JncdTzklOBWvEsLfT34jQ6vNUmUcZQnBOcWdUHv/cBMdklull95hp0
         Hlo9kwqJt7y1Ouj6yf7vRVUBsvOVbA5GtP2cxBFzCI4gHMLGbW3LlMfbaIBxsCh71R+o
         3D9rEL3iKNKVDb4BWOMpho5URAaRoIGuCFmxyeO7MqJi6zE1ETWOhFtWTALbQ++D//Qy
         gQaxm/Rk1NTLxZWZVB8KbPqcFIjNUd+D/jMWWSw4AmLs69rDCwojPgqHARs33g6PdVx1
         sjQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FGAZe6VmyGfURZZFK8uSiZz7+1AA13mBjsuy49ESpLw=;
        b=m3K1JovkK9seQeKIDR05vcSpAwpdxit589coSGAhX71TFcQtO09jVjuytl7blBphNH
         l0ZlRqXF8sfA7qIIChlK4ApIbcSaqsKBVL57aAXAEvh0cmiDhpRFRZhnRokbw6JLlqqY
         jsrHnU28rKGTGzh0JqhV2VnN79FejCZ+/96yhlaURmXlbbQBZjrzrIi/82bKWR0joGHC
         gi+cT2AYpOsfMrsY3857jAJRcl67hrcuJBYsJfvpwSJ23n7C1aAOdZkMC6O5tClyX6DY
         TuFxqpPCFeH6lLEMOnITG4W4QKYY3G7R6k0a61yXxwtcliWIl6agbQQOuXyST8dUi7pL
         XMPA==
X-Gm-Message-State: APjAAAVjgHZSsZYVwm9oq9ehckve1X/hQmlXgS+4Z00ft7f+TB+THsgm
        yrBqMZyk96k6VVQrWnlgwl0=
X-Google-Smtp-Source: APXvYqzUL2c0T9Ywu2Vn6cLTCGO1BmE8RQ29pAUVg0e7LR0/B82YXWR98h73oKWVVWS9rots9Cgm6w==
X-Received: by 2002:a17:90a:80ca:: with SMTP id k10mr6045867pjw.35.1571336539002;
        Thu, 17 Oct 2019 11:22:19 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:22:18 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 30/33] fix unused parameter warning in ibm_emac_dump_regs()
Date:   Thu, 17 Oct 2019 11:21:18 -0700
Message-Id: <20191017182121.103569-30-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
In-Reply-To: <20191017182121.103569-1-zenczykowski@gmail.com>
References: <CAHo-Ooze4yTO_yeimV-XSD=AXvvd0BmbKdvUK4bKWN=+LXirYQ@mail.gmail.com>
 <20191017182121.103569-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This fixes:
  external/ethtool/ibm_emac.c:317:48: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  int ibm_emac_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: I18f305612e48ae76031ae327acf134d1623a8a3d
---
 ibm_emac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ibm_emac.c b/ibm_emac.c
index 75cb560..3259c17 100644
--- a/ibm_emac.c
+++ b/ibm_emac.c
@@ -314,7 +314,8 @@ static void *print_tah_regs(void *buf)
 	return p + 1;
 }
 
-int ibm_emac_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
+int ibm_emac_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+		       struct ethtool_regs *regs)
 {
 	struct emac_ethtool_regs_hdr *hdr =
 	    (struct emac_ethtool_regs_hdr *)regs->data;
-- 
2.23.0.866.gb869b98d4c-goog

