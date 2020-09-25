Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E20E278C9A
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 17:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbgIYP0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 11:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729041AbgIYP0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 11:26:37 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48484C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 08:26:37 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id y14so2855255pgf.12
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 08:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/g1MNPK7NzqcDjo9blVGLfANJvMJDOVvngLo2LA0bAc=;
        b=DSTicEMRaa5gJnsfyAiQz048v3Qbdio+XsSz/jZa+xuBi1yZGDQnRo7DptvcPzDYQT
         AVvzmxIcmPi2L0y2ioWg26QUoUB1q7/0M5sjLaMB5gqv43Eu8VZoe08jLuGuYOW8i//S
         ZICkc6YbH7g93YqiuCE4buQQxQiV3Hu61IbqXa4D2FvVtBizyYFs3A9n7PXS+FIfege/
         uBD8ZJnEWTcBKU8+yRTpZRqr+fXQ6ceeXxwukoEwrjRKRPGDFWgK6wKpZ+s2OahSK352
         tpRhRjKQJa/etTKUHyQsFYzqNf0M6mQh6La2ed0rPWIIrTJ2n9/QWtm8ePCljVooHGom
         2BDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/g1MNPK7NzqcDjo9blVGLfANJvMJDOVvngLo2LA0bAc=;
        b=glgUxXTzusotxJeZ5RSDqgLlT9SO1NjokdZaWyOgP9aQKiGaNMrXq7rR5qASMvEZWo
         tTYjWJUaVj5StK1G82fw0CtphscIwpCnu0j9tSLU4yVHAUhbqLbvhACfbhGQ7oDvJvsa
         GtWArjpaiTI/ctPmQdduSJz6iXNsUW7//DNZi10zWFxt7ALDiW14nurdOuSaYcz0pVkt
         YBPpdcq0QUWSgPZ4fIaoxvlya1MH33y3gYAVDWz+IBhkMXw9g3NiqOa8OMubx7sSuz/d
         1QJE2uxeKiZqmAgM39yVojh8uW+/+/cXo4+n5/8kU3Fjbo6B2WoQeY5cKnJHZcUP30eh
         T8Hg==
X-Gm-Message-State: AOAM533560bRAJ2RXur21A/XHTN9CBXouJOGawF81EvbaftgMjJ2Uc+5
        t22MUoJc8jJj+R80U7PJLZjMnCHcuibT8w==
X-Google-Smtp-Source: ABdhPJz+jOV9Ys7mEzr06tOHDwMUvjzJvVQCM2UB9ecnLxy35t2dW3AHCdxhISHXNI4TFje2O6rzTQ==
X-Received: by 2002:a17:902:6a88:b029:d2:4365:304e with SMTP id n8-20020a1709026a88b02900d24365304emr5105931plk.9.1601047596220;
        Fri, 25 Sep 2020 08:26:36 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id mh8sm2395604pjb.32.2020.09.25.08.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 08:26:35 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net] MAINTAINERS: Add Vladimir as a maintainer for DSA
Date:   Fri, 25 Sep 2020 08:26:16 -0700
Message-Id: <20200925152616.20963-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9350506a1127..6dc9ebf5bf76 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12077,6 +12077,7 @@ NETWORKING [DSA]
 M:	Andrew Lunn <andrew@lunn.ch>
 M:	Vivien Didelot <vivien.didelot@gmail.com>
 M:	Florian Fainelli <f.fainelli@gmail.com>
+M:	Vladimir Oltean <olteanv@gmail.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/
 F:	drivers/net/dsa/
-- 
2.25.1

