Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72FA28F2CD
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 14:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbgJOM7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 08:59:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53120 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727833AbgJOM7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 08:59:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602766757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=a+qTdi9x7/b/800Jd5BX/VdnihmyDP17kbJ0Mp8/s7Q=;
        b=Kdg4JBwHH/0rgkxFXTBAV4+sQY4A8BmmtiAHtX3hfi1WEGbrSpqAAHc8YDhCtaiex8yfTq
        zzE6+nOW5T8AUlHMMgajsmS4s/Vn5+0jswhWUMzG0OM7UTT8fbJPx+bQRkJkWWxFEQ5IlO
        7RnahAxFae6/L+OM0PNjqTJhVFXqJ/k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-vCPb6S4aPmSpvDc3HhvJxQ-1; Thu, 15 Oct 2020 08:59:15 -0400
X-MC-Unique: vCPb6S4aPmSpvDc3HhvJxQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8320718BE174;
        Thu, 15 Oct 2020 12:59:13 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-70.rdu2.redhat.com [10.10.120.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B85D76EE4C;
        Thu, 15 Oct 2020 12:59:12 +0000 (UTC)
Subject: [PATCH net-next 0/2] rxrpc: Fixes
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 15 Oct 2020 13:59:11 +0100
Message-ID: <160276675194.955243.3551319337030732277.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Here are a couple of fixes that need to be applied on top of rxrpc patches
in net-next:

 (1) Fix a bug in the connection bundle changes in the net-next tree.

 (2) Fix the loss of final ACK on socket shutdown.

The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
	rxrpc-next-20201015

David
---
David Howells (2):
      rxrpc: Fix bundle counting for exclusive connections
      rxrpc: Fix loss of final ack on shutdown


 net/rxrpc/ar-internal.h | 1 +
 net/rxrpc/conn_client.c | 3 +++
 net/rxrpc/conn_event.c  | 6 +++---
 3 files changed, 7 insertions(+), 3 deletions(-)


