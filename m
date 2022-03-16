Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3AE94DAF63
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 13:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355580AbiCPMND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 08:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350166AbiCPMNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 08:13:02 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D0555208
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 05:11:47 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id DADBB205ED;
        Wed, 16 Mar 2022 13:11:45 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id oDDh51Wxehy0; Wed, 16 Mar 2022 13:11:45 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 69BC420613;
        Wed, 16 Mar 2022 13:11:45 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 643A580004A;
        Wed, 16 Mar 2022 13:11:45 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Wed, 16 Mar 2022 13:11:45 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Wed, 16 Mar
 2022 13:11:44 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 856533180D59; Wed, 16 Mar 2022 13:11:44 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net): ipsec 2022-03-16
Date:   Wed, 16 Mar 2022 13:11:40 +0100
Message-ID: <20220316121142.3142336-1-steffen.klassert@secunet.com>
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

Two last fixes for this release cycle:

1) Fix a kernel-info-leak in pfkey.
   From Haimin Zhang.

2) Fix an incorrect check of the return value of ipv6_skip_exthdr.
   From Sabrina Dubroca.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 5f147476057832b8f87461ff6da35b5d2e1c2c29:

  Merge branch 'selftests-pmtu-sh-fix-cleanup-of-processes-launched-in-subshell' (2022-03-09 20:23:38 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master

for you to fetch changes up to 4db4075f92af2b28f415fc979ab626e6b37d67b6:

  esp6: fix check on ipv6_skip_exthdr's return value (2022-03-14 11:42:27 +0100)

----------------------------------------------------------------
Haimin Zhang (1):
      af_key: add __GFP_ZERO flag for compose_sadb_supported in function pfkey_register

Sabrina Dubroca (1):
      esp6: fix check on ipv6_skip_exthdr's return value

 net/ipv6/esp6.c  | 3 +--
 net/key/af_key.c | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)
