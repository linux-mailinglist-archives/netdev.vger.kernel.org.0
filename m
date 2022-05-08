Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52AF151EDC4
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 15:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbiEHNaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 09:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233493AbiEHNaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 09:30:09 -0400
X-Greylist: delayed 298 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 08 May 2022 06:26:19 PDT
Received: from simonwunderlich.de (simonwunderlich.de [23.88.38.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE4DB1CD
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 06:26:18 -0700 (PDT)
Received: from kero.packetmixer.de (p200300Fa271a310000945df34724C077.dip0.t-ipconnect.de [IPv6:2003:fa:271a:3100:94:5df3:4724:c077])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 4B6BCFA1FF;
        Sun,  8 May 2022 15:26:17 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/2] pull request for net-next: batman-adv 2022-05-08
Date:   Sun,  8 May 2022 15:26:14 +0200
Message-Id: <20220508132616.21232-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, hi David,

here is a very little cleanup pull request of batman-adv to go into net-next.

Please pull or let me know of any problem!

Thank you,
      Simon

The following changes since commit 3123109284176b1532874591f7c81f3837bbdc17:

  Linux 5.18-rc1 (2022-04-03 14:08:21 -0700)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-next-pullrequest-20220508

for you to fetch changes up to 8864d2fcf04385cabb8c8bb159f1f2ba5790cf71:

  batman-adv: remove unnecessary type castings (2022-04-22 11:23:46 +0200)

----------------------------------------------------------------
This cleanup patchset includes the following patches:

 - bump version strings, by Simon Wunderlich

 - remove unnecessary type castings, by Yu Zhe

----------------------------------------------------------------
Simon Wunderlich (1):
      batman-adv: Start new development cycle

Yu Zhe (1):
      batman-adv: remove unnecessary type castings

 net/batman-adv/bridge_loop_avoidance.c |  4 ++--
 net/batman-adv/main.h                  |  2 +-
 net/batman-adv/translation-table.c     | 12 ++++++------
 3 files changed, 9 insertions(+), 9 deletions(-)
