Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 442C34D588E
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 04:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345846AbiCKDBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 22:01:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239205AbiCKDA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 22:00:59 -0500
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6267F9549A;
        Thu, 10 Mar 2022 18:59:56 -0800 (PST)
HMM_SOURCE_IP: 172.18.0.218:37692.1206753115
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-202.80.192.39 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id 15E93280137;
        Fri, 11 Mar 2022 10:50:38 +0800 (CST)
X-189-SAVE-TO-SEND: +sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id 59bedcae11f147cfa01eb2135873986d for j.vosburgh@gmail.com;
        Fri, 11 Mar 2022 10:50:42 CST
X-Transaction-ID: 59bedcae11f147cfa01eb2135873986d
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
From:   Sun Shouxin <sunshouxin@chinatelecom.cn>
To:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyd12@chinatelecom.cn, sunshouxin@chinatelecom.cn
Subject: [PATCH 0/3] net:bonding:Add support for IPV6 RLB to balance-alb mode
Date:   Thu, 10 Mar 2022 21:49:55 -0500
Message-Id: <20220311024958.7458-1-sunshouxin@chinatelecom.cn>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is implementing IPV6 RLB for balance-alb mode.

Sun Shouxin (3):
  net:ipv6:Add ndisc_bond_send_na to support sending na by slave
    directly
  net:ipv6:Export inet6_ifa_finish_destroy and ipv6_get_ifaddr
  net:bonding:Add support for IPV6 RLB to balance-alb mode

 drivers/net/bonding/bond_3ad.c     |   2 +-
 drivers/net/bonding/bond_alb.c     | 588 ++++++++++++++++++++++++++++-
 drivers/net/bonding/bond_debugfs.c |  14 +
 drivers/net/bonding/bond_main.c    |   6 +-
 include/net/bond_3ad.h             |   2 +-
 include/net/bond_alb.h             |   7 +
 include/net/bonding.h              |   6 +-
 include/net/ndisc.h                |   6 +
 net/ipv6/addrconf.c                |   2 +
 net/ipv6/ndisc.c                   |  61 +++
 10 files changed, 680 insertions(+), 14 deletions(-)


base-commit: 2a9eef868a997ec575c2e6ae885e91313f635d59
-- 
2.27.0

