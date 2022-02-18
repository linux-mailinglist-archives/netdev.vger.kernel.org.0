Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB8E54BB0BD
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 05:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiBRE0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 23:26:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiBRE0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 23:26:22 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1D11409E
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 20:26:02 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 4270A202C6; Fri, 18 Feb 2022 12:25:56 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>
Subject: [PATCH net-next 0/2] Add checks for incoming packet addresses
Date:   Fri, 18 Feb 2022 12:25:52 +0800
Message-Id: <20220218042554.564787-1-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds a couple of checks for valid addresses on incoming MCTP
packets. We introduce a couple of helpers in 1/2, and use them in the
ingress path in 2/2.

Cheers,


Jeremy

---

Jeremy Kerr (2):
  mctp: replace mctp_address_ok with more fine-grained helpers
  mctp: add address validity checking for packet receive

 include/net/mctp.h | 12 +++++++++++-
 net/mctp/device.c  |  2 +-
 net/mctp/neigh.c   |  2 +-
 net/mctp/route.c   | 13 ++++++++++++-
 4 files changed, 25 insertions(+), 4 deletions(-)

-- 
2.34.1

