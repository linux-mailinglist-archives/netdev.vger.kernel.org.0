Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E78A2D7E1B
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 19:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394493AbgLKS3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 13:29:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56882 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732642AbgLKS3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 13:29:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607711258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YHwpNELzrO/M/WjgceOcG21YjX2EGE0Jz9i008ROq44=;
        b=R+7pqOv2ysiRRT8EkcG2VoduH7NJ3QKCA0bTJnBXkFPSxc3kbEaHeAHyFofHgkwLJqMy1w
        rVT4+IZ7w9qp++OOWaEQAbMiJy+TfbAr+J8eXigGjnIUm2V+FPGAwcWT7OdcK9+7gz+Bvy
        dhux0GkQ6E/SaM5SBOjvQwjQt77CCx8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-TMRbt82vMciEcvlG6Ty6vA-1; Fri, 11 Dec 2020 13:27:35 -0500
X-MC-Unique: TMRbt82vMciEcvlG6Ty6vA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5466D10691A7;
        Fri, 11 Dec 2020 18:26:54 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-114-11.ams2.redhat.com [10.36.114.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 68C7F5D9D2;
        Fri, 11 Dec 2020 18:26:53 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] man: tc-flower: fix manpage
Date:   Fri, 11 Dec 2020 19:26:40 +0100
Message-Id: <d77ddf8ca39adedf9eaee95b681e1a17ddf9ea62.1607711027.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 924c43778a84 ("man: tc-ct.8: Add manual page for ct tc action")
add man page for tc-ct, but it brings with it a bogus block of text
in the benning of tc-flower man page.

This commit simply removes it.

Fixes: 924c43778a84 ("man: tc-ct.8: Add manual page for ct tc action")
Reported-by: Paolo Valerio <pvalerio@redhat.com>
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 man/man8/tc-flower.8 | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/man/man8/tc-flower.8 b/man/man8/tc-flower.8
index da3dd757..1a76b375 100644
--- a/man/man8/tc-flower.8
+++ b/man/man8/tc-flower.8
@@ -1,11 +1,5 @@
 .TH "Flower filter in tc" 8 "22 Oct 2015" "iproute2" "Linux"
 
-	"Usage: ct clear\n"
-		"	ct commit [force] [zone ZONE] [mark MASKED_MARK] [label MASKED_LABEL] [nat NAT_SPEC] [OFFLOAD_POLICY]\n"
-		"	ct [nat] [zone ZONE] [OFFLOAD_POLICY]\n"
-		"Where: ZONE is the conntrack zone table number\n"
-		"	NAT_SPEC is {src|dst} addr addr1[-addr2] [port port1[-port2]]\n"
-		"	OFFLOAD_POLICY is [policy_pkts PACKETS] [policy_timeout TIMEOUT]\n"
 .SH NAME
 flower \- flow based traffic control filter
 .SH SYNOPSIS
-- 
2.29.2

