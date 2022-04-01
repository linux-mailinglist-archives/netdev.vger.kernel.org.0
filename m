Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7CB44EE65D
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 05:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244324AbiDADD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 23:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242345AbiDADDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 23:03:54 -0400
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3846F257182
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 20:02:05 -0700 (PDT)
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id 0571E202C7; Fri,  1 Apr 2022 11:02:00 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codeconstruct.com.au; s=2022a; t=1648782120;
        bh=KFdSy8Ph8+vmUssRrd63PkcxpKP+48CD1Ug7CoN2hg4=;
        h=From:To:Cc:Subject:Date;
        b=X8C4vDLBK4IciRhFF/QyvSqHvFK5IrP4AdQcQoOWeY6p3p+g2gKFqXdXGKDJgRNfH
         VXSwwY0xVVXdIgsinlpXaqu51f2hUrJb2UmRTuKoxD0kofN/uetFzsumLEAquUn0oW
         GrCRhZmJIphV5qen5JWsZ2C4flFQvYrz0wJktfSQefKWEygB//m4mEgnXjBFWF5uFJ
         Fq8YD/VVmuTiSHHmpz5Zn32dtAk7GJz40lvZ+UT1In+93pHrz0QGLrzTZCGeYqeP/Y
         3d6kCOkZ6U19nJTeVC+IrYXmYp2V3e6Iqmvlh8MLClPRUAtRdFy34wZ8VwqcxcsfQ0
         gc9na4fmlK/2Q==
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     mjrinal@g.clemson.edu, jk@codeconstruct.com.au,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net 0/3] MCTP fixes
Date:   Fri,  1 Apr 2022 10:48:41 +0800
Message-Id: <20220401024844.1578937-1-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following are fixes for the mctp core and mctp-i2c driver.

Thanks,
Matt

Matt Johnston (3):
  mctp: Fix check for dev_hard_header() result
  mctp i2c: correct mctp_i2c_header_create result
  mctp: Use output netdev to allocate skb headroom

 drivers/net/mctp/mctp-i2c.c |  2 +-
 include/net/mctp.h          |  2 --
 net/mctp/af_mctp.c          | 46 ++++++++++++++++++++++++++-----------
 net/mctp/route.c            | 16 +++++++++----
 4 files changed, 46 insertions(+), 20 deletions(-)

-- 
2.32.0

