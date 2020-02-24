Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF0FC16A5DD
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 13:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbgBXMQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 07:16:18 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35209 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgBXMQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 07:16:18 -0500
Received: by mail-wm1-f68.google.com with SMTP id b17so9140315wmb.0;
        Mon, 24 Feb 2020 04:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=XPjzytM7w1uClSMXbpEVkJXmp/8+ZSQb5PcZcXLELJQ=;
        b=V3mXP28Q4ffq50vDSoTlF1xSkdSeXspgnCERbp4VKruiPhhPb1PATphkbe8v8MTmFB
         1Z2OQkCefIgGokn0lQlj355TEpu/DNnzY5NOtRyHGWHK0YjYnqsx/VYBP9JL3LMJOkaP
         Oq9+4WkFS7c3ShMNGOSHcE4m8R02MQ6orB+dgCAcgj9IyV1Zl7DmaN9wejVVoNnGMNCi
         yxh4x4B3hnSCkV0zgAcfOzSy3hCrDcL2ok4ImoqAHxBWizIxTbyuAh7ePNa0YuecRDgF
         DbzOdkVShGZdeez0ZJOM0gepvjHYy9vQPadBwVAGHBG6E7ipThPzF4AoTO6fm4Wf1mTj
         U0vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XPjzytM7w1uClSMXbpEVkJXmp/8+ZSQb5PcZcXLELJQ=;
        b=JcP3NwV4LaFYf9UmJapkyO70PvLnDSSJnIM23fhE4ANbpaRPoPz/7L8PZ5t0VG7hLQ
         m30Llfjb0GSJqwDWWF/8vKEG3CdnGZHdf7GtilNF3xddaEGxh3VryBrsHhx+HUSVJGSU
         KyFxcWgi4ValoXdj1GXrDiLwfHbc+VmN0HXtmHVdzuwnUqk5CY64YTDMHQSj3f5mNGyB
         pOM0PYU1SdMK/NU2gvu86craGa16iYnUQi4VPXlxvTvBNHtsZHHfR4ewDHWzku//5qbd
         E571MeCSCJC1ZQhol94NcoUfsqrhitGuwTaIYw+FXA4w1/5bCrV3IhNz5qBSlfDPomO1
         hEQw==
X-Gm-Message-State: APjAAAVqU5tKDH2RGH8jb4u6i7oG4U7jmQJQDkVxkaNdWWlwccP+EaSI
        /FSksir3D7Y4DBGdMRE8arM=
X-Google-Smtp-Source: APXvYqwfE04voGa/UTraT7VXsY2989dxXkN06vIHcnN9MmyG1I8v6qCn78HSk/853GR5U0U0ZgLrVA==
X-Received: by 2002:a1c:9c52:: with SMTP id f79mr22028359wme.30.1582546576736;
        Mon, 24 Feb 2020 04:16:16 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id a13sm8450456wrv.62.2020.02.24.04.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 04:16:16 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     shawnguo@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        michael@walle.cc, linux-kernel@vger.kernel.org
Subject: [PATCH v4 net-next 0/2] Remainder for "DT bindings for Felix DSA switch on LS1028A"
Date:   Mon, 24 Feb 2020 14:15:32 +0200
Message-Id: <20200224121534.29679-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series is the remainder of patchset [0] which has been merged
through Shawn Guo's devicetree tree.

It contains changes to the PHY mode validation in the Felix driver
("gmii" to "internal") and the documentation for the DT bindings.

[0]: https://patchwork.ozlabs.org/cover/1242716/

Vladimir Oltean (2):
  net: dsa: felix: Use PHY_INTERFACE_MODE_INTERNAL instead of GMII
  dt-bindings: net: dsa: ocelot: document the vsc9959 core

 .../devicetree/bindings/net/dsa/ocelot.txt    | 116 ++++++++++++++++++
 drivers/net/dsa/ocelot/felix.c                |   3 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c        |   3 +-
 3 files changed, 118 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/ocelot.txt

-- 
2.17.1

