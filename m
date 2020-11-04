Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B298C2A5FFD
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 10:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbgKDJAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 04:00:22 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:46544 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbgKDJAW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 04:00:22 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 13182201D3;
        Wed,  4 Nov 2020 10:00:21 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jIrF9YquEp0y; Wed,  4 Nov 2020 10:00:20 +0100 (CET)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D7A4420082;
        Wed,  4 Nov 2020 10:00:15 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Wed, 4 Nov 2020 10:00:15 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Wed, 4 Nov 2020
 10:00:15 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id EB3B231809FF;
 Wed,  4 Nov 2020 10:00:14 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net): ipsec 2020-11-04
Date:   Wed, 4 Nov 2020 10:00:08 +0100
Message-ID: <20201104090010.17558-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Fix packet receiving of standard IP tunnels when the xfrm_interface
   module is installed. From Xin Long.

2) Fix a race condition between spi allocating and hash list
   resizing. From zhuoliang zhang.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 3fdd47c3b40ac48e6e6e5904cf24d12e6e073a96:

  Merge tag 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost (2020-10-08 14:25:46 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master

for you to fetch changes up to a779d91314ca7208b7feb3ad817b62904397c56d:

  net: xfrm: fix a race condition during allocing spi (2020-10-23 09:08:55 +0200)

----------------------------------------------------------------
Xin Long (1):
      xfrm: interface: fix the priorities for ipip and ipv6 tunnels

zhuoliang zhang (1):
      net: xfrm: fix a race condition during allocing spi

 net/ipv4/xfrm4_tunnel.c   | 4 ++--
 net/ipv6/xfrm6_tunnel.c   | 4 ++--
 net/xfrm/xfrm_interface.c | 8 ++++----
 net/xfrm/xfrm_state.c     | 8 +++++---
 4 files changed, 13 insertions(+), 11 deletions(-)
