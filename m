Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85DB914122
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 18:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbfEEQjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 12:39:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727232AbfEEQjl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 12:39:41 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DCEB205F4;
        Sun,  5 May 2019 16:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557074380;
        bh=0QgoYpKU9NvmFfNvUv8rE3iNi2RWll4A/kGeta599nE=;
        h=From:To:Cc:Subject:Date:From;
        b=jcT0ndjyUMo1qrAZBhXUD4uWMs7wBTkFPmonZ8U4/iBl4kGs+h7rUJI9k1wWr3s33
         GWfWJUa0S/aXMo9bIFjd5WEfaGNbMiY8yYPcm5/5neIVfDj7UuQLkBh5FNeMqzQT2B
         uD7ESHeVKnh3/mT3kuCFyiq+PxISV1JauRzl3mnY=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 0/7] net: Export functions for nexthop code
Date:   Sun,  5 May 2019 09:40:49 -0700
Message-Id: <20190505164056.1742-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

This set exports ipv4 and ipv6 fib functions for use by the nexthop
code. It also adds new ones to send route notifications if a nexthop
configuration changes.

David Ahern (7):
  ipv6: Add delete route hook to stubs
  ipv6: Add hook to bump sernum for a route to stubs
  ipv6: export function to send route updates
  ipv4: Add function to send route updates
  ipv4: export fib_check_nh
  ipv4: export fib_flush
  ipv4: export fib_info_update_nh_saddr

 include/net/ip6_fib.h    |  7 +++++
 include/net/ip_fib.h     |  8 +++++-
 include/net/ipv6_stubs.h |  5 ++++
 net/ipv4/fib_frontend.c  |  2 +-
 net/ipv4/fib_semantics.c | 23 ++++++++--------
 net/ipv4/fib_trie.c      | 72 ++++++++++++++++++++++++++++++++++++++++++++++++
 net/ipv6/addrconf_core.c |  6 ++++
 net/ipv6/af_inet6.c      |  3 ++
 net/ipv6/ip6_fib.c       | 16 ++++++++---
 net/ipv6/route.c         | 32 +++++++++++++++++++++
 10 files changed, 156 insertions(+), 18 deletions(-)

-- 
2.11.0

