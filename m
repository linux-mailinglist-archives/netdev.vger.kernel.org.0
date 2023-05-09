Return-Path: <netdev+bounces-1092-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A548D6FC260
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 11:08:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2CF41C20B0C
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:08:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D93E6883E;
	Tue,  9 May 2023 09:08:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE08520F7
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 09:08:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95EE2718
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 02:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683623294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oGPEmXtiWKYZ86rFBafONQEnyUSDRcjcPzcWfmgs0hA=;
	b=U9Hzx6Mw7NvzI0cbfKrjZ89okpMlt+q/IVgKHKDz7RyC8ttNp1YeKTe3dHDXzM3stTJcOy
	onXH+aeUnszXMxiJ4IKSqEQgg7sKyVmGpBWlFFCXUMwnEtA74zxO/3RvS67JxNNYsCiZHK
	ZDK3UwBGtVMvhfIJqAzGoWnnOed1TMU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-217-_C6qiKWxOsaDqh2s8YykwA-1; Tue, 09 May 2023 05:08:11 -0400
X-MC-Unique: _C6qiKWxOsaDqh2s8YykwA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 226451C08967;
	Tue,  9 May 2023 09:08:11 +0000 (UTC)
Received: from localhost.localdomain (vm-10-0-76-221.hosted.upshift.rdu2.redhat.com [10.0.76.221])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1CAC235453;
	Tue,  9 May 2023 09:08:11 +0000 (UTC)
From: Liang Li <liali@redhat.com>
To: netdev@vger.kernel.org
Cc: liali@redhat.com,
	j.vosburgh@gmail.com,
	razor@blackwall.org,
	Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next] selftests: bonding: delete unnecessary line
Date: Tue,  9 May 2023 09:09:19 +0000
Message-Id: <20230509090919.1100329-1-liali@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

"ip link set dev "$devbond1" nomaster"
This line code in bond-eth-type-change.sh is unnecessary.
Because $devbond1 was not added to any master device.

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


