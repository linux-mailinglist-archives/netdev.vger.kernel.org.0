Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D80356F62
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 16:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345430AbhDGOza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 10:55:30 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:55148 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345325AbhDGOzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 10:55:24 -0400
Received: from fedora.datenfreihafen.local (p200300e9d71da91c4806f3b11585b4d2.dip0.t-ipconnect.de [IPv6:2003:e9:d71d:a91c:4806:f3b1:1585:b4d2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@sostec.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id F28C1C00BF;
        Wed,  7 Apr 2021 16:55:09 +0200 (CEST)
From:   Stefan Schmidt <stefan@datenfreihafen.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org
Subject: pull-request: ieee802154 for net 2021-04-07
Date:   Wed,  7 Apr 2021 16:55:05 +0200
Message-Id: <20210407145505.467867-1-stefan@datenfreihafen.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dave, Jakub.

An update from ieee802154 for your *net* tree.

Most of these are coming from the flood of syzkaller reports
lately got for the ieee802154 subsystem. There are likely to
come more for this, but this is a good batch to get out for now.

Alexander Aring created a patchset to avoid llsec handling on a
monitor interface, which we do not support.
Alex Shi removed a unused macro.
Pavel Skripkin fixed another protection fault found by syzkaller.

regards
Stefan Schmidt

The following changes since commit fcb3007371e1a4afb03280af1b336a83287fe115:

  Merge branch 'wireguard-fixes-for-5-12-rc1' (2021-02-23 15:59:35 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan.git tags/ieee802154-for-davem-2021-04-07

for you to fetch changes up to 1165affd484889d4986cf3b724318935a0b120d8:

  net: mac802154: Fix general protection fault (2021-04-06 22:42:16 +0200)

----------------------------------------------------------------
Alex Shi (1):
      net/ieee802154: remove unused macros to tame gcc

Alexander Aring (19):
      net: ieee802154: fix nl802154 del llsec key
      net: ieee802154: fix nl802154 del llsec dev
      net: ieee802154: fix nl802154 add llsec key
      net: ieee802154: fix nl802154 del llsec devkey
      net: ieee802154: nl-mac: fix check on panid
      net: ieee802154: forbid monitor for set llsec params
      net: ieee802154: stop dump llsec keys for monitors
      net: ieee802154: forbid monitor for add llsec key
      net: ieee802154: forbid monitor for del llsec key
      net: ieee802154: stop dump llsec devs for monitors
      net: ieee802154: forbid monitor for add llsec dev
      net: ieee802154: forbid monitor for del llsec dev
      net: ieee802154: stop dump llsec devkeys for monitors
      net: ieee802154: forbid monitor for add llsec devkey
      net: ieee802154: forbid monitor for del llsec devkey
      net: ieee802154: stop dump llsec seclevels for monitors
      net: ieee802154: forbid monitor for add llsec seclevel
      net: ieee802154: forbid monitor for del llsec seclevel
      net: ieee802154: stop dump llsec params for monitors

Pavel Skripkin (1):
      net: mac802154: Fix general protection fault

Stefan Schmidt (1):
      Merge remote-tracking branch 'net/master'

 net/ieee802154/nl-mac.c   |  7 ++---
 net/ieee802154/nl802154.c | 68 +++++++++++++++++++++++++++++++++++++++++------
 net/mac802154/llsec.c     |  2 +-
 3 files changed, 65 insertions(+), 12 deletions(-)
