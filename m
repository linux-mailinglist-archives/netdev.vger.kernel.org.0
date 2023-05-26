Return-Path: <netdev+bounces-5786-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F534712BDC
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 19:37:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6291281973
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C52C28C39;
	Fri, 26 May 2023 17:37:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2721E536
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 17:37:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C719C
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685122646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VqgSbsHtOYwwoTPYz3XSCCmVUlsmFN+8XO+mxFJBZLg=;
	b=Yb+WYtUrSJPRYXBQ20ClwtElau/7TLzDJhcRBmwlN7B6CvKS0TsX3BZ79VuOZkkxznPQpn
	sxT0O0GgJ9vtKtDG5TGUmAUd6+gyrhFEpKxdTyYYUCx79YX0qh0tgLBf7yM7zABchRXYoP
	1KlxWvgT5e3K/rqhRhCldnAa8r5KjJg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-AKBq1mOLMRuUkDLQgEMSDQ-1; Fri, 26 May 2023 13:37:22 -0400
X-MC-Unique: AKBq1mOLMRuUkDLQgEMSDQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E6FFB280AA96;
	Fri, 26 May 2023 17:37:21 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.194.190])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9EA3D8162;
	Fri, 26 May 2023 17:37:20 +0000 (UTC)
From: Andrea Claudi <aclaudi@redhat.com>
To: netdev@vger.kernel.org
Cc: stephen@networkplumber.org,
	dsahern@gmail.com
Subject: [PATCH iproute2] ip: remove double space before 'allmulti' flag
Date: Fri, 26 May 2023 19:36:54 +0200
Message-Id: <6f33fb3b3479dc333c7dc3145d2e8bbc184b2c2a.1685122479.git.aclaudi@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Current output:
$ ip -d link show vxlan0
79: vxlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether b6:f6:12:c3:2d:52 brd ff:ff:ff:ff:ff:ff promiscuity 0  allmulti 0 minmtu 68 maxmtu 65535

Resulting output:
$ ip -d link show vxlan0
79: vxlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether b6:f6:12:c3:2d:52 brd ff:ff:ff:ff:ff:ff promiscuity 0 allmulti 0 minmtu 68 maxmtu 65535

Fixes: e98683accc28 ("link: display 'allmulti' counter")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 ip/ipaddress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 41055c43..c428dd3d 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -1207,7 +1207,7 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
 		if (tb[IFLA_ALLMULTI])
 			print_uint(PRINT_ANY,
 				   "allmulti",
-				   " allmulti %u ",
+				   "allmulti %u ",
 				   rta_getattr_u32(tb[IFLA_ALLMULTI]));
 
 		if (tb[IFLA_MIN_MTU])
-- 
2.40.1


