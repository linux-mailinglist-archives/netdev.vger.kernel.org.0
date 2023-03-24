Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7896C8375
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbjCXRjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjCXRjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:39:40 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0565C170;
        Fri, 24 Mar 2023 10:39:38 -0700 (PDT)
Received: from localhost.localdomain.datenfreihafen.local (p200300e9d7115f8f7b5e613a60e47837.dip0.t-ipconnect.de [IPv6:2003:e9:d711:5f8f:7b5e:613a:60e4:7837])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@sostec.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id E9908C0871;
        Fri, 24 Mar 2023 18:39:35 +0100 (CET)
From:   Stefan Schmidt <stefan@datenfreihafen.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        miquel.raynal@bootlin.com, netdev@vger.kernel.org
Subject: pull-request: ieee802154 for net 2023-03-24
Date:   Fri, 24 Mar 2023 18:39:31 +0100
Message-Id: <20230324173931.1812694-1-stefan@datenfreihafen.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.7 required=5.0 tests=RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dave, Jakub, Paolo.

An update from ieee802154 for your *net* tree:

Two small fixes this time.

Dongliang Mu removed an unnecessary null pointer check.

Harshit Mogalapalli fixed an int comparison unsigned against signed from a
recent other fix in the ca8210 driver.

regards
Stefan Schmidt

The following changes since commit cd356010ce4c69ac7e1a40586112df24d22c6a4b:

  net: phy: mscc: fix deadlock in phy_ethtool_{get,set}_wol() (2023-03-15 21:33:22 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wpan/wpan.git tags/ieee802154-for-net-2023-03-24

for you to fetch changes up to 984cfd55e0c99e80b2e5b1dc6b2bf98608af7ff9:

  net: ieee802154: remove an unnecessary null pointer check (2023-03-17 09:13:53 +0100)

----------------------------------------------------------------
Dongliang Mu (1):
      net: ieee802154: remove an unnecessary null pointer check

Harshit Mogalapalli (1):
      ca8210: Fix unsigned mac_len comparison with zero in ca8210_skb_tx()

 drivers/net/ieee802154/ca8210.c | 3 +--
 net/ieee802154/nl802154.c       | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)
