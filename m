Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B542C6AB9
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 18:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732288AbgK0RjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 12:39:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732196AbgK0RjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 12:39:01 -0500
Received: from simonwunderlich.de (packetmixer.de [IPv6:2001:4d88:2000:24::c0de])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907A4C0613D4
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 09:39:00 -0800 (PST)
Received: from kero.packetmixer.de (p200300c59712a4e04204e2f79fd8c031.dip0.t-ipconnect.de [IPv6:2003:c5:9712:a4e0:4204:e2f7:9fd8:c031])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id E54DC17405F;
        Fri, 27 Nov 2020 18:38:57 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/3] pull request for net: batman-adv 2020-11-27
Date:   Fri, 27 Nov 2020 18:38:46 +0100
Message-Id: <20201127173849.19208-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

here are some more bugfixes for batman-adv which we would like to have integrated into net.

Please pull or let me know of any problem!

Thank you,
      Simon

The following changes since commit 14a2e551faea53d45bc11629a9dac88f88950ca7:

  batman-adv: set .owner to THIS_MODULE (2020-11-15 11:43:56 +0100)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-net-pullrequest-20201127

for you to fetch changes up to 992b03b88e36254e26e9a4977ab948683e21bd9f:

  batman-adv: Don't always reallocate the fragmentation skb head (2020-11-27 08:02:55 +0100)

----------------------------------------------------------------
Here are some batman-adv bugfixes:

 - Fix head/tailroom issues for fragments, by Sven Eckelmann (3 patches)

----------------------------------------------------------------
Sven Eckelmann (3):
      batman-adv: Consider fragmentation for needed_headroom
      batman-adv: Reserve needed_*room for fragments
      batman-adv: Don't always reallocate the fragmentation skb head

 net/batman-adv/fragmentation.c  | 26 ++++++++++++++++----------
 net/batman-adv/hard-interface.c |  3 +++
 2 files changed, 19 insertions(+), 10 deletions(-)
