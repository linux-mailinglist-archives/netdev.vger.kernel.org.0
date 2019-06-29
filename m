Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF7765AC1E
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 17:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbfF2PRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 11:17:17 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42201 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbfF2PRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 11:17:17 -0400
Received: by mail-pf1-f194.google.com with SMTP id q10so4407913pff.9
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 08:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=wvR4h97GZFoinczaJ5SV1JajuYiiNABAHd10ggy8DOM=;
        b=hqrj3MPut0Qeka5Uj5eo4ENpq8XksNz8zyDdYheZATR1IhKXHzEx3nEa12l3gfq4IT
         64ZNZEANAncv52043lu//n5hSrLnGePCeouhBT8k53JX50ySodx7kck6ebSGXKZoA0Yy
         d2hqrMCgDmYMQh8aT0eTqCUqWbaQxS3cnspFI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wvR4h97GZFoinczaJ5SV1JajuYiiNABAHd10ggy8DOM=;
        b=lGlsT1U5zz6rSWOessrXeVyE5qHxLGxGMLWKAgXT/56/X3xJukDcEsQmkDL4+O3pVg
         KNlYqxDzkOpbeC8ms8kEbfJYz9VdwtniKQLjCZ/L6DMcq6RjawNXc4qaQyE7jeI6vG5W
         Ds66cVLd/9ZVONCXETLyJSMfQfWANb/n0llhRGEuy/fKzbPb5ws0r/qAm1eHMTCfLgDA
         8JbDLG0m9dxEQj+xzpwspdTgDwKSq92Y2p+3Deu635WPuKz6D6MtvBINkYhTx2xKS5bI
         lRd8alK7xlN0oRi1L9QeNLzGFRWBIToMDMiEI5GzRvMj579TFH9x39o10KbjH8uC26Al
         kUIQ==
X-Gm-Message-State: APjAAAXQXU25b6gt7I5iI9Vn5WfRY8Q+AaFThXI7E0ZW1OnDTbHZ+aFM
        6mXvQZDHM/UO6JBnT4PYLq8Fug==
X-Google-Smtp-Source: APXvYqyqM2EvjhwEn0a7EgO+IhHLYyUGynZzW7RNAlfbwxGMoTVtd/C00/X/4rzq2QPNjrJRE699Gw==
X-Received: by 2002:a63:dc56:: with SMTP id f22mr15173584pgj.305.1561821436393;
        Sat, 29 Jun 2019 08:17:16 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z14sm5048233pgs.79.2019.06.29.08.17.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Jun 2019 08:17:15 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 0/5] bnxt_en: Bug fixes.
Date:   Sat, 29 Jun 2019 11:16:43 -0400
Message-Id: <1561821408-17418-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Miscellaneous bug fix patches, including two resource handling fixes for
the RDMA driver, a PCI shutdown patch to add pci_disable_device(), a patch
to fix ethtool selftest crash, and the last one suppresses an unnecessry
error message.

Please also queue patches 1, 2, and 3 for -stable.  Thanks.

Michael Chan (5):
  bnxt_en: Disable bus master during PCI shutdown and driver unload.
  bnxt_en: Fix ethtool selftest crash under error conditions.
  bnxt_en: Fix statistics context reservation logic for RDMA driver.
  bnxt_en: Cap the returned MSIX vectors to the RDMA driver.
  bnxt_en: Suppress error messages when querying DSCP DCB capabilities.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 20 +++++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c     |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  6 +++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c     |  4 +++-
 4 files changed, 20 insertions(+), 12 deletions(-)

-- 
2.5.1

