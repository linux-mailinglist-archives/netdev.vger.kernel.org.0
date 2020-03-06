Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3A5D17BC71
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 13:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgCFMNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 07:13:20 -0500
Received: from simonwunderlich.de ([79.140.42.25]:44498 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbgCFMNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 07:13:20 -0500
X-Greylist: delayed 418 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Mar 2020 07:13:19 EST
Received: from kero.packetmixer.de (p200300C597077300B0A48B46F0435C76.dip0.t-ipconnect.de [IPv6:2003:c5:9707:7300:b0a4:8b46:f043:5c76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id E154D6205D;
        Fri,  6 Mar 2020 13:13:18 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/3] pull request for net-next: batman-adv 2020-03-06
Date:   Fri,  6 Mar 2020 13:13:14 +0100
Message-Id: <20200306121317.28931-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

here is a small cleanup pull request of batman-adv to go into net-next.

Please pull or let me know of any problem!

Thank you,
      Simon

The following changes since commit bb6d3fb354c5ee8d6bde2d576eb7220ea09862b9:

  Linux 5.6-rc1 (2020-02-09 16:08:48 -0800)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-next-for-davem-20200306

for you to fetch changes up to 5f27eb055d5c5814785fb9cf0ae4a4c150a8f334:

  batman-adv: Replace zero-length array with flexible-array member (2020-02-17 22:43:42 +0100)

----------------------------------------------------------------
This cleanup patchset includes the following patches:

 - bump version strings, by Simon Wunderlich

 - Avoid RCU list-traversal in spinlock, by Sven Eckelmann

 - Replace zero-length array with flexible-array member,
   by Gustavo A. R. Silva

----------------------------------------------------------------
Gustavo A. R. Silva (1):
      batman-adv: Replace zero-length array with flexible-array member

Simon Wunderlich (1):
      batman-adv: Start new development cycle

Sven Eckelmann (1):
      batman-adv: Avoid RCU list-traversal in spinlock

 net/batman-adv/distributed-arp-table.c | 2 +-
 net/batman-adv/main.h                  | 2 +-
 net/batman-adv/translation-table.c     | 8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)
