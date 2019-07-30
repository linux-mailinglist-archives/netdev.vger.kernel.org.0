Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 494E27AB6C
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 16:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730691AbfG3OuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 10:50:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48100 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728722AbfG3OuM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 10:50:12 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C911E3082E69;
        Tue, 30 Jul 2019 14:50:12 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 08D9B60BE5;
        Tue, 30 Jul 2019 14:50:11 +0000 (UTC)
Subject: [PATCH net 0/2] rxrpc: Fixes
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 30 Jul 2019 15:50:11 +0100
Message-ID: <156449821120.9558.2821927090314866621.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 30 Jul 2019 14:50:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Here are a couple of fixes for rxrpc:

 (1) Fix a potential deadlock in the peer keepalive dispatcher.

 (2) Fix a missing notification when a UDP sendmsg error occurs in rxrpc.


The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
	rxrpc-fixes-20190730

and can also be found on the following branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-fixes

David
---
David Howells (2):
      rxrpc: Fix potential deadlock
      rxrpc: Fix the lack of notification when sendmsg() fails on a DATA packet


 net/rxrpc/ar-internal.h |    1 +
 net/rxrpc/peer_event.c  |    2 +-
 net/rxrpc/peer_object.c |   18 ++++++++++++++++++
 net/rxrpc/sendmsg.c     |    1 +
 4 files changed, 21 insertions(+), 1 deletion(-)

