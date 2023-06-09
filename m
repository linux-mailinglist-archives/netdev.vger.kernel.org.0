Return-Path: <netdev+bounces-9730-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D526472A580
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 23:45:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 397501C211D9
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:45:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 447D624E90;
	Fri,  9 Jun 2023 21:43:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4BF408E0
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 21:43:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E538BC4339E;
	Fri,  9 Jun 2023 21:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686347036;
	bh=D2Rh2LghU+ZU6lOqZRm6H2hhxZai3Hx5dDGEx4DbVbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sYVatD47OhT+VUdpSXThQ91yobOE+nrgDMLMxPFizycgE0ZQsCKHpUmzqbCV5DIlh
	 APZDgZ9t8wgrDuZ5voDFMqdG446xARMq3TElaKJ+E05uoaTw5Lr2rGLnShW5hCKSSa
	 WfoK5pkmBkoyf4blRWiRqA1CtvdxfJ18xf9KsJd+AYUAaJ+Y+/ig7NhnVSWUneDAr9
	 s6YppOxz9buBU0FlSRWQrRWs30ISHHLyRgg0Vmf4NA2+F8rGp/NYwxansxt9VGA4Mz
	 szrriopwbRwEot+QLdukakQTk/4vL16Qq3uVPI3PhiIoiJaBBh3LNQL2S1WjNwOmw9
	 7FydmclWWRV0Q==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	sdf@google.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 04/12] netlink: specs: ethtool: add C render hints
Date: Fri,  9 Jun 2023 14:43:38 -0700
Message-Id: <20230609214346.1605106-5-kuba@kernel.org>
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

Most of the C enum names are guessed correctly, but there
is a handful of corner cases we need to name explicitly.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/netlink/specs/ethtool.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/netlink/specs/ethtool.yaml
index 4846345bade4..b0e4147d0890 100644
--- a/Documentation/netlink/specs/ethtool.yaml
+++ b/Documentation/netlink/specs/ethtool.yaml
@@ -9,6 +9,7 @@ doc: Partial family for Ethtool Netlink.
 definitions:
   -
     name: udp-tunnel-type
+    enum-name:
     type: enum
     entries: [ vxlan, geneve, vxlan-gpe ]
 
@@ -836,12 +837,15 @@ doc: Partial family for Ethtool Netlink.
       -
         name: admin-state
         type: u32
+        name-prefix: ethtool-a-podl-pse-
       -
         name: admin-control
         type: u32
+        name-prefix: ethtool-a-podl-pse-
       -
         name: pw-d-status
         type: u32
+        name-prefix: ethtool-a-podl-pse-
   -
     name: rss
     attributes:
@@ -895,6 +899,7 @@ doc: Partial family for Ethtool Netlink.
 
 operations:
   enum-model: directional
+  name-prefix: ethtool-msg-
   list:
     -
       name: strset-get
-- 
2.40.1


