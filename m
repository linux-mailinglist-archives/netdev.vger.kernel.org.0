Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B5241E8F0
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 10:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352415AbhJAIVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 04:21:05 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:33714 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbhJAIVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 04:21:05 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 8575920166; Fri,  1 Oct 2021 16:19:14 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next 0/5] MCTP kunit tests
Date:   Fri,  1 Oct 2021 16:18:39 +0800
Message-Id: <20211001081844.3408786-1-jk@codeconstruct.com.au>
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

Jeremy Kerr (5):
  mctp: Add initial test structure and fragmentation test
  mctp: Add test utils
  mctp: Add packet rx tests
  mctp: Add route input to socket tests
  mctp: Add input reassembly tests

 net/mctp/Kconfig           |   5 +
 net/mctp/Makefile          |   3 +
 net/mctp/route.c           |   5 +
 net/mctp/test/route-test.c | 532 +++++++++++++++++++++++++++++++++++++
 net/mctp/test/utils.c      |  67 +++++
 net/mctp/test/utils.h      |  20 ++
 6 files changed, 632 insertions(+)
 create mode 100644 net/mctp/test/route-test.c
 create mode 100644 net/mctp/test/utils.c
 create mode 100644 net/mctp/test/utils.h

-- 
2.33.0

