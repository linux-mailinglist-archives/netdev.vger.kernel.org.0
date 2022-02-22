Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4F154BF0EC
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 05:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiBVE2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 23:28:54 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiBVE2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 23:28:52 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79ABB639B
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 20:17:57 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id 7AA92202A4; Tue, 22 Feb 2022 12:17:52 +0800 (AWST)
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Kerr <jk@codeconstruct.com.au>
Subject: [PATCH net-next v3 0/2] mctp: Fix incorrect refs for extended addr
Date:   Tue, 22 Feb 2022 12:17:37 +0800
Message-Id: <20220222041739.511255-1-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.32.0
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

This fixes an incorrect netdev unref and also addresses the race
condition identified by Jakub in v2. Thanks for the review.

Cheers,
Matt

Matt Johnston (2):
  mctp: make __mctp_dev_get() take a refcount hold
  mctp: Fix incorrect netdev unref for extended addr

 net/mctp/device.c     | 21 ++++++++++++++++++---
 net/mctp/route.c      | 13 ++++++-------
 net/mctp/test/utils.c |  1 -
 3 files changed, 24 insertions(+), 11 deletions(-)

-- 
2.32.0

