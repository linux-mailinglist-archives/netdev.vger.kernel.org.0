Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E308113AC44
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 15:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbgANOZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 09:25:31 -0500
Received: from simonwunderlich.de ([79.140.42.25]:49872 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbgANOZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 09:25:31 -0500
Received: from kero.packetmixer.de (p200300C5970F1B0095082C17D9AE8553.dip0.t-ipconnect.de [IPv6:2003:c5:970f:1b00:9508:2c17:d9ae:8553])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 69C506205C;
        Tue, 14 Jan 2020 15:16:48 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/1] pull request for net: batman-adv 2020-01-14
Date:   Tue, 14 Jan 2020 15:16:45 +0100
Message-Id: <20200114141646.23598-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

here is a bugfix which we would like to have integrated into net.

Please pull or let me know of any problem!

Thank you,
      Simon

The following changes since commit 40e220b4218bb3d278e5e8cc04ccdfd1c7ff8307:

  batman-adv: Avoid free/alloc race when handling OGM buffer (2019-10-13 21:00:07 +0200)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-net-for-davem-20200114

for you to fetch changes up to 4cc4a1708903f404d2ca0dfde30e71e052c6cbc9:

  batman-adv: Fix DAT candidate selection on little endian systems (2019-11-28 12:48:59 +0100)

----------------------------------------------------------------
Here is a batman-adv bugfix:

 - Fix DAT candidate selection on little endian systems,
   by Sven Eckelmann

----------------------------------------------------------------
Sven Eckelmann (1):
      batman-adv: Fix DAT candidate selection on little endian systems

 net/batman-adv/distributed-arp-table.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)
