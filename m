Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37AF7E473E
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 11:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408816AbfJYJbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 05:31:19 -0400
Received: from simonwunderlich.de ([79.140.42.25]:53290 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408067AbfJYJbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 05:31:19 -0400
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Oct 2019 05:31:18 EDT
Received: from kero.packetmixer.de (p200300C5970A8C00492EDFEC592AE94F.dip0.t-ipconnect.de [IPv6:2003:c5:970a:8c00:492e:dfec:592a:e94f])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id A568962016;
        Fri, 25 Oct 2019 11:22:17 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/2] pull request for net: batman-adv 2019-10-25
Date:   Fri, 25 Oct 2019 11:22:14 +0200
Message-Id: <20191025092216.12791-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

here are two bugfixes which we would like to have integrated into net.

Please pull or let me know of any problem!

Thank you,
      Simon

The following changes since commit 54ecb8f7028c5eb3d740bb82b0f1d90f2df63c5c:

  Linux 5.4-rc1 (2019-09-30 10:35:40 -0700)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-net-for-davem-20191025

for you to fetch changes up to 40e220b4218bb3d278e5e8cc04ccdfd1c7ff8307:

  batman-adv: Avoid free/alloc race when handling OGM buffer (2019-10-13 21:00:07 +0200)

----------------------------------------------------------------
Here are two batman-adv bugfixes:

 * Fix free/alloc race for OGM and OGMv2, by Sven Eckelmann (2 patches)

----------------------------------------------------------------
Sven Eckelmann (2):
      batman-adv: Avoid free/alloc race when handling OGM2 buffer
      batman-adv: Avoid free/alloc race when handling OGM buffer

 net/batman-adv/bat_iv_ogm.c     | 61 +++++++++++++++++++++++++++++++++++------
 net/batman-adv/bat_v_ogm.c      | 41 +++++++++++++++++++++------
 net/batman-adv/hard-interface.c |  2 ++
 net/batman-adv/types.h          |  7 +++++
 4 files changed, 94 insertions(+), 17 deletions(-)
