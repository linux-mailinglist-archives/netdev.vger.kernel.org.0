Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F00704B0BAB
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 12:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240431AbiBJLCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 06:02:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240390AbiBJLCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 06:02:33 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0BDFDB;
        Thu, 10 Feb 2022 03:02:34 -0800 (PST)
Received: from localhost.localdomain.datenfreihafen.local (p200300e9d7187a06664ffc391c1aaa99.dip0.t-ipconnect.de [IPv6:2003:e9:d718:7a06:664f:fc39:1c1a:aa99])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@sostec.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 2B8CEC00B0;
        Thu, 10 Feb 2022 12:02:31 +0100 (CET)
From:   Stefan Schmidt <stefan@datenfreihafen.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org
Subject: pull-request: ieee802154-next 2022-02-10
Date:   Thu, 10 Feb 2022 12:02:27 +0100
Message-Id: <20220210110227.3433928-1-stefan@datenfreihafen.org>
X-Mailer: git-send-email 2.34.1
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

An update from ieee802154 for your *net-next* tree.

There is more ongoing in ieee802154 than usual. This will be the first pull
request for this cycle, but I expect one more. Depending on review and rework
times.

Pavel Skripkin ported the atusb driver over to the new USB api to avoid unint
problems as well as making use of the modern api without kmalloc() needs in he
driver.

Miquel Raynal landed some changes to ensure proper frame checksum checking with
hwsim, documenting our use of wake and stop_queue and eliding a magic value by
using the proper define.

David Girault documented the address struct used in ieee802154.

regards
Stefan Schmidt

The following changes since commit 8aaaf2f3af2ae212428f4db1af34214225f5cec3:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-01-09 17:00:17 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan-next.git tags/ieee802154-for-davem-2022-02-10

for you to fetch changes up to 02b2a91c6f0d57df687e666b475849a54f295a12:

  net: ieee802154: Provide a kdoc to the address structure (2022-02-01 21:03:48 +0100)

----------------------------------------------------------------
David Girault (1):
      net: ieee802154: Provide a kdoc to the address structure

Miquel Raynal (3):
      net: ieee802154: hwsim: Ensure frame checksum are valid
      net: ieee802154: Use the IEEE802154_MAX_PAGE define when relevant
      net: mac802154: Explain the use of ieee802154_wake/stop_queue()

Pavel Skripkin (1):
      ieee802154: atusb: move to new USB API

 drivers/net/ieee802154/atusb.c           | 186 +++++++++++--------------------
 drivers/net/ieee802154/mac802154_hwsim.c |   2 +-
 include/net/cfg802154.h                  |  10 ++
 include/net/mac802154.h                  |  12 ++
 net/ieee802154/nl-phy.c                  |   4 +-
 5 files changed, 92 insertions(+), 122 deletions(-)
