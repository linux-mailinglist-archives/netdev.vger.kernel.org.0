Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7AD13AB7FF
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 17:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhFQP6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 11:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233485AbhFQP6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 11:58:16 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE120C061574
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 08:56:07 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id s15so4670089edt.13
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 08:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SZhb3E6PK0i+3eNtO2PswVPyfSgdN3tL1CwbW05mP0A=;
        b=aOmYgjgZeCFP5eoAZy+2TXtbw0yRBifzslWJs1kH92f2wA8CJqqWW00/cgqZDM0Ml7
         /Ruh1Wwr9EopzGoCg1BN0I9vM2RPi0zl5rnkuwKiH5/l1YBiyHdw69xobB5Cc/cOgvkt
         AGpu9drb315bdl9Cdqd53x0rCOkJOak9OoWb6/r1HPpoXx/8qEBZfSySSylAbEK2Qexy
         80mBn80bOaLYp90DMqfiJr4nUo8UmxxG9h1Y1FtcTh8TWBqZle6VY8bhQTE+OHwpoldw
         oRDa6WHJPHSp5E6St2xf9WzKiXkRCzbA0pjVUMfh7vX8U/Ky5xr7S5qF+bpKynVdgAjY
         KweA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SZhb3E6PK0i+3eNtO2PswVPyfSgdN3tL1CwbW05mP0A=;
        b=oMCCuYnYI6+790Y7V/XxiRiz+MqOYEU4m6FhBtqlMTn3NuW8oHrTvXekcomb2fLnh8
         QM3d1DjuZDMcSkOY7dVgU+oikbPdbYUj+TUNpeWaMsIbbgvghPPA44Lp5QedZZeEnOlj
         llvXrCpOglkmxe5yKpITbse08m5ILjfqIymWucFXyl0d+e4Y5XutTlSaUHwcRGJrWW9K
         KCiP9FvIj0HZIKZlJhj54Is03sP4GaNxTwk8liDSLFOEGs59weT79stEjW8DTfIV83Ea
         o47NExsDjAXlcwtrBqgVhARFAOfKqH3vFh+sTshA7/ZJAhrbfh3bt413CrAIfDL82WQx
         VkLA==
X-Gm-Message-State: AOAM530i+GRqcPXfgKd6X2XiaRNF8wQVxeY5txgMDRKdYo24pvJS3hXK
        vE0oJPWqbDwvAmCBNO1lScxC6wxAefs=
X-Google-Smtp-Source: ABdhPJybDkp82YG5UL8TLObBKWvq5In3nuzYt5Sfy4cxDhS6XIKsG89wunCAhB02J8n5aTzYjjLVlw==
X-Received: by 2002:a05:6402:4315:: with SMTP id m21mr7434479edc.39.1623945366265;
        Thu, 17 Jun 2021 08:56:06 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id x13sm4097220ejj.21.2021.06.17.08.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 08:56:05 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     rjw@rjwysocki.net, calvin.johnson@oss.nxp.com,
        grant.likely@arm.com, lenb@kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 0/2] Documentation: ACPI: DSD: fix some build warnings
Date:   Thu, 17 Jun 2021 18:55:50 +0300
Message-Id: <20210617155552.1776011-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Fix some build warnings in the phy.rst documentation describing the MDIO
bus and PHYs in ACPI.

Ioana Ciornei (2):
  Documentation: ACPI: DSD: include phy.rst in the toctree
  Documentation: ACPI: DSD: fix block code comments

 Documentation/firmware-guide/acpi/dsd/phy.rst | 15 +++++++++++----
 Documentation/firmware-guide/acpi/index.rst   |  1 +
 2 files changed, 12 insertions(+), 4 deletions(-)

-- 
2.31.1

