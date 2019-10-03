Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0FA6C9560
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 02:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbfJCAIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 20:08:19 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55198 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfJCAIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 20:08:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Date:Message-ID:Subject:From:Cc:To:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LX3dKDMWbmfdXy+k1nvUJV+7PrVhFHyukz+qUS83wpQ=; b=PI/aMGexMso1KjocPJKaNhNdu
        4kUfwLq8UJLQn4nt+Y2SiyqL4CVAuymhlW0g7tGnbdgDfLyvDUeaCJQl78mZoD6SwfCsCjqeSTeRd
        tbTIdnBECyfKnbCX4pSN2+2S4gNKzXci1Ux38EoAl6xNapt06rcKyBJXC/2mJBt0O9IM9O9vZLix1
        pfO+HJWEwIzsUuIeSshT8jfbUbmIkuwZG9Dq6aUFXFYrMUzBLnj1MVQ80wOipvXhBZjEy6h0Pr8Je
        oxt+nHVOCLCuB2yO8QV5dnDxYKa/hjirf+0Qz2J2UOj9j6Q3+WS914UMBsQq8tIUtHvjOKjfgDk9z
        1Y0FLukiQ==;
Received: from [2601:1c0:6280:3f0::9a1f]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iFofK-00082B-Ig; Thu, 03 Oct 2019 00:08:18 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Al Viro <viro@ZenIV.linux.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] lib: textsearch: fix escapes in example code
Message-ID: <86cf431b-9dbc-d608-205d-1f161bb14533@infradead.org>
Date:   Wed, 2 Oct 2019 17:08:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

This textsearch code example does not need the '\' escapes and they can
be misleading to someone reading the example. Also, gcc and sparse warn
that the "\%d" is an unknown escape sequence.

Fixes: 5968a70d7af5 ("textsearch: fix kernel-doc warnings and add kernel-api section")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 lib/textsearch.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- lnx-54-rc1.orig/lib/textsearch.c
+++ lnx-54-rc1/lib/textsearch.c
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

