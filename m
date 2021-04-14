Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935B935F160
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 12:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbhDNKR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 06:17:28 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:59488 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232032AbhDNKR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 06:17:26 -0400
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Apr 2021 06:17:25 EDT
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 3AF13800059;
        Wed, 14 Apr 2021 12:17:04 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Apr 2021 12:17:04 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 14 Apr
 2021 12:17:03 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 8DA3131803A8; Wed, 14 Apr 2021 12:17:03 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net-next): ipsec-next 2021-04-14
Date:   Wed, 14 Apr 2021 12:16:58 +0200
Message-ID: <20210414101701.324777-1-steffen.klassert@secunet.com>
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

Not much this time:

1) Simplification of some variable calculations in esp4 and esp6.
   From Jiapeng Chong and Junlin Yang.

2) Fix a clang Wformat warning in esp6 and ah6.
   From Arnd Bergmann.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 34bb975126419e86bc3b95e200dc41de6c6ca69c:

  net: fddi: skfp: Mundane typo fixes throughout the file smt.h (2021-03-10 15:42:22 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master

for you to fetch changes up to 6ad2dd6c14d3989b44cdc17f1e7258bf613dd070:

  ipv6: fix clang Wformat warning (2021-03-25 09:48:32 +0100)

----------------------------------------------------------------
Arnd Bergmann (1):
      ipv6: fix clang Wformat warning

Jiapeng Chong (1):
      esp4: Simplify the calculation of variables

Junlin Yang (1):
      esp6: remove a duplicative condition

 net/ipv4/esp4.c         | 2 +-
 net/ipv6/ah6.c          | 2 +-
 net/ipv6/esp6.c         | 2 +-
 net/ipv6/esp6_offload.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)
