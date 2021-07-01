Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 713FC3B8BB9
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 03:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238345AbhGABUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 21:20:08 -0400
Received: from novek.ru ([213.148.174.62]:59366 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238301AbhGABUH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 21:20:07 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id D004F50332D;
        Thu,  1 Jul 2021 04:15:32 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru D004F50332D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1625102133; bh=S9dAAHDp1jEnrAkc5uQ1mfVv7nWGZZAC0uE0HeVYlls=;
        h=From:To:Cc:Subject:Date:From;
        b=P7phaVt7ShTFxvMeWl0Bqv5/GwcJFifbUN9kpr2WMsV/OgTZlU7yEx/ItE0FkJAmp
         q5IidDoST0QwK9DC8HNtc/Pnt9HSQ+ThzzlJLxA3yinJYOdZqI9yBkWS1dpjGWWkkq
         WKvb6xH57mBGwHNuZ5x0/eX57ueQT42dMHGgrT7Y=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [RFC net-next 0/2] Remove duplicate code around MTU
Date:   Thu,  1 Jul 2021 04:17:26 +0300
Message-Id: <20210701011728.22626-1-vfedorenko@novek.ru>
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

