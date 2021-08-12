Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3055C3EAA5A
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 20:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234348AbhHLSjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 14:39:49 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:56908 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234251AbhHLSjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 14:39:48 -0400
Received: from fedora.fritz.box (unknown [80.156.89.114])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@sostec.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 5ED3FC0387;
        Thu, 12 Aug 2021 20:39:20 +0200 (CEST)
From:   Stefan Schmidt <stefan@datenfreihafen.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org
Subject: pull-request: ieee802154 for net 2021-08-12 v2
Date:   Thu, 12 Aug 2021 20:39:12 +0200
Message-Id: <20210812183912.1663996-1-stefan@datenfreihafen.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dave, Jakub.

An update from ieee802154 for your *net* tree.

This is a v2 with the merge commit elided.

Mostly fixes coming from bot reports. Dongliang Mu tackled some syzkaller
reports in hwsim again and Takeshi Misawa a memory leak  in  ieee802154 raw.

regards
Stefan Schmidt

The following changes since commit be7f62eebaff2f86c1467a2d33930a0a7a87675b:

  net: dsa: sja1105: fix NULL pointer dereference in sja1105_reload_cbs() (2021-06-24 15:46:51 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan.git tags/ieee802154-for-davem-2021-08-12

for you to fetch changes up to 1090340f7ee53e824fd4eef66a4855d548110c5b:

  net: Fix memory leak in ieee802154_raw_deliver (2021-08-10 12:18:10 +0200)

----------------------------------------------------------------
Dongliang Mu (2):
      ieee802154: hwsim: fix GPF in hwsim_set_edge_lqi
      ieee802154: hwsim: fix GPF in hwsim_new_edge_nl

Takeshi Misawa (1):
      net: Fix memory leak in ieee802154_raw_deliver

 drivers/net/ieee802154/mac802154_hwsim.c | 6 +++---
 net/ieee802154/socket.c                  | 7 ++++++-
 2 files changed, 9 insertions(+), 4 deletions(-)
