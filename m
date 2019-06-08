Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56F1439F71
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 14:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbfFHMFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 08:05:45 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34447 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727495AbfFHMFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 08:05:44 -0400
Received: by mail-wm1-f65.google.com with SMTP id w9so5807117wmd.1;
        Sat, 08 Jun 2019 05:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZQi7zeP4cCwQ8OfQ+fZYxwx298w9AexzaRHDwbmWbGY=;
        b=e57LYhCrEKM42Yi39DIunTvkSoeO6zzux8BLmRpIRIlnomksTBCc1cOgkpyuRKwN4W
         5V+ZXD7uR7ZtgmKKruvt6B37kWqg4X9PlOQigmRJ4bVcPPyWJBPi81ez8nJGjix6faMN
         S0iBWUexVCWgeTDtBzb2HkgG/PW1H5+iO4uc0uPhf3v0p4OQnYFPDuazoAfnDiiR/f8S
         ELK++ejydMQMdxJzEFU0SY612tPo/oKXBKa06xJ/Ji3DIl/KdXOHAVoEPOMG/PmgF5xP
         JaRdckHh5xnfJjYj/7aP8wMwm8S6TODLu8WaymPmvycpvZVecPMLzce0BJda6PiowlPw
         MYow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZQi7zeP4cCwQ8OfQ+fZYxwx298w9AexzaRHDwbmWbGY=;
        b=mx5F6CVj4KFwdWbM9Zqpy0pb+yMOWAgEuAalDchlJBTMephHwAX6fNOGGaK0fc240J
         KgBxACRcdwPTitX/1twiKV5h36uvDVDsZYigENxZa6iZbArTZgAkDlGdnxd38g0y+AtU
         GBDmpDX8bBuS264qAJs9zbaoePqqgyNngbOKm05v3LSNrL8wex46KezwA9acj0e4ri3S
         4+4k9nH57zNjJb+YrYlyigDjieKvoyCVRUc2J7CLzLxu1S5rPJUisn7QdhQ+RfYNAmFl
         VVzCw3+o7Sm0qQA2U1lRG/YPiTCrbho7UJdccCtpPHNeDkkY6S2IfKRA30e0SOv7MQ0j
         gI/Q==
X-Gm-Message-State: APjAAAU3PZprU+ubE3eOutF8+hI69iankHd5l10lB8z2wCsxNaQ6X5aS
        sCRdi1Cr9xoiMAFmT9qlj9M=
X-Google-Smtp-Source: APXvYqya2r1HejimQ472WLr+ddRGlpS/Wy8+SNus2FvKAO+vxEROtt28WLuh8U3UpxHvbTe5qdKT9w==
X-Received: by 2002:a1c:c907:: with SMTP id f7mr7162808wmb.142.1559995542760;
        Sat, 08 Jun 2019 05:05:42 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id j16sm5440030wre.94.2019.06.08.05.05.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 05:05:41 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 07/17] net: dsa: sja1105: Export symbols for upcoming PTP driver
Date:   Sat,  8 Jun 2019 15:04:33 +0300
Message-Id: <20190608120443.21889-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190608120443.21889-1-olteanv@gmail.com>
References: <20190608120443.21889-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are needed for the situation where the switch driver and the PTP
driver are both built as modules.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v4:

Patch is new. Fixes build errors reported by David Miller.

 drivers/net/dsa/sja1105/sja1105_spi.c           | 2 ++
 drivers/net/dsa/sja1105/sja1105_static_config.c | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index b1344ed1697f..422894068c8b 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -100,6 +100,7 @@ int sja1105_spi_send_packed_buf(const struct sja1105_private *priv,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(sja1105_spi_send_packed_buf);
 
 /* If @rw is:
  * - SPI_WRITE: creates and sends an SPI write message at absolute
@@ -135,6 +136,7 @@ int sja1105_spi_send_int(const struct sja1105_private *priv,
 
 	return rc;
 }
+EXPORT_SYMBOL_GPL(sja1105_spi_send_int);
 
 /* Should be used if a @packed_buf larger than SJA1105_SIZE_SPI_MSG_MAXLEN
  * must be sent/received. Splitting the buffer into chunks and assembling
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index 6d65a7b09395..e2f86b332b09 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -35,6 +35,7 @@ void sja1105_pack(void *buf, const u64 *val, int start, int end, size_t len)
 	}
 	dump_stack();
 }
+EXPORT_SYMBOL_GPL(sja1105_pack);
 
 void sja1105_unpack(const void *buf, u64 *val, int start, int end, size_t len)
 {
@@ -52,6 +53,7 @@ void sja1105_unpack(const void *buf, u64 *val, int start, int end, size_t len)
 		       start, end);
 	dump_stack();
 }
+EXPORT_SYMBOL_GPL(sja1105_unpack);
 
 void sja1105_packing(void *buf, u64 *val, int start, int end,
 		     size_t len, enum packing_op op)
@@ -74,6 +76,7 @@ void sja1105_packing(void *buf, u64 *val, int start, int end,
 	}
 	dump_stack();
 }
+EXPORT_SYMBOL_GPL(sja1105_packing);
 
 /* Little-endian Ethernet CRC32 of data packed as big-endian u32 words */
 u32 sja1105_crc32(const void *buf, size_t len)
-- 
2.17.1

