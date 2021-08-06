Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76F83E277F
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 11:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244641AbhHFJko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 05:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242680AbhHFJkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 05:40:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2C4C06179A
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 02:40:27 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mBwKQ-0002EX-4A; Fri, 06 Aug 2021 11:39:46 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mBwKK-00055m-8Y; Fri, 06 Aug 2021 11:39:40 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mBwKK-00045k-6o; Fri, 06 Aug 2021 11:39:40 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>
Cc:     Corey Minyard <minyard@acm.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, linux-parisc@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net,
        linux-input@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, kernel@pengutronix.de
Subject: [PATCH] parisc: Make struct parisc_driver::remove() return void
Date:   Fri,  6 Aug 2021 11:39:38 +0200
Message-Id: <20210806093938.1950990-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Patch-Hashes: v=1; h=sha256; i=HLXgmV0qGpnDkwp+WuFBRiMxpahH8/d1S8XGx9ztOew=; m=/Xfiwv9Sgti2fAWM+CCGGuyEa+42WeTUsYSiavJEcp4=; p=LTinZqdEm+49N5fzpMRX/3KHEg6iSFKlQ37K2YsT/yw=; g=31eafea52988a1959a5f1e91faf2fa6fa1180f08
X-Patch-Sig: m=pgp; i=u.kleine-koenig@pengutronix.de; s=0x0D2511F322BFAB1C1580266BE2DCDD9132669BD6; b=iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmENA1YACgkQwfwUeK3K7AmwFAf/QMo DCcLmUzOdVxwtZVUJeAeibE3hDSCOquffMEws3ZHebJbIY/48zK3qN9oNIE42DIGpbutke8RMTIL/ YcpodRezDno0n23pIo8+CvrVJbbDSRRor8T/sjhwmgVQN6A3hrZNFPzeYJJE5s7aAIYHla2EyTPFu w0GwFqjSkyB/GbI31rrm0iVC1oyIa1vM7ka+QaY+VB04YlS6fkRjBJ/Lq8tkE/vkU9drpXWYC55OI TJsjvnfhCMBrq/Ni589VoNnb7/ulNssXgL3lmhPYlVSv2lq8JZa4Gcj/XeSf08R7PQ3gyEo5lFN3B cKYf44UYWGWu2PusacXlcxzVx0HjxpA==
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The caller of this function (parisc_driver_remove() in
arch/parisc/kernel/drivers.c) ignores the return value, so better don't
return any value at all to not wake wrong expectations in driver authors.

The only function that could return a non-zero value before was
ipmi_parisc_remove() which returns the return value of
ipmi_si_remove_by_dev(). Make this function return void, too, as for all
other callers the value is ignored, too.

Also fold in a small checkpatch fix for:

WARNING: Unnecessary space before function pointer arguments
+	void (*remove) (struct parisc_device *dev);

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/parisc/include/asm/parisc-device.h  | 4 ++--
 drivers/char/ipmi/ipmi_si_intf.c         | 6 +-----
 drivers/char/ipmi/ipmi_si_parisc.c       | 4 ++--
 drivers/char/ipmi/ipmi_si_platform.c     | 4 +++-
 drivers/input/keyboard/hilkbd.c          | 4 +---
 drivers/input/serio/gscps2.c             | 3 +--
 drivers/net/ethernet/i825xx/lasi_82596.c | 3 +--
 drivers/parport/parport_gsc.c            | 3 +--
 drivers/scsi/lasi700.c                   | 4 +---
 drivers/scsi/zalon.c                     | 4 +---
 drivers/tty/serial/mux.c                 | 3 +--
 sound/parisc/harmony.c                   | 3 +--
 12 files changed, 16 insertions(+), 29 deletions(-)

diff --git a/arch/parisc/include/asm/parisc-device.h b/arch/parisc/include/asm/parisc-device.h
index d02d144c6012..4de3b391d812 100644
--- a/arch/parisc/include/asm/parisc-device.h
+++ b/arch/parisc/include/asm/parisc-device.h
@@ -34,8 +34,8 @@ struct parisc_driver {
 	struct parisc_driver *next;
 	char *name; 
 	const struct parisc_device_id *id_table;
-	int (*probe) (struct parisc_device *dev); /* New device discovered */
-	int (*remove) (struct parisc_device *dev);
+	int (*probe)(struct parisc_device *dev); /* New device discovered */
+	void (*remove)(struct parisc_device *dev);
 	struct device_driver drv;
 };
 
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 62929a3e397e..bb466981dc1b 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2228,22 +2228,18 @@ static void cleanup_one_si(struct smi_info *smi_info)
 	kfree(smi_info);
 }
 
-int ipmi_si_remove_by_dev(struct device *dev)
+void ipmi_si_remove_by_dev(struct device *dev)
 {
 	struct smi_info *e;
-	int rv = -ENOENT;
 
 	mutex_lock(&smi_infos_lock);
 	list_for_each_entry(e, &smi_infos, link) {
 		if (e->io.dev == dev) {
 			cleanup_one_si(e);
-			rv = 0;
 			break;
 		}
 	}
 	mutex_unlock(&smi_infos_lock);
-
-	return rv;
 }
 
 struct device *ipmi_si_remove_by_data(int addr_space, enum si_type si_type,
diff --git a/drivers/char/ipmi/ipmi_si_parisc.c b/drivers/char/ipmi/ipmi_si_parisc.c
index 11c9160275df..2be2967f6b5f 100644
--- a/drivers/char/ipmi/ipmi_si_parisc.c
+++ b/drivers/char/ipmi/ipmi_si_parisc.c
@@ -29,9 +29,9 @@ static int __init ipmi_parisc_probe(struct parisc_device *dev)
 	return ipmi_si_add_smi(&io);
 }
 
-static int __exit ipmi_parisc_remove(struct parisc_device *dev)
+static void __exit ipmi_parisc_remove(struct parisc_device *dev)
 {
-	return ipmi_si_remove_by_dev(&dev->dev);
+	ipmi_si_remove_by_dev(&dev->dev);
 }
 
 static const struct parisc_device_id ipmi_parisc_tbl[] __initconst = {
diff --git a/drivers/char/ipmi/ipmi_si_platform.c b/drivers/char/ipmi/ipmi_si_platform.c
index 380a6a542890..505cc978c97a 100644
--- a/drivers/char/ipmi/ipmi_si_platform.c
+++ b/drivers/char/ipmi/ipmi_si_platform.c
@@ -411,7 +411,9 @@ static int ipmi_probe(struct platform_device *pdev)
 
 static int ipmi_remove(struct platform_device *pdev)
 {
-	return ipmi_si_remove_by_dev(&pdev->dev);
+	ipmi_si_remove_by_dev(&pdev->dev);
+
+	return 0;
 }
 
 static int pdev_match_name(struct device *dev, const void *data)
diff --git a/drivers/input/keyboard/hilkbd.c b/drivers/input/keyboard/hilkbd.c
index 62ccfebf2f60..c1a4d5055de6 100644
--- a/drivers/input/keyboard/hilkbd.c
+++ b/drivers/input/keyboard/hilkbd.c
@@ -316,11 +316,9 @@ static int __init hil_probe_chip(struct parisc_device *dev)
 	return hil_keyb_init();
 }
 
-static int __exit hil_remove_chip(struct parisc_device *dev)
+static void __exit hil_remove_chip(struct parisc_device *dev)
 {
 	hil_keyb_exit();
-
-	return 0;
 }
 
 static const struct parisc_device_id hil_tbl[] __initconst = {
diff --git a/drivers/input/serio/gscps2.c b/drivers/input/serio/gscps2.c
index 2f9775de3c5b..a9065c6ab550 100644
--- a/drivers/input/serio/gscps2.c
+++ b/drivers/input/serio/gscps2.c
@@ -411,7 +411,7 @@ static int __init gscps2_probe(struct parisc_device *dev)
  * @return: success/error report
  */
 
-static int __exit gscps2_remove(struct parisc_device *dev)
+static void __exit gscps2_remove(struct parisc_device *dev)
 {
 	struct gscps2port *ps2port = dev_get_drvdata(&dev->dev);
 
@@ -425,7 +425,6 @@ static int __exit gscps2_remove(struct parisc_device *dev)
 #endif
 	dev_set_drvdata(&dev->dev, NULL);
 	kfree(ps2port);
-	return 0;
 }
 
 
diff --git a/drivers/net/ethernet/i825xx/lasi_82596.c b/drivers/net/ethernet/i825xx/lasi_82596.c
index 96c6f4f36904..48e001881c75 100644
--- a/drivers/net/ethernet/i825xx/lasi_82596.c
+++ b/drivers/net/ethernet/i825xx/lasi_82596.c
@@ -196,7 +196,7 @@ lan_init_chip(struct parisc_device *dev)
 	return retval;
 }
 
-static int __exit lan_remove_chip(struct parisc_device *pdev)
+static void __exit lan_remove_chip(struct parisc_device *pdev)
 {
 	struct net_device *dev = parisc_get_drvdata(pdev);
 	struct i596_private *lp = netdev_priv(dev);
@@ -205,7 +205,6 @@ static int __exit lan_remove_chip(struct parisc_device *pdev)
 	dma_free_noncoherent(&pdev->dev, sizeof(struct i596_private), lp->dma,
 		       lp->dma_addr, DMA_BIDIRECTIONAL);
 	free_netdev (dev);
-	return 0;
 }
 
 static const struct parisc_device_id lan_tbl[] __initconst = {
diff --git a/drivers/parport/parport_gsc.c b/drivers/parport/parport_gsc.c
index 1e43b3f399a8..4332692ca4b8 100644
--- a/drivers/parport/parport_gsc.c
+++ b/drivers/parport/parport_gsc.c
@@ -378,7 +378,7 @@ static int __init parport_init_chip(struct parisc_device *dev)
 	return 0;
 }
 
-static int __exit parport_remove_chip(struct parisc_device *dev)
+static void __exit parport_remove_chip(struct parisc_device *dev)
 {
 	struct parport *p = dev_get_drvdata(&dev->dev);
 	if (p) {
@@ -397,7 +397,6 @@ static int __exit parport_remove_chip(struct parisc_device *dev)
 		parport_put_port(p);
 		kfree (ops); /* hope no-one cached it */
 	}
-	return 0;
 }
 
 static const struct parisc_device_id parport_tbl[] __initconst = {
diff --git a/drivers/scsi/lasi700.c b/drivers/scsi/lasi700.c
index 6d14a7a94d0b..86fe19e0468d 100644
--- a/drivers/scsi/lasi700.c
+++ b/drivers/scsi/lasi700.c
@@ -134,7 +134,7 @@ lasi700_probe(struct parisc_device *dev)
 	return -ENODEV;
 }
 
-static int __exit
+static void __exit
 lasi700_driver_remove(struct parisc_device *dev)
 {
 	struct Scsi_Host *host = dev_get_drvdata(&dev->dev);
@@ -146,8 +146,6 @@ lasi700_driver_remove(struct parisc_device *dev)
 	free_irq(host->irq, host);
 	iounmap(hostdata->base);
 	kfree(hostdata);
-
-	return 0;
 }
 
 static struct parisc_driver lasi700_driver __refdata = {
diff --git a/drivers/scsi/zalon.c b/drivers/scsi/zalon.c
index 7eac76cccc4c..f1e5cf8a17d9 100644
--- a/drivers/scsi/zalon.c
+++ b/drivers/scsi/zalon.c
@@ -168,15 +168,13 @@ static const struct parisc_device_id zalon_tbl[] __initconst = {
 
 MODULE_DEVICE_TABLE(parisc, zalon_tbl);
 
-static int __exit zalon_remove(struct parisc_device *dev)
+static void __exit zalon_remove(struct parisc_device *dev)
 {
 	struct Scsi_Host *host = dev_get_drvdata(&dev->dev);
 
 	scsi_remove_host(host);
 	ncr53c8xx_release(host);
 	free_irq(dev->irq, host);
-
-	return 0;
 }
 
 static struct parisc_driver zalon_driver __refdata = {
diff --git a/drivers/tty/serial/mux.c b/drivers/tty/serial/mux.c
index be640d9863cd..643dfbcc43f9 100644
--- a/drivers/tty/serial/mux.c
+++ b/drivers/tty/serial/mux.c
@@ -496,7 +496,7 @@ static int __init mux_probe(struct parisc_device *dev)
 	return 0;
 }
 
-static int __exit mux_remove(struct parisc_device *dev)
+static void __exit mux_remove(struct parisc_device *dev)
 {
 	int i, j;
 	int port_count = (long)dev_get_drvdata(&dev->dev);
@@ -518,7 +518,6 @@ static int __exit mux_remove(struct parisc_device *dev)
 	}
 
 	release_mem_region(dev->hpa.start + MUX_OFFSET, port_count * MUX_LINE_OFFSET);
-	return 0;
 }
 
 /* Hack.  This idea was taken from the 8250_gsc.c on how to properly order
diff --git a/sound/parisc/harmony.c b/sound/parisc/harmony.c
index 1440db8b4177..2e3e5aa47682 100644
--- a/sound/parisc/harmony.c
+++ b/sound/parisc/harmony.c
@@ -968,11 +968,10 @@ snd_harmony_probe(struct parisc_device *padev)
 	return err;
 }
 
-static int __exit
+static void __exit
 snd_harmony_remove(struct parisc_device *padev)
 {
 	snd_card_free(parisc_get_drvdata(padev));
-	return 0;
 }
 
 static struct parisc_driver snd_harmony_driver __refdata = {
-- 
2.30.2

