Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF11364636
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 16:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240293AbhDSOfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 10:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240042AbhDSOfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 10:35:34 -0400
Received: from plekste.mt.lv (bute.mt.lv [IPv6:2a02:610:7501:2000::195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2AF0C06174A;
        Mon, 19 Apr 2021 07:35:03 -0700 (PDT)
Received: from [2a02:610:7501:feff:1ccf:41ff:fe50:18b9] (helo=localhost.localdomain)
        by plekste.mt.lv with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <gatis@mikrotik.com>)
        id 1lYUzI-0000xj-Tm; Mon, 19 Apr 2021 17:34:56 +0300
From:   Gatis Peisenieks <gatis@mikrotik.com>
To:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, jesse.brandeburg@intel.com,
        dchickles@marvell.com, tully@mikrotik.com, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gatis Peisenieks <gatis@mikrotik.com>
Subject: [PATCH net-next 0/4] atl1c: support for Mikrotik 10/25G NIC features
Date:   Mon, 19 Apr 2021 17:34:45 +0300
Message-Id: <20210419143449.751852-1-gatis@mikrotik.com>
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


base-commit: 8203c7ce4ef2840929d38b447b4ccd384727f92b
-- 
2.31.1

