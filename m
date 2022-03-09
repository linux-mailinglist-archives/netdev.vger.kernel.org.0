Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD7C04D2FAD
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 14:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbiCINJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 08:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbiCINJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 08:09:45 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBD1C3347
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 05:08:44 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id CB707201CA;
        Wed,  9 Mar 2022 14:08:42 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id iJ9EYk9JKtWG; Wed,  9 Mar 2022 14:08:42 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 47F8B20096;
        Wed,  9 Mar 2022 14:08:42 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 394C480004A;
        Wed,  9 Mar 2022 14:08:42 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Wed, 9 Mar 2022 14:08:42 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Wed, 9 Mar
 2022 14:08:42 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 9B0763181156; Wed,  9 Mar 2022 14:08:41 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net): ipsec 2022-03-09
Date:   Wed, 9 Mar 2022 14:08:34 +0100
Message-ID: <20220309130839.3263912-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
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

1) Fix IPv6 PMTU discovery for xfrm interfaces.
   From Lina Wang.

2) Revert failing for policies and states that are
   configured with XFRMA_IF_ID 0. It broke a
   user configuration. From Kai Lueke.

3) Fix a possible buffer overflow in the ESP output path.

4) Fix ESP GSO for tunnel and BEET mode on inter address
   family tunnels.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 519ca6fa960587d02904a9f8f79d587ac874fb03:

  Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue (2022-02-26 12:50:20 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master

for you to fetch changes up to 23c7f8d7989e1646aac82f75761b7648c355cb8a:

  net: Fix esp GSO on inter address family tunnels. (2022-03-07 13:14:04 +0100)

----------------------------------------------------------------
Kai Lueke (1):
      Revert "xfrm: state and policy should fail if XFRMA_IF_ID 0"

Lina Wang (1):
      xfrm: fix tunnel model fragmentation behavior

Steffen Klassert (3):
      esp: Fix possible buffer overflow in ESP transformation
      esp: Fix BEET mode inter address family tunneling on GSO
      net: Fix esp GSO on inter address family tunnels.

 include/linux/netdevice.h |  2 ++
 include/net/esp.h         |  2 ++
 net/core/gro.c            | 25 +++++++++++++++++++++++++
 net/ipv4/esp4.c           |  5 +++++
 net/ipv4/esp4_offload.c   |  6 ++++--
 net/ipv6/esp6.c           |  5 +++++
 net/ipv6/esp6_offload.c   |  6 ++++--
 net/ipv6/xfrm6_output.c   | 16 ++++++++++++++++
 net/xfrm/xfrm_interface.c |  5 ++++-
 net/xfrm/xfrm_user.c      | 21 +++------------------
 10 files changed, 70 insertions(+), 23 deletions(-)
