Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1FE33195CB
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 23:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbhBKW0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 17:26:12 -0500
Received: from mail-ot1-f47.google.com ([209.85.210.47]:37915 "EHLO
        mail-ot1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhBKW0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 17:26:10 -0500
Received: by mail-ot1-f47.google.com with SMTP id e4so6697142ote.5;
        Thu, 11 Feb 2021 14:25:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NMJ7yLd9O23CBO6jbidyP4gLEKA1R1vMVgKZt27Rrho=;
        b=LnWcRmismu4YPPd4nfoslW4u23YucqrdHJUotExCT92TrOMjo6E8aAQh4/RKfBXsLy
         /47PZ336+PytidRHJrBj2wvC+OF8Sm+VYec8OZ+oMVxnLAqj175X9Xe+9vPkGxPJKta+
         aMxgGossB9rLZbY8kbnJauYXtiAhMI4HWqpCyz0c2H87lll/T3aPukGo2pH1Y5+6SkZA
         cUF8yOn/ee558FDBASOFGkDINTCv5d5FSgo8vQj7Ww+aXidVyK7PEWK/9p8A3k0OOO2R
         xlznzws2LUU292BISZIbFsQWKPG2DySW4Z99pY0vRDWBGNIFO9Rz41m28Z0rNFG+Up68
         odTQ==
X-Gm-Message-State: AOAM5323IC5SBQ8VkgI4p9nikmRS9pbnEV08QKG5wtuJQA8fXY+bEsiz
        NhnugMN69PjlzWhHjp1pEg==
X-Google-Smtp-Source: ABdhPJzRltYMbqkEA5TZcjaBpmfP3dX2bR/krAIyVqt0+CVFo//SIzQQtuDqD4ScQJUbSJBsjy5raQ==
X-Received: by 2002:a9d:1d04:: with SMTP id m4mr151368otm.354.1613082329194;
        Thu, 11 Feb 2021 14:25:29 -0800 (PST)
Received: from xps15.herring.priv (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.googlemail.com with ESMTPSA id j25sm978030otn.55.2021.02.11.14.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 14:25:28 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        devicetree@vger.kernel.org
Cc:     Paul Mackerras <paulus@samba.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Patrice Chotard <patrice.chotard@st.com>,
        Felipe Balbi <balbi@kernel.org>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Gilles Muller <Gilles.Muller@inria.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Michal Marek <michal.lkml@markovi.net>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, cocci@systeme.lip6.fr,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 0/2] of: of_device.h cleanups
Date:   Thu, 11 Feb 2021 16:25:24 -0600
Message-Id: <20210211222526.1318236-1-robh@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a couple of cleanups for of_device.h. They fell out from my
attempt at decoupling of_device.h and of_platform.h which is a mess
and I haven't finished, but there's no reason to wait on these.

Rob

Rob Herring (2):
  of: Remove of_dev_{get,put}()
  driver core: platform: Drop of_device_node_put() wrapper

 arch/powerpc/platforms/pseries/ibmebus.c |  4 ++--
 drivers/base/platform.c                  |  2 +-
 drivers/net/ethernet/ibm/emac/core.c     | 15 ++++++++-------
 drivers/of/device.c                      | 21 ---------------------
 drivers/of/platform.c                    |  4 ++--
 drivers/of/unittest.c                    |  2 +-
 drivers/usb/dwc3/dwc3-st.c               |  2 +-
 include/linux/of_device.h                | 10 ----------
 scripts/coccinelle/free/put_device.cocci |  1 -
 9 files changed, 15 insertions(+), 46 deletions(-)

-- 
2.27.0

