Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB1D450099A
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 11:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241642AbiDNJWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 05:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240083AbiDNJWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 05:22:17 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65D713DCC
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 02:19:50 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E9D1B20612;
        Thu, 14 Apr 2022 11:19:47 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id L94TMDq15qis; Thu, 14 Apr 2022 11:19:47 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 787D4205FC;
        Thu, 14 Apr 2022 11:19:47 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 69DF580004A;
        Thu, 14 Apr 2022 11:19:47 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 14 Apr 2022 11:19:47 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 14 Apr
 2022 11:19:47 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id DFE963182EB0; Thu, 14 Apr 2022 11:19:46 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 0/2] pull request (net): ipsec 2022-04-14
Date:   Thu, 14 Apr 2022 11:19:41 +0200
Message-ID: <20220414091943.3000372-1-steffen.klassert@secunet.com>
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

1) Fix the output interface for VRF cases in xfrm_dst_lookup.
   From David Ahern.

2) Fix write out of bounds by doing COW on esp output when the
   packet size is larger than a page.
   From Sabrina Dubroca.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 692930cc435099580a4b9e32fa781b0688c18439:

  selftests: net: fix nexthop warning cleanup double ip typo (2022-04-03 13:09:05 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master

for you to fetch changes up to 5bd8baab087dff657e05387aee802e70304cc813:

  esp: limit skb_page_frag_refill use to a single page (2022-04-13 10:16:11 +0200)

----------------------------------------------------------------
David Ahern (1):
      xfrm: Pass flowi_oif or l3mdev as oif to xfrm_dst_lookup

Sabrina Dubroca (1):
      esp: limit skb_page_frag_refill use to a single page

 include/net/esp.h      | 2 --
 net/ipv4/esp4.c        | 5 ++---
 net/ipv6/esp6.c        | 5 ++---
 net/xfrm/xfrm_policy.c | 4 +++-
 4 files changed, 7 insertions(+), 9 deletions(-)
