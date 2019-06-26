Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A42775710B
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 20:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfFZSxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 14:53:16 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:42577 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfFZSxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 14:53:16 -0400
Received: by mail-pf1-f201.google.com with SMTP id y7so2352723pfy.9
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 11:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=62U0cC35cAsyCZKdkiaczGeJGITyeHGfSapVw5ghdrI=;
        b=jW9ougi17E8axSEhD+NKKyC6t30/TTNiJH02NSK/6+jHmUB45Xjxg7vRtjRDlj3gn/
         7uEik5kEbeNA26pmi+JHsYxt9LzPOzoaLH1/F6jWPp+C/R/89+XLVU8L2sBJEBFj5b8w
         TQuTXkOvVdPMR9zYfzCfsWWolEPb/zHdISLGkOIaPAzlAhn0uV71tqrNyeHM4tcCZiMw
         HxNJsTrCahn8419f2j6UL1XyXOySJyrfQevLaviPUTfL+hdxQtx3U6ZYyKpoqrFSroS1
         tbrWREuGoK9JHX7fxm2m0S/Pe0eWlMatpramiG/nC7JlD/C+g/FdUBBXteU0RRYujBnG
         Eg/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=62U0cC35cAsyCZKdkiaczGeJGITyeHGfSapVw5ghdrI=;
        b=bDfvHzsiUVb4u9tikiwqVxu7Gj1T5wUbKJQ6Go8g3BHpi4wyDxTsJmVCacrul1KNf5
         3XsoQFrWOUdI15Pnd/j+BjFirllQAniSEOCVI6D764DMAj9rNJ+4XOkSRHHNymPw+iVZ
         xcuytY9EpwGiadeCIwiKd4tzH8VQwH9FN94li9xTdd+ekJUfW02DGCYhbhZCKyvcIiFN
         XjBAN8CERC4jpCTp1c7Q4XvXhmTVITspgTaRndfQgJ/ADxkPff5j0xOHpeQWCPeuv6XT
         Lcq21KbF+a9asLzqyitrEg17hqH6G3H3ZB2WcTQcUXPXbmy1ElXMapuEmObsXuS1faCf
         34Fg==
X-Gm-Message-State: APjAAAUc9m2TaBNwqYoPf1cCydMquPSPxVxK4vJf+cfX/1FqOZ0puR49
        sIG0lirXrPSucbciiu6fHjzvAXoZJhIGKPV4EnixDPDMiUgyOXcgTAqaOI0FU3yj4Yjea/Sxw9p
        HMCdOxnaaqy8RgMPDAfFU/J5vCpMLQm0zNVjZzaWzw/FnF+NIRGZNxgRndOSGbg==
X-Google-Smtp-Source: APXvYqx6SMxzmmFJgNl8aBt7Jsa+LyW9Sf9xaQiIhDRb3sb4fsVMbz56yr4xPHYw547RNnnErqWiAgE7lHc=
X-Received: by 2002:a63:b04a:: with SMTP id z10mr4309902pgo.18.1561575195526;
 Wed, 26 Jun 2019 11:53:15 -0700 (PDT)
Date:   Wed, 26 Jun 2019 11:52:47 -0700
Message-Id: <20190626185251.205687-1-csully@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [net-next 0/4] Add gve driver
From:   Catherine Sullivan <csully@google.com>
To:     netdev@vger.kernel.org
Cc:     Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds the gve driver which will support the
Compute Engine Virtual NIC that will be available in the future.

Catherine Sullivan (4):
  gve: Add basic driver framework for Compute Engine Virtual NIC
  gve: Add transmit and receive support
  gve: Add workqueue and reset support
  gve: Add ethtool support

 .../networking/device_drivers/google/gve.rst  |  123 ++
 .../networking/device_drivers/index.rst       |    1 +
 MAINTAINERS                                   |    9 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/google/Kconfig           |   27 +
 drivers/net/ethernet/google/Makefile          |    5 +
 drivers/net/ethernet/google/gve/Makefile      |    4 +
 drivers/net/ethernet/google/gve/gve.h         |  456 ++++++
 drivers/net/ethernet/google/gve/gve_adminq.c  |  389 ++++++
 drivers/net/ethernet/google/gve/gve_adminq.h  |  215 +++
 drivers/net/ethernet/google/gve/gve_desc.h    |  118 ++
 drivers/net/ethernet/google/gve/gve_ethtool.c |  226 +++
 drivers/net/ethernet/google/gve/gve_main.c    | 1231 +++++++++++++++++
 .../net/ethernet/google/gve/gve_register.h    |   27 +
 drivers/net/ethernet/google/gve/gve_rx.c      |  445 ++++++
 .../net/ethernet/google/gve/gve_size_assert.h |   15 +
 drivers/net/ethernet/google/gve/gve_tx.c      |  584 ++++++++
 18 files changed, 3877 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/google/gve.rst
 create mode 100644 drivers/net/ethernet/google/Kconfig
 create mode 100644 drivers/net/ethernet/google/Makefile
 create mode 100644 drivers/net/ethernet/google/gve/Makefile
 create mode 100644 drivers/net/ethernet/google/gve/gve.h
 create mode 100644 drivers/net/ethernet/google/gve/gve_adminq.c
 create mode 100644 drivers/net/ethernet/google/gve/gve_adminq.h
 create mode 100644 drivers/net/ethernet/google/gve/gve_desc.h
 create mode 100644 drivers/net/ethernet/google/gve/gve_ethtool.c
 create mode 100644 drivers/net/ethernet/google/gve/gve_main.c
 create mode 100644 drivers/net/ethernet/google/gve/gve_register.h
 create mode 100644 drivers/net/ethernet/google/gve/gve_rx.c
 create mode 100644 drivers/net/ethernet/google/gve/gve_size_assert.h
 create mode 100644 drivers/net/ethernet/google/gve/gve_tx.c

-- 
2.22.0.410.gd8fdbe21b5-goog

