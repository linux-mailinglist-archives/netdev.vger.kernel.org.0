Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA90B1CDE24
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729789AbgEKPIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728090AbgEKPIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 11:08:21 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C94C061A0E
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 08:08:20 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id u16so19695904wmc.5
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 08:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/J8miyILwwd4yeHypeApHEY6tVwb+3C32vv+icx83JU=;
        b=OTdMO8s1WgboMNhaDTGwQRLL6oPTm6LLnYMKvpds/gLxCEYm/L/tz9ICUGzZLiU3ei
         YvwiSmIcssbhOdrNVTjU1HfBqBCs40dnl89hXOHPRmjaAeJghS71NCJu97EEFzClXyBj
         zTErYcE0rLjPIXk+WVMw1CWhUrB1AnSiADXS9GirXjYlf3y0SX2kJ2UxyLMjh70hVx8I
         8EHLcu3Ps8hB00DG8HRf8pVDeNBL0fkVe//Q9BB7IlC/wjAB4W/ZNdfHvQ/nEkSNqcuW
         58RZ2Gwh4Oygoe8bll6iXGBANCMQIPkT9lY0vDfjRphc+q+S6RvvW0gPn4yLXGy29b/Y
         zW1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/J8miyILwwd4yeHypeApHEY6tVwb+3C32vv+icx83JU=;
        b=dXX+GnNGyYEaBKV4lk6LbseeJcrVkEDoLRNoRq2Ll/EIAC5jaJMbSdqicLk0NYG9uz
         M/xCYm3m23RWf6x91kllTOCmNY/+RMvHd8cXCAWR3wqggJBlhaL1GxukwkAgctXoHDhO
         Nw1lIlHp4lGnIlWd7xrCvyl9KVlv+j0lFSnoWdbhZkImtT3gG78NRQ3XWupYdyaiMbJW
         LA5BBRqkjhBQXte62AzVKOvkTb0p4nZoEsZ2bTVfDcqqyFK/eajspGLvnfdNwPwXO0bB
         yN0NSjo077ge2WoHCFarcvG2T7jCmGwhcEWOcqpiG7v1RtrZXjEY9S+VEM/2qVlskNff
         5+Dw==
X-Gm-Message-State: AGi0PuYVtNpJSdujDW18vPh8gQaSV0cC731XR7D3A9pZAXtRDrAaKScD
        W28aftEeg+hMfMtWXVlY1omCVA==
X-Google-Smtp-Source: APiQypKvNSjq4TfJ0CivzedoluQIOXBiXcFnJi5slyojLcRrav800+2iZaWdjk73vkbbGixHhUBMBA==
X-Received: by 2002:a1c:2457:: with SMTP id k84mr30052808wmk.96.1589209699367;
        Mon, 11 May 2020 08:08:19 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id 94sm3514792wrf.74.2020.05.11.08.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 08:08:18 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v2 00/14] mediatek: add support for MediaTek Ethernet MAC
Date:   Mon, 11 May 2020 17:07:45 +0200
Message-Id: <20200511150759.18766-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

This adds support for the Ethernet Controller present on MediaTeK SoCs
from the MT8* family.

The first two patches add binding documents for the PERICFG syscon and
for the MAC itself.

Patches 3/14 & 4/14 do some cleanup of the mediatek ethernet drivers
directory.

Patch 5/14 provides a new helper that allows to retrieve the address of
the net_device associated with given private data address.

Patches 6-8/14 introduce the managed variant of register_netdev().

Patch 9/11 adds the new ethernet driver.

The rest of the patches add DT fixups for the boards already supported
upstream.

v1 -> v2:
- add a generic helper for retrieving the net_device associated with given
  private data
- fix several typos in commit messages
- remove MTK_MAC_VERSION and don't set the driver version
- use NET_IP_ALIGN instead of a magic number (2) but redefine it as it defaults
  to 0 on arm64
- don't manually turn the carrier off in mtk_mac_enable()
- process TX cleanup in napi poll callback
- configure pause in the adjust_link callback
- use regmap_read_poll_timeout() instead of handcoding the polling
- use devres_find() to verify that struct net_device is managed by devres in
  devm_register_netdev()
- add a patch moving all networking devres helpers into net/devres.c
- tweak the dma barriers: remove where unnecessary and add comments to the
  remaining barriers
- don't reset internal counters when enabling the NIC
- set the net_device's mtu size instead of checking the framesize in
  ndo_start_xmit() callback
- fix a race condition in waking up the netif queue
- don't emit log messages on OOM errors
- use dma_set_mask_and_coherent()
- use eth_hw_addr_random()
- rework the receive callback so that we reuse the previous skb if unmapping
  fails, like we already do if skb allocation fails
- rework hash table operations: add proper timeout handling and clear bits when
  appropriate

Bartosz Golaszewski (14):
  dt-bindings: arm: add a binding document for MediaTek PERICFG
    controller
  dt-bindings: net: add a binding document for MediaTek Ethernet MAC
  net: ethernet: mediatek: rename Kconfig prompt
  net: ethernet: mediatek: remove unnecessary spaces from Makefile
  net: core: provide priv_to_netdev()
  net: move devres helpers into a separate source file
  net: devres: define a separate devres structure for
    devm_alloc_etherdev()
  net: devres: provide devm_register_netdev()
  net: ethernet: mtk-eth-mac: new driver
  ARM64: dts: mediatek: add pericfg syscon to mt8516.dtsi
  ARM64: dts: mediatek: add the ethernet node to mt8516.dtsi
  ARM64: dts: mediatek: add an alias for ethernet0 for pumpkin boards
  ARM64: dts: mediatek: add ethernet pins for pumpkin boards
  ARM64: dts: mediatek: enable ethernet on pumpkin boards

 .../arm/mediatek/mediatek,pericfg.yaml        |   34 +
 .../bindings/net/mediatek,eth-mac.yaml        |   80 +
 arch/arm64/boot/dts/mediatek/mt8516.dtsi      |   17 +
 .../boot/dts/mediatek/pumpkin-common.dtsi     |   34 +
 drivers/net/ethernet/mediatek/Kconfig         |    8 +-
 drivers/net/ethernet/mediatek/Makefile        |    3 +-
 drivers/net/ethernet/mediatek/mtk_eth_mac.c   | 1561 +++++++++++++++++
 include/linux/netdevice.h                     |   14 +
 net/Makefile                                  |    2 +-
 net/devres.c                                  |   95 +
 net/ethernet/eth.c                            |   28 -
 11 files changed, 1845 insertions(+), 31 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml
 create mode 100644 Documentation/devicetree/bindings/net/mediatek,eth-mac.yaml
 create mode 100644 drivers/net/ethernet/mediatek/mtk_eth_mac.c
 create mode 100644 net/devres.c

-- 
2.25.0

