Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34664DB5E6
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503251AbfJQSWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:22:17 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36464 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441308AbfJQSWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:22:12 -0400
Received: by mail-pg1-f193.google.com with SMTP id 23so1827571pgk.3
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3pNp+j/nvPO/DENEdL3Uu/6J4q4Vb7xYn+ibWl/NB4g=;
        b=jAT3mAIM9utJ4FdgP/aIp6cCFbeObx0aiY0eheOl2RoUlidP+cRSEV/48kdI3FZ4dP
         LtAdqnxkbojW1XthlQFIeg7LHQJ/X0kGizNvwCazmcxiz1TjZETTjeFaik/dBlOvEPi6
         AQxnvbTEWY57xaLSwGixnr5i4OiyCo1qklKGKhUbXTb1uPIsiBoQeH66YbiX+oQIiARw
         seqp1VegLc8J7ArwzAqJD37FAP10Q1zgohxqpA9h4EZg3BhIxsSmK3sLDwjPJEBwm9yQ
         JdQtAmeoZH/dSl3K6cxXxp4qeO0TjRzHAuZGPuuPTTHbU5Lhen1IQsFzaNO+xqA82nT9
         ImPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3pNp+j/nvPO/DENEdL3Uu/6J4q4Vb7xYn+ibWl/NB4g=;
        b=mgt1K8euWW64M+biK600r2ELCHTbWbv2LdilmqEsnH5wVtdGdvY6uAzxDl1ud4izQo
         QPSF1xQif5JNCRfPBXvRzXb9sWGDGWZfOiBVv6T36pumKyOTiOrclE4zySNHbbdA38o2
         gcCHsuEGnSASmGw+/utYsIwejZfb6puE8mL8gNXofpPfcqwBBwTu1pnMd7M748wTG6p0
         C+LV2TiYL6afJ3ko82ukkQY5LN1KYuYFIIf6J7GnaVQ0T7taRfUOZU/0YyH+i3N6+0ER
         vVGuO9DRYtzwO2a2HmFMT3igw/ZyyOU7nul/PFDO6y61yK1RxZSAhiVbXxbIrDAZc5GJ
         btMQ==
X-Gm-Message-State: APjAAAXo88ANkZHdTQRourkAxib2v8Z04FSLsnT+Jr0HfMY1zJWX5sVL
        HPs1YMqSlIXUdVO0cNOe+QA=
X-Google-Smtp-Source: APXvYqzC5rP/1K+qvnDjit4F6aodwT/Ko4pJZelCqXfhXK6PRB676hdTT8uPIJI+M3gZQVzu9okFsQ==
X-Received: by 2002:a63:4624:: with SMTP id t36mr5612169pga.376.1571336531799;
        Thu, 17 Oct 2019 11:22:11 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:22:10 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 25/33] fix unused parameter warning in smsc911x_dump_regs()
Date:   Thu, 17 Oct 2019 11:21:13 -0700
Message-Id: <20191017182121.103569-25-zenczykowski@gmail.com>
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
  external/ethtool/smsc911x.c:5:48: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  int smsc911x_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: I419e8e365481020241303033fcdfaf31aaf4e178
---
 smsc911x.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/smsc911x.c b/smsc911x.c
index c55b97b..bafee21 100644
--- a/smsc911x.c
+++ b/smsc911x.c
@@ -2,7 +2,8 @@
 #include <string.h>
 #include "internal.h"
 
-int smsc911x_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
+int smsc911x_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+		       struct ethtool_regs *regs)
 {
 	unsigned int *smsc_reg = (unsigned int *)regs->data;
 
-- 
2.23.0.866.gb869b98d4c-goog

