Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E52F4EBA3
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 17:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfFUPOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 11:14:48 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:42831 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfFUPOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 11:14:47 -0400
Received: by mail-pg1-f177.google.com with SMTP id l19so3519878pgh.9;
        Fri, 21 Jun 2019 08:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Jz+3fronUKu7RPQbVLmEz9ddIbExu11kF859JxxBx4M=;
        b=ttwlwEkCEFfyyuFCnpeedvoMryw8b8IrKHm8RDFcp+qc0pEkzyj0nDpmDGgwyKOnJy
         GnmdP1ArEHfX/XPmF7K1t9sYSUUKoiS5ZgLXImBMqNy4yRK6U+HrK+CMcRv83oZCCaCP
         Nt0WYQ4IlF/cG2H+lJMGaHEV8etQ03mb8C6My3aCevsAz2b3us1qzsD6DSdMf8ezYO9x
         xWOLt/1nEW3nfhFKQHq1rACAZoKUDNGw9uBcSFufoXtaBvyvjRA8KIU6hlJ9CmM5B6Yj
         3Hl/AXi20nuuttXzonAr+zd8asfcn2/8P7KXOdRzKZUMw2rB4T7O1R669Lsf89ht1FUT
         Xq0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jz+3fronUKu7RPQbVLmEz9ddIbExu11kF859JxxBx4M=;
        b=PAh10NrozTPdbuDJrISiYLcYM1FnyNCyABPeaMCDtQYycXZQz32H54Mh7lUdujcSFg
         BZwpBeG1Cv56LM4m0aUdLsMpBFkrprEDKvCX3YQTR2T9Mdhprkdj7h/FnJP2FHkUb1pC
         4OM/Ig1O6nSmAGp1CTt6tmBvV4+Pblx6ZLzpBTJ/9JCEUC8PcjI7ke/VK2bODDY/hPS9
         6DGsWg9PDQWtxbvRL5yVHihzVye8OMmBnhmzDzIiOOLihbQvtSA1Np6OOyVfyXmF3aSe
         zQHKTm26bbBUSQ9APqozbr7w8IPVNLCyNGuihpV5axxa87QpTRmli2dLduiC5HG0cNwO
         dEjA==
X-Gm-Message-State: APjAAAXp6/WYRdq+/AhwQirBugyAUKjDphXzSUuM2QFafr11UJPjB5Ch
        6c77m9ZIRGkpnr8pOuLW5z8=
X-Google-Smtp-Source: APXvYqxNjgtBa4JMA1YcAcpUkXr6POgRJ8panNyh7tN1clzLzzRowJmGor4UE1jBR05fiVfps6UvMw==
X-Received: by 2002:a65:6686:: with SMTP id b6mr19044917pgw.125.1561130085778;
        Fri, 21 Jun 2019 08:14:45 -0700 (PDT)
Received: from localhost.localdomain ([112.196.181.13])
        by smtp.googlemail.com with ESMTPSA id 25sm3254465pfp.76.2019.06.21.08.14.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 08:14:45 -0700 (PDT)
From:   Puranjay Mohan <puranjay12@gmail.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Puranjay Mohan <puranjay12@gmail.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v4 3/3] net: fddi: skfp: Remove unused private PCI definitions
Date:   Fri, 21 Jun 2019 20:44:15 +0530
Message-Id: <20190621151415.10795-4-puranjay12@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190621151415.10795-1-puranjay12@gmail.com>
References: <20190621151415.10795-1-puranjay12@gmail.com>
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
 drivers/net/fddi/skfp/h/skfbi.h | 211 +-------------------------------
 1 file changed, 1 insertion(+), 210 deletions(-)

diff --git a/drivers/net/fddi/skfp/h/skfbi.h b/drivers/net/fddi/skfp/h/skfbi.h
index 5f9b631e7515..ef9dfd131d79 100644
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
@@ -76,176 +33,10 @@
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
 
-/*	PCI_REV_ID	8 bit	Revision ID */
-/*	PCI_CLASS_CODE	24 bit	Class Code */
-/*	Byte 2:		Base Class		(02) */
-/*	Byte 1:		SubClass		(02) */
-/*	Byte 0:		Programming Interface	(00) */
-
-/*	PCI_CACHE_LSZ	8 bit	Cache Line Size */
-/*	Possible values: 0,2,4,8,16	*/
-
-/*	PCI_LAT_TIM	8 bit	Latency Timer */
-
-/*	PCI_HEADER_T	8 bit	Header Type */
-#define	PCI_HD_MF_DEV	0x80	/* Bit 7:	0= single, 1= multi-func dev */
-#define	PCI_HD_TYPE	0x7f	/* Bit 6..0:	Header Layout 0= normal */
-
-/*	PCI_BIST	8 bit	Built-in selftest */
-#define	PCI_BIST_CAP	0x80	/* Bit 7:	BIST Capable */
-#define	PCI_BIST_ST	0x40	/* Bit 6:	Start BIST */
-#define	PCI_BIST_RET	0x0f	/* Bit 3..0:	Completion Code */
-
-/*	PCI_BASE_1ST	32 bit	1st Base address */
-#define	PCI_MEMSIZE	0x800L       /* use 2 kB Memory Base */
-#define	PCI_MEMBASE_BITS 0xfffff800L /* Bit 31..11:	Memory Base Address */
-#define	PCI_MEMSIZE_BIIS 0x000007f0L /* Bit 10..4:	Memory Size Req. */
-#define	PCI_PREFEN	0x00000008L  /* Bit 3:		Prefetchable */
-#define	PCI_MEM_TYP	0x00000006L  /* Bit 2..1:	Memory Type */
-#define	PCI_MEM32BIT	(0<<1)	     /* Base addr anywhere in 32 Bit range */
-#define	PCI_MEM1M	(1<<1)	     /* Base addr below 1 MegaByte */
-#define	PCI_MEM64BIT	(2<<1)	     /* Base addr anywhere in 64 Bit range */
-#define	PCI_MEMSPACE	0x00000001L  /* Bit 0:	Memory Space Indic. */
-
-/*	PCI_SUB_VID	16 bit	Subsystem Vendor ID */
-/*	PCI_SUB_ID	16 bit	Subsystem ID */
-
-/*	PCI_BASE_ROM	32 bit	Expansion ROM Base Address */
-#define	PCI_ROMBASE	0xfffe0000L  /* Bit 31..17: ROM BASE address (1st) */
-#define	PCI_ROMBASZ	0x0001c000L  /* Bit 16..14: Treat as BASE or SIZE */
-#define	PCI_ROMSIZE	0x00003800L  /* Bit 13..11: ROM Size Requirements */
-#define	PCI_ROMEN	0x00000001L  /* Bit 0:	    Address Decode enable */
-
-/*	PCI_CAP_PTR	8 bit	New Capabilities Pointers */
-/*	PCI_IRQ_LINE	8 bit	Interrupt Line */
-/*	PCI_IRQ_PIN	8 bit	Interrupt Pin */
-/*	PCI_MIN_GNT	8 bit	Min_Gnt */
-/*	PCI_MAX_LAT	8 bit	Max_Lat */
-/* Device Dependent Region */
-/*	PCI_OUR_REG	(DV)	32 bit	Our Register */
-/*	PCI_OUR_REG_1	(ML)	32 bit	Our Register 1 */
-				  /*	 Bit 31..29:	reserved */
-#define	PCI_PATCH_DIR	(3L<<27)  /*(DV) Bit 28..27:	Ext Patchs direction */
-#define PCI_PATCH_DIR_0	(1L<<27)  /*(DV) Type of the pins EXT_PATCHS<1..0>   */
-#define PCI_PATCH_DIR_1 (1L<<28)  /*	   0 = input			     */
-				  /*	   1 = output			     */
-#define	PCI_EXT_PATCHS	(3L<<25)  /*(DV) Bit 26..25:	Extended Patches     */
-#define PCI_EXT_PATCH_0 (1L<<25)  /*(DV)				     */
-#define PCI_EXT_PATCH_1 (1L<<26)  /*	 CLK for MicroWire (ML)		     */
-#define PCI_VIO		(1L<<25)  /*(ML)				     */
-#define	PCI_EN_BOOT	(1L<<24)  /*	 Bit 24:	Enable BOOT via ROM  */
-				  /*	   1 = Don't boot with ROM	     */
-				  /*	   0 = Boot with ROM		     */
-#define	PCI_EN_IO	(1L<<23)  /*	 Bit 23:	Mapping to IO space  */
-#define	PCI_EN_FPROM	(1L<<22)  /*	 Bit 22:	FLASH mapped to mem? */
-				  /*	   1 = Map Flash to Memory	     */
-			  	  /*	   0 = Disable all addr. decoding    */
-#define	PCI_PAGESIZE	(3L<<20)  /*	 Bit 21..20:	FLASH Page Size	     */
-#define	PCI_PAGE_16	(0L<<20)  /*		16 k pages		     */
-#define	PCI_PAGE_32K	(1L<<20)  /*		32 k pages		     */
-#define	PCI_PAGE_64K	(2L<<20)  /*		64 k pages		     */
-#define	PCI_PAGE_128K	(3L<<20)  /*		128 k pages		     */
-				  /*	 Bit 19: reserved (ML) and (DV)	     */
-#define	PCI_PAGEREG	(7L<<16)  /*	 Bit 18..16:	Page Register	     */
-				  /*	 Bit 15:	reserved	     */
-#define	PCI_FORCE_BE	(1L<<14)  /*	 Bit 14:	Assert all BEs on MR */
-#define	PCI_DIS_MRL	(1L<<13)  /*	 Bit 13:	Disable Mem R Line   */
-#define	PCI_DIS_MRM	(1L<<12)  /*	 Bit 12:	Disable Mem R multip */
-#define	PCI_DIS_MWI	(1L<<11)  /*	 Bit 11:	Disable Mem W & inv  */
-#define	PCI_DISC_CLS	(1L<<10)  /*	 Bit 10:	Disc: cacheLsz bound */
-#define	PCI_BURST_DIS	(1L<<9)	  /*	 Bit  9:	Burst Disable	     */
-#define	PCI_BYTE_SWAP	(1L<<8)	  /*(DV) Bit  8:	Byte Swap in DATA    */
-#define	PCI_SKEW_DAS	(0xfL<<4) /*	 Bit 7..4:	Skew Ctrl, DAS Ext   */
-#define	PCI_SKEW_BASE	(0xfL<<0) /*	 Bit 3..0:	Skew Ctrl, Base	     */
-
-/*	PCI_OUR_REG_2	(ML)	32 bit	Our Register 2 (Monalisa only) */
-#define PCI_VPD_WR_TH	(0xffL<<24)	/* Bit 24..31	VPD Write Threshold  */
-#define	PCI_DEV_SEL	(0x7fL<<17)	/* Bit 17..23	EEPROM Device Select */
-#define	PCI_VPD_ROM_SZ	(7L<<14)	/* Bit 14..16	VPD ROM Size	     */
-					/* Bit 12..13	reserved	     */
-#define	PCI_PATCH_DIR2	(0xfL<<8)	/* Bit  8..11	Ext Patchs dir 2..5  */
-#define	PCI_PATCH_DIR_2	(1L<<8)		/* Bit  8	CS for MicroWire     */
-#define	PCI_PATCH_DIR_3	(1L<<9)
-#define	PCI_PATCH_DIR_4	(1L<<10)
-#define	PCI_PATCH_DIR_5	(1L<<11)
-#define PCI_EXT_PATCHS2 (0xfL<<4)	/* Bit  4..7	Extended Patches     */
-#define	PCI_EXT_PATCH_2	(1L<<4)		/* Bit  4	CS for MicroWire     */
-#define	PCI_EXT_PATCH_3	(1L<<5)
-#define	PCI_EXT_PATCH_4	(1L<<6)
-#define	PCI_EXT_PATCH_5	(1L<<7)
-#define	PCI_EN_DUMMY_RD	(1L<<3)		/* Bit  3	Enable Dummy Read    */
-#define PCI_REV_DESC	(1L<<2)		/* Bit  2	Reverse Desc. Bytes  */
-#define PCI_USEADDR64	(1L<<1)		/* Bit  1	Use 64 Bit Addresse  */
-#define PCI_USEDATA64	(1L<<0)		/* Bit  0	Use 64 Bit Data bus ext*/
-
-/* Power Management Region */
-/*	PCI_PM_CAP_ID		 8 bit (ML)	Power Management Cap. ID */
-/*	PCI_PM_NITEM		 8 bit (ML)	Next Item Ptr */
-/*	PCI_PM_CAP_REG		16 bit (ML)	Power Management Capabilities*/
-#define	PCI_PME_SUP	(0x1f<<11)	/* Bit 11..15	PM Manag. Event Support*/
-#define PCI_PM_D2_SUB	(1<<10)		/* Bit 10	D2 Support Bit	     */
-#define PCI_PM_D1_SUB	(1<<9)		/* Bit 9	D1 Support Bit       */
-					/* Bit 6..8 reserved		     */
-#define PCI_PM_DSI	(1<<5)		/* Bit 5	Device Specific Init.*/
-#define PCI_PM_APS	(1<<4)		/* Bit 4	Auxialiary Power Src */
-#define PCI_PME_CLOCK	(1<<3)		/* Bit 3	PM Event Clock       */
-#define PCI_PM_VER	(7<<0)		/* Bit 0..2	PM PCI Spec. version */
-
-/*	PCI_PM_CTL_STS		16 bit (ML)	Power Manag. Control/Status  */
-#define	PCI_PME_STATUS	(1<<15)		/* Bit 15 	PFA doesn't sup. PME#*/
-#define PCI_PM_DAT_SCL	(3<<13)		/* Bit 13..14	dat reg Scaling factor */
-#define PCI_PM_DAT_SEL	(0xf<<9)	/* Bit  9..12	PM data selector field */
-					/* Bit  7.. 2	reserved	     */
-#define PCI_PM_STATE	(3<<0)		/* Bit  0.. 1	Power Management State */
-#define PCI_PM_STATE_D0	(0<<0)		/* D0:	Operational (default) */
-#define	PCI_PM_STATE_D1	(1<<0)		/* D1:	not supported */
-#define PCI_PM_STATE_D2	(2<<0)		/* D2:	not supported */
-#define PCI_PM_STATE_D3 (3<<0)		/* D3:	HOT, Power Down and Reset */
-
-/*	PCI_PM_DAT_REG		 8 bit (ML)	Power Manag. Data Register */
-/* VPD Region */
-/*	PCI_VPD_CAP_ID		 8 bit (ML)	VPD Cap. ID */
-/*	PCI_VPD_NITEM		 8 bit (ML)	Next Item Ptr */
-/*	PCI_VPD_ADR_REG		16 bit (ML)	VPD Address Register */
-#define	PCI_VPD_FLAG	(1<<15)		/* Bit 15	starts VPD rd/wd cycle*/
-
-/*	PCI_VPD_DAT_REG		32 bit (ML)	VPD Data Register */
+
 
 /*
  *	Control Register File:
-- 
2.21.0

