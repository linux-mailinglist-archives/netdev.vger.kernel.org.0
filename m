Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 504F37E2B4
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 20:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387713AbfHASzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 14:55:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731751AbfHASzM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 14:55:12 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A83E920679;
        Thu,  1 Aug 2019 18:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564685711;
        bh=5GEJqO1kfXAQ4j6fG0++6R2cifs3pzP3vXl3IPGJuho=;
        h=From:To:Cc:Subject:Date:From;
        b=vYh4ax4/oEi6M3sd8pi+EqJd1jrhkzmv83sKgluH+ladYW7cJtyLNQlWzKcuNuIHz
         LVkpL0R7DE6mUM3QUQtHOjk9pdEiMEyAeDdqVYAvHiIMwxMdjzPSvm9xRSskKqQq3l
         87wHMJoVrGgYLX03gLWlVzbtdAixmAdCr/T0rGeA=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 00/15] net: Add functional tests for L3 and L4
Date:   Thu,  1 Aug 2019 11:56:33 -0700
Message-Id: <20190801185648.27653-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

This is a port the functional test cases created during the development
of the VRF feature. It covers various permutations of icmp, tcp and udp
for IPv4 and IPv6 including negative tests.

David Ahern (15):
  selftests: Add nettest
  selftests: Setup for functional tests for fib and socket lookups
  selftests: Add ipv4 ping tests to fcnal-test
  selftests: Add ipv6 ping tests to fcnal-test
  selftests: Add ipv4 tcp tests to fcnal-test
  selftests: Add ipv6 tcp tests to fcnal-test
  selftests: Add ipv4 udp tests to fcnal-test
  selftests: Add ipv6 udp tests to fcnal-test
  selftests: Add ipv4 address bind tests to fcnal-test
  selftests: Add ipv6 address bind tests to fcnal-test
  selftests: Add ipv4 runtime tests to fcnal-test
  selftests: Add ipv6 runtime tests to fcnal-test
  selftests: Add ipv4 netfilter tests to fcnal-test
  selftests: Add ipv6 netfilter tests to fcnal-test
  selftests: Add use case section to fcnal-test

 tools/testing/selftests/net/Makefile      |    4 +-
 tools/testing/selftests/net/fcnal-test.sh | 3458 +++++++++++++++++++++++++++++
 tools/testing/selftests/net/nettest.c     | 1756 +++++++++++++++
 3 files changed, 5216 insertions(+), 2 deletions(-)
 create mode 100755 tools/testing/selftests/net/fcnal-test.sh
 create mode 100644 tools/testing/selftests/net/nettest.c

-- 
2.11.0

