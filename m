Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71F330DBD6
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 14:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbhBCNwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 08:52:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:50460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232403AbhBCNwA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 08:52:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB10464DDA;
        Wed,  3 Feb 2021 13:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612360279;
        bh=lPoTVRPjF6SQYvTA6ZAIj8U7jpB4I9E0tROY2/i16a4=;
        h=From:To:Cc:Subject:Date:From;
        b=bNuWXKB+XTbdeESkL3pLJS8h5guMcIQ9AakDKtwdLUwmQajJLF1nEDviZKxMy3i8S
         texp5vpgcieZH/9YzDsPGlG8/tOrsYHzIqdTbBwM/ax1MTArajz9dUFTFR+CriltJw
         dL086BNcJHzrKLy4vk55kqGnMT8jEUxCmYjzuf3zXjs4b7lpH+IynwKmH1r+ucKUXd
         s3y7/pa/NPIOxbdZXvz6vhrC+FPaVcHfrK7iJoOzg0ZsEskd9XiRJjHvo2YHpKxVpq
         ukesm1nnnahCsyCoq7GFa+SvB/oyrjGt6AUsbb19KwtEWbK34Qwi9qf9R8bWLMUITc
         mmNmxFt3CqysQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, coreteam@netfilter.org,
        Florian Westphal <fw@strlen.de>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Julian Anastasov <ja@ssi.bg>, linux-kernel@vger.kernel.org,
        lvs-devel@vger.kernel.org, Matteo Croce <mcroce@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Simon Horman <horms@verge.net.au>
Subject: [PATCH net-next v2 0/4] Fix W=1 compilation warnings in net/* folder
Date:   Wed,  3 Feb 2021 15:51:08 +0200
Message-Id: <20210203135112.4083711-1-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Changelog:
v2:
 * Patch 3: Added missing include file.
v1: https://lore.kernel.org/lkml/20210203101612.4004322-1-leon@kernel.org
 * Removed Fixes lines.
 * Changed target from net to be net-next.
 * Patch 1: Moved function declaration to be outside config instead
   games with if/endif.
 * Patch 3: Moved declarations to new header file.
v0: https://lore.kernel.org/lkml/20210202135544.3262383-1-leon@kernel.org
------------------------------------------------------------------
Hi,

This short series fixes W=1 compilation warnings which I experienced
when tried to compile net/* folder.

Thanks

Leon Romanovsky (4):
  ipv6: silence compilation warning for non-IPV6 builds
  ipv6: move udp declarations to net/udp.h
  net/core: move gro function declarations to separate header
  netfilter: move handlers to net/ip_vs.h

 include/linux/icmpv6.h          |  2 +-
 include/net/gro.h               | 12 ++++++++++++
 include/net/ip_vs.h             | 11 +++++++++++
 include/net/udp.h               |  3 +++
 net/core/dev.c                  |  7 +------
 net/ipv6/ip6_input.c            |  3 +--
 net/ipv6/ip6_offload.c          |  1 +
 net/netfilter/ipvs/ip_vs_core.c | 12 ------------
 8 files changed, 30 insertions(+), 21 deletions(-)
 create mode 100644 include/net/gro.h

--
2.29.2

