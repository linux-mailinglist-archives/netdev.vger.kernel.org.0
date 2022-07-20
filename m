Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 649C857B2AD
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236229AbiGTIR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiGTIRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 04:17:55 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F5B54652
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:17:53 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 864C320624;
        Wed, 20 Jul 2022 10:17:51 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4FcnKD9yVveW; Wed, 20 Jul 2022 10:17:51 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id F261C205CF;
        Wed, 20 Jul 2022 10:17:50 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id E99C480004A;
        Wed, 20 Jul 2022 10:17:50 +0200 (CEST)
Received: from mbx-dresden-01.secunet.de (10.53.40.199) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Jul 2022 10:17:50 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-dresden-01.secunet.de
 (10.53.40.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 20 Jul
 2022 10:17:50 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id CEA3E3182A61; Wed, 20 Jul 2022 10:17:49 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 0/5] pull request (net-next): ipsec-next 2022-07-20
Date:   Wed, 20 Jul 2022 10:17:41 +0200
Message-ID: <20220720081746.1187382-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="y"
Content-Transfer-Encoding: 8bit
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

1) Don't set DST_NOPOLICY in IPv4, a recent patch made this
   superfluous. From Eyal Birger.

2) Convert alg_key to flexible array member to avoid an iproute2
   compile warning when built with gcc-12.
   From Stephen Hemminger.

3) xfrm_register_km and xfrm_unregister_km do always return 0
   so change the type to void. From Zhengchao Shao.

4) Fix spelling mistake in esp6.c
   From Zhang Jiaming.

5) Improve the wording of comment above XFRM_OFFLOAD flags.
   From Petr Vaněk.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 6cbd05b2d07a651e00c76d287a5f44994cbafe60:

  Merge tag 'ieee802154-for-net-next-2022-06-09' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan-next (2022-06-09 23:21:29 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master

for you to fetch changes up to 5e25c25aa2c08fb9a79476e029c0b1e3dcd70566:

  xfrm: improve wording of comment above XFRM_OFFLOAD flags (2022-07-04 10:20:11 +0200)

----------------------------------------------------------------
Eyal Birger (1):
      xfrm: no need to set DST_NOPOLICY in IPv4

Petr Vaněk (1):
      xfrm: improve wording of comment above XFRM_OFFLOAD flags

Stephen Hemminger (1):
      xfrm: convert alg_key to flexible array member

Zhang Jiaming (1):
      esp6: Fix spelling mistake

Zhengchao Shao (1):
      xfrm: change the type of xfrm_register_km and xfrm_unregister_km

 drivers/net/vrf.c         |  2 +-
 include/net/route.h       |  3 +--
 include/net/xfrm.h        |  4 ++--
 include/uapi/linux/xfrm.h | 12 ++++++------
 net/ipv4/route.c          | 24 ++++++++----------------
 net/ipv6/esp6.c           |  4 ++--
 net/key/af_key.c          |  6 +-----
 net/xfrm/xfrm_state.c     |  6 ++----
 net/xfrm/xfrm_user.c      |  6 ++----
 9 files changed, 25 insertions(+), 42 deletions(-)
