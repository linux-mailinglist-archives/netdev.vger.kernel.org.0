Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12BB449D939
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 04:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235735AbiA0D1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 22:27:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiA0D1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 22:27:23 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8435C06161C;
        Wed, 26 Jan 2022 19:27:22 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d7so1321378plr.12;
        Wed, 26 Jan 2022 19:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rrf6Rn0SiGYwefrxHIaDPJrUN9dc6c+oBR7QCLv3tw0=;
        b=Fds/GIhVOknR2vLQcpl/UNHtf6cVO7D1Mpx3Uc64WTgaF917gWA8CsOvYjecV7raW0
         wn3fDD28vlw4eEgHgVJOror22FzJQzQfap5lRcuzXL1MG4YS7bFpsokyBwjr6RXq0Ym0
         qlDwU3u2HrZsWoeUCpjWlF3SEXqdsLqUV/fX9Px7zvf074ghTDWgriFB3/MrZefBu7vn
         7lNgsVhwy+mP/yWRnjdTYOJipL5/k9ykfD7WiL42Ov8A4g+Ap/cMw+JCanh7YwzT4u3j
         q9od0gfO7B1M0Sc8Dl13hUCIZJsFZA0s0MihML7kiKW9WsKbVPtWmtbEPz34TPjpW1Ra
         xVRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rrf6Rn0SiGYwefrxHIaDPJrUN9dc6c+oBR7QCLv3tw0=;
        b=oo16kCN+Fi4xxZGViXV2ttYdwqfftJWbKiTF9kDJVRbZcOJpD5HRy8PafKWP6CnCQg
         v3VF3ADjCDs7Vj0+AwLpcPW7jD+w0faPuADXHxVKkppUz09zjQy8avwRAr5pJ92SepDz
         mFneij9RmWPSzo1Iryv6oNGFA0OgAwOuhSidD7WMcjO11wUAlG4hOtW1eDKt3+jMcmSP
         guzsesF4lbOfdGSTsWbKWsnGVlwacJxCRcOORiIXdQzl6FObyGHDIhaPOcUOJ+htCekL
         9Ipr8IdlcNE0+zZ4raipHoAxA/mBX3Cvppu/6WDDxeiTIzM3+nG0SJ00XmM/y5Z3chFj
         T7zA==
X-Gm-Message-State: AOAM5316z++lhPU0Lp/riAGAXVyejP5Bdbc2afjfbEO/V6CDB2LBeIAT
        xIMEzB8xzLrawg3jNt+NSs0=
X-Google-Smtp-Source: ABdhPJzgaQLsuW+2jyLO1D2zvbNe9otwEuO3KtZUxK7LRi40FMdidk+qmWnwoQRns18b6IKwg5UHIA==
X-Received: by 2002:a17:902:ba94:: with SMTP id k20mr1459101pls.155.1643254042295;
        Wed, 26 Jan 2022 19:27:22 -0800 (PST)
Received: from localhost.localdomain (61-231-106-36.dynamic-ip.hinet.net. [61.231.106.36])
        by smtp.gmail.com with ESMTPSA id s6sm634536pjg.22.2022.01.26.19.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 19:27:21 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        andrew@lunn.ch, leon@kernel.org
Subject: [PATCH v14, 0/2] ADD DM9051 ETHERNET DRIVER
Date:   Thu, 27 Jan 2022 11:26:59 +0800
Message-Id: <20220127032701.23056-1-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DM9051 is a spi interface chip,
need cs/mosi/miso/clock with an interrupt gpio pin

Joseph CHAMG (1):
  net: Add dm9051 driver

JosephCHANG (1):
  yaml: Add dm9051 SPI network yaml file

 .../bindings/net/davicom,dm9051.yaml          |   62 +
 drivers/net/ethernet/davicom/Kconfig          |   31 +
 drivers/net/ethernet/davicom/Makefile         |    1 +
 drivers/net/ethernet/davicom/dm9051.c         | 1151 +++++++++++++++++
 drivers/net/ethernet/davicom/dm9051.h         |  159 +++
 5 files changed, 1404 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
 create mode 100644 drivers/net/ethernet/davicom/dm9051.c
 create mode 100644 drivers/net/ethernet/davicom/dm9051.h


base-commit: 9d922f5df53844228b9f7c62f2593f4f06c0b69b
-- 
2.20.1

