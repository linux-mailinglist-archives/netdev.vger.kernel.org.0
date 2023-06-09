Return-Path: <netdev+bounces-9734-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ACCA72A589
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 23:46:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA2811C2118B
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:46:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6921D27724;
	Fri,  9 Jun 2023 21:44:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B46521069
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 21:43:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7E7C43444;
	Fri,  9 Jun 2023 21:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686347039;
	bh=PGCppX7/quWE0QFadzwFQ+sq4ycZ0RF4AMx/sejqdjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qsPiqNJdl9zFCGJ8EqmYeJDhCcDhpqUmg6YXprNAYzZn42PAdHZjL5oGoFO0lO0qO
	 aZ1wm6Fbu8kSptB1eF1oTVU51bDShvA0XUqVVjjl3tTVVmbNIk969lj5aZxUQSqMnp
	 sg6VAFXeqQS1WmMHbXJcwWnpb76SCLAruiURga2AI9w0n5yET4YPbD15biOQdliAIV
	 0AD4uevIspuE0d5onOlb+7R2OOwIbcLp4k1bw29XdtQ8oVLNG7VgR6SKQ2mEsDuyci
	 6Gv7szpTf2rvmnoE+7ORqtYZbDHw7csQP3I0hgl24u10sesv4nKvhEnK4maXb6cW6K
	 X+RXznSXQR5Vg==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	sdf@google.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 10/12] netlink: specs: ethtool: mark pads as pads
Date: Fri,  9 Jun 2023 14:43:44 -0700
Message-Id: <20230609214346.1605106-11-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230609214346.1605106-1-kuba@kernel.org>
References: <20230609214346.1605106-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pad is a separate type. Even though in practice they can
only be a u32 the value should be discarded.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/netlink/specs/ethtool.yaml | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/netlink/specs/ethtool.yaml
index 00c1ab04b857..837b565577ca 100644
--- a/Documentation/netlink/specs/ethtool.yaml
+++ b/Documentation/netlink/specs/ethtool.yaml
@@ -502,7 +502,7 @@ doc: Partial family for Ethtool Netlink.
     attributes:
       -
         name: pad
-        type: u32
+        type: pad
       -
         name: tx-frames
         type: u64
@@ -720,7 +720,7 @@ doc: Partial family for Ethtool Netlink.
     attributes:
       -
         name: pad
-        type: u8
+        type: pad
       -
         name: corrected
         type: binary
@@ -784,7 +784,7 @@ doc: Partial family for Ethtool Netlink.
     attributes:
       -
         name: pad
-        type: u32
+        type: pad
       -
         name: id
         type: u32
@@ -830,7 +830,7 @@ doc: Partial family for Ethtool Netlink.
     attributes:
       -
         name: pad
-        type: u32
+        type: pad
       -
         name: header
         type: nest
-- 
2.40.1


