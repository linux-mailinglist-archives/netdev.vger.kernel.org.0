Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99BF25F56A6
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 16:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbiJEOpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 10:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiJEOpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 10:45:17 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153D11C908;
        Wed,  5 Oct 2022 07:45:15 -0700 (PDT)
Received: from localhost.localdomain.datenfreihafen.local (p200300e9d724a76b99bd950755e0d439.dip0.t-ipconnect.de [IPv6:2003:e9:d724:a76b:99bd:9507:55e0:d439])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@sostec.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 98F44C056B;
        Wed,  5 Oct 2022 16:45:13 +0200 (CEST)
From:   Stefan Schmidt <stefan@datenfreihafen.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org
Subject: pull-request: ieee802154 for net 2022-10-05
Date:   Wed,  5 Oct 2022 16:45:08 +0200
Message-Id: <20221005144508.787376-1-stefan@datenfreihafen.org>
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

Only two patches this time around. A revert from Alexander Aring to a patch
that hit net and the updated patch to fix the problem from Tetsuo Handa.

regards
Stefan Schmidt

The following changes since commit 0326074ff4652329f2a1a9c8685104576bd8d131:

  Merge tag 'net-next-6.1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2022-10-04 13:38:03 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan.git tags/ieee802154-for-net-2022-10-05

for you to fetch changes up to b12e924a2f5b960373459c8f8a514f887adf5cac:

  net/ieee802154: don't warn zero-sized raw_sendmsg() (2022-10-05 12:37:10 +0200)

----------------------------------------------------------------
Alexander Aring (1):
      Revert "net/ieee802154: reject zero-sized raw_sendmsg()"

Tetsuo Handa (1):
      net/ieee802154: don't warn zero-sized raw_sendmsg()

 net/ieee802154/socket.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)
