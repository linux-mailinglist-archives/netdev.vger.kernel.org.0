Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECEE52B519
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 10:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbiERITt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 04:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232830AbiERITs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 04:19:48 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601B6AFB2D
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 01:19:45 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B0D1A20764;
        Wed, 18 May 2022 10:19:44 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hAOekCN0oSNV; Wed, 18 May 2022 10:19:44 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 2F18B206B9;
        Wed, 18 May 2022 10:19:44 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 29DEE80004A;
        Wed, 18 May 2022 10:19:44 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 18 May 2022 10:19:44 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 18 May
 2022 10:19:43 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id A01663182D02; Wed, 18 May 2022 10:19:43 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 0/3] pull request (net): ipsec 2022-05-18
Date:   Wed, 18 May 2022 10:19:35 +0200
Message-ID: <20220518081938.2075278-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Fix "disable_policy" flag use when arriving from different devices.
   From Eyal Birger.

2) Fix error handling of pfkey_broadcast in function pfkey_process.
   From Jiasheng Jiang.

3) Check the encryption module availability consistency in pfkey.
   From Thomas Bartschies.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 79396934e289dbc501316c1d1f975bb4c88ae460:

  net: dsa: b53: convert to phylink_pcs (2022-05-01 17:51:06 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master

for you to fetch changes up to 015c44d7bff3f44d569716117becd570c179ca32:

  net: af_key: check encryption module availability consistency (2022-05-18 09:42:16 +0200)

----------------------------------------------------------------
Eyal Birger (1):
      xfrm: fix "disable_policy" flag use when arriving from different devices

Jiasheng Jiang (1):
      net: af_key: add check for pfkey_broadcast in function pfkey_process

Thomas Bartschies (1):
      net: af_key: check encryption module availability consistency

 include/net/ip.h   |  1 +
 include/net/xfrm.h | 14 +++++++++++++-
 net/ipv4/route.c   | 23 ++++++++++++++++++-----
 net/key/af_key.c   | 12 +++++++-----
 4 files changed, 39 insertions(+), 11 deletions(-)
