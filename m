Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02A065BD8F
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 16:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729263AbfGAOEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 10:04:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52514 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727031AbfGAOEQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 10:04:16 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7C50F307CDF0;
        Mon,  1 Jul 2019 14:04:11 +0000 (UTC)
Received: from renaissance-vector.mxp.redhat.com (unknown [10.32.181.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 997B719C6F;
        Mon,  1 Jul 2019 14:04:08 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
Subject: [PATCH iproute2] man: tc-netem.8: fix URL for netem page
Date:   Mon,  1 Jul 2019 16:04:41 +0200
Message-Id: <39256a189709ec195fd97da736ee5b003a49f298.1561989640.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Mon, 01 Jul 2019 14:04:16 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

URL for netem page on sources section points to a no more existent
resource. Fix this using the correct URL.

Fixes: cd72dcf13c8a4 ("netem: add man-page")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 man/man8/tc-netem.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/tc-netem.8 b/man/man8/tc-netem.8
index 111109cf042f0..5a08a406a4a7b 100644
--- a/man/man8/tc-netem.8
+++ b/man/man8/tc-netem.8
@@ -219,7 +219,7 @@ April 2005
 (http://devresources.linux-foundation.org/shemminger/netem/LCA2005_paper.pdf)
 
 .IP " 2. " 4
-Netem page from Linux foundation, (http://www.linuxfoundation.org/en/Net:Netem)
+Netem page from Linux foundation, (https://wiki.linuxfoundation.org/networking/netem)
 
 .IP " 3. " 4
 Salsano S., Ludovici F., Ordine A., "Definition of a general and intuitive loss
-- 
2.20.1

