Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D6650DC4B
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 11:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbiDYJVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 05:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241606AbiDYJTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 05:19:43 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF3191FA66;
        Mon, 25 Apr 2022 02:16:37 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 3/4] netfilter: flowtable: Remove the empty file
Date:   Mon, 25 Apr 2022 11:16:30 +0200
Message-Id: <20220425091631.109320-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220425091631.109320-1-pablo@netfilter.org>
References: <20220425091631.109320-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rongguang Wei <weirongguang@kylinos.cn>

CONFIG_NF_FLOW_TABLE_IPV4 is already removed and the real user is also
removed(nf_flow_table_ipv4.c is empty).

Fixes: c42ba4290b2147aa ("netfilter: flowtable: remove ipv4/ipv6 modules")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_flow_table_ipv4.c | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 delete mode 100644 net/ipv4/netfilter/nf_flow_table_ipv4.c

diff --git a/net/ipv4/netfilter/nf_flow_table_ipv4.c b/net/ipv4/netfilter/nf_flow_table_ipv4.c
deleted file mode 100644
index e69de29bb2d1..000000000000
-- 
2.30.2

