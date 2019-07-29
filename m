Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD9E7867C
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 09:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfG2Hml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 03:42:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726940AbfG2Hml (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 03:42:41 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E215220657;
        Mon, 29 Jul 2019 07:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564386160;
        bh=bFVKJRc1vUqLUbnCvD0XD/0GgG2PdYURd7s3ZPqycAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ANKYS3YMg7kSouYcm7/GDhptFTSjxKj9H9FbnFCI8cQXwJqD/wMYmuOJRZwvojJ4v
         MVnosMF8dHNRwTXmSb0IdAc1Uk5ohxfO7uVAG3EQb40mZMSLHu+H41zw52Ljr5tEr6
         fYgMxqzPa4Yxz13gEbyxSb8q52ryFrAigyc4X7v8=
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yamin Friedman <yaminf@mellanox.com>
Subject: [PATCH iproute2-rc 2/2] rdma: Document adaptive-moderation
Date:   Mon, 29 Jul 2019 10:42:26 +0300
Message-Id: <20190729074226.4335-3-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190729074226.4335-1-leon@kernel.org>
References: <20190729074226.4335-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yamin Friedman <yaminf@mellanox.com>

Add document of setting the adaptive-moderation for the ib device.

Signed-off-by: Yamin Friedman <yaminf@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 man/man8/rdma-dev.8 | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/man/man8/rdma-dev.8 b/man/man8/rdma-dev.8
index e77e7cd0..368cdc7c 100644
--- a/man/man8/rdma-dev.8
+++ b/man/man8/rdma-dev.8
@@ -34,11 +34,17 @@ rdma-dev \- RDMA device configuration
 .BR netns
 .BR NSNAME
 
+.ti -8
+.B rdma dev set
+.RI "[ " DEV " ]"
+.BR adaptive-moderation
+.BR [on/off]
+
 .ti -8
 .B rdma dev help
 
 .SH "DESCRIPTION"
-.SS rdma dev set - rename RDMA device or set network namespace
+.SS rdma dev set - rename RDMA device or set network namespace or set RDMA device adaptive-moderation
 
 .SS rdma dev show - display RDMA device attributes
 
@@ -70,6 +76,14 @@ Changes the network namespace of RDMA device to foo where foo is
 previously created using iproute2 ip command.
 .RE
 .PP
+rdma dev set mlx5_3 adaptive-moderation [on/off]
+.RS 4
+Sets the state of adaptive interrupt moderation for the RDMA device.
+.RE
+.RS 4
+This is a global setting for the RDMA device but the value is printed for each CQ individually because the state is constant from CQ allocation.
+.RE
+.PP
 
 .SH SEE ALSO
 .BR ip (8),
-- 
2.20.1

