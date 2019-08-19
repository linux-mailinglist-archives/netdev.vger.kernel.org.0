Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF6191E56
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 09:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfHSHxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 03:53:50 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58637 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725790AbfHSHxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 03:53:49 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 19 Aug 2019 10:53:43 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7J7rgG0010776;
        Mon, 19 Aug 2019 10:53:42 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jhs@mojatatu.com, lucasb@mojatatu.com,
        mrv@mojatatu.com, shuah@kernel.org, batuhanosmantaskaya@gmail.com,
        dcaratti@redhat.com, marcelo.leitner@gmail.com,
        Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net-next 0/2] Fix problems with using ns plugin
Date:   Mon, 19 Aug 2019 10:52:06 +0300
Message-Id: <20190819075208.12240-1-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent changes to plugin architecture broke some of the tests when running tdc
without specifying a test group. Fix tests incompatible with ns plugin and
modify tests to not reuse interface name of ns veth interface for dummy
interface.

Vlad Buslov (2):
  tc-testing: use dedicated DUMMY interface name for dummy dev
  tc-testing: concurrency: wrap piped rule update commands

 .../tc-tests/filters/concurrency.json         |  18 +-
 .../tc-testing/tc-tests/filters/matchall.json | 242 +++++++++---------
 .../tc-testing/tc-tests/qdiscs/fifo.json      | 150 +++++------
 .../tc-testing/tc-tests/qdiscs/ingress.json   |  50 ++--
 .../tc-testing/tc-tests/qdiscs/prio.json      | 128 ++++-----
 .../selftests/tc-testing/tdc_config.py        |   1 +
 6 files changed, 295 insertions(+), 294 deletions(-)

-- 
2.21.0

