Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 870FB18369F
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 17:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgCLQxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 12:53:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33590 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726328AbgCLQxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 12:53:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584031981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SgzrkBKYKxEI91Bv031YqfH0jrAaW8qrFcv77hDNeXI=;
        b=fBGkE03x1tXgpnFPAWbUKK5T0bfEm7nhU9zn5s7RHj8TlMoH75xfXEFneQZQ9cHZXqjKBw
        0vQXUCBcUBZHuBl38xooB6x3mTFfEk3gBaJuhW535cMAmQMSnffUNW/FdG+LKqc5uJBI0N
        X1hZ2CZSfn8pO18K3AtnVxPnG0XkAqk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-HJ85zVnNPLKI_zILyVShbA-1; Thu, 12 Mar 2020 12:52:59 -0400
X-MC-Unique: HJ85zVnNPLKI_zILyVShbA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9069113F7;
        Thu, 12 Mar 2020 16:52:58 +0000 (UTC)
Received: from new-host-5.redhat.com (ovpn-206-30.brq.redhat.com [10.40.206.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3C4619C6A;
        Thu, 12 Mar 2020 16:52:56 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Roman Mashak <mrv@mojatatu.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@mellanox.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net] tc-testing: add ETS scheduler to tdc build configuration
Date:   Thu, 12 Mar 2020 17:51:45 +0100
Message-Id: <dcff461f45a5dc4a403dcbe020caeee607e7c5dc.1584031891.git.dcaratti@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add CONFIG_NET_SCH_ETS to 'config', otherwise test suites using this file
to perform a full tdc run will encounter the following warning:

  ok 645 e90e - Add ETS qdisc using bands # skipped - "-----> teardown st=
age" did not complete successfully

Fixes: 82c664b69c8b ("selftests: qdiscs: Add test coverage for ETS Qdisc"=
)
Reported-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 tools/testing/selftests/tc-testing/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/tc-testing/config b/tools/testing/se=
lftests/tc-testing/config
index 477bc61b374a..c03af4600281 100644
--- a/tools/testing/selftests/tc-testing/config
+++ b/tools/testing/selftests/tc-testing/config
@@ -57,3 +57,4 @@ CONFIG_NET_IFE_SKBMARK=3Dm
 CONFIG_NET_IFE_SKBPRIO=3Dm
 CONFIG_NET_IFE_SKBTCINDEX=3Dm
 CONFIG_NET_SCH_FIFO=3Dy
+CONFIG_NET_SCH_ETS=3Dm
--=20
2.24.1

