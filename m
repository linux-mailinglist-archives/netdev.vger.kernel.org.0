Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403A1637BA0
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 15:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiKXOon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 09:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiKXOom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 09:44:42 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6F1E0B77
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 06:44:41 -0800 (PST)
Received: (Authenticated sender: sd@queasysnail.net)
        by mail.gandi.net (Postfix) with ESMTPSA id A4E08C0016;
        Thu, 24 Nov 2022 14:44:39 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 0/7] xfrm: add extack support to some more message types
Date:   Thu, 24 Nov 2022 15:43:37 +0100
Message-Id: <cover.1668507420.git.sd@queasysnail.net>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the last part of my extack work for xfrm, adding extack
messages to the last remaining operations: NEWSPDINFO, ALLOCSPI,
MIGRATE, NEWAE, DELSA, EXPIRE.

The first patch does a few clean ups on code that will be changed
later on it the series.

Sabrina Dubroca (7):
  xfrm: a few coding style clean ups
  xfrm: add extack to xfrm_add_sa_expire
  xfrm: add extack to xfrm_del_sa
  xfrm: add extack to xfrm_new_ae and xfrm_replay_verify_len
  xfrm: add extack to xfrm_do_migrate
  xfrm: add extack to xfrm_alloc_userspi
  xfrm: add extack to xfrm_set_spdinfo

 include/net/xfrm.h     |  8 ++--
 net/key/af_key.c       |  6 +--
 net/xfrm/xfrm_policy.c | 33 ++++++++++++-----
 net/xfrm/xfrm_state.c  | 21 ++++++++---
 net/xfrm/xfrm_user.c   | 84 ++++++++++++++++++++++++++++++------------
 5 files changed, 109 insertions(+), 43 deletions(-)

-- 
2.38.0

