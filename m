Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5FC035AE3F
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 16:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235023AbhDJOZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 10:25:04 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53541 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235184AbhDJOYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 10:24:12 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 1C7645C011C;
        Sat, 10 Apr 2021 10:23:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 10 Apr 2021 10:23:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=talbothome.com;
         h=message-id:subject:from:to:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm2; bh=
        yCTiFfCilZpw8CHxlMVAEHYuuw/IucthOjGZ1iGHK4M=; b=TWHzx0IUzm7xIy4q
        nAQEaIwyOs4OYn27Zu/PRqKT7EUtU8w1w+/SzkpdGLPN7f7SmojOCt8VwlXcGZbv
        7F/aawT9uXTX+ZIiIsml7yFsPZwBxrLvgvIEpXTgvYDdyh20/gq7pXMm54doFap0
        I/MPp76lRuda9L6ic8nfdwPDtT8QSa2Jkkn0TrEE54o+WvMOx/JIvm40LgW6zKBj
        3Y5AwUk2hsMtHLJ8nZJnkzwAnvAxS0OnFYHVprR3h/cKnqBNcWUF+BrgyZgtP8SE
        Kw4iDOOtlCKZYeyPhhl0bfsfqayis+uh4vVRTXFdBrjKuEINJlEituVM3ytnEx1g
        oacg8g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=yCTiFfCilZpw8CHxlMVAEHYuuw/IucthOjGZ1iGHK
        4M=; b=lBclWJgegCBKK1VhGzWn1QrGS4RIZQeJ8UO8jzvbu/bWzm5TeBHTyZ2jt
        10qudODDkOF3qLVF4Q6Pfc3USxnF32Za2Cd2PqD0CKQjQPxWL7mBi0riNDJ+ZZHI
        fGbexKBj8PQXjfu9AQldXCiGo6/KRg+F1cJed3DxYVysMn+XmJBkoftjEOFyq2n0
        ULrCi74UlIeqtCaaH8X9l+Lts9MqoUf1x40lu1sYTYrOJ97hGVBlQIJqXo4mEk1h
        7NCMtAes2worO9RDKrg02sRb8VY884GtoQ6OSZLA727kDoJoZ7fsoHHVOmZzyMyE
        O2MWpWGDQNNQVeVtltzMfEr3ehWfQ==
X-ME-Sender: <xms:_rRxYK88EcY2iH40jzYuySawgCuLCvsRFF1EYzsTKEV3t1iYrq2IGA>
    <xme:_rRxYKssJs2fRyHiIV_BCWm2AkMmmPZwMCJ_fx-596GCXBKyjN-WF7ZY3RFZBMqNm
    Ehewa_3u37JUeAV0w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekfedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefkuffhvfffjghftggfggfgsehtje
    ertddtreejnecuhfhrohhmpeevhhhrihhsucfvrghlsghothcuoegthhhrihhssehtrghl
    sghothhhohhmvgdrtghomheqnecuggftrfgrthhtvghrnhepgefhtdfhgfeklefgueevte
    dtfeejjefhvdetheevudfgkeeghefhleelvdeuieegnecukfhppeejvddrleehrddvgeef
    rdduheeinecuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomh
    eptghhrhhishesthgrlhgsohhthhhomhgvrdgtohhm
X-ME-Proxy: <xmx:_rRxYAD_ZhQOTajtdgHf7EWW9DGdj_iLEeKgXYxmc-JfKlozqcRZ0A>
    <xmx:_rRxYCf_15EyKWlwo6gkhjdYwpamQHm57uZUSN9iMjjYJp66ZzNC-w>
    <xmx:_rRxYPNxbG7dZoU-AzJfvOqdMPJh9NvHCrgGg-013gMllmqAKtKNAg>
    <xmx:_rRxYF0oSykZ5zE3_4UFo0AnslBpCbNWJxyQgQz1voq6YO76tIq9xA>
Received: from SpaceballstheLaptop.talbothome.com (unknown [72.95.243.156])
        by mail.messagingengine.com (Postfix) with ESMTPA id DF06424005B;
        Sat, 10 Apr 2021 10:23:57 -0400 (EDT)
Message-ID: <c239428496e79e503d51c77346ef648f86c32eb0.camel@talbothome.com>
Subject: [PATCH 8/9] Allow Maintainer mode to compile without -WError
From:   Chris Talbot <chris@talbothome.com>
To:     ofono@ofono.org, netdev@vger.kernel.org,
        debian-on-mobile-maintainers@alioth-lists.debian.net,
        librem-5-dev@lists.community.puri.sm
Date:   Sat, 10 Apr 2021 10:23:57 -0400
In-Reply-To: <9f9d0f40db75ff82a306af14e7879e567dce9821.camel@talbothome.com>
References: <051ae8ae27f5288d64ec6ef2bd9f77c06b829b52.camel@talbothome.com>
         <b23ba0656ea0d58fdbd8c83072e017f63629f934.camel@talbothome.com>
         <df512b811ee2df6b8f55dd2a9fb0178e6e5c490f.camel@talbothome.com>
         <178dd29027e6abb4a205e25c02f06769848cbb76.camel@talbothome.com>
         <eee886683aa0cbf57ec3f0c8637ba02bc01600d6.camel@talbothome.com>
         <9c67f5690bd4d5625b799f40e68fa54373617341.camel@talbothome.com>
         <85928d2def5893cd90f823b563369e313e993084.camel@talbothome.com>
         <9f9d0f40db75ff82a306af14e7879e567dce9821.camel@talbothome.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows mmsd to compile.

---
 acinclude.m4 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/acinclude.m4 b/acinclude.m4
index 329c6a9..314dbb1 100644
--- a/acinclude.m4
+++ b/acinclude.m4
@@ -15,7 +15,7 @@ AC_DEFUN([COMPILER_FLAGS], [
 		CFLAGS="-Wall -O2 -D_FORTIFY_SOURCE=2"
 	fi
 	if (test "$USE_MAINTAINER_MODE" = "yes"); then
-		CFLAGS+=" -Werror -Wextra"
+		CFLAGS+=" -Wextra"
 		CFLAGS+=" -Wno-unused-parameter"
 		CFLAGS+=" -Wno-missing-field-initializers"
 		CFLAGS+=" -Wdeclaration-after-statement"
-- 
2.30.2

