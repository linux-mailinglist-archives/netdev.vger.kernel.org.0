Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91022CD613
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 13:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730577AbgLCMve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 07:51:34 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:44283 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730502AbgLCMut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 07:50:49 -0500
Received: from orion.localdomain ([95.118.71.13]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1N2jO8-1k1WXp1v8W-0135VV; Thu, 03 Dec 2020 13:48:05 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     rspringer@google.com, toddpoynor@google.com, benchan@chromium.org,
        rcy@google.com, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, f.fainelli@gmail.com, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        nsaenzjulienne@suse.de, speakup@linux-speakup.org,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 01/11] drivers: staging: speakup: remove unneeded MODULE_VERSION() call
Date:   Thu,  3 Dec 2020 13:47:53 +0100
Message-Id: <20201203124803.23390-1-info@metux.net>
X-Mailer: git-send-email 2.11.0
X-Provags-ID: V03:K1:2y8lEqcYnL2cBhFNRzxmlZlDfDvW7WCjo5V1dlbOXb4jKG4jY/S
 cb/XYaDxgxA9QzRw281fwgHAFnH/0j5LuCB/mq02pO6YDeRPkBXxvWQQ/oWiJYeo/IWK49C
 0JLh8zQo6WOt91WRQ0hLcy8eX+9GAHOXHv35ilU6VjIQ3kFLDeiHl6vjvJ0JKMlVrCaV3wn
 OWeqrvLscDtIia9z0W5QA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:8YQQZCRYH6M=:4eWnAdVI6COiV7xTKFuxgz
 5Sqp7KuEo5o0qsnXsPM9Fx36tkR7kIExtV/EXzBviWdFSZfF/y3vazsyQP0pPp8M8bedP6XVd
 yziv+FqEbzIlKnBe80IwphhKgto91CITmXj+kcF1RYoOiV294Ip8lvHAXUusjWRTSQ43dgPRF
 Rvi3a8c7TWrTMM89KrdaSNX/AShcmiwe9eL/YHuYTDboTURoyFJcMFMx8f2WeQalRngCHa/+Z
 RjupiXkrznWEpRusR+nd8mhSZw/F+CxEgjulKP4otcESBHuXiwzP69zFkcmv3Kz0nmgWFPY94
 TWs7eTGM1J3pIESuTtzVoLt6B1aAT4yXGwfKm9SYR7r1XdrcneAFQIIkRuosYPFP/IZflKKck
 kVz3bmHCFoS08FLYw7iDlSijY2xsXCs5OgM+ZolpcjNy87yM47NiDv/fe4Mt8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove MODULE_VERSION(), as it doesn't seem to serve any practical
purpose. For in-tree drivers, the kernel version matters.

The drivers have received lots of changes, without the module version
(or the underlying DRV_VERSION macro) ever changed, since the code
landed in the kernel tree. So, it doesn't seem to have any practical
meaning anymore.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 drivers/accessibility/speakup/main.c           | 1 -
 drivers/accessibility/speakup/speakup_acntpc.c | 1 -
 drivers/accessibility/speakup/speakup_acntsa.c | 1 -
 drivers/accessibility/speakup/speakup_apollo.c | 2 --
 drivers/accessibility/speakup/speakup_audptr.c | 2 --
 drivers/accessibility/speakup/speakup_bns.c    | 2 --
 drivers/accessibility/speakup/speakup_decext.c | 1 -
 drivers/accessibility/speakup/speakup_decpc.c  | 1 -
 drivers/accessibility/speakup/speakup_dectlk.c | 1 -
 drivers/accessibility/speakup/speakup_dtlk.c   | 2 --
 drivers/accessibility/speakup/speakup_dummy.c  | 2 --
 drivers/accessibility/speakup/speakup_keypc.c  | 1 -
 drivers/accessibility/speakup/speakup_ltlk.c   | 2 --
 drivers/accessibility/speakup/speakup_soft.c   | 1 -
 drivers/accessibility/speakup/speakup_spkout.c | 2 --
 drivers/accessibility/speakup/speakup_txprt.c  | 2 --
 16 files changed, 24 deletions(-)

diff --git a/drivers/accessibility/speakup/main.c b/drivers/accessibility/speakup/main.c
index 48019660a096..d512f4775ae1 100644
--- a/drivers/accessibility/speakup/main.c
+++ b/drivers/accessibility/speakup/main.c
@@ -46,7 +46,6 @@ MODULE_AUTHOR("Kirk Reiser <kirk@braille.uwo.ca>");
 MODULE_AUTHOR("Daniel Drake <dsd@gentoo.org>");
 MODULE_DESCRIPTION("Speakup console speech");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(SPEAKUP_VERSION);
 
 char *synth_name;
 module_param_named(synth, synth_name, charp, 0444);
diff --git a/drivers/accessibility/speakup/speakup_acntpc.c b/drivers/accessibility/speakup/speakup_acntpc.c
index c94328a5bd4a..4d9ebf8b3460 100644
--- a/drivers/accessibility/speakup/speakup_acntpc.c
+++ b/drivers/accessibility/speakup/speakup_acntpc.c
@@ -315,5 +315,4 @@ MODULE_AUTHOR("Kirk Reiser <kirk@braille.uwo.ca>");
 MODULE_AUTHOR("David Borowski");
 MODULE_DESCRIPTION("Speakup support for Accent PC synthesizer");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
 
diff --git a/drivers/accessibility/speakup/speakup_acntsa.c b/drivers/accessibility/speakup/speakup_acntsa.c
index 3a863dc61286..1dc2fd99043f 100644
--- a/drivers/accessibility/speakup/speakup_acntsa.c
+++ b/drivers/accessibility/speakup/speakup_acntsa.c
@@ -140,5 +140,4 @@ MODULE_AUTHOR("Kirk Reiser <kirk@braille.uwo.ca>");
 MODULE_AUTHOR("David Borowski");
 MODULE_DESCRIPTION("Speakup support for Accent SA synthesizer");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
 
diff --git a/drivers/accessibility/speakup/speakup_apollo.c b/drivers/accessibility/speakup/speakup_apollo.c
index 0877b4044c28..ce215fb3f7ff 100644
--- a/drivers/accessibility/speakup/speakup_apollo.c
+++ b/drivers/accessibility/speakup/speakup_apollo.c
@@ -204,5 +204,3 @@ MODULE_AUTHOR("Kirk Reiser <kirk@braille.uwo.ca>");
 MODULE_AUTHOR("David Borowski");
 MODULE_DESCRIPTION("Speakup support for Apollo II synthesizer");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
-
diff --git a/drivers/accessibility/speakup/speakup_audptr.c b/drivers/accessibility/speakup/speakup_audptr.c
index e6a6a9665d8f..e4733215b5a9 100644
--- a/drivers/accessibility/speakup/speakup_audptr.c
+++ b/drivers/accessibility/speakup/speakup_audptr.c
@@ -167,5 +167,3 @@ MODULE_AUTHOR("Kirk Reiser <kirk@braille.uwo.ca>");
 MODULE_AUTHOR("David Borowski");
 MODULE_DESCRIPTION("Speakup support for Audapter synthesizer");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
-
diff --git a/drivers/accessibility/speakup/speakup_bns.c b/drivers/accessibility/speakup/speakup_bns.c
index 76dfa3f7c058..6783b007c020 100644
--- a/drivers/accessibility/speakup/speakup_bns.c
+++ b/drivers/accessibility/speakup/speakup_bns.c
@@ -124,5 +124,3 @@ MODULE_AUTHOR("Kirk Reiser <kirk@braille.uwo.ca>");
 MODULE_AUTHOR("David Borowski");
 MODULE_DESCRIPTION("Speakup support for Braille 'n Speak synthesizers");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
-
diff --git a/drivers/accessibility/speakup/speakup_decext.c b/drivers/accessibility/speakup/speakup_decext.c
index 7408eb29cf38..efe7ccbfbf05 100644
--- a/drivers/accessibility/speakup/speakup_decext.c
+++ b/drivers/accessibility/speakup/speakup_decext.c
@@ -236,5 +236,4 @@ MODULE_AUTHOR("Kirk Reiser <kirk@braille.uwo.ca>");
 MODULE_AUTHOR("David Borowski");
 MODULE_DESCRIPTION("Speakup support for DECtalk External synthesizers");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
 
diff --git a/drivers/accessibility/speakup/speakup_decpc.c b/drivers/accessibility/speakup/speakup_decpc.c
index 96f24c848cc5..60da9ec9949c 100644
--- a/drivers/accessibility/speakup/speakup_decpc.c
+++ b/drivers/accessibility/speakup/speakup_decpc.c
@@ -492,4 +492,3 @@ MODULE_AUTHOR("Kirk Reiser <kirk@braille.uwo.ca>");
 MODULE_AUTHOR("David Borowski");
 MODULE_DESCRIPTION("Speakup support for DECtalk PC synthesizers");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
diff --git a/drivers/accessibility/speakup/speakup_dectlk.c b/drivers/accessibility/speakup/speakup_dectlk.c
index 780214b5ca16..dc5e91c7a2c9 100644
--- a/drivers/accessibility/speakup/speakup_dectlk.c
+++ b/drivers/accessibility/speakup/speakup_dectlk.c
@@ -307,5 +307,4 @@ MODULE_AUTHOR("Kirk Reiser <kirk@braille.uwo.ca>");
 MODULE_AUTHOR("David Borowski");
 MODULE_DESCRIPTION("Speakup support for DECtalk Express synthesizers");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
 
diff --git a/drivers/accessibility/speakup/speakup_dtlk.c b/drivers/accessibility/speakup/speakup_dtlk.c
index dbebed0eeeec..265ab003627e 100644
--- a/drivers/accessibility/speakup/speakup_dtlk.c
+++ b/drivers/accessibility/speakup/speakup_dtlk.c
@@ -386,5 +386,3 @@ MODULE_AUTHOR("Kirk Reiser <kirk@braille.uwo.ca>");
 MODULE_AUTHOR("David Borowski");
 MODULE_DESCRIPTION("Speakup support for DoubleTalk PC synthesizers");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
-
diff --git a/drivers/accessibility/speakup/speakup_dummy.c b/drivers/accessibility/speakup/speakup_dummy.c
index e393438af81b..f3b38dc04499 100644
--- a/drivers/accessibility/speakup/speakup_dummy.c
+++ b/drivers/accessibility/speakup/speakup_dummy.c
@@ -130,5 +130,3 @@ module_spk_synth(synth_dummy);
 MODULE_AUTHOR("Samuel Thibault <samuel.thibault@ens-lyon.org>");
 MODULE_DESCRIPTION("Speakup support for text console");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
-
diff --git a/drivers/accessibility/speakup/speakup_keypc.c b/drivers/accessibility/speakup/speakup_keypc.c
index 414827e888fc..8110ddea8ef3 100644
--- a/drivers/accessibility/speakup/speakup_keypc.c
+++ b/drivers/accessibility/speakup/speakup_keypc.c
@@ -314,5 +314,4 @@ module_spk_synth(synth_keypc);
 MODULE_AUTHOR("David Borowski");
 MODULE_DESCRIPTION("Speakup support for Keynote Gold PC synthesizers");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
 
diff --git a/drivers/accessibility/speakup/speakup_ltlk.c b/drivers/accessibility/speakup/speakup_ltlk.c
index 3c59519a871f..d506380d7235 100644
--- a/drivers/accessibility/speakup/speakup_ltlk.c
+++ b/drivers/accessibility/speakup/speakup_ltlk.c
@@ -171,5 +171,3 @@ MODULE_AUTHOR("Kirk Reiser <kirk@braille.uwo.ca>");
 MODULE_AUTHOR("David Borowski");
 MODULE_DESCRIPTION("Speakup support for DoubleTalk LT/LiteTalk synthesizers");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
-
diff --git a/drivers/accessibility/speakup/speakup_soft.c b/drivers/accessibility/speakup/speakup_soft.c
index 9a7029539f35..7c97444744ea 100644
--- a/drivers/accessibility/speakup/speakup_soft.c
+++ b/drivers/accessibility/speakup/speakup_soft.c
@@ -427,4 +427,3 @@ module_spk_synth(synth_soft);
 MODULE_AUTHOR("Kirk Reiser <kirk@braille.uwo.ca>");
 MODULE_DESCRIPTION("Speakup userspace software synthesizer support");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
diff --git a/drivers/accessibility/speakup/speakup_spkout.c b/drivers/accessibility/speakup/speakup_spkout.c
index 6e933bf1de2e..dbaec515d94e 100644
--- a/drivers/accessibility/speakup/speakup_spkout.c
+++ b/drivers/accessibility/speakup/speakup_spkout.c
@@ -135,5 +135,3 @@ MODULE_AUTHOR("Kirk Reiser <kirk@braille.uwo.ca>");
 MODULE_AUTHOR("David Borowski");
 MODULE_DESCRIPTION("Speakup support for Speak Out synthesizers");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
-
diff --git a/drivers/accessibility/speakup/speakup_txprt.c b/drivers/accessibility/speakup/speakup_txprt.c
index a7326f226a5e..687efe2f02e6 100644
--- a/drivers/accessibility/speakup/speakup_txprt.c
+++ b/drivers/accessibility/speakup/speakup_txprt.c
@@ -123,5 +123,3 @@ MODULE_AUTHOR("Kirk Reiser <kirk@braille.uwo.ca>");
 MODULE_AUTHOR("David Borowski");
 MODULE_DESCRIPTION("Speakup support for Transport synthesizers");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
-
-- 
2.11.0

