Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F331C4645
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 05:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbfJBDoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 23:44:11 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33706 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfJBDoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 23:44:11 -0400
Received: by mail-pf1-f195.google.com with SMTP id q10so9607380pfl.0
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 20:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:user-agent:date:from:to:cc:cc:subject:references
         :mime-version:content-disposition;
        bh=k5jMv6jbqbp4G+N90teQHUla0oOS5TVQ90kP+jozqTY=;
        b=S/qdicixYUXfj7cuHloQtQ7AfKQnk2pqT9pqXpWp0e3XNbRv+10rQI10QA1iGj6KIS
         4oHnwqbvPKJn84S6XOXZkKVDU51EpsAH/ggB9DmRHoeWdpwfr07jZmgJ7Pj8IMo7HmQb
         AXvI2q6Jb+/+Nhywv2kPWI/dmN5+jqxX4c2oHjYuTgdaLcLBUYRtR64jmDRfE3MLD75/
         WN5TV4M6C19VvY0MKPW7LHyEt5WA2skb5kDEUVbjlLrQ4aeVO2rzpkGKgaf06ElDSsc9
         5LfAwENIMeM/3egpJBFfN5nWwvcoGzXF8dOZnrxig41/60E6O61Hwe3VFxBB5Io5RTLG
         +LmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:user-agent:date:from:to:cc:cc:subject
         :references:mime-version:content-disposition;
        bh=k5jMv6jbqbp4G+N90teQHUla0oOS5TVQ90kP+jozqTY=;
        b=ElIiohDHSNQIa2ElI2i/hc2YH6NWPmoVXV9CgdwiH26EFJHr3MZb9y0wLY9tU98AIL
         BmD3B0qabZ5gyaFH4i6yyPqK9jdiGlUzVK7wsDnlDwfrPlaWrX4N5CHQKWdgs1tZFLt5
         NffFztBWdW1Cl8B2tdyJtzzeORBizYWu9gIMpf3L/nD3EauOvgBUDEFu3coKm3MdSkFZ
         /MwdC2ApkrvfH3Tl4mP9iDH8uVahI9I9y57w9S6eHPg8gz5gbVTuB19Cr7cT5oTD0mae
         DZsM3gi0gmywoOgN42ygcUUJCq56YppKKjJZIeHKmHO/X2zHfWTqdcjDZUqtYawUo40Q
         jM4g==
X-Gm-Message-State: APjAAAVgcJhLf/9oExq0yV3Awwxo36CU8tLRzBef2qRKMtpjkQuuVeuY
        OcWycdkuLsU6EcuFcBMQ2HDcexpa
X-Google-Smtp-Source: APXvYqz8iSqPpGSMH+ZEcrUZi/FYps2F7M3+lEX/ZFe8Km5hoaFgYbVykoN+01cI8lP53oX4YY0Kgw==
X-Received: by 2002:a62:14c2:: with SMTP id 185mr2056727pfu.47.1569987849004;
        Tue, 01 Oct 2019 20:44:09 -0700 (PDT)
Received: from localhost ([2601:1c0:6280:3f0::9a1f])
        by smtp.gmail.com with ESMTPSA id h70sm23262576pgc.48.2019.10.01.20.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 20:44:08 -0700 (PDT)
Message-Id: <20190920230359.189935996@gmail.com>
User-Agent: quilt/0.65
Date:   Tue, 01 Oct 2019 16:04:01 -0700
From:   rd.dunlab@gmail.com
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>
Cc:     rdunlap@infradead.org
Subject: [PATCH 3/3] Minor fixes to the CAIF Transport drivers Kconfig file
References: <20190920230358.973169240@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=drv-net-caif-Kconfig-clean002.patch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Minor fixes to the CAIF Transport drivers Kconfig file:

- end sentence with period
- capitalize CAIF acronym

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/net/caif/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- lnx-53-caif.orig/drivers/net/caif/Kconfig
+++ lnx-53-caif/drivers/net/caif/Kconfig
@@ -28,7 +28,7 @@ config CAIF_SPI_SLAVE
 	The CAIF Link layer SPI Protocol driver for Slave SPI interface.
 	This driver implements a platform driver to accommodate for a
 	platform specific SPI device. A sample CAIF SPI Platform device is
-	provided in Documentation/networking/caif/spi_porting.txt
+	provided in <file:Documentation/networking/caif/spi_porting.txt>.
 
 config CAIF_SPI_SYNC
 	bool "Next command and length in start of frame"
@@ -44,7 +44,7 @@ config CAIF_HSI
        depends on CAIF
        default n
        ---help---
-       The caif low level driver for CAIF over HSI.
+       The CAIF low level driver for CAIF over HSI.
        Be aware that if you enable this then you also need to
        enable a low-level HSI driver.
 
@@ -56,7 +56,7 @@ config CAIF_VIRTIO
 	select GENERIC_ALLOCATOR
 	default n
 	---help---
-	The caif driver for CAIF over Virtio.
+	The CAIF driver for CAIF over Virtio.
 
 if CAIF_VIRTIO
 source "drivers/vhost/Kconfig.vringh"


