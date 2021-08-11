Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35D83E9957
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 22:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhHKUE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 16:04:59 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:42000 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhHKUE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 16:04:58 -0400
Received: from fedora.fritz.box (unknown [80.156.89.81])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@sostec.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 34FCEC028E;
        Wed, 11 Aug 2021 22:04:33 +0200 (CEST)
From:   Stefan Schmidt <stefan@datenfreihafen.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org
Subject: pull-request: ieee802154 for net 2021-08-11
Date:   Wed, 11 Aug 2021 22:04:17 +0200
Message-Id: <20210811200417.1662917-1-stefan@datenfreihafen.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dave, Jakub.

An update from ieee802154 for your *net* tree.

Mostly fixes coming from bot reports. Dongliang Mu tackled some syzkaller
reports in hwsim again and Takeshi Misawa a memory leak  in  ieee802154 raw.

regards
Stefan Schmidt

The following changes since commit 37c86c4a0bfc2faaf0ed959db9de814c85797f09:

  Merge branch 'ks8795-vlan-fixes' (2021-08-10 09:58:15 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan.git tags/ieee802154-for-davem-2021-08-11

for you to fetch changes up to e48599df715793053407dcc2352ff6ba210b0869:

  Merge remote-tracking branch 'net/master' into merge-test (2021-08-10 12:45:20 +0200)

----------------------------------------------------------------
Dongliang Mu (2):
      ieee802154: hwsim: fix GPF in hwsim_set_edge_lqi
      ieee802154: hwsim: fix GPF in hwsim_new_edge_nl

Stefan Schmidt (1):
      Merge remote-tracking branch 'net/master' into merge-test

Takeshi Misawa (1):
      net: Fix memory leak in ieee802154_raw_deliver

 drivers/net/ieee802154/mac802154_hwsim.c | 6 +++---
 net/ieee802154/socket.c                  | 7 ++++++-
 2 files changed, 9 insertions(+), 4 deletions(-)
