Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076BE4DE6CC
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 08:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242389AbiCSHoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 03:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiCSHoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 03:44:09 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C27C2D2592
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 00:42:48 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 73BCC2063E;
        Sat, 19 Mar 2022 08:42:45 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MvPPdBNf3Ey3; Sat, 19 Mar 2022 08:42:44 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id ED7BD2019C;
        Sat, 19 Mar 2022 08:42:44 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id DC7FC80004A;
        Sat, 19 Mar 2022 08:42:44 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 19 Mar 2022 08:42:44 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Sat, 19 Mar
 2022 08:42:44 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 49D583182EB2; Sat, 19 Mar 2022 08:42:44 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 0/2] pull request (net-next): ipsec-next 2022-03-19
Date:   Sat, 19 Mar 2022 08:42:38 +0100
Message-ID: <20220319074240.554227-1-steffen.klassert@secunet.com>
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

1) Delete duplicated functions that calls same xfrm_api_check.
   From Leon Romanovsky.

2) Align userland API of the default policy structure to the 
   internal structures. From Nicolas Dichtel.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 000fe940e51f03210bd5fb1061d4d82ed9a7b1b6:

  sfc: The size of the RX recycle ring should be more flexible (2022-02-01 20:34:59 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master

for you to fetch changes up to b58b1f563ab78955d37e9e43e02790a85c66ac05:

  xfrm: rework default policy structure (2022-03-18 07:23:12 +0100)

----------------------------------------------------------------
Leon Romanovsky (1):
      xfrm: delete duplicated functions that calls same xfrm_api_check()

Nicolas Dichtel (1):
      xfrm: rework default policy structure

 include/net/netns/xfrm.h |  6 +-----
 include/net/xfrm.h       | 48 ++++++++++++++++++------------------------------
 net/xfrm/xfrm_device.c   | 14 ++------------
 net/xfrm/xfrm_policy.c   | 10 +++++++---
 net/xfrm/xfrm_user.c     | 43 ++++++++++++++++++-------------------------
 5 files changed, 46 insertions(+), 75 deletions(-)
