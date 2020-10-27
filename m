Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A5329A8CD
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 11:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896823AbgJ0KBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 06:01:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896036AbgJ0Jvn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 05:51:43 -0400
Received: from mail.kernel.org (ip5f5ad5af.dynamic.kabel-deutschland.de [95.90.213.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 606902242E;
        Tue, 27 Oct 2020 09:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603792301;
        bh=zhqkufZ7f7yOmStqpe6IwS4Q7Pbm2bPb4tI8f5PD8is=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nXetCSIdncDil++yqRz+Z7pblFepFeAUxK3hbbZUoMzKo056B4kZX12WTq6gbmpny
         TwpHRShS+9xERahBj2DOQVwYPRa74koiC6xGggaATzBfmhp4Eh9HdDXADRm5hQQVZR
         QjV07iLWiodY5vPxv7AT8Eo1KlZNSJqx+DRG+D50=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kXLdj-003FF2-Ck; Tue, 27 Oct 2020 10:51:39 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3 14/32] net: phy: remove kernel-doc duplication
Date:   Tue, 27 Oct 2020 10:51:18 +0100
Message-Id: <75e9a357f9a716833d2094b04898754876365e68.1603791716.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1603791716.git.mchehab+huawei@kernel.org>
References: <cover.1603791716.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sphinx 3 now checks for duplicated function declarations:

	.../Documentation/networking/kapi:143: ../include/linux/phy.h:163: WARNING: Duplicate C declaration, also defined in 'networking/kapi'.
	Declaration is 'unsigned int phy_supported_speeds (struct phy_device *phy, unsigned int *speeds, unsigned int size)'.
	.../Documentation/networking/kapi:143: ../include/linux/phy.h:1034: WARNING: Duplicate C declaration, also defined in 'networking/kapi'.
	Declaration is 'int phy_read_mmd (struct phy_device *phydev, int devad, u32 regnum)'.
	.../Documentation/networking/kapi:143: ../include/linux/phy.h:1076: WARNING: Duplicate C declaration, also defined in 'networking/kapi'.
	Declaration is 'int __phy_read_mmd (struct phy_device *phydev, int devad, u32 regnum)'.
	.../Documentation/networking/kapi:143: ../include/linux/phy.h:1088: WARNING: Duplicate C declaration, also defined in 'networking/kapi'.
	Declaration is 'int phy_write_mmd (struct phy_device *phydev, int devad, u32 regnum, u16 val)'.
	.../Documentation/networking/kapi:143: ../include/linux/phy.h:1100: WARNING: Duplicate C declaration, also defined in 'networking/kapi'.
	Declaration is 'int __phy_write_mmd (struct phy_device *phydev, int devad, u32 regnum, u16 val)'.

It turns that both the C and the H files have the same
kernel-doc markup for the same functions. Let's drop the
at the header file, keeping the one closer to the code.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 include/linux/phy.h | 40 +++++-----------------------------------
 1 file changed, 5 insertions(+), 35 deletions(-)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index eb3cb1a98b45..56563e5e0dc7 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -147,16 +147,8 @@ typedef enum {
 	PHY_INTERFACE_MODE_MAX,
 } phy_interface_t;
 
-/**
+/*
  * phy_supported_speeds - return all speeds currently supported by a PHY device
- * @phy: The PHY device to return supported speeds of.
- * @speeds: buffer to store supported speeds in.
- * @size: size of speeds buffer.
- *
- * Description: Returns the number of supported speeds, and fills
- * the speeds buffer with the supported speeds. If speeds buffer is
- * too small to contain all currently supported speeds, will return as
- * many speeds as can fit.
  */
 unsigned int phy_supported_speeds(struct phy_device *phy,
 				      unsigned int *speeds,
@@ -1022,14 +1014,9 @@ static inline int __phy_modify_changed(struct phy_device *phydev, u32 regnum,
 					regnum, mask, set);
 }
 
-/**
+/*
  * phy_read_mmd - Convenience function for reading a register
  * from an MMD on a given PHY.
- * @phydev: The phy_device struct
- * @devad: The MMD to read from
- * @regnum: The register on the MMD to read
- *
- * Same rules as for phy_read();
  */
 int phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum);
 
@@ -1064,38 +1051,21 @@ int phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum);
 	__ret; \
 })
 
-/**
+/*
  * __phy_read_mmd - Convenience function for reading a register
  * from an MMD on a given PHY.
- * @phydev: The phy_device struct
- * @devad: The MMD to read from
- * @regnum: The register on the MMD to read
- *
- * Same rules as for __phy_read();
  */
 int __phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum);
 
-/**
+/*
  * phy_write_mmd - Convenience function for writing a register
  * on an MMD on a given PHY.
- * @phydev: The phy_device struct
- * @devad: The MMD to write to
- * @regnum: The register on the MMD to read
- * @val: value to write to @regnum
- *
- * Same rules as for phy_write();
  */
 int phy_write_mmd(struct phy_device *phydev, int devad, u32 regnum, u16 val);
 
-/**
+/*
  * __phy_write_mmd - Convenience function for writing a register
  * on an MMD on a given PHY.
- * @phydev: The phy_device struct
- * @devad: The MMD to write to
- * @regnum: The register on the MMD to read
- * @val: value to write to @regnum
- *
- * Same rules as for __phy_write();
  */
 int __phy_write_mmd(struct phy_device *phydev, int devad, u32 regnum, u16 val);
 
-- 
2.26.2

