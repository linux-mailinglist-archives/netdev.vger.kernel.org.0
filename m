Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51AD453A2B3
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 12:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbiFAKeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 06:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351167AbiFAKeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 06:34:46 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38ADD7C148
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 03:34:45 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 47319205FC;
        Wed,  1 Jun 2022 12:34:43 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fVqHKiNdObHw; Wed,  1 Jun 2022 12:34:42 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id C7D35205E5;
        Wed,  1 Jun 2022 12:34:42 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id B9B2F80004A;
        Wed,  1 Jun 2022 12:34:42 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 1 Jun 2022 12:34:42 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 1 Jun
 2022 12:34:42 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 0AA493182E30; Wed,  1 Jun 2022 12:34:42 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 0/2] pull request (net): ipsec 2022-06-01
Date:   Wed, 1 Jun 2022 12:33:47 +0200
Message-ID: <20220601103349.2297361-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
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

1) Revert "net: af_key: add check for pfkey_broadcast in function pfkey_process"
   From Michal Kubecek.

2) Don't set IPv4 DF bit when encapsulating IPv6 frames below 1280 bytes.
   From Maciej Żenczykowski.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 8c3b8dc5cc9bf6d273ebe18b16e2d6882bcfb36d:

  net/smc: fix listen processing for SMC-Rv2 (2022-05-23 10:08:33 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master

for you to fetch changes up to 6821ad8770340825f17962cf5ef64ebaffee7fd7:

  xfrm: do not set IPv4 DF flag when encapsulating IPv6 frames <= 1280 bytes. (2022-05-25 11:41:26 +0200)

----------------------------------------------------------------
Maciej Żenczykowski (1):
      xfrm: do not set IPv4 DF flag when encapsulating IPv6 frames <= 1280 bytes.

Michal Kubecek (1):
      Revert "net: af_key: add check for pfkey_broadcast in function pfkey_process"

 net/key/af_key.c       | 10 ++++++----
 net/xfrm/xfrm_output.c |  3 ++-
 2 files changed, 8 insertions(+), 5 deletions(-)
