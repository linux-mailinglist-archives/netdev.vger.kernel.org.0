Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADCC18ACB
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 15:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfEINgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 09:36:24 -0400
Received: from packetmixer.de ([79.140.42.25]:33562 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbfEINgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 09:36:23 -0400
Received: from kero.packetmixer.de (unknown [IPv6:2001:16b8:55c8:9400:604e:fca1:2145:dcdc])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mail.packetmixer.de (Postfix) with ESMTPSA id 1D2F26206F;
        Thu,  9 May 2019 15:28:18 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/2] pull request for net: batman-adv 2019-05-09
Date:   Thu,  9 May 2019 15:28:13 +0200
Message-Id: <20190509132815.3723-1-sw@simonwunderlich.de>
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

The following changes since commit 438b3d3fae4346a49fe12fa7cc1dc9327f006a91:

  batman-adv: Fix genl notification for throughput_override (2019-03-25 09:31:19 +0100)

are available in the git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-net-for-davem-20190509

for you to fetch changes up to a3c7cd0cdf1107f891aff847ad481e34df727055:

  batman-adv: mcast: fix multicast tt/tvlv worker locking (2019-05-06 11:40:46 +0200)

----------------------------------------------------------------
This feature/cleanup patchset includes the following patches:

 - bump version strings, by Simon Wunderlich (we forgot to include
   this patch previously ...)

 - fix multicast tt/tvlv worker locking, by Linus Lüssing

----------------------------------------------------------------
Linus Lüssing (1):
      batman-adv: mcast: fix multicast tt/tvlv worker locking

Simon Wunderlich (1):
      batman-adv: Start new development cycle

 net/batman-adv/main.c      |  1 +
 net/batman-adv/main.h      |  2 +-
 net/batman-adv/multicast.c | 11 +++--------
 net/batman-adv/types.h     |  5 +++++
 4 files changed, 10 insertions(+), 9 deletions(-)
