Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2813B3805
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 22:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbhFXUm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 16:42:59 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:33130 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbhFXUm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 16:42:58 -0400
Received: from localhost.localdomain (p200300e9d7330cb6646baaec8ea0666e.dip0.t-ipconnect.de [IPv6:2003:e9:d733:cb6:646b:aaec:8ea0:666e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@sostec.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 82F17C03F3;
        Thu, 24 Jun 2021 22:40:37 +0200 (CEST)
From:   Stefan Schmidt <stefan@datenfreihafen.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org
Subject: pull-request: ieee802154 for net 2021-06-24
Date:   Thu, 24 Jun 2021 22:40:09 +0200
Message-Id: <20210624204009.3953413-1-stefan@datenfreihafen.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dave, Jakub.

An update from ieee802154 for your *net* tree.

This time we only have fixes for ieee802154 hwsim driver.

Sparked from some syzcaller reports We got a potential
crash fix from Eric Dumazet and two memory leak fixes from
Dongliang Mu.

regards
Stefan Schmidt

The following changes since commit f2386cf7c5f4ff5d7b584f5d92014edd7df6c676:

  net: lantiq: disable interrupt before sheduling NAPI (2021-06-08 19:16:32 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan.git tags/ieee802154-for-davem-2021-06-24

for you to fetch changes up to 0303b30375dff5351a79cc2c3c87dfa4fda29bed:

  ieee802154: hwsim: avoid possible crash in hwsim_del_edge_nl() (2021-06-22 21:26:59 +0200)

----------------------------------------------------------------
Dongliang Mu (2):
      ieee802154: hwsim: Fix possible memory leak in hwsim_subscribe_all_others
      ieee802154: hwsim: Fix memory leak in hwsim_add_one

Eric Dumazet (1):
      ieee802154: hwsim: avoid possible crash in hwsim_del_edge_nl()

 drivers/net/ieee802154/mac802154_hwsim.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)
