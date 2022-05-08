Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DACB551EDCB
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 15:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbiEHNeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 09:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233527AbiEHNeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 09:34:14 -0400
Received: from simonwunderlich.de (simonwunderlich.de [IPv6:2a01:4f8:c17:e8c0::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745BEE0E9
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 06:30:24 -0700 (PDT)
Received: from kero.packetmixer.de (p200300Fa271A310000945dF34724c077.dip0.t-ipconnect.de [IPv6:2003:fa:271a:3100:94:5df3:4724:c077])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id E95D6FA1FB;
        Sun,  8 May 2022 15:21:14 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/1] pull request for net: batman-adv 2022-05-08
Date:   Sun,  8 May 2022 15:21:09 +0200
Message-Id: <20220508132110.20451-1-sw@simonwunderlich.de>
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

Hi David, hi Jakub,

here is a bugfix for batman-adv which we would like to have integrated into net.

Please pull or let me know of any problem!

Thank you,
      Simon

The following changes since commit 3123109284176b1532874591f7c81f3837bbdc17:

  Linux 5.18-rc1 (2022-04-03 14:08:21 -0700)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-net-pullrequest-20220508

for you to fetch changes up to a063f2fba3fa633a599253b62561051ac185fa99:

  batman-adv: Don't skb_split skbuffs with frag_list (2022-04-17 23:41:44 +0200)

----------------------------------------------------------------
Here is a batman-adv bugfix:

 - Don't skb_split skbuffs with frag_list, by Sven Eckelmann

----------------------------------------------------------------
Sven Eckelmann (1):
      batman-adv: Don't skb_split skbuffs with frag_list

 net/batman-adv/fragmentation.c | 11 +++++++++++
 1 file changed, 11 insertions(+)
