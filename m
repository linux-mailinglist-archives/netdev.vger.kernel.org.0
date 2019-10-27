Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15CDDE673C
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 22:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731424AbfJ0VTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 17:19:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:39538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731418AbfJ0VTM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Oct 2019 17:19:12 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92F06214E0;
        Sun, 27 Oct 2019 21:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211152;
        bh=i/nbO+IeJ7byN/CBGOV0SB0HEpwsO/Q0GS3OHglr0v4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wvsHd5R96bq1bdEXY1MML8YF+5RS2jhp2em7kC05Ipn9v/WOaIN619QrBwGblddth
         bySuVgp4iLknUK8Pco7DnjrxcTn6s5GoNu1lPlA/dJtIOkKmu+Yj/HgJ4QZSyMsnz4
         HI1g03+yrJm0TQWZia5/VO8+wVSQbc4uln35/Tss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 051/197] lib: textsearch: fix escapes in example code
Date:   Sun, 27 Oct 2019 21:59:29 +0100
Message-Id: <20191027203354.442061112@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 2105b52e30debe7f19f3218598d8ae777dcc6776 ]

This textsearch code example does not need the '\' escapes and they can
be misleading to someone reading the example. Also, gcc and sparse warn
that the "\%d" is an unknown escape sequence.

Fixes: 5968a70d7af5 ("textsearch: fix kernel-doc warnings and add kernel-api section")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/textsearch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/textsearch.c b/lib/textsearch.c
index 4f16eec5d5544..f68dea8806be2 100644
--- a/lib/textsearch.c
+++ b/lib/textsearch.c
@@ -89,9 +89,9 @@
  *       goto errout;
  *   }
  *
- *   pos = textsearch_find_continuous(conf, \&state, example, strlen(example));
+ *   pos = textsearch_find_continuous(conf, &state, example, strlen(example));
  *   if (pos != UINT_MAX)
- *       panic("Oh my god, dancing chickens at \%d\n", pos);
+ *       panic("Oh my god, dancing chickens at %d\n", pos);
  *
  *   textsearch_destroy(conf);
  */
-- 
2.20.1



