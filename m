Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F31C5164806
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 16:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgBSPNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 10:13:08 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38191 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbgBSPNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 10:13:08 -0500
Received: by mail-wm1-f66.google.com with SMTP id a9so1041988wmj.3;
        Wed, 19 Feb 2020 07:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=lBnHOm9+KR9D6W7zBug28Lbh16kwAOqgMkWqDNeGK6o=;
        b=RukMzdYRUrSyPSfWpOOlyN711haqeIYBdd3eN0Yz7/sQ7KlM03p14yPxg7f10bfr3I
         1nQOLF3UGpDmQROejv6mqeCZHKgQvze+5Yh+LcFEjas0uLWHx4FQsGTx3G1ENdLuAk90
         iLVTe99Z4naV1B95VxcpWWngbUoC8rpmHiQwws3C0uQeJ8YQvhAKfu6ya1AX9QpdS3W2
         IEXwyE0Tqym1TpB6I/6GSRKihwkLp0jp6Ru4vVQ0tn8ifoDRNh4/j2EEGuWhBekwTuwz
         NDWX3ceQ4gk2OrA0oxKj/ZQpZLZFextpFhWT3j7Urdmb3inyInUMrWTMR2IHYoIzS5Ab
         I83A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lBnHOm9+KR9D6W7zBug28Lbh16kwAOqgMkWqDNeGK6o=;
        b=dHMVT2H/lDftY+3i+xik9URcuL5nhbucNuNBv3CB+BBoWcdtWLhCSsCQU6wL60uBK6
         BVlln8NAmDXqFvsO+Yg//LNwc5FtNod7deLZKshTbH+PGW94TXYE0Y5bni20gtgH9pcB
         ZrBeo2JcuSj7qvLxbLKfrefGCF7tEfFOuoWf28U+ICWYQR/AtTEIoyGDhqoBfpVjW+Zr
         bpovhO0CsweqFtpUV/mim4TOjM7z/xfHIjziXdx0RKH1lf3tOkaKKdA3X9zRT/69zuuY
         8AbDRsBrfYk59qH8XaWDF5klaqMnddXj5VIhbIYu27jffy0/GXC55NQz4amK+8MpC1P0
         0u9Q==
X-Gm-Message-State: APjAAAUbK1WrPTkIZEVaX1mS9siy7rLwOuM4SgMG+rx5MjO3qJrBIkgc
        zKbuK3HG6Gzi+TkUSZXOtnw=
X-Google-Smtp-Source: APXvYqzzc7eb8Leb62NNIsUSOZ0br96pqX0VUBn9tPBIfdh8Alps+1K3wJg1uJuk45qDHRDwj/DIXQ==
X-Received: by 2002:a1c:e28a:: with SMTP id z132mr10371198wmg.157.1582125185060;
        Wed, 19 Feb 2020 07:13:05 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id b13sm83137wrq.48.2020.02.19.07.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 07:13:04 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     shawnguo@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next/devicetree 0/5] DT bindings for Felix DSA switch on LS1028A
Date:   Wed, 19 Feb 2020 17:12:54 +0200
Message-Id: <20200219151259.14273-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series officializes the device tree bindings for the embedded
Ethernet switch on NXP LS1028A (and for the reference design board).
The driver has been in the tree since v5.4-rc6.

As per feedback received in v1, I've changed the DT bindings for the
internal ports from "gmii" to "internal". So I would like the entire
series to be merged through a single tree, be it net-next or devicetree.
If this happens, I would like the other maintainer to acknowledge this
fact and the patches themselves. Thanks.

Claudiu Manoil (2):
  arm64: dts: fsl: ls1028a: add node for Felix switch
  arm64: dts: fsl: ls1028a: enable switch PHYs on RDB

Vladimir Oltean (3):
  arm64: dts: fsl: ls1028a: delete extraneous #interrupt-cells for ENETC
    RCIE
  net: dsa: felix: Use PHY_INTERFACE_MODE_INTERNAL instead of GMII
  dt-bindings: net: dsa: ocelot: document the vsc9959 core

 .../devicetree/bindings/net/dsa/ocelot.txt    | 96 +++++++++++++++++++
 .../boot/dts/freescale/fsl-ls1028a-rdb.dts    | 51 ++++++++++
 .../arm64/boot/dts/freescale/fsl-ls1028a.dtsi | 85 +++++++++++++++-
 drivers/net/dsa/ocelot/felix.c                |  3 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c        |  3 +-
 5 files changed, 232 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/ocelot.txt

-- 
2.17.1

