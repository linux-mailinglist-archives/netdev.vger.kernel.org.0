Return-Path: <netdev+bounces-1063-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 50ABE6FC0BA
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:49:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F1B6281238
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 07:49:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCC01171C6;
	Tue,  9 May 2023 07:49:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEBF28F6
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 07:49:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6950630D0
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 00:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683618570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=CqHSyvWTGvUCU7F6/o4dGaudW495LmCKIe2eYlUXjHc=;
	b=IPDVtpyhdb8hqlqzpJv5c5YBJKcWNdsVOuuxwfzvNSmdanLpSTpfAFlTD4l/1/IBhLTER6
	u1CqAOy7K/UmcvlAOgXWkmfpMfqpF8z5cZxf7iWd/sYYcjv35NFenWppqgtI+Wy+v5FsSd
	eZTqAgwdDOBMZqYONZ+xFdP24YI7kM0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-qFHaa8odOAC1e2r0b5loMQ-1; Tue, 09 May 2023 03:49:29 -0400
X-MC-Unique: qFHaa8odOAC1e2r0b5loMQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B06152932488;
	Tue,  9 May 2023 07:49:28 +0000 (UTC)
Received: from localhost.localdomain (vm-10-0-76-221.hosted.upshift.rdu2.redhat.com [10.0.76.221])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A40A4492C13;
	Tue,  9 May 2023 07:49:28 +0000 (UTC)
From: Liang Li <liali@redhat.com>
To: netdev@vger.kernel.org
Cc: liali@redhat.com,
	j.vosburgh@gmail.com,
	razor@blackwall.org,
	Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net] selftests: bonding: delete unnecessary line.
Date: Tue,  9 May 2023 07:50:25 +0000
Message-Id: <20230509075025.952650-1-liali@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

"ip link set dev "$devbond1" nomaster"
This line code in bond-eth-type-change.sh is unnecessary.
Because $devbond1 was not added to any master device.

Fixes: 222c94ec0ad4("selftests: bonding: add tests for ether type changes")
Signed-off-by: Liang Li <liali@redhat.com>
Acked-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .../selftests/drivers/net/bonding/bond-eth-type-change.sh        | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh b/tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh
index 5cdd22048ba7..862e947e17c7 100755
--- a/tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh
+++ b/tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh
@@ -53,7 +53,6 @@ bond_test_enslave_type_change()
 	# restore ARPHRD_ETHER type by enslaving such device
 	ip link set dev "$devbond2" master "$devbond0"
 	check_err $? "could not enslave $devbond2 to $devbond0"
-	ip link set dev "$devbond1" nomaster
 
 	bond_check_flags "$devbond0"
 
-- 
2.35.1


