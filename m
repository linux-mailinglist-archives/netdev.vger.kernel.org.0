Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B652A76D2
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 00:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfICWTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 18:19:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:45570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725990AbfICWTZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 18:19:25 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9030C21883;
        Tue,  3 Sep 2019 22:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567549164;
        bh=UoRknw1pKkMKHdK2INVZui110pRRwpebqjafhqXKofs=;
        h=From:To:Cc:Subject:Date:From;
        b=AB5lJDK/cEYGikSTou5KspqLOpFvXdhLBsE2uiTVqo7U7pAwrn4u+W+qlPT+jlgQY
         Tpeahwpej+50Scw2YkQaL8U3153bezbn+dnczITLYu98XYeYmNwJLiY2xgZRo9ow/Q
         HsEVWxW7RBlCch+F433jSjGeaIb8s80dql3+MD8Q=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, sharpd@cumulusnetworks.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net 0/2] nexthops: Fix multipath notifications for IPv6 and selftests
Date:   Tue,  3 Sep 2019 15:22:11 -0700
Message-Id: <20190903222213.7029-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

A couple of bug fixes noticed while testing Donald's patch.

David Ahern (2):
  ipv6: Fix RTA_MULTIPATH with nexthop objects
  selftest: A few cleanups for fib_nexthops.sh

 net/ipv6/route.c                            |  2 +-
 tools/testing/selftests/net/fib_nexthops.sh | 24 +++++++++++++-----------
 2 files changed, 14 insertions(+), 12 deletions(-)

-- 
2.11.0

