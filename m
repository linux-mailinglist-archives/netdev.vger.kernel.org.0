Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2EA3AB803
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 17:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233537AbhFQP6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 11:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233526AbhFQP6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 11:58:19 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01D3C061574
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 08:56:09 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id z12so4751642edc.1
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 08:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F3bb/y20kvOIvEReavUtM+18IobnvDpkflfokuL0Za8=;
        b=I+kz8Ur/v0J4O87esyLqUmNX1VvESaxn8ykuJxJaPgb9lTDKCJi3vVnVgcOQFwJ1mO
         ppXO8Pz5mXKpOBT01hdk1TKhHxtuM/ugDnYQe/ZDaEn9YDzzzHs1vHNaczRysOBHSGFi
         y/FsrFfzfCK36w1Jce+oZEm6u/JPTJKPOZhXdfsEkjz1FpgIkrYpQYXU1OsZMdpiLgig
         yXJm3TY6PyF2pBYOXQHeXg+VNlRKDq2dZVpzSKm2biEtZT9LpU6d0ag26475KKAHaQU9
         oA91vEjPvboSKd16WQ6X1WAaxR0OiQ3ieaz2/+jcVXH48DFkrYreS/9maPuVtR4vAHMt
         M3Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F3bb/y20kvOIvEReavUtM+18IobnvDpkflfokuL0Za8=;
        b=AB5SZqaPdbWO3HndBXjg/FSEOmzHX32NpaiNyQk0oLYglwR3CN4CV2Djb6KTDNGUb7
         SGlOco3r8KaPDFCHI3HKRvdf3I4QDNxfeKhxjrG83EyBmKCpm08iXymtXc415M8/CwE8
         XcDy9IvQ4NeD7SU1dhErcNAFlO83328eO0rXQ4bn7Io7j40jzC7rLKytVxbjaMc3MsqR
         8sC7QSoTmGtB+JZVDl9RB5mA0NB31dZ+zgehqfGBqjXFHW1p+yBN45hpCum7U1muX3v9
         qFCOQZKKc6NHj94e5GZoIQiN9B6rCe1hdfHdPoXHrPp9poKOvmbNNECTOonPPew16JQu
         CY3w==
X-Gm-Message-State: AOAM5309lVKq0Ak7HHOs60IlFLeb3vNjwMKIfumtlAl/OAJzkXxF3ITZ
        nlSJ8zMI2hyZifXApV7NTvY=
X-Google-Smtp-Source: ABdhPJxXUbzUNILe5nlvGL3p385Y+MhRWl8N1Bf0C8DzrenVmL0Btycswy2d7DehUkKZX23wYg4D8Q==
X-Received: by 2002:a05:6402:12d8:: with SMTP id k24mr7523148edx.47.1623945368448;
        Thu, 17 Jun 2021 08:56:08 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id x13sm4097220ejj.21.2021.06.17.08.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 08:56:08 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     rjw@rjwysocki.net, calvin.johnson@oss.nxp.com,
        grant.likely@arm.com, lenb@kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH net-next 2/2] Documentation: ACPI: DSD: fix block code comments
Date:   Thu, 17 Jun 2021 18:55:52 +0300
Message-Id: <20210617155552.1776011-3-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210617155552.1776011-1-ciorneiioana@gmail.com>
References: <20210617155552.1776011-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Use the '.. code-block:: none' to properly highlight the documented DSDT
entries. This also fixes warnings in the documentation build process.

Fixes: e71305acd81c ("Documentation: ACPI: DSD: Document MDIO PHY")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 Documentation/firmware-guide/acpi/dsd/phy.rst | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
index 7d01ae8b3cc6..0d49bad2ea9c 100644
--- a/Documentation/firmware-guide/acpi/dsd/phy.rst
+++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
@@ -27,7 +27,8 @@ network interfaces that have PHYs connected to MAC via MDIO bus.
 During the MDIO bus driver initialization, PHYs on this bus are probed
 using the _ADR object as shown below and are registered on the MDIO bus.
 
-::
+.. code-block:: none
+
       Scope(\_SB.MDI0)
       {
         Device(PHY1) {
@@ -60,7 +61,9 @@ component (PHYs on the MDIO bus).
 a) Silicon Component
 This node describes the MDIO controller, MDI0
 ---------------------------------------------
-::
+
+.. code-block:: none
+
 	Scope(_SB)
 	{
 	  Device(MDI0) {
@@ -80,7 +83,9 @@ This node describes the MDIO controller, MDI0
 b) Platform Component
 The PHY1 and PHY2 nodes represent the PHYs connected to MDIO bus MDI0
 ---------------------------------------------------------------------
-::
+
+.. code-block:: none
+
 	Scope(\_SB.MDI0)
 	{
 	  Device(PHY1) {
@@ -98,7 +103,9 @@ DSDT entries representing MAC nodes
 Below are the MAC nodes where PHY nodes are referenced.
 phy-mode and phy-handle are used as explained earlier.
 ------------------------------------------------------
-::
+
+.. code-block:: none
+
 	Scope(\_SB.MCE0.PR17)
 	{
 	  Name (_DSD, Package () {
-- 
2.31.1

