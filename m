Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3629B399F08
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 12:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhFCKg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 06:36:59 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:34748 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbhFCKg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 06:36:59 -0400
Received: from fedora.datenfreihafen.local (p200300e9d72228a192405b8af0370504.dip0.t-ipconnect.de [IPv6:2003:e9:d722:28a1:9240:5b8a:f037:504])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@sostec.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id D062AC051B;
        Thu,  3 Jun 2021 12:35:12 +0200 (CEST)
From:   Stefan Schmidt <stefan@datenfreihafen.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org
Subject: pull-request: ieee802154 for net 2021-06-03
Date:   Thu,  3 Jun 2021 12:35:08 +0200
Message-Id: <20210603103508.2913207-1-stefan@datenfreihafen.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dave, Jakub.

An update from ieee802154 for your *net* tree.

This time we have fixes for the ieee802154 netlink code, as well as a driver
fix. Zhen Lei, Wei Yongjun and Yang Li each had  a patch to cleanup some return
code handling ensuring we actually get a real error code when things fails.

Dan Robertson fixed a potential null dereference in our netlink handling.

Andy Shevchenko removed of_match_ptr()usage in the mrf24j40 driver.

regards
Stefan Schmidt


The following changes since commit 8a12f8836145ffe37e9c8733dce18c22fb668b66:

  net: hso: fix null-ptr-deref during tty device unregistration (2021-04-07 15:18:15 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan.git tags/ieee802154-for-davem-2021-06-03

for you to fetch changes up to 373e864cf52403b0974c2f23ca8faf9104234555:

  ieee802154: fix error return code in ieee802154_llsec_getparams() (2021-06-03 10:59:49 +0200)

----------------------------------------------------------------
Andy Shevchenko (1):
      net: ieee802154: mrf24j40: Drop unneeded of_match_ptr()

Dan Robertson (1):
      net: ieee802154: fix null deref in parse dev addr

Wei Yongjun (1):
      ieee802154: fix error return code in ieee802154_llsec_getparams()

Yang Li (1):
      net/ieee802154: drop unneeded assignment in llsec_iter_devkeys()

Zhen Lei (1):
      ieee802154: fix error return code in ieee802154_add_iface()

 drivers/net/ieee802154/mrf24j40.c |  4 ++--
 net/ieee802154/nl-mac.c           | 10 ++++++----
 net/ieee802154/nl-phy.c           |  4 +++-
 net/ieee802154/nl802154.c         |  9 +++++----
 4 files changed, 16 insertions(+), 11 deletions(-)
