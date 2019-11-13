Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7F33FAFA2
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 12:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbfKML0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 06:26:21 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:49900 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727908AbfKML0U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 06:26:20 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 56D9E20536;
        Wed, 13 Nov 2019 12:26:19 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id xVU5vT-A1qRp; Wed, 13 Nov 2019 12:26:18 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E737F2057B;
        Wed, 13 Nov 2019 12:26:18 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 13 Nov 2019
 12:26:18 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 52E2631801A7;
 Wed, 13 Nov 2019 12:26:16 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: pull request (net): ipsec 2019-11-13
Date:   Wed, 13 Nov 2019 12:26:11 +0100
Message-ID: <20191113112613.2596-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Fix a page memleak on xfrm state destroy.

2) Fix a refcount imbalance if a xfrm_state
   gets invaild during async resumption.
   From Xiaodong Xu.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 99a8efbb6e30b72ac98cecf81103f847abffb1e5:

  NFC: st21nfca: fix double free (2019-11-06 21:48:29 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git master

for you to fetch changes up to 4944a4b1077f74d89073624bd286219d2fcbfce3:

  xfrm: release device reference for invalid state (2019-11-12 08:24:38 +0100)

----------------------------------------------------------------
Steffen Klassert (1):
      xfrm: Fix memleak on xfrm state destroy

Xiaodong Xu (1):
      xfrm: release device reference for invalid state

 net/xfrm/xfrm_input.c | 3 +++
 net/xfrm/xfrm_state.c | 2 ++
 2 files changed, 5 insertions(+)
