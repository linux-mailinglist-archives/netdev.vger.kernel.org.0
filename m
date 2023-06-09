Return-Path: <netdev+bounces-9735-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B306572A58A
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 23:47:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E9031C211A6
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:47:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3989128C2E;
	Fri,  9 Jun 2023 21:44:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D9C23C85
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 21:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D28C433AF;
	Fri,  9 Jun 2023 21:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686347037;
	bh=D2v7ZevgFTtAnmYPznCtz+Bt3TSOit30Sfne3woMrAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZ8WZ3Xv3SZXMUXUHOUQbt0r4FKb4prjKwWPBiP8TnJV5W6Kq72BkbnyRTDVR16g/
	 VFZpea6N+yanQq4XZZgGc5bfaq+VGhBkp6vTdm3IUM4JLUx0Cb/xAN1qGnzmvPEkkT
	 g6pZXyfN7DrJmuGZTsPHygdVlomJFeEiBVTdFQ/WzN1ys0S3kLKKrCK/XU6lObKPK8
	 r0WGpbfmL69vcCc+UhS3uIJtI3ngl+/NdPD1LcyPFF9mLmHsQuzmRUt94FfN1+lHYL
	 qol2co6syLeAGFVZB30vr/RLsFFk3jhBc3X18Hwo2/MeJahpm08NL2F3bAF+XznMIO
	 6LY7jYq0AzHgg==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	sdf@google.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 07/12] netlink: specs: ethtool: add empty enum stringset
Date: Fri,  9 Jun 2023 14:43:41 -0700
Message-Id: <20230609214346.1605106-8-kuba@kernel.org>
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

C does not allow defining structures and enums with the same name.
Since enum ethtool_stringset exists in the uAPI we need to include
at least a stub of it in the spec. This will trigger name collision
avoidance in the code gen.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/netlink/specs/ethtool.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/netlink/specs/ethtool.yaml
index b0e4147d0890..d674731629c4 100644
--- a/Documentation/netlink/specs/ethtool.yaml
+++ b/Documentation/netlink/specs/ethtool.yaml
@@ -12,6 +12,10 @@ doc: Partial family for Ethtool Netlink.
     enum-name:
     type: enum
     entries: [ vxlan, geneve, vxlan-gpe ]
+  -
+    name: stringset
+    type: enum
+    entries: []
 
 attribute-sets:
   -
-- 
2.40.1


