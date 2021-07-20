Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46DE03D02B1
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 22:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhGTT2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 15:28:43 -0400
Received: from novek.ru ([213.148.174.62]:46282 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231927AbhGTT0U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 15:26:20 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id D21A750348D;
        Tue, 20 Jul 2021 23:04:28 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru D21A750348D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1626811469; bh=S9dAAHDp1jEnrAkc5uQ1mfVv7nWGZZAC0uE0HeVYlls=;
        h=From:To:Cc:Subject:Date:From;
        b=IMYkP5sx0Jlbv/1ClfUotVTKoVzWuElASNKGsSIFtd4/EW8r9HNb1KGWXasFAguA9
         lqqH4HoqbtmXEI9kbC0LJgVvIJKZyeMdjiRRHCJ+ggSlEO5xuR058shMPQog7XkRN+
         ISL7/qsHYjprpjw7TiIJfBoH/wSDp82Hy+1L2gj0=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     David Ahern <dsahern@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH RESEND net-next  0/2] Remove duplicate code around MTU
Date:   Tue, 20 Jul 2021 23:06:26 +0300
Message-Id: <20210720200628.16805-1-vfedorenko@novek.ru>
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

