Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9FE57B255
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238464AbiGTIJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235321AbiGTIJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 04:09:20 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3554198B
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:09:19 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E0B2720615;
        Wed, 20 Jul 2022 10:09:15 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id G3br8_uo0tlD; Wed, 20 Jul 2022 10:09:15 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 60A132058E;
        Wed, 20 Jul 2022 10:09:15 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 4F09980004A;
        Wed, 20 Jul 2022 10:09:15 +0200 (CEST)
Received: from mbx-dresden-01.secunet.de (10.53.40.199) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Jul 2022 10:09:15 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-dresden-01.secunet.de
 (10.53.40.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 20 Jul
 2022 10:09:14 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 2D5883182A61; Wed, 20 Jul 2022 10:09:14 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 0/2] pull request (net): ipsec 2022-07-20
Date:   Wed, 20 Jul 2022 10:09:10 +0200
Message-ID: <20220720080912.1183369-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-dresden-01.secunet.de (10.53.40.199)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Fix a policy refcount imbalance in xfrm_bundle_lookup.
   From Hangyu Hua.

2) Fix some clang -Wformat warnings.
   Justin Stitt

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 9f4fc18bf285f20c1498f8fcfb586fa70a070fb5:

  net: usb: qmi_wwan: Add support for Cinterion MV31 with new baseline (2022-06-01 18:09:34 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master

for you to fetch changes up to e79b9473e9b59e83e23db9b7411c6080b5a6826d:

  net: ipv4: fix clang -Wformat warnings (2022-07-12 12:58:53 +0200)

----------------------------------------------------------------
Hangyu Hua (1):
      xfrm: xfrm_policy: fix a possible double xfrm_pols_put() in xfrm_bundle_lookup()

Justin Stitt (1):
      net: ipv4: fix clang -Wformat warnings

 net/ipv4/ah4.c         | 2 +-
 net/ipv4/esp4.c        | 2 +-
 net/xfrm/xfrm_policy.c | 5 ++++-
 3 files changed, 6 insertions(+), 3 deletions(-)
