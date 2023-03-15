Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78AE16BAE4B
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 11:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbjCOK4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 06:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbjCOK4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 06:56:40 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6838E4BEBD
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 03:56:30 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 318272053B;
        Wed, 15 Mar 2023 11:56:28 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id TW8iWojaIiXk; Wed, 15 Mar 2023 11:56:27 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B3D2D20504;
        Wed, 15 Mar 2023 11:56:27 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id A50E080004A;
        Wed, 15 Mar 2023 11:56:27 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Wed, 15 Mar 2023 11:56:27 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Wed, 15 Mar
 2023 11:56:27 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 0BB5D3182EBA; Wed, 15 Mar 2023 11:56:27 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 0/2] pull request (net): ipsec 2023-03-15
Date:   Wed, 15 Mar 2023 11:56:21 +0100
Message-ID: <20230315105623.1396491-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Fix an information leak when dumping algos and encap.
   From Herbert Xu

2) Allow transport-mode states with AF_UNSPEC selector
   to allow for nested transport-mode states.
   From Herbert Xu.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 2038cc592811209de20c4e094ca08bfb1e6fbc6c:

  bnxt_en: Fix mqprio and XDP ring checking logic (2023-02-13 09:57:59 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git tags/ipsec-2023-03-15

for you to fetch changes up to c276a706ea1f51cf9723ed8484feceaf961b8f89:

  xfrm: Allow transport-mode states with AF_UNSPEC selector (2023-02-24 10:07:24 +0100)

----------------------------------------------------------------
ipsec-2023-03-15

----------------------------------------------------------------
Herbert Xu (2):
      xfrm: Zero padding when dumping algos and encap
      xfrm: Allow transport-mode states with AF_UNSPEC selector

 net/xfrm/xfrm_state.c |  5 -----
 net/xfrm/xfrm_user.c  | 45 +++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 41 insertions(+), 9 deletions(-)
