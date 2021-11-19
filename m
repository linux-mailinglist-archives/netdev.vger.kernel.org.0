Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC79E456AAA
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 08:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbhKSHNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 02:13:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:59712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232076AbhKSHNl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 02:13:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68A5761AD2;
        Fri, 19 Nov 2021 07:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637305840;
        bh=8em/bAE0LwFseK6KG+9VRj+8Md/5p9508afuHjxYDqg=;
        h=From:To:Cc:Subject:Date:From;
        b=cQXE2+g0sJoaOa0xJVbYS2sjnE8pmV9RynHOt0V2aEXGNV9dSJan9zjguszLC8PCA
         nigUFMspLzxncbrKV6orfa0XZ1kz1DKyRQ9WNu8nogrlO72JoVIqgRRW9wn7+zjquR
         KtWOKgyvOOheCi2gQAQ1R2eEf4lZq0OZ9+gQnUT9PROffSB2xUJ6Ay4br2e/DWKlL3
         yewDH8G3IkYF/KX6BkopvtB8M7BSTW6ZvGiLhhEigXaCkU+qPeuqldlc3Ot6g8D6Yc
         Nqyp0h0W36JjN+WNDo9sUY2MPops3x2TM4Cb3t5XRMhmm8KPyK+F7eYOPhaiXqrS9O
         yKw0PTv7eGr7w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 00/15] use eth_hw_addr_set() in arch-specific drivers
Date:   Thu, 18 Nov 2021 23:10:18 -0800
Message-Id: <20211119071033.3756560-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixups for more arch-specific drivers.

With these (and another patch which didn't fit) the build is more or
less clean with all cross-compilers available on kernel.org. I say
more or less because around half of the arches fail to build for
unrelated reasons right now.

Most of the changes here are for m68k, 32bit x86 and alpha.

Jakub Kicinski (15):
  amd: lance: use eth_hw_addr_set()
  amd: ni65: use eth_hw_addr_set()
  amd: a2065/ariadne: use eth_hw_addr_set()
  amd: hplance: use eth_hw_addr_set()
  amd: atarilance: use eth_hw_addr_set()
  amd: mvme147: use eth_hw_addr_set()
  8390: smc-ultra: use eth_hw_addr_set()
  8390: hydra: use eth_hw_addr_set()
  8390: mac8390: use eth_hw_addr_set()
  8390: wd: use eth_hw_addr_set()
  smc9194: use eth_hw_addr_set()
  lasi_82594: use eth_hw_addr_set()
  apple: macmace: use eth_hw_addr_set()
  cirrus: mac89x0: use eth_hw_addr_set()
  natsemi: macsonic: use eth_hw_addr_set()

 drivers/net/ethernet/8390/hydra.c        |  4 +++-
 drivers/net/ethernet/8390/mac8390.c      |  4 +++-
 drivers/net/ethernet/8390/smc-ultra.c    |  4 +++-
 drivers/net/ethernet/8390/wd.c           |  4 +++-
 drivers/net/ethernet/amd/a2065.c         | 18 +++++++++-------
 drivers/net/ethernet/amd/ariadne.c       | 20 ++++++++++--------
 drivers/net/ethernet/amd/atarilance.c    |  7 ++++--
 drivers/net/ethernet/amd/hplance.c       |  4 +++-
 drivers/net/ethernet/amd/lance.c         |  4 +++-
 drivers/net/ethernet/amd/mvme147.c       | 14 ++++++------
 drivers/net/ethernet/amd/ni65.c          |  8 ++++---
 drivers/net/ethernet/apple/macmace.c     | 14 +++++++-----
 drivers/net/ethernet/cirrus/mac89x0.c    |  7 ++++--
 drivers/net/ethernet/i825xx/lasi_82596.c |  6 ++++--
 drivers/net/ethernet/natsemi/macsonic.c  | 27 +++++++++++++++---------
 drivers/net/ethernet/smsc/smc9194.c      |  6 ++++--
 16 files changed, 96 insertions(+), 55 deletions(-)

-- 
2.31.1

