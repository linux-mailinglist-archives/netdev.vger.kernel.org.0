Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEFFDDB602
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503206AbfJQSVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:21:47 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44737 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503201AbfJQSVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:21:45 -0400
Received: by mail-pg1-f196.google.com with SMTP id e10so1804721pgd.11
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J2/gcZ6UdGYIkv32OLwfjRo2Q/x6794+l/k30en23VQ=;
        b=CDyjhzdusqGvOe9cjtrCDmEIfpYY9VUJGNOx/stQbuXd0zwA0G4QcmmipqwMUrStXw
         mdboLOQQsqAVYcrtD+EUvgC5GIpqWoUKgOem/HtB4wNXtTfeTZRKFr042/vGDI1SjcHl
         3Ix/ZJHQemRdXikTqkFqbBVp+/bMbGmSiUnIutwXoKvMPd1+9pL5sMZjzp8+DdhwDYyY
         ms0vz56TOCxIct40x8CHVLnP+I8ewcygiUIti09yA5yaXJG+eOPbPljt+ak6Wp7tkSD8
         8O50bBbQeSgFIv+drgzA1QXwpeFn3KzUjcsaV/FiIiSO5FUL+M6Z/BPu6HzPrw7PFW4o
         6f+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J2/gcZ6UdGYIkv32OLwfjRo2Q/x6794+l/k30en23VQ=;
        b=hIB3dYzYdRhmj1jDq6Ff/23mamzBo8aimD/VhnCdNSc5qcupVTbqk7VZMU9LaMRuFD
         6XxNM3XrvfkSHt5i6j19v3gweDZZUH7aLuBYjnUEUF0o59aygonDKhktGJNZGwYwxHDC
         TekaGc1X4kfBMsyaw3YTCwUWy8J6Zlw/O6UUg/SPME2SMfABhwBFVdgqM8m0C1A84UmJ
         1+6d61tHtygV6KJePsL2sGF6dF+HK2dqMV79aH15FOlb7tWcBbXVfA4XmPBosRCtoGOh
         bcbbChDL6P7EEnlBgtyK8KnxNSfqvrW3qKKi12tCHdYqsUInhPNj8eZPKJozfvWYQZsy
         Eacg==
X-Gm-Message-State: APjAAAWMwe0mUdLxAbV+GQVIiLDPD9Q57/IFbJ58fPhICKOABUU/1pWF
        pz/ZSyiyAKjusomE5M8KY7U=
X-Google-Smtp-Source: APXvYqwR5n2ciXpBdEyq9cqz+RWzR+dvPP6s+f6/N5LOIYWobEbCAvJfOoRh85BEbnM1x2lrNejYug==
X-Received: by 2002:a17:90a:bc41:: with SMTP id t1mr5981397pjv.67.1571336503525;
        Thu, 17 Oct 2019 11:21:43 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:21:42 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 05/33] fix unused parameter warning in altera_tse_dump_regs()
Date:   Thu, 17 Oct 2019 11:20:53 -0700
Message-Id: <20191017182121.103569-5-zenczykowski@gmail.com>
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
  external/ethtool/tse.c:28:50: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  int altera_tse_dump_regs(struct ethtool_drvinfo *info,

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: I555f0e3c55bba999aeb64f1e1435744590ea389d
---
 tse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tse.c b/tse.c
index f554dfe..e5241ee 100644
--- a/tse.c
+++ b/tse.c
@@ -25,7 +25,7 @@ bitset(u32 val, int bit)
 	return 0;
 }
 
-int altera_tse_dump_regs(struct ethtool_drvinfo *info,
+int altera_tse_dump_regs(struct ethtool_drvinfo *info maybe_unused,
 			 struct ethtool_regs *regs)
 {
 	int i;
-- 
2.23.0.866.gb869b98d4c-goog

