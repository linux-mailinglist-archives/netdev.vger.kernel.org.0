Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 081A36E746B
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 09:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbjDSHxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 03:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbjDSHxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 03:53:48 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4A7A5C7
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 00:53:24 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 80CB12085A;
        Wed, 19 Apr 2023 09:53:06 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id LmcKZZyDiTol; Wed, 19 Apr 2023 09:53:06 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 194952008D;
        Wed, 19 Apr 2023 09:53:06 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 0919B80004A;
        Wed, 19 Apr 2023 09:53:06 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 19 Apr 2023 09:53:05 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 19 Apr
 2023 09:53:04 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id C5F683182E59; Wed, 19 Apr 2023 09:53:04 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 0/2] pull request (net-next): ipsec-next 2023-04-19
Date:   Wed, 19 Apr 2023 09:52:58 +0200
Message-ID: <20230419075300.452227-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.34.1
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

1) Remove inner/outer modes from input/output path. These are
   not needed anymore. From Herbert Xu.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 95b744508d4d5135ae2a096ff3f0ee882bcc52b3:

  qede: remove linux/version.h and linux/compiler.h (2023-03-10 21:29:54 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git tags/ipsec-next-2023-04-19

for you to fetch changes up to f4796398f21b9844017a2dac883b1dd6ad6edd60:

  xfrm: Remove inner/outer modes from output path (2023-03-13 11:51:13 +0100)

----------------------------------------------------------------
ipsec-next-2023-04-19

----------------------------------------------------------------
Herbert Xu (2):
      xfrm: Remove inner/outer modes from input path
      xfrm: Remove inner/outer modes from output path

 net/xfrm/xfrm_input.c  | 66 ++++++++++++++++++--------------------------------
 net/xfrm/xfrm_output.c | 33 +++++++++----------------
 2 files changed, 34 insertions(+), 65 deletions(-)
