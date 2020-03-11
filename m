Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1152B180D2E
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 02:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbgCKBJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 21:09:47 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45182 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgCKBJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 21:09:46 -0400
Received: by mail-wr1-f65.google.com with SMTP id m9so396106wro.12;
        Tue, 10 Mar 2020 18:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=00GSpkojnx3B4GB0fFMAKFnU+tANLaiUGZgbkObBjO4=;
        b=rXZlxFI9JSzCtp81Ib7ST1kaLR/Xl1OrJ2z46XZY4sBTtm3lREyA9akpIS9lcjwiML
         VYoYR8hLGI5Z+wOOBt7p7W2aTJ/5M/pBoYe0rKUn5gWv3HYP1PSqQSypbszvwaNvmdCz
         kjTqHgsAfKVBgXFea9cHKcd2aURr8Atn5b94jRSfR4IeSgt6yHXxFVCPCcZVmw1K9fz9
         6PLIlVupVklKgjKMLnCPRmPcB5j/UPiF1BKPcq66GPMWM3UkRkJzNucYPExpORpw+xwM
         miIaPGjeP93ijikHj9Hs7ilF5w2j99rKV3ps+Lp+KmYG9JJjxyFyOcYRjXFKw24fYfoH
         XE3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=00GSpkojnx3B4GB0fFMAKFnU+tANLaiUGZgbkObBjO4=;
        b=TkSe/WYdYPHl/TTg5BL+7F0Hk4FXh1Qr3ledJqM6WLLzBVmZ0NKmcY76nn89i9Hr41
         zcQLa8OhTqvQ/beZ68PBwX9w0Ju8fkjnNHkC9kTUrv5qCxLXSKYSRlOFBKvCNVHBrf+9
         k1/OyzqKXhdrCuplFYFilONjKNPwSc0hGxNeuhHyyRaiunohjlwGoMgRJtjDVaukovbL
         s4dcq06CyqRavYfb9cUvStnMF37xhv57nJWfbSVbzz28ynzDTEkOW7L74Ip62Gf113Z2
         6sMi6bQmKUv1KQmsxgmld5hlT46BMmPJEPoK9vOUckZ7gdIOV8vFRcmkgreVFZ6Dj4G1
         XGDA==
X-Gm-Message-State: ANhLgQ0AMnJ+XXiy6KvgREU1Q06Er8XdrUYST4wGKqa5/OkKM7ox6LnC
        p1AEF7OAW74tvZ8EC5ghSA==
X-Google-Smtp-Source: ADFU+vuPZB+qEvJlgMjAKNaONJg23VSoTdeJapUHrDxw8mfccmCzR4CYmGDU2ygM1wMZnnyCmheYRQ==
X-Received: by 2002:a5d:6902:: with SMTP id t2mr720116wru.135.1583888983726;
        Tue, 10 Mar 2020 18:09:43 -0700 (PDT)
Received: from ninjahost.lan (host-2-102-15-144.as13285.net. [2.102.15.144])
        by smtp.googlemail.com with ESMTPSA id i6sm36658097wra.42.2020.03.10.18.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 18:09:43 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     boqun.feng@gmail.com
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Clemens Ladisch <clemens@ladisch.de>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        alsa-devel@alsa-project.org (moderated list:FIREWIRE AUDIO DRIVERS and
        IEC 61883-1/6 PACKET...)
Subject: [PATCH 8/8] ALSA: firewire-tascam: Add missing annotation for tscm_hwdep_read_locked()
Date:   Wed, 11 Mar 2020 01:09:08 +0000
Message-Id: <20200311010908.42366-9-jbi.octave@gmail.com>
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

Sparse reports a warning at tscm_hwdep_read_locked()

warning: context imbalance in tscm_hwdep_read_locked() - unexpected unlock

The root cause is the missing annotation at tscm_hwdep_read_locked()
Add the missing __releases(&tscm->lock) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 sound/firewire/tascam/tascam-hwdep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/firewire/tascam/tascam-hwdep.c b/sound/firewire/tascam/tascam-hwdep.c
index 9801e33e7f2a..6f38335fe10b 100644
--- a/sound/firewire/tascam/tascam-hwdep.c
+++ b/sound/firewire/tascam/tascam-hwdep.c
@@ -17,6 +17,7 @@
 
 static long tscm_hwdep_read_locked(struct snd_tscm *tscm, char __user *buf,
 				   long count, loff_t *offset)
+	__releases(&tscm->lock)
 {
 	struct snd_firewire_event_lock_status event = {
 		.type = SNDRV_FIREWIRE_EVENT_LOCK_STATUS,
-- 
2.24.1

