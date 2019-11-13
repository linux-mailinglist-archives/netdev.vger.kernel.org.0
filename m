Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24306FAFC7
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 12:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbfKMLeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 06:34:05 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:50388 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727567AbfKMLeF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 06:34:05 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 3102520581;
        Wed, 13 Nov 2019 12:34:04 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id HuPag4u4-vgA; Wed, 13 Nov 2019 12:34:03 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B1BFF205A4;
        Wed, 13 Nov 2019 12:34:03 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 13 Nov 2019
 12:34:03 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 9DA7631801A7;
 Wed, 13 Nov 2019 12:34:01 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net-next): ipsec-next 2019-11-13
Date:   Wed, 13 Nov 2019 12:33:56 +0100
Message-ID: <20191113113358.4740-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Remove a unnecessary net_exit function from the xfrm interface.
   From Xin Long.

2) Assign xfrm4_udp_encap_rcv to a UDP socket only if xfrm
   is configured. From Alexey Dobriyan.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 02dc96ef6c25f990452c114c59d75c368a1f4c8f:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2019-09-28 17:47:33 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master

for you to fetch changes up to fd1ac07f3f17fbbc2f08e3b43951bed937d86a7b:

  xfrm: ifdef setsockopt(UDP_ENCAP_ESPINUDP/UDP_ENCAP_ESPINUDP_NON_IKE) (2019-10-09 06:55:32 +0200)

----------------------------------------------------------------
Alexey Dobriyan (1):
      xfrm: ifdef setsockopt(UDP_ENCAP_ESPINUDP/UDP_ENCAP_ESPINUDP_NON_IKE)

Xin Long (1):
      xfrm: remove the unnecessary .net_exit for xfrmi

 include/net/xfrm.h        |  7 -------
 net/ipv4/udp.c            |  2 ++
 net/xfrm/xfrm_interface.c | 23 -----------------------
 3 files changed, 2 insertions(+), 30 deletions(-)
