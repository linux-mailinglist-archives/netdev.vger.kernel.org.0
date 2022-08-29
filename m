Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 394095A46BA
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 12:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiH2KDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 06:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiH2KDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 06:03:17 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623CB5FAC1;
        Mon, 29 Aug 2022 03:03:15 -0700 (PDT)
Received: from localhost.localdomain.datenfreihafen.local (p200300e9d7011d41444abdf5adf89c98.dip0.t-ipconnect.de [IPv6:2003:e9:d701:1d41:444a:bdf5:adf8:9c98])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@sostec.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id DA1F2C040C;
        Mon, 29 Aug 2022 12:03:12 +0200 (CEST)
From:   Stefan Schmidt <stefan@datenfreihafen.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org
Subject: pull-request: ieee802154 for net 2022-08-29
Date:   Mon, 29 Aug 2022 12:03:08 +0200
Message-Id: <20220829100308.2802578-1-stefan@datenfreihafen.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dave, Jakub.

An update from ieee802154 for your *net* tree.

A repeated word fix from Jilin Yuan.
A missed return code setting in the cc2520 driver by Li Qiong.
Fixing a potential race in by defering the workqueue destroy in the adf7242
driver by Lin Ma.
Fixing a long standing problem in the mac802154 rx path to match corretcly by
Miquel Raynal.

regards
Stefan Schmidt

The following changes since commit 5003e52c311a2135d737ae906577c639fbaafe54:

  Merge branch 'bonding-802-3ad-fix-no-transmission-of-lacpdus' (2022-08-22 18:30:28 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan.git tags/ieee802154-for-net-2022-08-29

for you to fetch changes up to ffd7bdddaab193c38416fd5dd416d065517d266e:

  ieee802154: cc2520: add rc code in cc2520_tx() (2022-08-29 11:10:22 +0200)

----------------------------------------------------------------
Jilin Yuan (1):
      net/ieee802154: fix repeated words in comments

Li Qiong (1):
      ieee802154: cc2520: add rc code in cc2520_tx()

Lin Ma (1):
      ieee802154/adf7242: defer destroy_workqueue call

Miquel Raynal (1):
      net: mac802154: Fix a condition in the receive path

 drivers/net/ieee802154/adf7242.c | 3 ++-
 drivers/net/ieee802154/ca8210.c  | 2 +-
 drivers/net/ieee802154/cc2520.c  | 1 +
 net/mac802154/rx.c               | 2 +-
 4 files changed, 5 insertions(+), 3 deletions(-)
