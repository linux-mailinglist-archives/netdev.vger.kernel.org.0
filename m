Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20B1BE6692
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 22:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730200AbfJ0VNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 17:13:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730174AbfJ0VNJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Oct 2019 17:13:09 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D42A20B7C;
        Sun, 27 Oct 2019 21:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210788;
        bh=iUn0+AXJbd2oK9c2oxMcnZEUu2QM6vGDtG0r2+b2KF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zbE+BEtETNBDNVxnRrxA9f0uv2SJ+ethNjo82AGdxhsxooZEtYl01Ow1Rae8USR/n
         ICnfslNMjn7u2b678aYvQanumfhYAGiFT5gEkfa0ctPry9J2SQt05vhzwRsQayXdLm
         atxdC2Bk5P8yZjVyALltrJxW9OduqFGgE9asP/Gw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 18/93] lib: textsearch: fix escapes in example code
Date:   Sun, 27 Oct 2019 22:00:30 +0100
Message-Id: <20191027203255.387257901@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
References: <20191027203251.029297948@linuxfoundation.org>
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
index 5939549c0e7bc..9135c29add624 100644
--- a/lib/textsearch.c
+++ b/lib/textsearch.c
@@ -93,9 +93,9 @@
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



