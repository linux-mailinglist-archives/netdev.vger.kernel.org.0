Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45BCC314C01
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 10:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbhBIJqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 04:46:04 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:38558 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230144AbhBIJnv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 04:43:51 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B50882006C;
        Tue,  9 Feb 2021 10:43:08 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id CQcvEOPT5Qe8; Tue,  9 Feb 2021 10:43:08 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 4D0CF201E2;
        Tue,  9 Feb 2021 10:43:08 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 9 Feb 2021 10:43:08 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Tue, 9 Feb 2021
 10:43:07 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 3623C3180060; Tue,  9 Feb 2021 10:43:08 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net-next): ipsec-next 2021-02-09
Date:   Tue, 9 Feb 2021 10:43:01 +0100
Message-ID: <20210209094305.3529418-1-steffen.klassert@secunet.com>
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

1) Support TSO on xfrm interfaces.
   From Eyal Birger.

2) Variable calculation simplifications in esp4/esp6.
   From Jiapeng Chong / Jiapeng Zhong.

3) Fix a return code in xfrm_do_migrate.
   From Zheng Yongjun.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit ede71cae72855f8d6f6268510895210adc317666:

  net-next: docs: Fix typos in snmp_counter.rst (2021-01-05 17:07:38 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master

for you to fetch changes up to 4ac7a6eecbec90c7f83d5ea6f0498d9fa9c62917:

  xfrm: Return the correct errno code (2021-02-04 09:29:27 +0100)

----------------------------------------------------------------
Eyal Birger (1):
      xfrm: interface: enable TSO on xfrm interfaces

Jiapeng Chong (1):
      esp: Simplify the calculation of variables

Jiapeng Zhong (1):
      net: Simplify the calculation of variables

Zheng Yongjun (1):
      xfrm: Return the correct errno code

 net/ipv4/esp4_offload.c   |  2 +-
 net/ipv6/esp6.c           |  2 +-
 net/xfrm/xfrm_interface.c | 10 +++++++++-
 net/xfrm/xfrm_user.c      |  2 +-
 4 files changed, 12 insertions(+), 4 deletions(-)
