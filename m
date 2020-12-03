Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651672CD610
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 13:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730538AbgLCMut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 07:50:49 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:52111 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730506AbgLCMur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 07:50:47 -0500
Received: from orion.localdomain ([95.118.71.13]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MQy0N-1kZRNh0hRX-00NvnC; Thu, 03 Dec 2020 13:48:06 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     rspringer@google.com, toddpoynor@google.com, benchan@chromium.org,
        rcy@google.com, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, f.fainelli@gmail.com, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        nsaenzjulienne@suse.de, speakup@linux-speakup.org,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 02/11] drivers: staging: gasket: remove unneeded MODULE_VERSION() call
Date:   Thu,  3 Dec 2020 13:47:54 +0100
Message-Id: <20201203124803.23390-2-info@metux.net>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20201203124803.23390-1-info@metux.net>
References: <20201203124803.23390-1-info@metux.net>
X-Provags-ID: V03:K1:5cNNaj3L1/oSaoHWBOWl0bfD/3mFxrG/x2hhKeTIwCx0/LVUkqJ
 9NVSdVPi4tZ8L7wKa7HtR7+OYYkwTIuZXgExz+2yWHIHjzhMXdwkO221R8mu8e3PmZ3gxGh
 KVPomrKpJKUobLqzoQICc41cHBibPpHdW0AblAT4iJkB/TZQGkencXQEj2T/2HetV82Yyph
 PD7FG5NSALtrKTRLxAo+A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ch9o7BlYNY0=:PCQG1wY9TcGzs26MLv2lEQ
 JI/cf0W1LfysAd/VFg13X3YS5gKmsaf3j9MEDQEMb5cNyUKy4CQqjdekZG0SxCW2dE62/VfPl
 xTtXC5ypyvj/C1VNLHFuavsgs4xmO3lRF26k8gKGTS7ZSfW55AjQ7ntjoFWjrL2sU3W9C6Twj
 p3t2OVVPRHH0oqA5WWFfBeN77/Pk45kF5WCzNclG0FJgCz/S63wcjXL6GEUgga+or2MtkPUAY
 O9PygrJ8tBk+sDOpX6KMNbKyRm0tTc7fgdawzvC75cNjo+FsAmuj4uLwZ6QpQQuRwzXRniWaZ
 2PnovUxiYTTcJuUu8cbmygnPsYvZmIcvCozRwU3nieAYD1UWyw16aZjcTwOxlaKrlIwZD521m
 OuxFxIWDTyckIpwES9kNKA3PhBhQ5QJHmLqZrgYwc2BIP/Y+i3wV8/W+qIVEk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove MODULE_VERSION(), as it doesn't seem to serve any practical purpose.
For in-tree drivers, the kernel version matters. The code has received lots
of changes, w/o the versions being actively maintained, so it doesn't seem
to have much practical meaning.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 drivers/staging/gasket/apex_driver.c | 1 -
 drivers/staging/gasket/gasket_core.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/gasket/apex_driver.c b/drivers/staging/gasket/apex_driver.c
index f12f81c8dd2f..66ae99bebfd8 100644
--- a/drivers/staging/gasket/apex_driver.c
+++ b/drivers/staging/gasket/apex_driver.c
@@ -718,7 +718,6 @@ static void apex_exit(void)
 	gasket_unregister_device(&apex_desc);
 }
 MODULE_DESCRIPTION("Google Apex driver");
-MODULE_VERSION(APEX_DRIVER_VERSION);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("John Joseph <jnjoseph@google.com>");
 MODULE_DEVICE_TABLE(pci, apex_pci_ids);
diff --git a/drivers/staging/gasket/gasket_core.c b/drivers/staging/gasket/gasket_core.c
index 28dab302183b..763d5ea45e68 100644
--- a/drivers/staging/gasket/gasket_core.c
+++ b/drivers/staging/gasket/gasket_core.c
@@ -1809,7 +1809,6 @@ static int __init gasket_init(void)
 }
 
 MODULE_DESCRIPTION("Google Gasket driver framework");
-MODULE_VERSION(GASKET_FRAMEWORK_VERSION);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Rob Springer <rspringer@google.com>");
 module_init(gasket_init);
-- 
2.11.0

