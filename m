Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B14A4E483
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 11:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfFUJrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 05:47:02 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45080 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbfFUJrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 05:47:00 -0400
Received: by mail-pf1-f196.google.com with SMTP id r1so3303934pfq.12;
        Fri, 21 Jun 2019 02:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ByCrE5Wwplze5qQLQuGQsAvZ7evnoshkc/mqeB9IlMg=;
        b=KhLyYMgGuB+5I2l/1RZ9819Vy0Z7D5gSSRjEFfi7MUuvkHLiE/8VXrgPoLq36zJaxt
         44mNBiKwR/nnfEmryCTYIA5WjtHgG6si/Cbm08vQ77BsT8JRU6eKnIhTG8v0YnFWHWIK
         p8UYyvoMQ9nv02QDZlgJVQ54WtDOZqrgDI6CdPGDHGwKQILBY0+CkU8wKgqSi2Gknhtm
         /MHXy+Dqba0qrYHRIM36v/S7icazzO9LP8atCDxi5vBSnMGTYhiJFIZLuoF4pyp/cD6R
         keEOx6qN29dmReY/Ag15KsAToxInDFoyaHt7UyS3mtmKmOcapdiBvvmI3XOzXx3tWAOk
         0W1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ByCrE5Wwplze5qQLQuGQsAvZ7evnoshkc/mqeB9IlMg=;
        b=U4MC00DL85a/ytH1koCJ+QFNw3EkaX6xVPy7cyOZienqZyb/G9ahJbLU6LEi9ipex3
         1eKo1FEaLdUTrs4x0kLzwddvFyAYP9sbqkS4QKb/89JO9BNWRTR32JDdimpgyHFzpEw6
         jYe79rBpmuUsS2f8VTGUU6gDaqWrPSMuMBmE/uHVCMsMODS1AYSR+XL1UuaRA19IvJC0
         Fy3wKQ/IfbBuvy7zFOmsHcXqXChtsic7pZZzfUmnOe5+tUxZ3ABvQL+KPExl2PZNcqF1
         5sl3se4pqxvLy5izB9lMI0PodY/X2Pwc6Gf4juk5wfja9YBs9ELzamS/YDXBDTu+QZoo
         cyew==
X-Gm-Message-State: APjAAAXNaSZTnkD1UWt7aO/i5haVhmFLHNVylRwMbFGhz/+x7FgqwVne
        lsTL1qpLNzAJN5xADSL6XtvgJN+VecRiTg==
X-Google-Smtp-Source: APXvYqzICenPifdS5/ensmLasaIdHVf0Gf5mUz+hKKAON+Wv9OHKbrLlhjXwTzh1ks3hAvUAuJNHrg==
X-Received: by 2002:a17:90a:fa07:: with SMTP id cm7mr5480918pjb.115.1561110419681;
        Fri, 21 Jun 2019 02:46:59 -0700 (PDT)
Received: from localhost.localdomain ([2402:3a80:913:88b1:ac7e:774f:a03c:dcac])
        by smtp.googlemail.com with ESMTPSA id u2sm2147746pjv.9.2019.06.21.02.46.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 02:46:59 -0700 (PDT)
From:   Puranjay Mohan <puranjay12@gmail.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Puranjay Mohan <puranjay12@gmail.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v3 3/3] net: fddi: skfp: Remove unused private PCI definitions
Date:   Fri, 21 Jun 2019 15:16:07 +0530
Message-Id: <20190621094607.15011-4-puranjay12@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190621094607.15011-1-puranjay12@gmail.com>
References: <20190621094607.15011-1-puranjay12@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unused private PCI definitions from skfbi.h because generic PCI
symbols are already included from pci_regs.h.

Signed-off-by: Puranjay Mohan <puranjay12@gmail.com>
---
 drivers/net/fddi/skfp/h/skfbi.h | 76 ---------------------------------
 1 file changed, 76 deletions(-)

diff --git a/drivers/net/fddi/skfp/h/skfbi.h b/drivers/net/fddi/skfp/h/skfbi.h
index 5f9b631e7515..0b5bd2e170a7 100644
--- a/drivers/net/fddi/skfp/h/skfbi.h
+++ b/drivers/net/fddi/skfp/h/skfbi.h
@@ -24,49 +24,6 @@
  *	(ML)	= only defined for Monalisa
  */
 
-/*
- * Configuration Space header
- */
-#define	PCI_VENDOR_ID	0x00	/* 16 bit	Vendor ID */
-#define	PCI_DEVICE_ID	0x02	/* 16 bit	Device ID */
-#define	PCI_COMMAND	0x04	/* 16 bit	Command */
-#define	PCI_STATUS	0x06	/* 16 bit	Status */
-#define	PCI_REVISION_ID	0x08	/*  8 bit	Revision ID */
-#define	PCI_CLASS_CODE	0x09	/* 24 bit	Class Code */
-#define	PCI_CACHE_LSZ	0x0c	/*  8 bit	Cache Line Size */
-#define	PCI_LAT_TIM	0x0d	/*  8 bit	Latency Timer */
-#define	PCI_HEADER_T	0x0e	/*  8 bit	Header Type */
-#define	PCI_BIST	0x0f	/*  8 bit	Built-in selftest */
-#define	PCI_BASE_1ST	0x10	/* 32 bit	1st Base address */
-#define	PCI_BASE_2ND	0x14	/* 32 bit	2nd Base address */
-/* Byte 18..2b:	Reserved */
-#define	PCI_SUB_VID	0x2c	/* 16 bit	Subsystem Vendor ID */
-#define	PCI_SUB_ID	0x2e	/* 16 bit	Subsystem ID */
-#define	PCI_BASE_ROM	0x30	/* 32 bit	Expansion ROM Base Address */
-/* Byte 34..33:	Reserved */
-#define PCI_CAP_PTR	0x34	/*  8 bit (ML)	Capabilities Ptr */
-/* Byte 35..3b:	Reserved */
-#define	PCI_IRQ_LINE	0x3c	/*  8 bit	Interrupt Line */
-#define	PCI_IRQ_PIN	0x3d	/*  8 bit	Interrupt Pin */
-#define	PCI_MIN_GNT	0x3e	/*  8 bit	Min_Gnt */
-#define	PCI_MAX_LAT	0x3f	/*  8 bit	Max_Lat */
-/* Device Dependent Region */
-#define	PCI_OUR_REG	0x40	/* 32 bit (DV)	Our Register */
-#define	PCI_OUR_REG_1	0x40	/* 32 bit (ML)	Our Register 1 */
-#define	PCI_OUR_REG_2	0x44	/* 32 bit (ML)	Our Register 2 */
-/* Power Management Region */
-#define PCI_PM_CAP_ID	0x48	/*  8 bit (ML)	Power Management Cap. ID */
-#define PCI_PM_NITEM	0x49	/*  8 bit (ML)	Next Item Ptr */
-#define PCI_PM_CAP_REG	0x4a	/* 16 bit (ML)	Power Management Capabilities */
-#define PCI_PM_CTL_STS	0x4c	/* 16 bit (ML)	Power Manag. Control/Status */
-/* Byte 0x4e:	Reserved */
-#define PCI_PM_DAT_REG	0x4f	/*  8 bit (ML)	Power Manag. Data Register */
-/* VPD Region */
-#define	PCI_VPD_CAP_ID	0x50	/*  8 bit (ML)	VPD Cap. ID */
-#define PCI_VPD_NITEM	0x51	/*  8 bit (ML)	Next Item Ptr */
-#define PCI_VPD_ADR_REG	0x52	/* 16 bit (ML)	VPD Address Register */
-#define PCI_VPD_DAT_REG	0x54	/* 32 bit (ML)	VPD Data Register */
-/* Byte 58..ff:	Reserved */
 
 /*
  * I2C Address (PCI Config)
@@ -76,39 +33,6 @@
  */
 #define I2C_ADDR_VPD	0xA0	/* I2C address for the VPD EEPROM */ 
 
-/*
- * Define Bits and Values of the registers
- */
-/*	PCI_VENDOR_ID	16 bit	Vendor ID */
-/*	PCI_DEVICE_ID	16 bit	Device ID */
-/* Values for Vendor ID and Device ID shall be patched into the code */
-/*	PCI_COMMAND	16 bit	Command */
-#define	PCI_FBTEN	0x0200	/* Bit 9:	Fast Back-To-Back enable */
-#define	PCI_SERREN	0x0100	/* Bit 8:	SERR enable */
-#define	PCI_ADSTEP	0x0080	/* Bit 7:	Address Stepping */
-#define	PCI_PERREN	0x0040	/* Bit 6:	Parity Report Response enable */
-#define	PCI_VGA_SNOOP	0x0020	/* Bit 5:	VGA palette snoop */
-#define	PCI_MWIEN	0x0010	/* Bit 4:	Memory write an inv cycl ena */
-#define	PCI_SCYCEN	0x0008	/* Bit 3:	Special Cycle enable */
-#define	PCI_BMEN	0x0004	/* Bit 2:	Bus Master enable */
-#define	PCI_MEMEN	0x0002	/* Bit 1:	Memory Space Access enable */
-#define	PCI_IOEN	0x0001	/* Bit 0:	IO Space Access enable */
-
-/*	PCI_STATUS	16 bit	Status */
-#define	PCI_PERR	0x8000	/* Bit 15:	Parity Error */
-#define	PCI_SERR	0x4000	/* Bit 14:	Signaled SERR */
-#define	PCI_RMABORT	0x2000	/* Bit 13:	Received Master Abort */
-#define	PCI_RTABORT	0x1000	/* Bit 12:	Received Target Abort */
-#define	PCI_STABORT	0x0800	/* Bit 11:	Sent Target Abort */
-#define	PCI_DEVSEL	0x0600	/* Bit 10..9:	DEVSEL Timing */
-#define	PCI_DEV_FAST	(0<<9)	/*		fast */
-#define	PCI_DEV_MEDIUM	(1<<9)	/*		medium */
-#define	PCI_DEV_SLOW	(2<<9)	/*		slow */
-#define	PCI_DATAPERR	0x0100	/* Bit 8:	DATA Parity error detected */
-#define	PCI_FB2BCAP	0x0080	/* Bit 7:	Fast Back-to-Back Capability */
-#define	PCI_UDF		0x0040	/* Bit 6:	User Defined Features */
-#define PCI_66MHZCAP	0x0020	/* Bit 5:	66 MHz PCI bus clock capable */
-#define PCI_NEWCAP	0x0010	/* Bit 4:	New cap. list implemented */
 
 #define PCI_ERRBITS	(PCI_STATUS_DETECTED_PARITY | PCI_STATUS_SIG_SYSTEM_ERROR | PCI_STATUS_REC_MASTER_ABORT | PCI_STATUS_SIG_TARGET_ABORT | PCI_STATUS_PARITY)
 
-- 
2.21.0

