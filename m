Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8A285809A
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 12:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfF0Kk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 06:40:26 -0400
Received: from packetmixer.de ([79.140.42.25]:48644 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfF0Kk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 06:40:26 -0400
Received: from kero.packetmixer.de (ip-109-41-128-179.web.vodafone.de [109.41.128.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mail.packetmixer.de (Postfix) with ESMTPSA id 3616962059;
        Thu, 27 Jun 2019 12:31:25 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/2] pull request for net: batman-adv 2019-06-27
Date:   Thu, 27 Jun 2019 12:31:17 +0200
Message-Id: <20190627103119.6969-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

here are some bugfixes which we would like to have integrated into net.

Please pull or let me know of any problem!

Thank you,
      Simon

The following changes since commit a188339ca5a396acc588e5851ed7e19f66b0ebd9:

  Linux 5.2-rc1 (2019-05-19 15:47:09 -0700)

are available in the git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-net-for-davem-20190627

for you to fetch changes up to 9e6b5648bbc4cd48fab62cecbb81e9cc3c6e7e88:

  batman-adv: Fix duplicated OGMs on NETDEV_UP (2019-06-02 13:33:48 +0200)

----------------------------------------------------------------
Here are some batman-adv bugfixes:

 - fix a leaked TVLV handler which wasn't unregistered, by Jeremy Sowden

 - fix duplicated OGMs when interfaces are set UP, by Sven Eckelmann

----------------------------------------------------------------
Jeremy Sowden (1):
      batman-adv: fix for leaked TVLV handler.

Sven Eckelmann (1):
      batman-adv: Fix duplicated OGMs on NETDEV_UP

 net/batman-adv/bat_iv_ogm.c        | 4 ++--
 net/batman-adv/hard-interface.c    | 3 +++
 net/batman-adv/translation-table.c | 2 ++
 net/batman-adv/types.h             | 3 +++
 4 files changed, 10 insertions(+), 2 deletions(-)
