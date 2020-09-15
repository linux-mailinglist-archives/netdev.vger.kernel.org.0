Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6A9269D6C
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 06:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgIOEZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 00:25:05 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:36481 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgIOEZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 00:25:04 -0400
Received: by mail-pf1-f174.google.com with SMTP id d9so1205643pfd.3;
        Mon, 14 Sep 2020 21:25:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a4IG6lJBh6+U1SoIVawTeMs0yszM6z5/EUlgPnbAuPA=;
        b=UOrmey3VOUIGx84G9Q11//2BYlIxsxV5rQfgs1sLpP+7Y2gyd2wbV9zWX84i40J1Yi
         Y4UcpEH9QHUvvDV+k+oIdlnpMcpKairQB/bU9GxBmX/uiq/dkMB3EPuLjExKU0F7iCgo
         +/JRbhXod5vT5ZexxNIOeQtIxHNHaihtLIExaHIYI8+nliKppKyNIGFS+kUgYmpIUstL
         /+5tn8Cpu5Pby/W7l0du1y/pTcteru3e8cNcgSwx87KvNF32KwYztV4FtQKL1ijO57qq
         Iz/flinbGK9W6jp1zZhgtJszFobpDPstVJvB68no2Bs69wpPkzCALJC9U6zsQIsn/U6N
         HHjA==
X-Gm-Message-State: AOAM530xd4RJ0LODAEIjdRBnXmxp7kWRz7GDAu0Zbmzpgu5BX/HwXR2C
        BD73M8Vq3EACzoRTi22kmRM=
X-Google-Smtp-Source: ABdhPJxftlbBHrAra9hCmc3vttixPBShGwbtAGyveXCVih49Izh99S//I/vM1Kci+AZDjRHT80y3tQ==
X-Received: by 2002:a63:1252:: with SMTP id 18mr13649891pgs.246.1600143903796;
        Mon, 14 Sep 2020 21:25:03 -0700 (PDT)
Received: from localhost ([2601:647:5b00:1162:1ac0:17a6:4cc6:d1ef])
        by smtp.gmail.com with ESMTPSA id a3sm11897923pfl.213.2020.09.14.21.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 21:25:03 -0700 (PDT)
From:   Moritz Fischer <mdf@kernel.org>
To:     davem@davemloft.net
Cc:     snelson@pensando.io, mst@redhat.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, moritzf@google.com,
        Moritz Fischer <mdf@kernel.org>
Subject: [PATCH net-next v2 0/3] First bunch of Tulip cleanups
Date:   Mon, 14 Sep 2020 21:24:49 -0700
Message-Id: <20200915042452.26155-1-mdf@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is the first bunch of minor cleanups for the de2104x driver
to make it look and behave more like a modern driver.

These changes replace some of the non-devres versions with devres
versions of functions to simplify the error paths.

Next up after this will be the ioremap part.

Changes from v1:
- Fix issue with the pci_enable_device patch.

Moritz Fischer (3):
  net: dec: tulip: de2104x: Replace alloc_etherdev by
    devm_alloc_etherdev
  net: dec: tulip: de2104x: Replace pci_enable_device with devres
    version
  net: dec: tulip: de2104x: Replace kmemdup() with devm_kmempdup()

 drivers/net/ethernet/dec/tulip/de2104x.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

-- 
2.28.0

