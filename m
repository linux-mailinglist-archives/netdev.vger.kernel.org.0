Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81EE6195367
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 09:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgC0I44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 04:56:56 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58015 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726118AbgC0I4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 04:56:55 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 9845B5C03DF;
        Fri, 27 Mar 2020 04:56:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 27 Mar 2020 04:56:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=2z8lsBVknE8nlkuHGPmN0BydoAqloxqh77bOCqsLrkA=; b=tn7c37WV
        DkDJSDPW2jKIssZmmh2bl7wTia1jgBztWc0A/+xA/5womL2L1QYqM9kszSQyqPFk
        8EZMG1cepMls8LH7Yqbhd221J2XOfx8EJUkmVRqHOxHFWd1dN2xSe3tkE7+I0s4+
        sFFoxT7UXADHy3Cv8OQLPVNMTlH5C1IaRU784zaXPAWM1AY2z8gKLojPGG1eK9Xz
        mxYqLaft13fMJvcKLBgJ0RPzR+0uNoiSdxPkr2M92/0nC6UxB/RvMDGNQ2LM38zu
        kVfvECVKvG06en5OD7A6PVaQfLsO1g8N0p2VdPSVYyecsb6v/RL1j4b6lBpr0MQF
        mzR0dbS2773YXw==
X-ME-Sender: <xms:1r99XnlvfKcLchnX0z0CQG8OsTHU39ApcIMoXS-5GqOLxqFwDBmTVQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehkedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekuddrudefvddrudeludenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:1r99Xm93jNiwwn5QTPOgS5ulGSe22L9rD7nTXC1kWfsUXtDKCZBi3Q>
    <xmx:1r99Xm6wxYAGj7VDLUvv4rZodXnG_cqIce20M6-iRNehPr1XRhQ6Yg>
    <xmx:1r99XupX-s3R6JVL_TgGuhAXSw9M3jl7RDz9EU_kMm1GIlJLrD1pig>
    <xmx:1r99Xp_mj0zoicR_x0ZPC8jVpHRT4Z_CXDGsDU3XWlhfr8d0dCv37Q>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 590F3306C157;
        Fri, 27 Mar 2020 04:56:53 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, kuba@kernel.org,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/6] mlxsw: i2c: Add missing field documentation
Date:   Fri, 27 Mar 2020 11:55:20 +0300
Message-Id: <20200327085525.1906170-2-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200327085525.1906170-1-idosch@idosch.org>
References: <20200327085525.1906170-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Suppress following warning when compiling with W=1:

drivers/net/ethernet/mellanox/mlxsw//i2c.c:78: warning: Function
parameter or member 'cmd' not described in 'mlxsw_i2c'

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/i2c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/i2c.c b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
index 34566eb62c47..939b692ffc33 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/i2c.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
@@ -53,6 +53,7 @@
 
 /**
  * struct mlxsw_i2c - device private data:
+ * @cmd: command attributes;
  * @cmd.mb_size_in: input mailbox size;
  * @cmd.mb_off_in: input mailbox offset in register space;
  * @cmd.mb_size_out: output mailbox size;
-- 
2.24.1

