Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD4A6A8527
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 16:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjCBPbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 10:31:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbjCBPbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 10:31:05 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4912E12BD0;
        Thu,  2 Mar 2023 07:31:03 -0800 (PST)
Received: from localhost.localdomain.datenfreihafen.local (p200300e9d718cfbb38f25c92aa892f41.dip0.t-ipconnect.de [IPv6:2003:e9:d718:cfbb:38f2:5c92:aa89:2f41])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@sostec.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 173C3C0151;
        Thu,  2 Mar 2023 16:31:01 +0100 (CET)
From:   Stefan Schmidt <stefan@datenfreihafen.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        miquel.raynal@bootlin.com, netdev@vger.kernel.org
Subject: pull-request: ieee802154 for net 2023-03-02
Date:   Thu,  2 Mar 2023 16:30:32 +0100
Message-Id: <20230302153032.1312755-1-stefan@datenfreihafen.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dave, Jakub, Paolo.

An update from ieee802154 for your *net* tree:

Two small fixes this time.

Alexander Aring fixed a potential negative array access in the ca8210 driver.

Miquel Raynal fixed a crash that could have been triggered through the extended
netlink API for 802154. This only came in this merge window. Found by syzkaller.

Please note the new git URL. We switched to team maintenance and thus the pull
request will point to wpan instead of the former used sschmidt namespace on
kernel.org. In the future you will also see pull requests coming from Alex and
Miquel for ieee802154 for net and net-next.

regards
Stefan Schmidt

The following changes since commit 044c8bf78db818b8c726eb47c560e05fbc71e128:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf (2023-03-02 11:10:43 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wpan/wpan.git tags/ieee802154-for-net-2023-03-02

for you to fetch changes up to 02f18662f6c671382345fcb696e808d78f4c194a:

  ieee802154: Prevent user from crashing the host (2023-03-02 14:39:48 +0100)

----------------------------------------------------------------
Alexander Aring (1):
      ca8210: fix mac_len negative array access

Miquel Raynal (1):
      ieee802154: Prevent user from crashing the host

 drivers/net/ieee802154/ca8210.c | 2 ++
 net/ieee802154/nl802154.c       | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)
