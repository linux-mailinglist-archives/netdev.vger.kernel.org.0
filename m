Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D011E1F58D4
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 18:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbgFJQPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 12:15:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727948AbgFJQPN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 12:15:13 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B3822063A;
        Wed, 10 Jun 2020 16:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591805713;
        bh=NeECbS+JD2nd9m1zZ4V4IaXqINFSAhWGzBIDMBB1vD4=;
        h=From:To:Cc:Subject:Date:From;
        b=Vcqo6vNpiERFxO5VKq/sNjCiZ5r7qbZyEr1Rfk+xY8QZPHLsONvC2Jm0nEU2qsowi
         FQlgm0h4SqDxjl1V+zPBy8+xknDZ7cM+42uef1HRPyoGwfwPmfj17j+BzgVlG9lxzp
         tPZBvXmuC1pH6K1wbrT5CdAwNod+1pPsHZQ07iAA=
From:   Eric Biggers <ebiggers@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net v4 0/3] esp, ah: improve crypto algorithm selections
Date:   Wed, 10 Jun 2020 09:14:34 -0700
Message-Id: <20200610161437.4290-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series consolidates and modernizes the lists of crypto algorithms
that are selected by the IPsec kconfig options, and adds CRYPTO_SEQIV
since it no longer gets selected automatically by other things.

See previous discussion at
https://lkml.kernel.org/netdev/20200604192322.22142-1-ebiggers@kernel.org/T/#u

Changed v3 => v4:
  - Don't say that AH is "NOT RECOMMENDED" by RFC 8221.
  - Updated commit messages (added Acked-by tags, fixed a bad Fixes tag,
    added some more explanation to patch 3).

Eric Biggers (3):
  esp, ah: consolidate the crypto algorithm selections
  esp: select CRYPTO_SEQIV
  esp, ah: modernize the crypto algorithm selections

 net/ipv4/Kconfig | 34 ++++++++++++++++++----------------
 net/ipv6/Kconfig | 34 ++++++++++++++++++----------------
 net/xfrm/Kconfig | 24 ++++++++++++++++++++++++
 3 files changed, 60 insertions(+), 32 deletions(-)


base-commit: 89dc68533b190117e1a2fb4298d88b96b3580abf
-- 
2.26.2

