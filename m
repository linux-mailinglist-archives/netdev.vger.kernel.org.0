Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C09233D63C
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 15:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237634AbhCPO4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 10:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbhCPOzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 10:55:33 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292F3C06175F
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 07:55:33 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id h10so21840563edt.13
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 07:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=081oBGRaopQAFloNt3N+a5BMkxg3DwMH4R3utVGkLRw=;
        b=MajL6vcPyoPEUDQV5QMwXyeaXCKjFnAACtdbk2vJjCI2oL0tY3eP+JBLrqGcpba6C1
         uKvNszqOS2J2uoVUxPEW/SRmZKhjlLuvx98ocSzd2IMgfcf+xZcajMuVDgeUoHA1Tbvp
         Z+EOUq7/fThys70kY0+XZDgh/Ht44VGUOWvv5cAfJHWNDxzRxHaGVd+lzrXSD7VNgTN+
         DQ/zUHK1bADggNXQXyKf5gvdXxLmL+O1aKkklzquWJ2/TN846wufqjB9C5C8GyS1YB37
         lIEzajQZnteOaezKlxngVQ5MXPVSlXDVZDT4p1JnL19cKE3IHB68eQFjJZk++YMalDT2
         rEDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=081oBGRaopQAFloNt3N+a5BMkxg3DwMH4R3utVGkLRw=;
        b=teUVM0DjZ+v3ZyTUxldy2NIKhoEyCQJufHEjS+yROjSO2vNws8c3i+kNopFuylHm0g
         hjBNLgQtUjkVzS1ZD3+EgHJuYGPMWZ0RJIaudok/ExhYamEQRgI8lB9He59j5himW53V
         rc1DL1AR+ZMe4R2OERFIX2HhLap1eDqAPbYpqEZjO+tX4p/NutlcoGMswGntu0fgxIAP
         AWZqZROxEQGf9jWI032V/kmRo3FR/LdJIoQxDesFycP5sLkkmTYVJLNTbm2ntb+HaYGa
         2E6KpN6GlYoBjy4je9miuzLuMOdBb3e0WpyQmt0yXovqGhdu6KRX6FljI5liMLLvOQc5
         RaBg==
X-Gm-Message-State: AOAM532Z9m1RIsoRKQG3YoFQSObeByM8weLV88DoaaamLItzmHz3ctCM
        fqFD1J5SvqLEg3VELLwEZ80=
X-Google-Smtp-Source: ABdhPJz/AoxUdWUK6cVfG40HXo56dMyASnejNj1QmNpQbNMZbEwmuEEuTa/IEEHRqqaf44vwr4qNfA==
X-Received: by 2002:a05:6402:3049:: with SMTP id bu9mr37250881edb.104.1615906530663;
        Tue, 16 Mar 2021 07:55:30 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id w18sm9681402ejn.23.2021.03.16.07.55.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 07:55:30 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ruxandra.radulescu@nxp.com, yangbo.lu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 0/5] dpaa2-switch: small cleanup
Date:   Tue, 16 Mar 2021 16:55:07 +0200
Message-Id: <20210316145512.2152374-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

This patch set addresses various low-hanging issues in both dpaa2-switch
and dpaa2-eth drivers.
Unused ABI functions are removed from dpaa2-switch, all the kernel-doc
warnings are fixed up in both drivers and the coding style for the
remaining ABIs is fixed-up a bit.

Ioana Ciornei (5):
  dpaa2-switch: remove unused ABI functions
  dpaa2-switch: fix kdoc warnings
  dpaa2-switch: reduce the size of the if_id bitmap to 64 bits
  dpaa2-switch: fit the function declaration on the same line
  dpaa2-eth: fixup kdoc warnings

 drivers/net/ethernet/freescale/dpaa2/dpkg.h   |   5 +-
 drivers/net/ethernet/freescale/dpaa2/dpmac.h  |  24 +-
 drivers/net/ethernet/freescale/dpaa2/dpni.c   |   6 +
 drivers/net/ethernet/freescale/dpaa2/dpni.h   | 162 +++++-----
 drivers/net/ethernet/freescale/dpaa2/dprtc.h  |   3 -
 .../net/ethernet/freescale/dpaa2/dpsw-cmd.h   |  11 +-
 drivers/net/ethernet/freescale/dpaa2/dpsw.c   | 281 ++++--------------
 drivers/net/ethernet/freescale/dpaa2/dpsw.h   | 265 +++++------------
 8 files changed, 217 insertions(+), 540 deletions(-)

-- 
2.30.0

