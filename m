Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623D12C8E20
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 20:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbgK3TeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 14:34:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728803AbgK3TeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 14:34:04 -0500
Received: from mail.buslov.dev (mail.buslov.dev [IPv6:2001:19f0:5001:2e3f:5400:1ff:feed:a259])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD97C0613D4
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 11:33:19 -0800 (PST)
Received: from vlad-x1g6.localdomain (unknown [IPv6:2a0b:2bc3:193f:1:a5fe:a7d6:6345:fe8d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id 802F51FA2E;
        Mon, 30 Nov 2020 21:33:15 +0200 (EET)
From:   Vlad Buslov <vlad@buslov.dev>
To:     jhs@mojatatu.com, dsahern@gmail.com, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Vlad Buslov <vlad@buslov.dev>
Subject: [PATCH iproute2-next 0/2] Implement action terse dump
Date:   Mon, 30 Nov 2020 21:32:48 +0200
Message-Id: <20201130193250.81308-1-vlad@buslov.dev>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor action flags according to recommended kernel upstream naming using
TCA_ACT_ prefix. Implement support for new action terse dump flag.

Vlad Buslov (2):
  tc: use TCA_ACT_ prefix for action flags
  tc: implement support for action terse dump

 include/uapi/linux/rtnetlink.h | 12 +++++++-----
 man/man8/tc.8                  |  2 +-
 tc/m_action.c                  | 13 +++++++++++--
 3 files changed, 19 insertions(+), 8 deletions(-)

-- 
2.29.2

