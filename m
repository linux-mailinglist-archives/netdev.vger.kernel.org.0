Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90B0B50D2B
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731785AbfFXOBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:01:12 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:43706 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728052AbfFXOBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 10:01:12 -0400
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id ED7A82D4AB9;
        Mon, 24 Jun 2019 16:01:09 +0200 (CEST)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.89)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1hfPWv-0003zj-RU; Mon, 24 Jun 2019 16:01:09 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ndesaulniers@google.com
Subject: [PATCH net v2 0/2] ipv6: fix neighbour resolution with raw socket
Date:   Mon, 24 Jun 2019 16:01:07 +0200
Message-Id: <20190624140109.14775-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190622.170816.1879839685931480272.davem@davemloft.net>
References: <20190622.170816.1879839685931480272.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


The first patch prepares the fix, it constify rt6_nexthop().
The detail of the bug is explained in the second patch.

v1 -> v2:
 - fix compilation warnings
 - split the initial patch

 drivers/net/vrf.c                | 2 +-
 include/net/ip6_route.h          | 4 ++--
 net/bluetooth/6lowpan.c          | 4 ++--
 net/ipv6/ip6_output.c            | 2 +-
 net/ipv6/route.c                 | 3 ++-
 net/netfilter/nf_flow_table_ip.c | 2 +-
 6 files changed, 9 insertions(+), 8 deletions(-)

Comments are welcomed,
Regards,
Nicolas

