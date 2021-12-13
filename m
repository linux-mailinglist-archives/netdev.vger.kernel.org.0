Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58275473090
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 16:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240120AbhLMPcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 10:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238225AbhLMPcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 10:32:03 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A3EC061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 07:32:03 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mwnJ2-0006nV-Ic; Mon, 13 Dec 2021 16:32:00 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 0/4] fib: remove suppress indirection, merge nl policies
Date:   Mon, 13 Dec 2021 16:31:43 +0100
Message-Id: <20211213153147.17635-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series removes the 'suppress' indirection in fib_rule_ops struct
and merges the different (largely identical) nla policies.

Florian Westphal (4):
  fib: remove suppress indirection
  fib: place common code in a helper
  fib: rules: remove duplicated nla policies
  fib: expand fib_rule_policy

 include/net/fib_rules.h |  30 -----------
 net/core/fib_rules.c    | 107 +++++++++++++++++++++++++++++++++++++---
 net/decnet/dn_rules.c   |   5 --
 net/ipv4/fib_rules.c    |  40 ---------------
 net/ipv4/ipmr.c         |   5 --
 net/ipv6/fib6_rules.c   |  39 ---------------
 net/ipv6/ip6mr.c        |   5 --
 7 files changed, 101 insertions(+), 130 deletions(-)

-- 
2.32.0

