Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03E42D0D85
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 10:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgLGJ4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 04:56:09 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:49418 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbgLGJ4J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 04:56:09 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id CF5B4204B4;
        Mon,  7 Dec 2020 10:55:27 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 17DbQJjY42LM; Mon,  7 Dec 2020 10:55:27 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 0C8782035C;
        Mon,  7 Dec 2020 10:55:27 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Dec 2020 10:55:26 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 7 Dec 2020
 10:55:26 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 946693182E5D; Mon,  7 Dec 2020 10:39:43 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net): ipsec 2020-12-07
Date:   Mon, 7 Dec 2020 10:39:33 +0100
Message-ID: <20201207093937.2874932-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Sysbot reported fixes for the new 64/32 bit compat layer.
   From Dmitry Safonov.

2) Fix a memory leak in xfrm_user_policy that was introduced
   by adding the 64/32 bit compat layer. From Yu Kuai.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 4e0396c59559264442963b349ab71f66e471f84d:

  net: marvell: prestera: fix compilation with CONFIG_BRIDGE=m (2020-11-07 12:43:26 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master

for you to fetch changes up to 48f486e13ffdb49fbb9b38c21d0e108ed60ab1a2:

  net: xfrm: fix memory leak in xfrm_user_policy() (2020-11-10 09:14:25 +0100)

----------------------------------------------------------------
Dmitry Safonov (3):
      xfrm/compat: Translate by copying XFRMA_UNSPEC attribute
      xfrm/compat: memset(0) 64-bit padding at right place
      xfrm/compat: Don't allocate memory with __GFP_ZERO

Steffen Klassert (1):
      Merge branch 'xfrm/compat: syzbot-found fixes'

Yu Kuai (1):
      net: xfrm: fix memory leak in xfrm_user_policy()

 net/xfrm/xfrm_compat.c | 5 +++--
 net/xfrm/xfrm_state.c  | 4 +++-
 2 files changed, 6 insertions(+), 3 deletions(-)
