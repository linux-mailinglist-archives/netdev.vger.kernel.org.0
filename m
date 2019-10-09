Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1FB2D1655
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 19:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732865AbfJIR3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 13:29:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732211AbfJIRYO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 13:24:14 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C20FD21924;
        Wed,  9 Oct 2019 17:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641853;
        bh=iUn0+AXJbd2oK9c2oxMcnZEUu2QM6vGDtG0r2+b2KF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TCfrPSureOAEnLxKYrmXCsJQViA+gRTExvKDVl7nPmU0ROm2PkIYJoYHpSO13XaK1
         fYURwBTHvQm/1n+IaKabS5t8AaHOpSb2Osw0UauoY2h8w/KO5073w6wCMa6sQukG+Y
         gvIZERXVc5wHxwDJkjAqutVBPekpPBXAqnrwmK9I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 22/26] lib: textsearch: fix escapes in example code
Date:   Wed,  9 Oct 2019 13:05:54 -0400
Message-Id: <20191009170558.32517-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009170558.32517-1-sashal@kernel.org>
References: <20191009170558.32517-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

