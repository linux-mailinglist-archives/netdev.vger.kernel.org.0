Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2082D85CD
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 11:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438565AbgLLKN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 05:13:58 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:48604 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405184AbgLLKNp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 05:13:45 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 4DE66201D3;
        Sat, 12 Dec 2020 09:57:41 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id olMWnHz9CQqb; Sat, 12 Dec 2020 09:57:40 +0100 (CET)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id DE3EB20299;
        Sat, 12 Dec 2020 09:57:40 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Sat, 12 Dec 2020 09:57:40 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Sat, 12 Dec
 2020 09:57:40 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id B2BC23182CE5;
 Sat, 12 Dec 2020 09:57:39 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net-next): ipsec-next 2020-12-12
Date:   Sat, 12 Dec 2020 09:57:36 +0100
Message-ID: <20201212085737.2101294-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just one patch this time:

1) Redact the SA keys with kernel lockdown confidentiality.
   If enabled, no secret keys are sent to uuserspace.
   From Antony Antony.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 8be33ecfc1ffd2da20cc29e957e4cb6eb99310cb:

  net: skb_vlan_untag(): don't reset transport offset if set by GRO layer (2020-11-09 20:03:55 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master

for you to fetch changes up to c7a5899eb26e2a4d516d53f65b6dd67be2228041:

  xfrm: redact SA secret with lockdown confidentiality (2020-11-27 11:03:06 +0100)

----------------------------------------------------------------
Antony Antony (1):
      xfrm: redact SA secret with lockdown confidentiality

 include/linux/security.h |  1 +
 net/xfrm/xfrm_user.c     | 74 +++++++++++++++++++++++++++++++++++++++++++-----
 security/security.c      |  1 +
 3 files changed, 69 insertions(+), 7 deletions(-)
