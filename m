Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B950C48356B
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234256AbiACRRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:17:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233033AbiACRRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:17:51 -0500
X-Greylist: delayed 342 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 03 Jan 2022 09:17:51 PST
Received: from simonwunderlich.de (simonwunderlich.de [IPv6:2a01:4f8:c17:e8c0::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9BBC061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 09:17:51 -0800 (PST)
Received: from kero.packetmixer.de (p200300c597476Fc09AF9daD664F33736.dip0.t-ipconnect.de [IPv6:2003:c5:9747:6fc0:9af9:dad6:64f3:3736])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id DB9C5FA1C0;
        Mon,  3 Jan 2022 18:17:49 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/3] pull request for net-next: batman-adv 2022-01-03
Date:   Mon,  3 Jan 2022 18:17:19 +0100
Message-Id: <20220103171722.1126109-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, hi David,

here is a little cleanup pull request of batman-adv to go into net-next.

Please pull or let me know of any problem!

Thank you,
      Simon

The following changes since commit 66f4beaa6c1d28161f534471484b2daa2de1dce0:

  Merge branch 'linus' of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 (2021-11-12 12:35:46 -0800)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-next-pullrequest-20220103

for you to fetch changes up to cde3fac565a7df8805a4e0e28d84a0f90177099a:

  batman-adv: remove unneeded variable in batadv_nc_init (2021-12-10 08:52:52 +0100)

----------------------------------------------------------------
This cleanup patchset includes the following patches:

 - bump version strings, by Simon Wunderlich

 - allow netlink usage in unprivileged containers, by Linus Lüssing

 - remove unneeded variable, by Minghao Chi

----------------------------------------------------------------
Linus Lüssing (1):
      batman-adv: allow netlink usage in unprivileged containers

Minghao Chi (1):
      batman-adv: remove unneeded variable in batadv_nc_init

Simon Wunderlich (1):
      batman-adv: Start new development cycle

 net/batman-adv/main.h           |  2 +-
 net/batman-adv/netlink.c        | 30 +++++++++++++++---------------
 net/batman-adv/network-coding.c |  8 ++------
 3 files changed, 18 insertions(+), 22 deletions(-)
