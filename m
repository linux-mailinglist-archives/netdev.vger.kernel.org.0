Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9153B1E91E8
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 16:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgE3ODn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 10:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729034AbgE3ODm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 10:03:42 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1268BC08C5C9
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 07:03:42 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id ds18so863630ejc.7
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 07:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pwrB0jbi6hsDgo77BasrQveuoLZdVMTzxANGjfIpuHY=;
        b=b8oyExNt/Nfu5ekeLMVLhoy+DKjFlphWAoHgusiyJpGhQ2Ji0WS4oauJiXu8bU52qi
         BbmSZ30wjBt3es86Ls5vx6uEcTzDVXr5e3xeU40S4R4uQ8mW257fO6iTBzaLCKhyaGpB
         BSVzMwCvhp4r6PowzOaDYiPF31nCZKngDBt/vQVwHP2fQgGZtiRImoR2diFJNaLMJlLs
         A00KjAPIbAGZEdr/70Jg3WJEJF/lvNqGpv4zf/0XQvycQSL6yqqPOr8sfsYv1Ki9XfBL
         iRZoQKDR4oSS7zI2tbrYKu8NhDGztMn0YB2MIgyG1p1ZJs9dtmFnHM/EOsTfgZiWmHRT
         XjxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pwrB0jbi6hsDgo77BasrQveuoLZdVMTzxANGjfIpuHY=;
        b=mEjdTHOe3zzo64o4ihN9TXifOA7f36CtrAo/n+FvH4yMWvNPLXDU1cOgAXjTklxHjZ
         pRCyeGOWrWYVZiHNYvvPqH63HPsFEmfhUJSdoSFm+zIMd44JsFF2CtS8BMd5jNpyIu6i
         c0qeRx435PXagKzLc3ek0DZcSLNY4MHPeS8CEkut0oxUtAtoW+2GDuIY6UwGY2AuBZ9v
         xPj0+6bkYi3vCyRgqBfLyhn1VPmRDzoTtE4/3Ub8/6Lz8ncoNdKAfbVy2dK80kqrGsRy
         wXboaJ4kjtry1ln1c0FNwrKSd8RU4PJm8RpV2yMpLbOavdTk8M0rYQgpyt8rzfe1B+dx
         rN9Q==
X-Gm-Message-State: AOAM531C+3Scoo/Slsy113ozc10FeLPFvk4l8d30uUxIxUwJ4b/D/XZk
        SI3sMo1MkXkWUwlJE+0BE4zMuQ1e
X-Google-Smtp-Source: ABdhPJwi1EjZ/8KvSQ4lDzTCcmu6MER3wuq6706cRgznKWzIycVHd8e2R3QSt/dOoYOjsrSQfVoApA==
X-Received: by 2002:a17:906:971a:: with SMTP id k26mr312407ejx.230.1590847420790;
        Sat, 30 May 2020 07:03:40 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id ch8sm9903220ejb.53.2020.05.30.07.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 07:03:40 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] net: dsa: sja1105: suppress -Wmissing-prototypes in sja1105_vl.c
Date:   Sat, 30 May 2020 17:03:22 +0300
Message-Id: <20200530140322.803136-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Newer C compilers are complaining about the fact that there are no
function prototypes in sja1105_vl.c for the non-static functions.
Give them what they want.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_vl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index f37611885376..41ef95e750aa 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -3,6 +3,7 @@
  */
 #include <net/tc_act/tc_gate.h>
 #include <linux/dsa/8021q.h>
+#include "sja1105_vl.h"
 #include "sja1105.h"
 
 #define SJA1105_SIZE_VL_STATUS			8
-- 
2.25.1

