Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8DC180D31
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 02:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbgCKBJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 21:09:45 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38268 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727923AbgCKBJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 21:09:43 -0400
Received: by mail-wm1-f67.google.com with SMTP id n2so291068wmc.3;
        Tue, 10 Mar 2020 18:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rM3cbsU55xJlyKmK7QwcQylOwbs8Tma9Iu3Kufv/e4E=;
        b=r93FSAoX3d3rZQcJ/3HADdXXtRixoWxZEGpdEuNh0YacpT4Ty8mUDyVxEXd8TyYAtj
         LKVik9H7txixvdX862XIkrjHwM1wrTzq1MWIMARCGXuI1sfYt6D3TbZn9bJcziwFzylW
         QkQ/5WyQTgdqlBkehnSHgYQAWLjnZaHvq/Psc+ZSjzU/FjJxMzNASkz3Wy9d3p8rzVTK
         9OzIcb5VGOsWocOu9tiURVX+ew1NIko8nZChiBDq1v01xXMRPTbl7pkv/o+kflW3Fk9L
         v2kaH0GAh1KA7FtRSKVkqo68xL0Ij7MsGl8w+LDDZSd9znw+IrbTXc/5P6le7RihJVqV
         zA2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rM3cbsU55xJlyKmK7QwcQylOwbs8Tma9Iu3Kufv/e4E=;
        b=AsHQXcQ4MeKA0EaPBa0H3arRCkvTHVCxxorkMn+io5P7iHyPErAbQW2VUDXvoYm4bf
         z+aMPY5O2EZxwj750hTB2Bnl0nMjxUnyXvJyykDk2pIdIv5PzD0JRZsJK+1N6ZIJ2aom
         Xl+q+wzWU1fyMFjULT2b1tBhOMU9ji9skmYhxBti2moeRYD6dpc+ez2VR/WqIeX0YgKC
         B+UUoVpg6sd2j9OG0f1cAt7g24XlDnwFlKp2U9IyiP1BtR04yQbVYLXzYlUI9GHsWJP5
         QtyS6k9UYR2erwcZMtK1QH0QgAnaZnu1ORDgAZkE1YC3YywBfVUD3hydgaQwT0ve9Umv
         jAfg==
X-Gm-Message-State: ANhLgQ3bdzTq7SWTuZvvL+yV3KKdkIz0nzt0UzCIdtrdfH00MBNaVqgK
        6ubKVHu1+ZV6b13lTaGbUQ==
X-Google-Smtp-Source: ADFU+vtjoWA4bkISywodXaBjpthXQzuAc5Q6v2tqYQpfmLp+cZN2g+BrSyNtymI7EZ5aVbUmOg6z2Q==
X-Received: by 2002:a05:600c:294a:: with SMTP id n10mr433928wmd.11.1583888979445;
        Tue, 10 Mar 2020 18:09:39 -0700 (PDT)
Received: from ninjahost.lan (host-2-102-15-144.as13285.net. [2.102.15.144])
        by smtp.googlemail.com with ESMTPSA id i6sm36658097wra.42.2020.03.10.18.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 18:09:39 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     boqun.feng@gmail.com
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Clemens Ladisch <clemens@ladisch.de>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        alsa-devel@alsa-project.org (moderated list:FIREWIRE AUDIO DRIVERS and
        IEC 61883-1/6 PACKET...)
Subject: [PATCH 7/8] ALSA: firewire-tascam: Add missing annotation for tscm_hwdep_read_queue()
Date:   Wed, 11 Mar 2020 01:09:07 +0000
Message-Id: <20200311010908.42366-8-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200311010908.42366-1-jbi.octave@gmail.com>
References: <0/8>
 <20200311010908.42366-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse reports a warning at tscm_hwdep_read_queue()

warning: context imbalance in tscm_hwdep_read_queue() - unexpected unlock

The root cause is the missing annotation at tscm_hwdep_read_queue()
Add the missing __releases(&tscm->lock) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 sound/firewire/tascam/tascam-hwdep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/firewire/tascam/tascam-hwdep.c b/sound/firewire/tascam/tascam-hwdep.c
index c29a97f6f638..9801e33e7f2a 100644
--- a/sound/firewire/tascam/tascam-hwdep.c
+++ b/sound/firewire/tascam/tascam-hwdep.c
@@ -36,6 +36,7 @@ static long tscm_hwdep_read_locked(struct snd_tscm *tscm, char __user *buf,
 
 static long tscm_hwdep_read_queue(struct snd_tscm *tscm, char __user *buf,
 				  long remained, loff_t *offset)
+	__releases(&tscm->lock)
 {
 	char __user *pos = buf;
 	unsigned int type = SNDRV_FIREWIRE_EVENT_TASCAM_CONTROL;
-- 
2.24.1

