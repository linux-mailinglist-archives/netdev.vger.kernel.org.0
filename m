Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27B648357A
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235197AbiACRUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235193AbiACRUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:20:34 -0500
Received: from simonwunderlich.de (simonwunderlich.de [IPv6:2a01:4f8:c17:e8c0::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5297C061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 09:20:33 -0800 (PST)
Received: from kero.packetmixer.de (p200300c597476Fc09AF9daD664F33736.dip0.t-ipconnect.de [IPv6:2003:c5:9747:6fc0:9af9:dad6:64f3:3736])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 352C4FA194;
        Mon,  3 Jan 2022 18:12:07 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/1] pull request for net: batman-adv 2022-01-03
Date:   Mon,  3 Jan 2022 18:12:02 +0100
Message-Id: <20220103171203.1124980-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

happy new year! Here is a bugfix for batman-adv which we would like to have integrated into net.

Please pull or let me know of any problem!

Thank you,
      Simon

The following changes since commit 66f4beaa6c1d28161f534471484b2daa2de1dce0:

  Merge branch 'linus' of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 (2021-11-12 12:35:46 -0800)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-net-pullrequest-20220103

for you to fetch changes up to 938f2e0b57ffe8a6df71e1e177b2978b1b33fe5e:

  batman-adv: mcast: don't send link-local multicast to mcast routers (2022-01-02 09:31:17 +0100)

----------------------------------------------------------------
Here is a batman-adv bugfix:

 - avoid sending link-local multicast to multicast routers,
   by Linus Lüssing

----------------------------------------------------------------
Linus Lüssing (1):
      batman-adv: mcast: don't send link-local multicast to mcast routers

 net/batman-adv/multicast.c      | 15 ++++++++++-----
 net/batman-adv/multicast.h      | 10 ++++++----
 net/batman-adv/soft-interface.c |  7 +++++--
 3 files changed, 21 insertions(+), 11 deletions(-)
