Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9083241FF6A
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 05:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhJCDTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 23:19:08 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:34320 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbhJCDTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 23:19:06 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 17401213DF; Sun,  3 Oct 2021 11:17:18 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next v2 0/5] MCTP kunit tests
Date:   Sun,  3 Oct 2021 11:17:03 +0800
Message-Id: <20211003031708.132096-1-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds some initial kunit tests for the MCTP core. We'll
expand the coverage in a future series, and augment with a few
selftests, but this establishes a baseline set of tests for now.

Thanks to the kunit folks for the framework!

Cheers,


Jeremy

---

v2:
 - fix MCTP=m, KUNIT={y,m} breakage
 - fix mctp test netdev initialisation
 - strict route reference count checking

---

Jeremy Kerr (5):
  mctp: Add initial test structure and fragmentation test
  mctp: Add test utils
  mctp: Add packet rx tests
  mctp: Add route input to socket tests
  mctp: Add input reassembly tests

 net/mctp/Kconfig           |   5 +
 net/mctp/Makefile          |   3 +
 net/mctp/route.c           |   5 +
 net/mctp/test/route-test.c | 544 +++++++++++++++++++++++++++++++++++++
 net/mctp/test/utils.c      |  67 +++++
 net/mctp/test/utils.h      |  20 ++
 6 files changed, 644 insertions(+)
 create mode 100644 net/mctp/test/route-test.c
 create mode 100644 net/mctp/test/utils.c
 create mode 100644 net/mctp/test/utils.h

-- 
2.33.0

