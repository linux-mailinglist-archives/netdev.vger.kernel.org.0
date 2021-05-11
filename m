Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5666E37AF07
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 21:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhEKTGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 15:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbhEKTGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 15:06:46 -0400
Received: from plekste.mt.lv (bute.mt.lv [IPv6:2a02:610:7501:2000::195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0D1C06174A;
        Tue, 11 May 2021 12:05:39 -0700 (PDT)
Received: from [2a02:610:7501:feff:1ccf:41ff:fe50:18b9] (helo=localhost.localdomain)
        by plekste.mt.lv with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <gatis@mikrotik.com>)
        id 1lgXhA-0004HR-RQ; Tue, 11 May 2021 22:05:28 +0300
From:   Gatis Peisenieks <gatis@mikrotik.com>
To:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, jesse.brandeburg@intel.com,
        dchickles@marvell.com, tully@mikrotik.com, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gatis Peisenieks <gatis@mikrotik.com>
Subject: [PATCH net-next 0/4] atl1c: support for Mikrotik 10/25G NIC features
Date:   Tue, 11 May 2021 22:05:14 +0300
Message-Id: <20210511190518.8901-1-gatis@mikrotik.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new Mikrotik 10/25G NIC maintains compatibility with existing atl1c
driver. However it does have new features.

This patch set adds support for reporting cards higher link speed, max-mtu,
enables rx csum offload and improves tx performance.

Gatis Peisenieks (4):
  atl1c: show correct link speed on Mikrotik 10/25G NIC
  atl1c: improve performance by avoiding unnecessary pcie writes on xmit
  atl1c: adjust max mtu according to Mikrotik 10/25G NIC ability
  atl1c: enable rx csum offload on Mikrotik 10/25G NIC

 drivers/net/ethernet/atheros/atl1c/atl1c.h    |  3 ++
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.c |  9 +++++
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.h |  7 ++++
 .../net/ethernet/atheros/atl1c/atl1c_main.c   | 33 +++++++++++++++----
 4 files changed, 46 insertions(+), 6 deletions(-)


base-commit: 3913ba732e972d88ebc391323999e780a9295852
-- 
2.31.1

