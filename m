Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE89B212F55
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 00:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgGBWOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 18:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbgGBWOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 18:14:00 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E23BC08C5C1;
        Thu,  2 Jul 2020 15:14:00 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id x11so11832374plo.7;
        Thu, 02 Jul 2020 15:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6oWu8CGvUHxicXVBr6Djg+FI6SK9f+5RLFtIeKJCKoQ=;
        b=Kg6yLeFQkYuYlGuTGlH8RpB/8QyZN7ayi8Kmblyda3HyVQW8KZarHzTEO8j9QiIQQ2
         Ojyw1CijRsJmicug/Cc/ouz7/zxT6z45Ls2cIyk2euuvZ04DbKj3pIIFNOby+jBti/iW
         f94ZMLPw/RrmZbPTVpXHLles2/HvxgPRn1fUZWUWDO3nL8iiWvKZnnY2i1rYV+KXZbyl
         U/CyLRJtpBd1uWKL4yZu3qfZpdWu0OZ/nmLCgI6OwcdluJg9LS3L7U5AcNZNcQQFrpnR
         xQgK59XDDBAYP1AOvrXQNYbVvJuzg5NaJf1wbmeP9k4xlirDBsKue62x9TaU/Whbv6Hs
         v81g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6oWu8CGvUHxicXVBr6Djg+FI6SK9f+5RLFtIeKJCKoQ=;
        b=VVKo8hlO9PMj5HlHnnCafgYOuVyQP+lX7k13qRs9HvnhrInYKUZ9DLURtMRqXC/enB
         0F+HWX6QvR2OhV9g1+dJmbmtX4jCj76F6nMs0iNdxTf5NulYwv9wXIovaic5OaXji9m/
         qIoVrWcFKVlx5yUg0HlFLyY1BQK0nYNJa14dhp91neDvy+/Z1e80eyg/lOlYsDoPAkl9
         5JYip3Jk5OClLsJlQ6xN9NI60I21mIhkBOgc42zl8gLXJ7/hXPuw/bD6peTae2PyoYq2
         478dsfMKEqqvpXMfEIPED8HUI99AdldazaGfWfpNpA3xrRwezuMq5VMnzq03hYDklqM/
         TUmQ==
X-Gm-Message-State: AOAM532fKJm/Q0K3g6WDN30bUWexdGqjZClDrLemd2j8F6qXRY7eMzK0
        81u9i8qfDiSi8cTi8s5eIIQ=
X-Google-Smtp-Source: ABdhPJyVFpqOvhx2lOLP9HTgx4ksvqPWVFw5kfuwAYv84vVPBxgiuYi8T6w/iZ621zdxYYC2MmlsBA==
X-Received: by 2002:a17:902:9a02:: with SMTP id v2mr28968513plp.321.1593728039427;
        Thu, 02 Jul 2020 15:13:59 -0700 (PDT)
Received: from taoren-ubuntu-R90MNF91.thefacebook.com (c-73-252-146-110.hsd1.ca.comcast.net. [73.252.146.110])
        by smtp.gmail.com with ESMTPSA id nl8sm8979501pjb.13.2020.07.02.15.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 15:13:58 -0700 (PDT)
From:   rentao.bupt@gmail.com
To:     Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <jdelvare@suse.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        openbmc@lists.ozlabs.org,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>, taoren@fb.com
Cc:     Tao Ren <rentao.bupt@gmail.com>
Subject: [PATCH] hwmon: (pmbus) fix a typo in Kconfig SENSORS_IR35221 option
Date:   Thu,  2 Jul 2020 15:13:49 -0700
Message-Id: <20200702221349.18139-1-rentao.bupt@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tao Ren <rentao.bupt@gmail.com>

Fix a typo in SENSORS_IR35221 option: module name should be "ir35221"
instead of "ir35521".

Fixes: 8991ebd9c9a6 ("hwmon: (pmbus) Add client driver for IR35221")

Cc: Samuel Mendoza-Jonas <sam@mendozajonas.com>
Signed-off-by: Tao Ren <rentao.bupt@gmail.com>
---
 drivers/hwmon/pmbus/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/pmbus/Kconfig b/drivers/hwmon/pmbus/Kconfig
index 3ad97fd5ce03..e35db489b76f 100644
--- a/drivers/hwmon/pmbus/Kconfig
+++ b/drivers/hwmon/pmbus/Kconfig
@@ -71,7 +71,7 @@ config SENSORS_IR35221
 	  Infineon IR35221 controller.
 
 	  This driver can also be built as a module. If so, the module will
-	  be called ir35521.
+	  be called ir35221.
 
 config SENSORS_IR38064
 	tristate "Infineon IR38064"
-- 
2.17.1

