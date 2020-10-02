Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D037280CFD
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 07:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgJBFBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 01:01:33 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:41940 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbgJBFB2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 01:01:28 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 0F4E02019C;
        Fri,  2 Oct 2020 07:01:26 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bTxC_jhEz0gE; Fri,  2 Oct 2020 07:01:24 +0200 (CEST)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 71D4020501;
        Fri,  2 Oct 2020 07:01:24 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 2 Oct 2020 07:01:24 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Fri, 2 Oct 2020
 07:01:23 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 3691E318067D;
 Fri,  2 Oct 2020 07:01:23 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net-next): ipsec-next 2020-10-02
Date:   Fri, 2 Oct 2020 07:01:06 +0200
Message-ID: <20201002050113.2210-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Add a full xfrm compatible layer for 32-bit applications on
   64-bit kernels. From Dmitry Safonov.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 02a20d4fef3da0278bd2d95c86f48318a9902b76:

  enic: switch from 'pci_' to 'dma_' API (2020-09-06 12:52:19 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master

for you to fetch changes up to 61e7113e48d3ca1ea692b5c6376a4b545b312166:

  Merge 'xfrm: Add compat layer' (2020-09-28 11:26:56 +0200)

----------------------------------------------------------------
Dmitry Safonov (7):
      xfrm: Provide API to register translator module
      xfrm/compat: Add 64=>32-bit messages translator
      xfrm/compat: Attach xfrm dumps to 64=>32 bit translator
      netlink/compat: Append NLMSG_DONE/extack to frag_list
      xfrm/compat: Add 32=>64-bit messages translator
      xfrm/compat: Translate 32-bit user_policy from sockptr
      selftest/net/xfrm: Add test for ipsec tunnel

Steffen Klassert (1):
      Merge 'xfrm: Add compat layer'

 MAINTAINERS                            |    1 +
 include/net/xfrm.h                     |   33 +
 net/netlink/af_netlink.c               |   47 +-
 net/xfrm/Kconfig                       |   11 +
 net/xfrm/Makefile                      |    1 +
 net/xfrm/xfrm_compat.c                 |  625 +++++++++
 net/xfrm/xfrm_state.c                  |   77 +-
 net/xfrm/xfrm_user.c                   |  110 +-
 tools/testing/selftests/net/.gitignore |    1 +
 tools/testing/selftests/net/Makefile   |    1 +
 tools/testing/selftests/net/ipsec.c    | 2195 ++++++++++++++++++++++++++++++++
 11 files changed, 3066 insertions(+), 36 deletions(-)
 create mode 100644 net/xfrm/xfrm_compat.c
 create mode 100644 tools/testing/selftests/net/ipsec.c
