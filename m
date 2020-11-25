Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01552C479E
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 19:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732997AbgKYS30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 13:29:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44109 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730551AbgKYS30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 13:29:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606328965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=yi9LWYaGz42lWjfBwhJ8ZjEtbKyFU7vdm6djz1PETH4=;
        b=VnCP99Hy4DS6nUE/RUZ8h+So5HUsLxeKG3e3RbmuEh4hquN0INB5aOx3bJWfFpQ0Xqfubf
        oCvsUOn+h3htIr5Uc750tRpfQ+3fM7z5SBrbad1zEFaA5QB+j4uK6cLKvPqGGL7AWLzsCD
        voAHnsaOt4Fx0WG6FtH9Zaf10Dq6gdY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-xrH2nzUjO6aQlqAMKFqF_A-1; Wed, 25 Nov 2020 13:29:21 -0500
X-MC-Unique: xrH2nzUjO6aQlqAMKFqF_A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8102284639C;
        Wed, 25 Nov 2020 18:29:19 +0000 (UTC)
Received: from f31.redhat.com (ovpn-113-167.rdu2.redhat.com [10.10.113.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B22119C46;
        Wed, 25 Nov 2020 18:29:16 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net-next v2 0/3] tipc: some minor improvements
Date:   Wed, 25 Nov 2020 13:29:12 -0500
Message-Id: <20201125182915.711370-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

We add some improvements that will be useful in future commits.

---
v2: fixed sparse warning in patch #2

Jon Maloy (3):
  tipc: refactor tipc_sk_bind() function
  tipc: make node number calculation reproducible
  tipc: update address terminology in code

 net/tipc/addr.c       |   7 ++-
 net/tipc/addr.h       |   1 +
 net/tipc/core.h       |  12 +++++
 net/tipc/group.c      |   3 +-
 net/tipc/group.h      |   3 +-
 net/tipc/name_table.c |  11 +++--
 net/tipc/net.c        |   2 +-
 net/tipc/socket.c     | 110 ++++++++++++++++++++----------------------
 net/tipc/subscr.c     |   5 +-
 net/tipc/subscr.h     |   5 +-
 net/tipc/topsrv.c     |   4 +-
 11 files changed, 87 insertions(+), 76 deletions(-)

-- 
2.25.4

