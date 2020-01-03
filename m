Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01CC012F84E
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 13:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727701AbgACMgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 07:36:35 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57052 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727507AbgACMge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 07:36:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578054993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=FbcakYlvuKH2ed4ezgN0n0PFByZuPuJdGmfWsNEEv4Y=;
        b=fatFUf5/UTBC2Oq56Fb+NpwKt36Jn1BA62InuEAUP8MIbSQSdVgK0AnyiYfbNm2tfzNrYm
        QYTpZXNEy6JhmKdO02zfnEEUFxl9/0rm/qIbsR2ZRIYaDDqdKlODVuswqKdWunM9/f6SJU
        PYYh03IHKual6ED2LLhGZl2DQ7xmUDA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-XXMB5Vd8NvuxpSsQVAv17w-1; Fri, 03 Jan 2020 07:36:29 -0500
X-MC-Unique: XXMB5Vd8NvuxpSsQVAv17w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8D1A800EB6;
        Fri,  3 Jan 2020 12:36:27 +0000 (UTC)
Received: from [192.168.122.1] (ovpn-200-18.brq.redhat.com [10.40.200.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8F16805F7;
        Fri,  3 Jan 2020 12:36:23 +0000 (UTC)
Subject: [net-next PATCH] doc/net: Update git https URLs in netdev-FAQ
 documentation
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        konstantin@linuxfoundation.org, jakub.kicinski@netronome.com
Date:   Fri, 03 Jan 2020 13:36:22 +0100
Message-ID: <157805498247.1556791.15507479174775505447.stgit@carbon>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DaveM's git tree have been moved into a named subdir 'netdev' to deal with
allowing Jakub Kicinski to help co-maintain the trees.

Link: https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 Documentation/networking/netdev-FAQ.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index 642fa963be3c..d5c9320901c3 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -34,8 +34,8 @@ the names, the ``net`` tree is for fixes to existing code already in the
 mainline tree from Linus, and ``net-next`` is where the new code goes
 for the future release.  You can find the trees here:
 
-- https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git
-- https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
+- https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
+- https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
 
 Q: How often do changes from these trees make it to the mainline Linus tree?
 ----------------------------------------------------------------------------


