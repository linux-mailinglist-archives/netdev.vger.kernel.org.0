Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CFC47CB9A
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 04:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242097AbhLVDQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 22:16:20 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44982 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242092AbhLVDQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 22:16:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AEAD61865
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 03:16:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE9AC36AEA;
        Wed, 22 Dec 2021 03:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640142973;
        bh=9UmvcQCZVmCLwR2OSs599vP4WHAcLUqhxVOO1xLknAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t1g7zba/y/zslXW0FHROH3Hewjvx+vnBCaVAKdo3CFt4UmxO0+ZY6E0QXLMywWlUx
         8fdQxA94zBupOqomIBD/0h/nsYYwjoJdgtA05Mr4vAK060esmC7k1b/OZtB3kSJ6wN
         2jcuBy3U3Hhj0YNS6oZ0iyjPsnNShSpJKjNmyWYYi7XaSSWja1gCNDU6B5uRiFsmar
         MHdneSRsRySYPjnf6o8esrLC0GMUSn16yMv9dUZHkGYD1jfBWbX5Ldje4yahPeFPbJ
         kn21yt+RpSurK0iDTFvVd6SXPJZ1oQCbkPNMdYtHDCKpXUKZjo2Mn7faOFkMRnVKCB
         7guiwZ+Akmpdg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 05/14] devlink: Clarifies max_macs generic devlink param
Date:   Tue, 21 Dec 2021 19:15:55 -0800
Message-Id: <20211222031604.14540-6-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211222031604.14540-1-saeed@kernel.org>
References: <20211222031604.14540-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

The generic param max_macs documentation isn't clear.
Replace it with a more descriptive documentation

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 Documentation/networking/devlink/devlink-params.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index da0b5e7f8eec..4e01dc32bc08 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -118,8 +118,10 @@ own name.
        errors.
    * - ``max_macs``
      - u32
-     - Specifies the maximum number of MAC addresses per ethernet port of
-       this device.
+     - Typically macvlan, vlan net devices mac are also programmed in their
+       parent netdevice's Function rx filter. This parameter limit the
+       maximum number of unicast mac address filters to receive traffic from
+       per ethernet port of this device.
    * - ``region_snapshot_enable``
      - Boolean
      - Enable capture of ``devlink-region`` snapshots.
-- 
2.33.1

