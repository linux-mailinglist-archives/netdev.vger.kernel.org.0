Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B651F4A76
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 02:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbgFJA5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 20:57:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbgFJA5n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 20:57:43 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43493206C3;
        Wed, 10 Jun 2020 00:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591750663;
        bh=uzmWQ37bKQDMUkQ25i+1+Gv0eF+nsjPtHVc2DRidLhs=;
        h=From:To:Cc:Subject:Date:From;
        b=Jow4cysVNWJRRZ7YMmlYUGeJMM5IK+www9hXpfLsanve9C53WrbLhwFe3OsAkT3nU
         8jmPnwWyL3FPDQ9TJZxzP7nIgvvCKMVO4cLLjucFF9nd9B4H0eDVTwxDIMao96zp6a
         PRRXUrdfM5WQ3Eq6LoF5dGfYGFSYi/mQe14qGLZg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net v3 0/3] esp, ah: improve crypto algorithm selections
Date:   Tue,  9 Jun 2020 17:53:59 -0700
Message-Id: <20200610005402.152495-1-ebiggers@kernel.org>
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

Eric Biggers (3):
  esp, ah: consolidate the crypto algorithm selections
  esp: select CRYPTO_SEQIV
  esp, ah: modernize the crypto algorithm selections

 net/ipv4/Kconfig | 37 +++++++++++++++++++++----------------
 net/ipv6/Kconfig | 37 +++++++++++++++++++++----------------
 net/xfrm/Kconfig | 24 ++++++++++++++++++++++++
 3 files changed, 66 insertions(+), 32 deletions(-)


base-commit: 8027bc0307ce59759b90679fa5d8b22949586d20
-- 
2.26.2

