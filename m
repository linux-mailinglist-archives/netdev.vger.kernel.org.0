Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F065668D01
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 07:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238226AbjAMGZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 01:25:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239005AbjAMGYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 01:24:31 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E0669B33;
        Thu, 12 Jan 2023 22:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=YWdaNZZD6eiGGHiQwqB4d/n7vbdllZAZ4PVlQ9KrUog=; b=XtPGvVCciAHH/ZLi442ryHF6rq
        FvgKnRpeqvwCx9UPgqvxyoSez2P7/TsQH4CCdKmAVKMjtEs7KN5fhRpLHTjMdmTb4fMzzf6CmNKlf
        rXdbPlEScIlBvjJrEpLQ9Qz+cT5QX9vrjKWKFTMLmEzur4VlSN6Xl4jhStM3ZSCwOvwfNkCRTuNnR
        wJyIbeNnp1Bzl3/RFdCiY+e0gUrTlrvJFtmxx0gpbmv+sIP/JUZGEtJIDk593yDFSk9RClQJfmg7Y
        4kjnLNtrXGl9NJsEFRSHVUmWUakVHMHmyXzQxjKYElq0QLSA3Qcs/NoVXvf4FXw2zlWkEQ7IFJk43
        R2e+Go7Q==;
Received: from [2001:4bb8:181:656b:9509:7d20:8d39:f895] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pGDTr-000lRy-FI; Fri, 13 Jan 2023 06:24:00 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-sh@vger.kernel.org
Subject: [PATCH 04/22] sound: remove sound/sh
Date:   Fri, 13 Jan 2023 07:23:21 +0100
Message-Id: <20230113062339.1909087-5-hch@lst.de>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230113062339.1909087-1-hch@lst.de>
References: <20230113062339.1909087-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that arch/sh is removed these drivers are dead code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 sound/Kconfig           |   2 -
 sound/Makefile          |   2 +-
 sound/sh/Kconfig        |  32 --
 sound/sh/Makefile       |  11 -
 sound/sh/aica.c         | 628 ----------------------------------------
 sound/sh/aica.h         |  68 -----
 sound/sh/sh_dac_audio.c | 412 --------------------------
 7 files changed, 1 insertion(+), 1154 deletions(-)
 delete mode 100644 sound/sh/Kconfig
 delete mode 100644 sound/sh/Makefile
 delete mode 100644 sound/sh/aica.c
 delete mode 100644 sound/sh/aica.h
 delete mode 100644 sound/sh/sh_dac_audio.c

diff --git a/sound/Kconfig b/sound/Kconfig
index e56d96d2b11cae..14361bb428baa1 100644
--- a/sound/Kconfig
+++ b/sound/Kconfig
@@ -75,8 +75,6 @@ source "sound/spi/Kconfig"
 
 source "sound/mips/Kconfig"
 
-source "sound/sh/Kconfig"
-
 # the following will depend on the order of config.
 # here assuming USB is defined before ALSA
 source "sound/usb/Kconfig"
diff --git a/sound/Makefile b/sound/Makefile
index 04ef04b1168f39..bb4b8806321c67 100644
--- a/sound/Makefile
+++ b/sound/Makefile
@@ -4,7 +4,7 @@
 
 obj-$(CONFIG_SOUND) += soundcore.o
 obj-$(CONFIG_DMASOUND) += oss/dmasound/
-obj-$(CONFIG_SND) += core/ i2c/ drivers/ isa/ pci/ ppc/ arm/ sh/ synth/ usb/ \
+obj-$(CONFIG_SND) += core/ i2c/ drivers/ isa/ pci/ ppc/ arm/ synth/ usb/ \
 	firewire/ sparc/ spi/ parisc/ pcmcia/ mips/ soc/ atmel/ hda/ x86/ xen/ \
 	virtio/
 obj-$(CONFIG_SND_AOA) += aoa/
diff --git a/sound/sh/Kconfig b/sound/sh/Kconfig
deleted file mode 100644
index b75fbb3236a7b9..00000000000000
--- a/sound/sh/Kconfig
+++ /dev/null
@@ -1,32 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-# ALSA SH drivers
-
-menuconfig SND_SUPERH
-	bool "SUPERH sound devices"
-	depends on SUPERH
-	default y
-	help
-	  Support for sound devices specific to SUPERH architectures.
-	  Drivers that are implemented on ASoC can be found in
-	  "ALSA for SoC audio support" section.
-
-if SND_SUPERH
-
-config SND_AICA
-	tristate "Dreamcast Yamaha AICA sound"
-	depends on SH_DREAMCAST
-	select SND_PCM
-	select G2_DMA
-	help
-	  ALSA Sound driver for the SEGA Dreamcast console.
-
-config SND_SH_DAC_AUDIO
-	tristate "SuperH DAC audio support"
-	depends on SND
-	depends on CPU_SH3 && HIGH_RES_TIMERS
-	select SND_PCM
-	help
-	  Say Y here to include support for the on-chip DAC.
-
-endif	# SND_SUPERH
-
diff --git a/sound/sh/Makefile b/sound/sh/Makefile
deleted file mode 100644
index c0bbc500c17c73..00000000000000
--- a/sound/sh/Makefile
+++ /dev/null
@@ -1,11 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-#
-# Makefile for ALSA
-#
-
-snd-aica-objs := aica.o
-snd-sh_dac_audio-objs := sh_dac_audio.o
-
-# Toplevel Module Dependency
-obj-$(CONFIG_SND_AICA) += snd-aica.o
-obj-$(CONFIG_SND_SH_DAC_AUDIO) += snd-sh_dac_audio.o
diff --git a/sound/sh/aica.c b/sound/sh/aica.c
deleted file mode 100644
index 6e9d6bd67369af..00000000000000
--- a/sound/sh/aica.c
+++ /dev/null
@@ -1,628 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
-*
-* Copyright Adrian McMenamin 2005, 2006, 2007
-* <adrian@mcmen.demon.co.uk>
-* Requires firmware (BSD licenced) available from:
-* http://linuxdc.cvs.sourceforge.net/linuxdc/linux-sh-dc/sound/oss/aica/firmware/
-* or the maintainer
-*/
-
-#include <linux/init.h>
-#include <linux/jiffies.h>
-#include <linux/slab.h>
-#include <linux/time.h>
-#include <linux/wait.h>
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/firmware.h>
-#include <linux/timer.h>
-#include <linux/delay.h>
-#include <linux/workqueue.h>
-#include <linux/io.h>
-#include <sound/core.h>
-#include <sound/control.h>
-#include <sound/pcm.h>
-#include <sound/initval.h>
-#include <sound/info.h>
-#include <asm/dma.h>
-#include <mach/sysasic.h>
-#include "aica.h"
-
-MODULE_AUTHOR("Adrian McMenamin <adrian@mcmen.demon.co.uk>");
-MODULE_DESCRIPTION("Dreamcast AICA sound (pcm) driver");
-MODULE_LICENSE("GPL");
-MODULE_FIRMWARE("aica_firmware.bin");
-
-/* module parameters */
-#define CARD_NAME "AICA"
-static int index = -1;
-static char *id;
-static bool enable = 1;
-module_param(index, int, 0444);
-MODULE_PARM_DESC(index, "Index value for " CARD_NAME " soundcard.");
-module_param(id, charp, 0444);
-MODULE_PARM_DESC(id, "ID string for " CARD_NAME " soundcard.");
-module_param(enable, bool, 0644);
-MODULE_PARM_DESC(enable, "Enable " CARD_NAME " soundcard.");
-
-/* Simple platform device */
-static struct platform_device *pd;
-static struct resource aica_memory_space[2] = {
-	{
-	 .name = "AICA ARM CONTROL",
-	 .start = ARM_RESET_REGISTER,
-	 .flags = IORESOURCE_MEM,
-	 .end = ARM_RESET_REGISTER + 3,
-	 },
-	{
-	 .name = "AICA Sound RAM",
-	 .start = SPU_MEMORY_BASE,
-	 .flags = IORESOURCE_MEM,
-	 .end = SPU_MEMORY_BASE + 0x200000 - 1,
-	 },
-};
-
-/* SPU specific functions */
-/* spu_write_wait - wait for G2-SH FIFO to clear */
-static void spu_write_wait(void)
-{
-	int time_count;
-	time_count = 0;
-	while (1) {
-		if (!(readl(G2_FIFO) & 0x11))
-			break;
-		/* To ensure hardware failure doesn't wedge kernel */
-		time_count++;
-		if (time_count > 0x10000) {
-			snd_printk
-			    ("WARNING: G2 FIFO appears to be blocked.\n");
-			break;
-		}
-	}
-}
-
-/* spu_memset - write to memory in SPU address space */
-static void spu_memset(u32 toi, u32 what, int length)
-{
-	int i;
-	unsigned long flags;
-	if (snd_BUG_ON(length % 4))
-		return;
-	for (i = 0; i < length; i++) {
-		if (!(i % 8))
-			spu_write_wait();
-		local_irq_save(flags);
-		writel(what, toi + SPU_MEMORY_BASE);
-		local_irq_restore(flags);
-		toi++;
-	}
-}
-
-/* spu_memload - write to SPU address space */
-static void spu_memload(u32 toi, const void *from, int length)
-{
-	unsigned long flags;
-	const u32 *froml = from;
-	u32 __iomem *to = (u32 __iomem *) (SPU_MEMORY_BASE + toi);
-	int i;
-	u32 val;
-	length = DIV_ROUND_UP(length, 4);
-	spu_write_wait();
-	for (i = 0; i < length; i++) {
-		if (!(i % 8))
-			spu_write_wait();
-		val = *froml;
-		local_irq_save(flags);
-		writel(val, to);
-		local_irq_restore(flags);
-		froml++;
-		to++;
-	}
-}
-
-/* spu_disable - set spu registers to stop sound output */
-static void spu_disable(void)
-{
-	int i;
-	unsigned long flags;
-	u32 regval;
-	spu_write_wait();
-	regval = readl(ARM_RESET_REGISTER);
-	regval |= 1;
-	spu_write_wait();
-	local_irq_save(flags);
-	writel(regval, ARM_RESET_REGISTER);
-	local_irq_restore(flags);
-	for (i = 0; i < 64; i++) {
-		spu_write_wait();
-		regval = readl(SPU_REGISTER_BASE + (i * 0x80));
-		regval = (regval & ~0x4000) | 0x8000;
-		spu_write_wait();
-		local_irq_save(flags);
-		writel(regval, SPU_REGISTER_BASE + (i * 0x80));
-		local_irq_restore(flags);
-	}
-}
-
-/* spu_enable - set spu registers to enable sound output */
-static void spu_enable(void)
-{
-	unsigned long flags;
-	u32 regval = readl(ARM_RESET_REGISTER);
-	regval &= ~1;
-	spu_write_wait();
-	local_irq_save(flags);
-	writel(regval, ARM_RESET_REGISTER);
-	local_irq_restore(flags);
-}
-
-/* 
- * Halt the sound processor, clear the memory,
- * load some default ARM7 code, and then restart ARM7
-*/
-static void spu_reset(void)
-{
-	unsigned long flags;
-	spu_disable();
-	spu_memset(0, 0, 0x200000 / 4);
-	/* Put ARM7 in endless loop */
-	local_irq_save(flags);
-	__raw_writel(0xea000002, SPU_MEMORY_BASE);
-	local_irq_restore(flags);
-	spu_enable();
-}
-
-/* aica_chn_start - write to spu to start playback */
-static void aica_chn_start(void)
-{
-	unsigned long flags;
-	spu_write_wait();
-	local_irq_save(flags);
-	writel(AICA_CMD_KICK | AICA_CMD_START, (u32 *) AICA_CONTROL_POINT);
-	local_irq_restore(flags);
-}
-
-/* aica_chn_halt - write to spu to halt playback */
-static void aica_chn_halt(void)
-{
-	unsigned long flags;
-	spu_write_wait();
-	local_irq_save(flags);
-	writel(AICA_CMD_KICK | AICA_CMD_STOP, (u32 *) AICA_CONTROL_POINT);
-	local_irq_restore(flags);
-}
-
-/* ALSA code below */
-static const struct snd_pcm_hardware snd_pcm_aica_playback_hw = {
-	.info = (SNDRV_PCM_INFO_NONINTERLEAVED),
-	.formats =
-	    (SNDRV_PCM_FMTBIT_S8 | SNDRV_PCM_FMTBIT_S16_LE |
-	     SNDRV_PCM_FMTBIT_IMA_ADPCM),
-	.rates = SNDRV_PCM_RATE_8000_48000,
-	.rate_min = 8000,
-	.rate_max = 48000,
-	.channels_min = 1,
-	.channels_max = 2,
-	.buffer_bytes_max = AICA_BUFFER_SIZE,
-	.period_bytes_min = AICA_PERIOD_SIZE,
-	.period_bytes_max = AICA_PERIOD_SIZE,
-	.periods_min = AICA_PERIOD_NUMBER,
-	.periods_max = AICA_PERIOD_NUMBER,
-};
-
-static int aica_dma_transfer(int channels, int buffer_size,
-			     struct snd_pcm_substream *substream)
-{
-	int q, err, period_offset;
-	struct snd_card_aica *dreamcastcard;
-	struct snd_pcm_runtime *runtime;
-	unsigned long flags;
-	err = 0;
-	dreamcastcard = substream->pcm->private_data;
-	period_offset = dreamcastcard->clicks;
-	period_offset %= (AICA_PERIOD_NUMBER / channels);
-	runtime = substream->runtime;
-	for (q = 0; q < channels; q++) {
-		local_irq_save(flags);
-		err = dma_xfer(AICA_DMA_CHANNEL,
-			       (unsigned long) (runtime->dma_area +
-						(AICA_BUFFER_SIZE * q) /
-						channels +
-						AICA_PERIOD_SIZE *
-						period_offset),
-			       AICA_CHANNEL0_OFFSET + q * CHANNEL_OFFSET +
-			       AICA_PERIOD_SIZE * period_offset,
-			       buffer_size / channels, AICA_DMA_MODE);
-		if (unlikely(err < 0)) {
-			local_irq_restore(flags);
-			break;
-		}
-		dma_wait_for_completion(AICA_DMA_CHANNEL);
-		local_irq_restore(flags);
-	}
-	return err;
-}
-
-static void startup_aica(struct snd_card_aica *dreamcastcard)
-{
-	spu_memload(AICA_CHANNEL0_CONTROL_OFFSET,
-		    dreamcastcard->channel, sizeof(struct aica_channel));
-	aica_chn_start();
-}
-
-static void run_spu_dma(struct work_struct *work)
-{
-	int buffer_size;
-	struct snd_pcm_runtime *runtime;
-	struct snd_card_aica *dreamcastcard;
-	dreamcastcard =
-	    container_of(work, struct snd_card_aica, spu_dma_work);
-	runtime = dreamcastcard->substream->runtime;
-	if (unlikely(dreamcastcard->dma_check == 0)) {
-		buffer_size =
-		    frames_to_bytes(runtime, runtime->buffer_size);
-		if (runtime->channels > 1)
-			dreamcastcard->channel->flags |= 0x01;
-		aica_dma_transfer(runtime->channels, buffer_size,
-				  dreamcastcard->substream);
-		startup_aica(dreamcastcard);
-		dreamcastcard->clicks =
-		    buffer_size / (AICA_PERIOD_SIZE * runtime->channels);
-		return;
-	} else {
-		aica_dma_transfer(runtime->channels,
-				  AICA_PERIOD_SIZE * runtime->channels,
-				  dreamcastcard->substream);
-		snd_pcm_period_elapsed(dreamcastcard->substream);
-		dreamcastcard->clicks++;
-		if (unlikely(dreamcastcard->clicks >= AICA_PERIOD_NUMBER))
-			dreamcastcard->clicks %= AICA_PERIOD_NUMBER;
-		mod_timer(&dreamcastcard->timer, jiffies + 1);
-	}
-}
-
-static void aica_period_elapsed(struct timer_list *t)
-{
-	struct snd_card_aica *dreamcastcard = from_timer(dreamcastcard,
-							      t, timer);
-	struct snd_pcm_substream *substream = dreamcastcard->substream;
-	/*timer function - so cannot sleep */
-	int play_period;
-	struct snd_pcm_runtime *runtime;
-	runtime = substream->runtime;
-	dreamcastcard = substream->pcm->private_data;
-	/* Have we played out an additional period? */
-	play_period =
-	    frames_to_bytes(runtime,
-			    readl
-			    (AICA_CONTROL_CHANNEL_SAMPLE_NUMBER)) /
-	    AICA_PERIOD_SIZE;
-	if (play_period == dreamcastcard->current_period) {
-		/* reschedule the timer */
-		mod_timer(&(dreamcastcard->timer), jiffies + 1);
-		return;
-	}
-	if (runtime->channels > 1)
-		dreamcastcard->current_period = play_period;
-	if (unlikely(dreamcastcard->dma_check == 0))
-		dreamcastcard->dma_check = 1;
-	schedule_work(&(dreamcastcard->spu_dma_work));
-}
-
-static void spu_begin_dma(struct snd_pcm_substream *substream)
-{
-	struct snd_card_aica *dreamcastcard;
-	struct snd_pcm_runtime *runtime;
-	runtime = substream->runtime;
-	dreamcastcard = substream->pcm->private_data;
-	/*get the queue to do the work */
-	schedule_work(&(dreamcastcard->spu_dma_work));
-	mod_timer(&dreamcastcard->timer, jiffies + 4);
-}
-
-static int snd_aicapcm_pcm_open(struct snd_pcm_substream
-				*substream)
-{
-	struct snd_pcm_runtime *runtime;
-	struct aica_channel *channel;
-	struct snd_card_aica *dreamcastcard;
-	if (!enable)
-		return -ENOENT;
-	dreamcastcard = substream->pcm->private_data;
-	channel = kmalloc(sizeof(struct aica_channel), GFP_KERNEL);
-	if (!channel)
-		return -ENOMEM;
-	/* set defaults for channel */
-	channel->sfmt = SM_8BIT;
-	channel->cmd = AICA_CMD_START;
-	channel->vol = dreamcastcard->master_volume;
-	channel->pan = 0x80;
-	channel->pos = 0;
-	channel->flags = 0;	/* default to mono */
-	dreamcastcard->channel = channel;
-	runtime = substream->runtime;
-	runtime->hw = snd_pcm_aica_playback_hw;
-	spu_enable();
-	dreamcastcard->clicks = 0;
-	dreamcastcard->current_period = 0;
-	dreamcastcard->dma_check = 0;
-	return 0;
-}
-
-static int snd_aicapcm_pcm_close(struct snd_pcm_substream
-				 *substream)
-{
-	struct snd_card_aica *dreamcastcard = substream->pcm->private_data;
-	flush_work(&(dreamcastcard->spu_dma_work));
-	del_timer(&dreamcastcard->timer);
-	dreamcastcard->substream = NULL;
-	kfree(dreamcastcard->channel);
-	spu_disable();
-	return 0;
-}
-
-static int snd_aicapcm_pcm_prepare(struct snd_pcm_substream
-				   *substream)
-{
-	struct snd_card_aica *dreamcastcard = substream->pcm->private_data;
-	if ((substream->runtime)->format == SNDRV_PCM_FORMAT_S16_LE)
-		dreamcastcard->channel->sfmt = SM_16BIT;
-	dreamcastcard->channel->freq = substream->runtime->rate;
-	dreamcastcard->substream = substream;
-	return 0;
-}
-
-static int snd_aicapcm_pcm_trigger(struct snd_pcm_substream
-				   *substream, int cmd)
-{
-	switch (cmd) {
-	case SNDRV_PCM_TRIGGER_START:
-		spu_begin_dma(substream);
-		break;
-	case SNDRV_PCM_TRIGGER_STOP:
-		aica_chn_halt();
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static unsigned long snd_aicapcm_pcm_pointer(struct snd_pcm_substream
-					     *substream)
-{
-	return readl(AICA_CONTROL_CHANNEL_SAMPLE_NUMBER);
-}
-
-static const struct snd_pcm_ops snd_aicapcm_playback_ops = {
-	.open = snd_aicapcm_pcm_open,
-	.close = snd_aicapcm_pcm_close,
-	.prepare = snd_aicapcm_pcm_prepare,
-	.trigger = snd_aicapcm_pcm_trigger,
-	.pointer = snd_aicapcm_pcm_pointer,
-};
-
-/* TO DO: set up to handle more than one pcm instance */
-static int __init snd_aicapcmchip(struct snd_card_aica
-				  *dreamcastcard, int pcm_index)
-{
-	struct snd_pcm *pcm;
-	int err;
-	/* AICA has no capture ability */
-	err =
-	    snd_pcm_new(dreamcastcard->card, "AICA PCM", pcm_index, 1, 0,
-			&pcm);
-	if (unlikely(err < 0))
-		return err;
-	pcm->private_data = dreamcastcard;
-	strcpy(pcm->name, "AICA PCM");
-	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK,
-			&snd_aicapcm_playback_ops);
-	/* Allocate the DMA buffers */
-	snd_pcm_set_managed_buffer_all(pcm,
-				       SNDRV_DMA_TYPE_CONTINUOUS,
-				       NULL,
-				       AICA_BUFFER_SIZE,
-				       AICA_BUFFER_SIZE);
-	return 0;
-}
-
-/* Mixer controls */
-#define aica_pcmswitch_info		snd_ctl_boolean_mono_info
-
-static int aica_pcmswitch_get(struct snd_kcontrol *kcontrol,
-			      struct snd_ctl_elem_value *ucontrol)
-{
-	ucontrol->value.integer.value[0] = 1;	/* TO DO: Fix me */
-	return 0;
-}
-
-static int aica_pcmswitch_put(struct snd_kcontrol *kcontrol,
-			      struct snd_ctl_elem_value *ucontrol)
-{
-	if (ucontrol->value.integer.value[0] == 1)
-		return 0;	/* TO DO: Fix me */
-	else
-		aica_chn_halt();
-	return 0;
-}
-
-static int aica_pcmvolume_info(struct snd_kcontrol *kcontrol,
-			       struct snd_ctl_elem_info *uinfo)
-{
-	uinfo->type = SNDRV_CTL_ELEM_TYPE_INTEGER;
-	uinfo->count = 1;
-	uinfo->value.integer.min = 0;
-	uinfo->value.integer.max = 0xFF;
-	return 0;
-}
-
-static int aica_pcmvolume_get(struct snd_kcontrol *kcontrol,
-			      struct snd_ctl_elem_value *ucontrol)
-{
-	struct snd_card_aica *dreamcastcard;
-	dreamcastcard = kcontrol->private_data;
-	if (unlikely(!dreamcastcard->channel))
-		return -ETXTBSY;	/* we've not yet been set up */
-	ucontrol->value.integer.value[0] = dreamcastcard->channel->vol;
-	return 0;
-}
-
-static int aica_pcmvolume_put(struct snd_kcontrol *kcontrol,
-			      struct snd_ctl_elem_value *ucontrol)
-{
-	struct snd_card_aica *dreamcastcard;
-	unsigned int vol;
-	dreamcastcard = kcontrol->private_data;
-	if (unlikely(!dreamcastcard->channel))
-		return -ETXTBSY;
-	vol = ucontrol->value.integer.value[0];
-	if (vol > 0xff)
-		return -EINVAL;
-	if (unlikely(dreamcastcard->channel->vol == vol))
-		return 0;
-	dreamcastcard->channel->vol = ucontrol->value.integer.value[0];
-	dreamcastcard->master_volume = ucontrol->value.integer.value[0];
-	spu_memload(AICA_CHANNEL0_CONTROL_OFFSET,
-		    dreamcastcard->channel, sizeof(struct aica_channel));
-	return 1;
-}
-
-static const struct snd_kcontrol_new snd_aica_pcmswitch_control = {
-	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-	.name = "PCM Playback Switch",
-	.index = 0,
-	.info = aica_pcmswitch_info,
-	.get = aica_pcmswitch_get,
-	.put = aica_pcmswitch_put
-};
-
-static const struct snd_kcontrol_new snd_aica_pcmvolume_control = {
-	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-	.name = "PCM Playback Volume",
-	.index = 0,
-	.info = aica_pcmvolume_info,
-	.get = aica_pcmvolume_get,
-	.put = aica_pcmvolume_put
-};
-
-static int load_aica_firmware(void)
-{
-	int err;
-	const struct firmware *fw_entry;
-	spu_reset();
-	err = request_firmware(&fw_entry, "aica_firmware.bin", &pd->dev);
-	if (unlikely(err))
-		return err;
-	/* write firmware into memory */
-	spu_disable();
-	spu_memload(0, fw_entry->data, fw_entry->size);
-	spu_enable();
-	release_firmware(fw_entry);
-	return err;
-}
-
-static int add_aicamixer_controls(struct snd_card_aica *dreamcastcard)
-{
-	int err;
-	err = snd_ctl_add
-	    (dreamcastcard->card,
-	     snd_ctl_new1(&snd_aica_pcmvolume_control, dreamcastcard));
-	if (unlikely(err < 0))
-		return err;
-	err = snd_ctl_add
-	    (dreamcastcard->card,
-	     snd_ctl_new1(&snd_aica_pcmswitch_control, dreamcastcard));
-	if (unlikely(err < 0))
-		return err;
-	return 0;
-}
-
-static int snd_aica_remove(struct platform_device *devptr)
-{
-	struct snd_card_aica *dreamcastcard;
-	dreamcastcard = platform_get_drvdata(devptr);
-	if (unlikely(!dreamcastcard))
-		return -ENODEV;
-	snd_card_free(dreamcastcard->card);
-	kfree(dreamcastcard);
-	return 0;
-}
-
-static int snd_aica_probe(struct platform_device *devptr)
-{
-	int err;
-	struct snd_card_aica *dreamcastcard;
-	dreamcastcard = kzalloc(sizeof(struct snd_card_aica), GFP_KERNEL);
-	if (unlikely(!dreamcastcard))
-		return -ENOMEM;
-	err = snd_card_new(&devptr->dev, index, SND_AICA_DRIVER,
-			   THIS_MODULE, 0, &dreamcastcard->card);
-	if (unlikely(err < 0)) {
-		kfree(dreamcastcard);
-		return err;
-	}
-	strcpy(dreamcastcard->card->driver, "snd_aica");
-	strcpy(dreamcastcard->card->shortname, SND_AICA_DRIVER);
-	strcpy(dreamcastcard->card->longname,
-	       "Yamaha AICA Super Intelligent Sound Processor for SEGA Dreamcast");
-	/* Prepare to use the queue */
-	INIT_WORK(&(dreamcastcard->spu_dma_work), run_spu_dma);
-	timer_setup(&dreamcastcard->timer, aica_period_elapsed, 0);
-	/* Load the PCM 'chip' */
-	err = snd_aicapcmchip(dreamcastcard, 0);
-	if (unlikely(err < 0))
-		goto freedreamcast;
-	/* Add basic controls */
-	err = add_aicamixer_controls(dreamcastcard);
-	if (unlikely(err < 0))
-		goto freedreamcast;
-	/* Register the card with ALSA subsystem */
-	err = snd_card_register(dreamcastcard->card);
-	if (unlikely(err < 0))
-		goto freedreamcast;
-	platform_set_drvdata(devptr, dreamcastcard);
-	snd_printk
-	    ("ALSA Driver for Yamaha AICA Super Intelligent Sound Processor\n");
-	return 0;
-      freedreamcast:
-	snd_card_free(dreamcastcard->card);
-	kfree(dreamcastcard);
-	return err;
-}
-
-static struct platform_driver snd_aica_driver = {
-	.probe = snd_aica_probe,
-	.remove = snd_aica_remove,
-	.driver = {
-		.name = SND_AICA_DRIVER,
-	},
-};
-
-static int __init aica_init(void)
-{
-	int err;
-	err = platform_driver_register(&snd_aica_driver);
-	if (unlikely(err < 0))
-		return err;
-	pd = platform_device_register_simple(SND_AICA_DRIVER, -1,
-					     aica_memory_space, 2);
-	if (IS_ERR(pd)) {
-		platform_driver_unregister(&snd_aica_driver);
-		return PTR_ERR(pd);
-	}
-	/* Load the firmware */
-	return load_aica_firmware();
-}
-
-static void __exit aica_exit(void)
-{
-	platform_device_unregister(pd);
-	platform_driver_unregister(&snd_aica_driver);
-	/* Kill any sound still playing and reset ARM7 to safe state */
-	spu_reset();
-}
-
-module_init(aica_init);
-module_exit(aica_exit);
diff --git a/sound/sh/aica.h b/sound/sh/aica.h
deleted file mode 100644
index 021b132e088e82..00000000000000
--- a/sound/sh/aica.h
+++ /dev/null
@@ -1,68 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/* aica.h
- * Header file for ALSA driver for
- * Sega Dreamcast Yamaha AICA sound
- * Copyright Adrian McMenamin
- * <adrian@mcmen.demon.co.uk>
- * 2006
- */
-
-/* SPU memory and register constants etc */
-#define G2_FIFO 0xa05f688c
-#define SPU_MEMORY_BASE 0xA0800000
-#define ARM_RESET_REGISTER 0xA0702C00
-#define SPU_REGISTER_BASE 0xA0700000
-
-/* AICA channels stuff */
-#define AICA_CONTROL_POINT 0xA0810000
-#define AICA_CONTROL_CHANNEL_SAMPLE_NUMBER 0xA0810008
-#define AICA_CHANNEL0_CONTROL_OFFSET 0x10004
-
-/* Command values */
-#define AICA_CMD_KICK 0x80000000
-#define AICA_CMD_NONE 0
-#define AICA_CMD_START 1
-#define AICA_CMD_STOP 2
-#define AICA_CMD_VOL 3
-
-/* Sound modes */
-#define SM_8BIT		1
-#define SM_16BIT	0
-#define SM_ADPCM	2
-
-/* Buffer and period size */
-#define AICA_BUFFER_SIZE 0x8000
-#define AICA_PERIOD_SIZE 0x800
-#define AICA_PERIOD_NUMBER 16
-
-#define AICA_CHANNEL0_OFFSET 0x11000
-#define AICA_CHANNEL1_OFFSET 0x21000
-#define CHANNEL_OFFSET 0x10000
-
-#define AICA_DMA_CHANNEL 5
-#define AICA_DMA_MODE 5
-
-#define SND_AICA_DRIVER "AICA"
-
-struct aica_channel {
-	uint32_t cmd;		/* Command ID           */
-	uint32_t pos;		/* Sample position      */
-	uint32_t length;	/* Sample length        */
-	uint32_t freq;		/* Frequency            */
-	uint32_t vol;		/* Volume 0-255         */
-	uint32_t pan;		/* Pan 0-255            */
-	uint32_t sfmt;		/* Sound format         */
-	uint32_t flags;		/* Bit flags            */
-};
-
-struct snd_card_aica {
-	struct work_struct spu_dma_work;
-	struct snd_card *card;
-	struct aica_channel *channel;
-	struct snd_pcm_substream *substream;
-	int clicks;
-	int current_period;
-	struct timer_list timer;
-	int master_volume;
-	int dma_check;
-};
diff --git a/sound/sh/sh_dac_audio.c b/sound/sh/sh_dac_audio.c
deleted file mode 100644
index 8ebd972846acb5..00000000000000
--- a/sound/sh/sh_dac_audio.c
+++ /dev/null
@@ -1,412 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * sh_dac_audio.c - SuperH DAC audio driver for ALSA
- *
- * Copyright (c) 2009 by Rafael Ignacio Zurita <rizurita@yahoo.com>
- *
- * Based on sh_dac_audio.c (Copyright (C) 2004, 2005 by Andriy Skulysh)
- */
-
-#include <linux/hrtimer.h>
-#include <linux/interrupt.h>
-#include <linux/io.h>
-#include <linux/platform_device.h>
-#include <linux/slab.h>
-#include <linux/module.h>
-#include <sound/core.h>
-#include <sound/initval.h>
-#include <sound/pcm.h>
-#include <sound/sh_dac_audio.h>
-#include <asm/clock.h>
-#include <asm/hd64461.h>
-#include <mach/hp6xx.h>
-#include <cpu/dac.h>
-
-MODULE_AUTHOR("Rafael Ignacio Zurita <rizurita@yahoo.com>");
-MODULE_DESCRIPTION("SuperH DAC audio driver");
-MODULE_LICENSE("GPL");
-
-/* Module Parameters */
-static int index = SNDRV_DEFAULT_IDX1;
-static char *id = SNDRV_DEFAULT_STR1;
-module_param(index, int, 0444);
-MODULE_PARM_DESC(index, "Index value for SuperH DAC audio.");
-module_param(id, charp, 0444);
-MODULE_PARM_DESC(id, "ID string for SuperH DAC audio.");
-
-/* main struct */
-struct snd_sh_dac {
-	struct snd_card *card;
-	struct snd_pcm_substream *substream;
-	struct hrtimer hrtimer;
-	ktime_t wakeups_per_second;
-
-	int rate;
-	int empty;
-	char *data_buffer, *buffer_begin, *buffer_end;
-	int processed; /* bytes proccesed, to compare with period_size */
-	int buffer_size;
-	struct dac_audio_pdata *pdata;
-};
-
-
-static void dac_audio_start_timer(struct snd_sh_dac *chip)
-{
-	hrtimer_start(&chip->hrtimer, chip->wakeups_per_second,
-		      HRTIMER_MODE_REL);
-}
-
-static void dac_audio_stop_timer(struct snd_sh_dac *chip)
-{
-	hrtimer_cancel(&chip->hrtimer);
-}
-
-static void dac_audio_reset(struct snd_sh_dac *chip)
-{
-	dac_audio_stop_timer(chip);
-	chip->buffer_begin = chip->buffer_end = chip->data_buffer;
-	chip->processed = 0;
-	chip->empty = 1;
-}
-
-static void dac_audio_set_rate(struct snd_sh_dac *chip)
-{
-	chip->wakeups_per_second = 1000000000 / chip->rate;
-}
-
-
-/* PCM INTERFACE */
-
-static const struct snd_pcm_hardware snd_sh_dac_pcm_hw = {
-	.info			= (SNDRV_PCM_INFO_MMAP |
-					SNDRV_PCM_INFO_MMAP_VALID |
-					SNDRV_PCM_INFO_INTERLEAVED |
-					SNDRV_PCM_INFO_HALF_DUPLEX),
-	.formats		= SNDRV_PCM_FMTBIT_U8,
-	.rates			= SNDRV_PCM_RATE_8000,
-	.rate_min		= 8000,
-	.rate_max		= 8000,
-	.channels_min		= 1,
-	.channels_max		= 1,
-	.buffer_bytes_max	= (48*1024),
-	.period_bytes_min	= 1,
-	.period_bytes_max	= (48*1024),
-	.periods_min		= 1,
-	.periods_max		= 1024,
-};
-
-static int snd_sh_dac_pcm_open(struct snd_pcm_substream *substream)
-{
-	struct snd_sh_dac *chip = snd_pcm_substream_chip(substream);
-	struct snd_pcm_runtime *runtime = substream->runtime;
-
-	runtime->hw = snd_sh_dac_pcm_hw;
-
-	chip->substream = substream;
-	chip->buffer_begin = chip->buffer_end = chip->data_buffer;
-	chip->processed = 0;
-	chip->empty = 1;
-
-	chip->pdata->start(chip->pdata);
-
-	return 0;
-}
-
-static int snd_sh_dac_pcm_close(struct snd_pcm_substream *substream)
-{
-	struct snd_sh_dac *chip = snd_pcm_substream_chip(substream);
-
-	chip->substream = NULL;
-
-	dac_audio_stop_timer(chip);
-	chip->pdata->stop(chip->pdata);
-
-	return 0;
-}
-
-static int snd_sh_dac_pcm_prepare(struct snd_pcm_substream *substream)
-{
-	struct snd_sh_dac *chip = snd_pcm_substream_chip(substream);
-	struct snd_pcm_runtime *runtime = chip->substream->runtime;
-
-	chip->buffer_size = runtime->buffer_size;
-	memset(chip->data_buffer, 0, chip->pdata->buffer_size);
-
-	return 0;
-}
-
-static int snd_sh_dac_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
-{
-	struct snd_sh_dac *chip = snd_pcm_substream_chip(substream);
-
-	switch (cmd) {
-	case SNDRV_PCM_TRIGGER_START:
-		dac_audio_start_timer(chip);
-		break;
-	case SNDRV_PCM_TRIGGER_STOP:
-		chip->buffer_begin = chip->buffer_end = chip->data_buffer;
-		chip->processed = 0;
-		chip->empty = 1;
-		dac_audio_stop_timer(chip);
-		break;
-	default:
-		 return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int snd_sh_dac_pcm_copy(struct snd_pcm_substream *substream,
-			       int channel, unsigned long pos,
-			       void __user *src, unsigned long count)
-{
-	/* channel is not used (interleaved data) */
-	struct snd_sh_dac *chip = snd_pcm_substream_chip(substream);
-
-	if (copy_from_user_toio(chip->data_buffer + pos, src, count))
-		return -EFAULT;
-	chip->buffer_end = chip->data_buffer + pos + count;
-
-	if (chip->empty) {
-		chip->empty = 0;
-		dac_audio_start_timer(chip);
-	}
-
-	return 0;
-}
-
-static int snd_sh_dac_pcm_copy_kernel(struct snd_pcm_substream *substream,
-				      int channel, unsigned long pos,
-				      void *src, unsigned long count)
-{
-	/* channel is not used (interleaved data) */
-	struct snd_sh_dac *chip = snd_pcm_substream_chip(substream);
-
-	memcpy_toio(chip->data_buffer + pos, src, count);
-	chip->buffer_end = chip->data_buffer + pos + count;
-
-	if (chip->empty) {
-		chip->empty = 0;
-		dac_audio_start_timer(chip);
-	}
-
-	return 0;
-}
-
-static int snd_sh_dac_pcm_silence(struct snd_pcm_substream *substream,
-				  int channel, unsigned long pos,
-				  unsigned long count)
-{
-	/* channel is not used (interleaved data) */
-	struct snd_sh_dac *chip = snd_pcm_substream_chip(substream);
-
-	memset_io(chip->data_buffer + pos, 0, count);
-	chip->buffer_end = chip->data_buffer + pos + count;
-
-	if (chip->empty) {
-		chip->empty = 0;
-		dac_audio_start_timer(chip);
-	}
-
-	return 0;
-}
-
-static
-snd_pcm_uframes_t snd_sh_dac_pcm_pointer(struct snd_pcm_substream *substream)
-{
-	struct snd_sh_dac *chip = snd_pcm_substream_chip(substream);
-	int pointer = chip->buffer_begin - chip->data_buffer;
-
-	return pointer;
-}
-
-/* pcm ops */
-static const struct snd_pcm_ops snd_sh_dac_pcm_ops = {
-	.open		= snd_sh_dac_pcm_open,
-	.close		= snd_sh_dac_pcm_close,
-	.prepare	= snd_sh_dac_pcm_prepare,
-	.trigger	= snd_sh_dac_pcm_trigger,
-	.pointer	= snd_sh_dac_pcm_pointer,
-	.copy_user	= snd_sh_dac_pcm_copy,
-	.copy_kernel	= snd_sh_dac_pcm_copy_kernel,
-	.fill_silence	= snd_sh_dac_pcm_silence,
-	.mmap		= snd_pcm_lib_mmap_iomem,
-};
-
-static int snd_sh_dac_pcm(struct snd_sh_dac *chip, int device)
-{
-	int err;
-	struct snd_pcm *pcm;
-
-	/* device should be always 0 for us */
-	err = snd_pcm_new(chip->card, "SH_DAC PCM", device, 1, 0, &pcm);
-	if (err < 0)
-		return err;
-
-	pcm->private_data = chip;
-	strcpy(pcm->name, "SH_DAC PCM");
-	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK, &snd_sh_dac_pcm_ops);
-
-	/* buffer size=48K */
-	snd_pcm_set_managed_buffer_all(pcm, SNDRV_DMA_TYPE_CONTINUOUS,
-				       NULL, 48 * 1024, 48 * 1024);
-
-	return 0;
-}
-/* END OF PCM INTERFACE */
-
-
-/* driver .remove  --  destructor */
-static int snd_sh_dac_remove(struct platform_device *devptr)
-{
-	snd_card_free(platform_get_drvdata(devptr));
-	return 0;
-}
-
-/* free -- it has been defined by create */
-static int snd_sh_dac_free(struct snd_sh_dac *chip)
-{
-	/* release the data */
-	kfree(chip->data_buffer);
-	kfree(chip);
-
-	return 0;
-}
-
-static int snd_sh_dac_dev_free(struct snd_device *device)
-{
-	struct snd_sh_dac *chip = device->device_data;
-
-	return snd_sh_dac_free(chip);
-}
-
-static enum hrtimer_restart sh_dac_audio_timer(struct hrtimer *handle)
-{
-	struct snd_sh_dac *chip = container_of(handle, struct snd_sh_dac,
-					       hrtimer);
-	struct snd_pcm_runtime *runtime = chip->substream->runtime;
-	ssize_t b_ps = frames_to_bytes(runtime, runtime->period_size);
-
-	if (!chip->empty) {
-		sh_dac_output(*chip->buffer_begin, chip->pdata->channel);
-		chip->buffer_begin++;
-
-		chip->processed++;
-		if (chip->processed >= b_ps) {
-			chip->processed -= b_ps;
-			snd_pcm_period_elapsed(chip->substream);
-		}
-
-		if (chip->buffer_begin == (chip->data_buffer +
-					   chip->buffer_size - 1))
-			chip->buffer_begin = chip->data_buffer;
-
-		if (chip->buffer_begin == chip->buffer_end)
-			chip->empty = 1;
-
-	}
-
-	if (!chip->empty)
-		hrtimer_start(&chip->hrtimer, chip->wakeups_per_second,
-			      HRTIMER_MODE_REL);
-
-	return HRTIMER_NORESTART;
-}
-
-/* create  --  chip-specific constructor for the cards components */
-static int snd_sh_dac_create(struct snd_card *card,
-			     struct platform_device *devptr,
-			     struct snd_sh_dac **rchip)
-{
-	struct snd_sh_dac *chip;
-	int err;
-
-	static const struct snd_device_ops ops = {
-		   .dev_free = snd_sh_dac_dev_free,
-	};
-
-	*rchip = NULL;
-
-	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
-	if (chip == NULL)
-		return -ENOMEM;
-
-	chip->card = card;
-
-	hrtimer_init(&chip->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	chip->hrtimer.function = sh_dac_audio_timer;
-
-	dac_audio_reset(chip);
-	chip->rate = 8000;
-	dac_audio_set_rate(chip);
-
-	chip->pdata = devptr->dev.platform_data;
-
-	chip->data_buffer = kmalloc(chip->pdata->buffer_size, GFP_KERNEL);
-	if (chip->data_buffer == NULL) {
-		kfree(chip);
-		return -ENOMEM;
-	}
-
-	err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, chip, &ops);
-	if (err < 0) {
-		snd_sh_dac_free(chip);
-		return err;
-	}
-
-	*rchip = chip;
-
-	return 0;
-}
-
-/* driver .probe  --  constructor */
-static int snd_sh_dac_probe(struct platform_device *devptr)
-{
-	struct snd_sh_dac *chip;
-	struct snd_card *card;
-	int err;
-
-	err = snd_card_new(&devptr->dev, index, id, THIS_MODULE, 0, &card);
-	if (err < 0) {
-			snd_printk(KERN_ERR "cannot allocate the card\n");
-			return err;
-	}
-
-	err = snd_sh_dac_create(card, devptr, &chip);
-	if (err < 0)
-		goto probe_error;
-
-	err = snd_sh_dac_pcm(chip, 0);
-	if (err < 0)
-		goto probe_error;
-
-	strcpy(card->driver, "snd_sh_dac");
-	strcpy(card->shortname, "SuperH DAC audio driver");
-	printk(KERN_INFO "%s %s", card->longname, card->shortname);
-
-	err = snd_card_register(card);
-	if (err < 0)
-		goto probe_error;
-
-	snd_printk(KERN_INFO "ALSA driver for SuperH DAC audio");
-
-	platform_set_drvdata(devptr, card);
-	return 0;
-
-probe_error:
-	snd_card_free(card);
-	return err;
-}
-
-/*
- * "driver" definition
- */
-static struct platform_driver sh_dac_driver = {
-	.probe	= snd_sh_dac_probe,
-	.remove = snd_sh_dac_remove,
-	.driver = {
-		.name = "dac_audio",
-	},
-};
-
-module_platform_driver(sh_dac_driver);
-- 
2.39.0

