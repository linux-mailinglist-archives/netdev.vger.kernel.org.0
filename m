Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACF6C26672D
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725793AbgIKRjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbgIKRiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 13:38:55 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4FBC061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 10:38:55 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id u18so9743937ybu.0
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 10:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=GVT+4F0h7asqzizzjQkH8cD1/vs6XpJA+rgLXFc50AI=;
        b=UeLVJsAoQd/Dhxxlgd+WbvoiUJhb2MEKWjlDwEOrrGCRwt9ocwa6UebRNyz09+8nJb
         NvRQ2P21xyYkwGqaa2QcCnRG88JJ1fCca+5fhVVka8cbTSu9/y92svaBieH1MtGk/OYt
         X/M9l3V/wndpIcEbLiWjoEF4an9q0hpGXc5Zctt4gpKxO02bsWdBIh0U8sNSKRpbnusI
         p8pceHPImKmwQakfyNdkQV87byMgaX/3oFHnpzXLBO6iqZ6Ui4iRVCrfisyQKSZToaZ6
         ZJobw43QcZau7uFf4C+g+r1/98+x5DO6kW3Johm9ENxTLn5J91DQrSleSfFxZBFfA7j2
         jRug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=GVT+4F0h7asqzizzjQkH8cD1/vs6XpJA+rgLXFc50AI=;
        b=QWhihXA4Ak3ghLit5UYZ5uDvu9Fk45I2mDW0nRfactZhO1qoqxO335H3Q2ESVe6HTr
         3adk1e0l8JnV0Ztl+XSRrzFKVakFGaH5z9YwU7YqKRdnjgu1oje52wD/abFxOSwPaM35
         RMxGo23ft7/cxKpVRQNvCoAM6Casn04LQaNlxaN+L6OuvGJ2E6zEhPkaqRZOFCqhvs4G
         0yDPDWFWcYSba3tSwUsd5Klfn6+g2Fn68e4ZqFg4lponUpII9t7Fj0Bt10xawKjbZeHB
         7iqv/sr7HwkE2j/FTkztVqE+bpl30s5bh+nQbKRVIt9ZmUoT+aZ+1hn4WUzOW1elsQEF
         5x6g==
X-Gm-Message-State: AOAM5311Ow7xjwDg5ePC/8PVOfgsIRiH0uQkMbI8wXqWHFLKUfMzqOj/
        ABZFtHtrFh8yE+TMHl2XCKoYiUc6YxJg1f5hxRn7gS73V2XLaDgiPKGiDuR0efs9dyPXZAQbW3d
        +sR6y6POIoZaHCbfyAwHv0YfVHYjLpyI3/BqaYccol7/boNodFRvODTF87DyQCC6f9xkE+hcC
X-Google-Smtp-Source: ABdhPJzJwvgG6cg4ATBHcWg/QYvslwpzstBpkOnePZkbf9L0C3dWqgq3wukvN1jxJVgMsESjmYUhrwct82ugyP2Q
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a25:60d5:: with SMTP id
 u204mr4012617ybb.44.1599845934897; Fri, 11 Sep 2020 10:38:54 -0700 (PDT)
Date:   Fri, 11 Sep 2020 10:38:43 -0700
Message-Id: <20200911173851.2149095-1-awogbemila@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH net-next v4 0/8] Add GVE Features.
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Note: Patch 4 in v3 was dropped.

Patch 4 (patch 5 in v3): Start/stop timer only when report stats is
				enabled/disabled.
Patch 7 (patch 8 in v3): Use netdev_info, not dev_info, to log
				device link status.

Catherine Sullivan (1):
  gve: Use dev_info/err instead of netif_info/err.

David Awogbemila (2):
  gve: NIC stats for report-stats and for ethtool
  gve: Enable Link Speed Reporting in the driver.

Kuo Zhao (3):
  gve: Get and set Rx copybreak via ethtool
  gve: Add stats for gve.
  gve: Add Gvnic stats AQ command and ethtool show/set-priv-flags.

Patricio Noyola (1):
  gve: Use link status register to report link status

Sagi Shahar (1):
  gve: Batch AQ commands for creating and destroying queues.

 drivers/net/ethernet/google/gve/gve.h         | 106 ++++-
 drivers/net/ethernet/google/gve/gve_adminq.c  | 315 +++++++++++++--
 drivers/net/ethernet/google/gve/gve_adminq.h  |  62 ++-
 drivers/net/ethernet/google/gve/gve_ethtool.c | 366 ++++++++++++++++--
 drivers/net/ethernet/google/gve/gve_main.c    | 301 ++++++++++----
 .../net/ethernet/google/gve/gve_register.h    |   1 +
 drivers/net/ethernet/google/gve/gve_rx.c      |  37 +-
 7 files changed, 1024 insertions(+), 164 deletions(-)

-- 
2.28.0.526.ge36021eeef-goog

