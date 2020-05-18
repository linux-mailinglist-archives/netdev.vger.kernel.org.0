Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A541D8967
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 22:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgERUk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 16:40:28 -0400
Received: from novek.ru ([213.148.174.62]:49106 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726417AbgERUk1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 16:40:27 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id DDD605020BC;
        Mon, 18 May 2020 23:33:49 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru DDD605020BC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1589834030; bh=q0iuzAPG0+tdz0TR0y0Ba5pC6HxN/hujfIpsycYWAXE=;
        h=From:To:Cc:Subject:Date:From;
        b=T2fVQPRjAGgqJMj3mQ4IP/hbLG+wvs/IajVsxpvcHbIzMfIcT4y3CyvfIul8S819j
         yBKhZ1rB0UGmqeFttIiPOZvYE0dQqxMkYkfdmy9dZYUWzYaPizDV8ec893jMUtRK2y
         C9uIEqjzFXI6J3otP28vPW2R14HnligtSMQHuB3c=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [net-next 0/5] ip6_tunnel: add MPLS support
Date:   Mon, 18 May 2020 23:33:43 +0300
Message-Id: <1589834028-9929-1-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The support for MPLS-in-IPv4 was added earlier. This patchset adds
support for MPLS-in-IPv6.

Vadim Fedorenko (5):
  ip6_tunnel: simplify transmit path
  ip6_tunnel: add MPLS transmit support
  tunnel6: support for IPPROTO_MPLS
  ip6_tunnel: add generic MPLS receive support
  mpls: Add support for IPv6 tunnels

 net/ipv6/ip6_tunnel.c | 252 +++++++++++++++++++++++++++++---------------------
 net/ipv6/tunnel6.c    |  96 ++++++++++++++++++-
 net/mpls/af_mpls.c    |   3 +-
 3 files changed, 242 insertions(+), 109 deletions(-)

-- 
1.8.3.1

