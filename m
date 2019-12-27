Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDEE12B01A
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 02:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfL0BIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 20:08:31 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40968 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfL0BIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 20:08:31 -0500
Received: by mail-wr1-f65.google.com with SMTP id c9so24872480wrw.8;
        Thu, 26 Dec 2019 17:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5qBV6ew8s1N9fYUvOO0//bKF0z9LM7TG1Jue/fyKu08=;
        b=moPTOwvT8uvt49GZN7zaIzKkufqm9i+wrMk1WQjL7iqiq/frC9V8v0wCSbBdo9wKBK
         0OSPOav6J++wUCdNQWdM19K8y51HPGN/y31Nas3hEDQxODhlwqLF2IQ5hs7TV8Vbchyw
         0+znjNEqqA2Cu1zR6w1gejouUSlCPPbjHV+Wty7XJYY2s+oKX5Dibpv81z67CuoElo2v
         EjF5uuwi9Q7V1MQJSLyMAbNvIQlSkkeZbbczjh+zVcuoaeTu9/0ZxeM44Sm3T75deusV
         9YXSkhUtC+pvQyem0lei7ZYdz55Opi3eu7HJ4Wwc8f3MFfn8TCIpwVv74NqdvNj+ro84
         pzAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5qBV6ew8s1N9fYUvOO0//bKF0z9LM7TG1Jue/fyKu08=;
        b=QLntxK1szxXG5NUn/NciHGTIpucqmWLpUAEoRhOo72d4m1jxYEY5WDgJ1aPEvP3JX2
         pfLa3KrTU9N59QR2b3P90rkTnv5HUpYNCuaVTtfM6wrmmpqBZitkiWUFSYo39zUG2UYT
         +wSIbcPmKtsXyYeDzAGXHXmmJ8Y7W5AKt6N5kcS8wGnFQ5qBgrmYUC/ujXDVy9UtAT56
         c3pHhtJVBLHjRNXvvVjsgWHAtkD15mEI9NCATHvx74SEuIas4MPEXvZmTo6ifIB5S7pN
         055AL98hhGJBa+5hBHRZ4l567NLk0sh+Ny0vzqQcedIAS1Xc6XNv2RRsD1eg3SeSVP7o
         tXDQ==
X-Gm-Message-State: APjAAAUkd7sLueTtTyly2BbZw49gJPAM9eVbzGweFiF6RM2s0olayjdB
        P+oGYn5Hv0AlzicHAsYGinnPIc4f
X-Google-Smtp-Source: APXvYqzIZAa89bWOQ/ThgJghnMhYymq2HvJKTz8l8x8HNIL818T+lRZCrFZYqZJymlRGHTx0HdpYaQ==
X-Received: by 2002:a5d:53c1:: with SMTP id a1mr45680029wrw.373.1577408908840;
        Thu, 26 Dec 2019 17:08:28 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id f1sm33506409wrp.93.2019.12.26.17.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 17:08:28 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     corbet@lwn.net
Cc:     davem@davemloft.net, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH] Documentation: net: dsa: sja1105: Remove text about taprio base-time limitation
Date:   Fri, 27 Dec 2019 03:08:07 +0200
Message-Id: <20191227010807.28162-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 86db36a347b4 ("net: dsa: sja1105: Implement state machine
for TAS with PTP clock source"), this paragraph is no longer true. So
remove it.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 Documentation/networking/dsa/sja1105.rst | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/Documentation/networking/dsa/sja1105.rst b/Documentation/networking/dsa/sja1105.rst
index 21a288aa7692..35d0643f1377 100644
--- a/Documentation/networking/dsa/sja1105.rst
+++ b/Documentation/networking/dsa/sja1105.rst
@@ -245,12 +245,6 @@ simultaneously on two ports. The driver checks the consistency of the schedules
 against this restriction and errors out when appropriate. Schedule analysis is
 needed to avoid this, which is outside the scope of the document.
 
-At the moment, the time-aware scheduler can only be triggered based on a
-standalone clock and not based on PTP time. This means the base-time argument
-from tc-taprio is ignored and the schedule starts right away. It also means it
-is more difficult to phase-align the scheduler with the other devices in the
-network.
-
 Device Tree bindings and board design
 =====================================
 
-- 
2.17.1

