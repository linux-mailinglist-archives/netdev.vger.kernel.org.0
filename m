Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDAB64286F
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 13:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiLEM2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 07:28:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiLEM2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 07:28:40 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BC5BE0C;
        Mon,  5 Dec 2022 04:28:38 -0800 (PST)
Received: from localhost.localdomain.datenfreihafen.local (p5dd0dfce.dip0.t-ipconnect.de [93.208.223.206])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@sostec.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id BFC7AC0049;
        Mon,  5 Dec 2022 13:28:36 +0100 (CET)
From:   Stefan Schmidt <stefan@datenfreihafen.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org
Subject: pull-request: ieee802154 for net 2022-12-05
Date:   Mon,  5 Dec 2022 13:25:15 +0100
Message-Id: <20221205122515.1720539-1-stefan@datenfreihafen.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dave, Jakub.

An update from ieee802154 for your *net* tree:

Three small fixes this time around.

Ziyang Xuan fixed an error code for a timeout during initialization of the
cc2520 driver.
Hauke Mehrtens fixed a crash in the ca8210 driver SPI communication due
uninitialized SPI structures.
Wei Yongjun added INIT_LIST_HEAD ieee802154_if_add() to avoid a potential
null pointer dereference.

regards
Stefan Schmidt


The following changes since commit baee5a14ab2c9a8f8df09d021885c8f5de458a38:

  Merge tag 'ieee802154-for-net-2022-10-24' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan (2022-10-24 21:17:03 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan.git tags/ieee802154-for-net-2022-12-05

for you to fetch changes up to b3d72d3135d2ef68296c1ee174436efd65386f04:

  mac802154: fix missing INIT_LIST_HEAD in ieee802154_if_add() (2022-12-05 09:53:08 +0100)

----------------------------------------------------------------
Hauke Mehrtens (1):
      ca8210: Fix crash by zero initializing data

Wei Yongjun (1):
      mac802154: fix missing INIT_LIST_HEAD in ieee802154_if_add()

Ziyang Xuan (1):
      ieee802154: cc2520: Fix error return code in cc2520_hw_init()

 drivers/net/ieee802154/ca8210.c | 2 +-
 drivers/net/ieee802154/cc2520.c | 2 +-
 net/mac802154/iface.c           | 1 +
 3 files changed, 3 insertions(+), 2 deletions(-)
