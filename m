Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F82609EE6
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 12:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiJXKXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 06:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiJXKXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 06:23:09 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0DD57DC4;
        Mon, 24 Oct 2022 03:23:08 -0700 (PDT)
Received: from localhost.localdomain (unknown [217.17.28.204])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@sostec.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id B1797C0434;
        Mon, 24 Oct 2022 12:23:06 +0200 (CEST)
From:   Stefan Schmidt <stefan@datenfreihafen.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org
Subject: pull-request: ieee802154 for net 2022-10-24
Date:   Mon, 24 Oct 2022 12:23:01 +0200
Message-Id: <20221024102301.9433-1-stefan@datenfreihafen.org>
X-Mailer: git-send-email 2.37.3
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

Two fixup patches for return code changes of an earlier commit.
Wei Yongjun fixed a missed -EINVAL return on the recent change, while
Alexander Aring adds handling for unknown address type cases as well.

Miquel Raynal fixed a long standing issue with LQI value recording
which got broken 8 years ago. (It got more attention with the work
in progress enhancement in wpan).

regards
Stefan Schmidt

The following changes since commit 1d22f78d05737ce21bff7b88b6e58873f35e65ba:

  Merge tag 'ieee802154-for-net-2022-10-05' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan (2022-10-05 20:38:46 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan.git tags/ieee802154-for-net-2022-10-24

for you to fetch changes up to 5a5c4e06fd03b595542d5590f2bc05a6b7fc5c2b:

  mac802154: Fix LQI recording (2022-10-24 11:07:39 +0200)

----------------------------------------------------------------
Alexander Aring (1):
      net: ieee802154: return -EINVAL for unknown addr type

Miquel Raynal (1):
      mac802154: Fix LQI recording

Wei Yongjun (1):
      net: ieee802154: fix error return code in dgram_bind()

 include/net/ieee802154_netdev.h | 12 +++++++++---
 net/ieee802154/socket.c         |  4 +++-
 net/mac802154/rx.c              |  5 +++--
 3 files changed, 15 insertions(+), 6 deletions(-)
