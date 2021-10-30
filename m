Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971C54407DA
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 09:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbhJ3H3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 03:29:08 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37652 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231428AbhJ3H3H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 03:29:07 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id A082F20501;
        Sat, 30 Oct 2021 09:26:36 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5M5r3hDmkBMu; Sat, 30 Oct 2021 09:26:36 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 2B8A52049A;
        Sat, 30 Oct 2021 09:26:36 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 17B3F80004A;
        Sat, 30 Oct 2021 09:26:36 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Sat, 30 Oct 2021 09:26:35 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14; Sat, 30 Oct
 2021 09:26:35 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id E89DD318056B; Sat, 30 Oct 2021 09:26:35 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net-next): ipsec-next 2021-10-30
Date:   Sat, 30 Oct 2021 09:26:31 +0200
Message-ID: <20211030072633.4158069-1-steffen.klassert@secunet.com>
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

Just two minor changes this time:

1) Remove some superfluous header files from xfrm4_tunnel.c
   From Mianhan Liu.

2) Simplify some error checks in xfrm_input().
   From luo penghao.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 428168f9951710854d8d1abf6ca03a8bdab0ccc5:

  Merge branch 'mlxsw-trap-adjacency' (2021-09-22 14:35:02 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master

for you to fetch changes up to ad57dae8a64da3926a22debbbe7d3b487a685a08:

  xfrm: Remove redundant fields and related parentheses (2021-10-28 07:56:02 +0200)

----------------------------------------------------------------
Mianhan Liu (1):
      net/ipv4/xfrm4_tunnel.c: remove superfluous header files from xfrm4_tunnel.c

luo penghao (1):
      xfrm: Remove redundant fields and related parentheses

 net/ipv4/xfrm4_tunnel.c | 2 --
 net/xfrm/xfrm_input.c   | 4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)
