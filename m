Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC44639595
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 12:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiKZLDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 06:03:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiKZLDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 06:03:10 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519191900E
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 03:03:09 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 1AE2E20539;
        Sat, 26 Nov 2022 12:03:08 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id KI-Ry3pVVg8v; Sat, 26 Nov 2022 12:03:07 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 52A8720501;
        Sat, 26 Nov 2022 12:03:07 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 449FC80004A;
        Sat, 26 Nov 2022 12:03:07 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 26 Nov 2022 12:03:07 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 26 Nov
 2022 12:03:06 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 1C7183183C31; Sat, 26 Nov 2022 12:03:06 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 0/10] pull request (net-next): ipsec-next 2022-11-26
Date:   Sat, 26 Nov 2022 12:02:53 +0100
Message-ID: <20221126110303.1859238-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
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

1) Remove redundant variable in esp6.
   From Colin Ian King.

2) Update x->lastused for every packet. It was used only for
   outgoing mobile IPv6 packets, but showed to be usefull
   to check if the a SA is still in use in general.
   From Antony Antony.

3) Remove unused variable in xfrm_byidx_resize.
   From Leon Romanovsky.

4) Finalize extack support for xfrm.
   From Sabrina Dubroca.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit e2ac2a00dae10997b71870ecf26ca69f4d726537:

  enic: define constants for legacy interrupts offset (2022-10-18 19:34:28 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master

for you to fetch changes up to b198d7b40ad946206217224b8379626a089f73ed:

  Merge branch 'xfrm: add extack support to some more message types' (2022-11-26 11:32:19 +0100)

----------------------------------------------------------------
Antony Antony (1):
      xfrm: update x->lastused for every packet

Colin Ian King (1):
      esp6: remove redundant variable err

Leon Romanovsky (1):
      xfrm: Remove not-used total variable

Sabrina Dubroca (7):
      xfrm: a few coding style clean ups
      xfrm: add extack to xfrm_add_sa_expire
      xfrm: add extack to xfrm_del_sa
      xfrm: add extack to xfrm_new_ae and xfrm_replay_verify_len
      xfrm: add extack to xfrm_do_migrate
      xfrm: add extack to xfrm_alloc_userspi
      xfrm: add extack to xfrm_set_spdinfo

Steffen Klassert (1):
      Merge branch 'xfrm: add extack support to some more message types'

 include/net/xfrm.h      |  8 +++--
 net/ipv6/esp6_offload.c |  3 +-
 net/key/af_key.c        |  6 ++--
 net/xfrm/xfrm_input.c   |  1 +
 net/xfrm/xfrm_output.c  |  3 +-
 net/xfrm/xfrm_policy.c  | 37 +++++++++++++++-------
 net/xfrm/xfrm_state.c   | 21 ++++++++++---
 net/xfrm/xfrm_user.c    | 84 +++++++++++++++++++++++++++++++++++--------------
 8 files changed, 114 insertions(+), 49 deletions(-)
