Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E834E3BC3B7
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 23:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbhGEVko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 17:40:44 -0400
Received: from novek.ru ([213.148.174.62]:46158 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233476AbhGEVjT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Jul 2021 17:39:19 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id C05C7503221;
        Tue,  6 Jul 2021 00:34:31 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru C05C7503221
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1625520872; bh=S9dAAHDp1jEnrAkc5uQ1mfVv7nWGZZAC0uE0HeVYlls=;
        h=From:To:Cc:Subject:Date:From;
        b=WG/8NfBGXebxEhxch/a9uMunhDxgkBAPLMqFlXgz9Ru51XD/PYjgisfiek1mZQgWL
         j8ZRxzLe91vEF5he42se3wUWQrMZ9OuZYmSp/8OLeGhObCdtRsoLzt7bqT299oSGRU
         3ESJ3vyTJyyFzdSswl//YeM/96vHmgvWH7vsDnTI=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [PATCH net-next 0/2] Remove duplicate code around MTU
Date:   Tue,  6 Jul 2021 00:36:15 +0300
Message-Id: <20210705213617.18317-1-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.18.4
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is intended to remove duplicated code around MTU calculation
and consolidate in one function. Also it alignes IPv4 and IPv6 code in
functions naming and usage

Vadim Fedorenko (2):
  net: ipv6: introduce ip6_dst_mtu_maybe_forward
  net: ipv4: Consolidate ipv4_mtu and ip_dst_mtu_maybe_forward

 include/net/ip.h                   | 22 ++++++++++++++++++----
 include/net/ip6_route.h            |  5 +++--
 net/ipv4/route.c                   | 21 +--------------------
 net/ipv6/ip6_output.c              |  2 +-
 net/ipv6/route.c                   | 20 +-------------------
 net/netfilter/nf_flow_table_core.c |  2 +-
 6 files changed, 25 insertions(+), 47 deletions(-)

-- 
2.18.4

