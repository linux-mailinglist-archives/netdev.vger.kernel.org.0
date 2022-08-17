Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8796597674
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 21:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241478AbiHQTab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 15:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241122AbiHQTaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 15:30:30 -0400
Received: from mx23lb.world4you.com (mx23lb.world4you.com [81.19.149.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9925B042
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 12:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SAC2tLltkxFutm2amySsRfNiZprzxLy5N0sqhQ6oyes=; b=Ia3CbqoFsvCkZK8FG+b3l80zWA
        v1x0thslhaJR3tCK4UGZWrXPFFejQrbYVYLQCFH+hUaTNb1c3dkD0c3UasCaxZhbEDzTsmmHiYrwO
        qtwc4IZfOwCEmcDtj1gwDOkzzhf6SNCyRmwxwy+48pUVYXIeRdxAVbzv0dOApbYgtyHk=;
Received: from [88.117.52.3] (helo=hornet.engleder.at)
        by mx23lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1oOOkA-0006Vi-TA; Wed, 17 Aug 2022 21:30:22 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 0/5] tsnep: Various minor driver improvements
Date:   Wed, 17 Aug 2022 21:30:12 +0200
Message-Id: <20220817193017.44063-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During XDP development some general driver improvements has been done
which I want to keep out of future patch series.

Gerhard(5):
  tsnep: Fix TSNEP_INFO_TX_TIME register define
  tsnep: Add loopback support
  tsnep: Improve TX length handling
  tsnep: Support full DMA mask
  tsnep: Record RX queue

 drivers/net/ethernet/engleder/tsnep.h      |   1 +
 drivers/net/ethernet/engleder/tsnep_hw.h   |   3 +-
 drivers/net/ethernet/engleder/tsnep_main.c | 115 +++++++++++++++------
 3 files changed, 88 insertions(+), 31 deletions(-)

-- 
2.30.2

