Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F05E4A9F85
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 12:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733170AbfIEKWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 06:22:14 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:57340 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731067AbfIEKWL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 06:22:11 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 0ED0C20573;
        Thu,  5 Sep 2019 12:22:10 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MBVWj72NBSCQ; Thu,  5 Sep 2019 12:22:09 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 30C4820561;
        Thu,  5 Sep 2019 12:22:09 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 5 Sep 2019
 12:22:07 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id B725831826E7;
 Thu,  5 Sep 2019 12:22:08 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net): ipsec 2019-09-05
Date:   Thu, 5 Sep 2019 12:21:56 +0200
Message-ID: <20190905102201.1636-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Several xfrm interface fixes from Nicolas Dichtel:
   - Avoid an interface ID corruption on changelink.
   - Fix wrong intterface names in the logs.
   - Fix a list corruption when changing network namespaces.
   - Fix unregistation of the underying phydev.

2) Fix a potential warning when merging xfrm_plocy nodes.
   From Florian Westphal.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 114a5c3240155fdb01bf821c9d326d7bb05bd464:

  Merge tag 'mlx5-fixes-2019-07-11' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2019-07-11 15:06:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master

for you to fetch changes up to 769a807d0b41df4201dbeb01c22eaeb3e5905532:

  xfrm: policy: avoid warning splat when merging nodes (2019-08-20 08:09:42 +0200)

----------------------------------------------------------------
Florian Westphal (1):
      xfrm: policy: avoid warning splat when merging nodes

Nicolas Dichtel (4):
      xfrm interface: avoid corruption on changelink
      xfrm interface: ifname may be wrong in logs
      xfrm interface: fix list corruption for x-netns
      xfrm interface: fix management of phydev

 include/net/xfrm.h                         |  2 --
 net/xfrm/xfrm_interface.c                  | 56 +++++++++++++-----------------
 net/xfrm/xfrm_policy.c                     |  6 ++--
 tools/testing/selftests/net/xfrm_policy.sh |  7 ++++
 4 files changed, 36 insertions(+), 35 deletions(-)
