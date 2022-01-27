Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F7549EA51
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 19:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238965AbiA0SZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 13:25:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237514AbiA0SZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 13:25:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8DCC061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 10:25:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 17C73CE2332
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 18:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB78C340E4;
        Thu, 27 Jan 2022 18:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643307904;
        bh=PkYet2dy2vfHlb94bC3Bsv1ISvhud39tHzNF0XGYkfY=;
        h=From:To:Cc:Subject:Date:From;
        b=GtD5oLUAvUmApjPtjhMCbCym8O3cq480tclM0LWC+7S1i5koRhn7S3VnG+kOwzxUl
         j3BaueH3Azvh8rBC0C2kodwUwy/0JDGpzGx6FGWODPTyANNPkB5VWyRwgbIDrYWK6O
         8gli2HO+ayvenvBBKn4TlVmtT3DZKE8XN0cgOU3rvCrn1tVB570bUaqbiBuEYeLJ++
         1+KdaBuIXoEioxhl0geFKWCJ0dtb4kSgXAjV0bJoYiAlH8Jt833auJsJERzvWoEVIq
         BbqrIBmjXGC5gPeis+pTN7Q1/ypYqXXDsK7P1A2yN4/oYd20rcj0ayv7+ZkkHXfDDY
         d9eqLlLnRkTJg==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org
Subject: [PATCH ipsec-next] xfrm: delete not-used XFRM_OFFLOAD_IPV6 define
Date:   Thu, 27 Jan 2022 20:24:58 +0200
Message-Id: <31811e3cf276ae2af01574f4fbcb127b88d9c6b5.1643307803.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

XFRM_OFFLOAD_IPV6 define was exposed in the commit mentioned in the
fixes line, but it is never been used both in the kernel and in the
user space. So delete it.

Fixes: d77e38e612a0 ("xfrm: Add an IPsec hardware offloading API")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/uapi/linux/xfrm.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
index 4e29d7851890..2c822671cc32 100644
--- a/include/uapi/linux/xfrm.h
+++ b/include/uapi/linux/xfrm.h
@@ -511,7 +511,6 @@ struct xfrm_user_offload {
 	int				ifindex;
 	__u8				flags;
 };
-#define XFRM_OFFLOAD_IPV6	1
 #define XFRM_OFFLOAD_INBOUND	2
 
 struct xfrm_userpolicy_default {
-- 
2.34.1

