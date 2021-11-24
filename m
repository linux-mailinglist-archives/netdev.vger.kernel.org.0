Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A6F45C84E
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 16:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhKXPMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 10:12:50 -0500
Received: from proxima.lasnet.de ([78.47.171.185]:53788 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhKXPMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 10:12:50 -0500
Received: from localhost.localdomain.datenfreihafen.local (p200300e9d710513467c869e722e3db3d.dip0.t-ipconnect.de [IPv6:2003:e9:d710:5134:67c8:69e7:22e3:db3d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@sostec.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 48520C055C;
        Wed, 24 Nov 2021 16:09:39 +0100 (CET)
From:   Stefan Schmidt <stefan@datenfreihafen.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org
Subject: pull-request: ieee802154 for net 2021-11-24
Date:   Wed, 24 Nov 2021 16:09:34 +0100
Message-Id: <20211124150934.3670248-1-stefan@datenfreihafen.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dave, Jakub.

An update from ieee802154 for your *net* tree.

A fix from Alexander which has been brought up various times found by
automated checkers. Make sure values are in u32 range.

regards
Stefan Schmidt

The following changes since commit 848e5d66fa3105b4136c95ddbc5654e9c43ba7d7:

  Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue (2021-11-16 13:27:32 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan.git tags/ieee802154-for-net-2021-11-24

for you to fetch changes up to 451dc48c806a7ce9fbec5e7a24ccf4b2c936e834:

  net: ieee802154: handle iftypes as u32 (2021-11-16 18:02:46 +0100)

----------------------------------------------------------------
Alexander Aring (1):
      net: ieee802154: handle iftypes as u32

 include/net/nl802154.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)
