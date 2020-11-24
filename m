Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C228A2C2E87
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 18:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390873AbgKXR2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 12:28:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53506 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728749AbgKXR2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 12:28:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606238922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RZw14nu0WeV+0cJEy4Uy5oc23Dz6DkXIjUHuB46N0lw=;
        b=e4+fTOGG5EIAFynu+kRSke9b8bX2Gl1t/VlEeeEX3v7F8WtNDNuZ1TFoLtrMMvp0wxSdkg
        nnTfyfvO5EtwK4KeHq7SQERl9as13zUUS+eRv4++C4FcBWvsAlLBD2ITGU5+uComcmuDVt
        dnvOQBcF4PCOpK5uf0AA0LEjGjZQnls=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55-ZtBdNc6ROYu6ZKfJtVALig-1; Tue, 24 Nov 2020 12:28:40 -0500
X-MC-Unique: ZtBdNc6ROYu6ZKfJtVALig-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 574AA1009464;
        Tue, 24 Nov 2020 17:28:38 +0000 (UTC)
Received: from f31.redhat.com (ovpn-113-8.rdu2.redhat.com [10.10.113.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8AD7C5C1A3;
        Tue, 24 Nov 2020 17:28:35 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net-next 0/3] tipc: some minor improvements
Date:   Tue, 24 Nov 2020 12:28:31 -0500
Message-Id: <20201124172834.317966-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

We add some improvements that will be useful in future commits.

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

