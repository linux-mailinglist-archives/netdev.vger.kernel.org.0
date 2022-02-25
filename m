Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A390A4C3DF4
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 06:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237574AbiBYFk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 00:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236037AbiBYFk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 00:40:26 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416B41DB892
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 21:39:53 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id F0CC72029D; Fri, 25 Feb 2022 13:39:47 +0800 (AWST)
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Kerr <jk@codeconstruct.com.au>
Subject: [PATCH net-next 0/3] Small fixes for MCTP
Date:   Fri, 25 Feb 2022 13:39:35 +0800
Message-Id: <20220225053938.643605-1-matt@codeconstruct.com.au>
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

Hi,

This series has 3 fixes for MCTP.

Cheers,
Matt

Matt Johnston (3):
  mctp: Avoid warning if unregister notifies twice
  mctp i2c: Fix potential use-after-free
  mctp i2c: Fix hard head TX bounds length check

 drivers/net/mctp/mctp-i2c.c | 7 ++++---
 net/mctp/device.c           | 8 ++++----
 2 files changed, 8 insertions(+), 7 deletions(-)

-- 
2.32.0

