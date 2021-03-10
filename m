Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A42333AF9
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 12:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbhCJLD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 06:03:56 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55109 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232695AbhCJLDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 06:03:34 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 173645C0052;
        Wed, 10 Mar 2021 06:03:34 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 10 Mar 2021 06:03:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=Pj68eSByXHQd9Ovg/4uffIraXtI2XVcEvQRUzM2VBHs=; b=mHwozdiN
        hZBi0UkLVrjWRAfapRpzgrljCbr25zpGMuYF4Ce9TUkSgajzdhU6tyVBqwSOUikU
        8QJsvKrYI4Z1xwWxBfgBfurls02AxDgzA05H/HS4v97mYVtuWLtyNWiPFTrYy41w
        eCyOTsKbjZwW79DNTboke1vftfXfiWcmPs6bf8c6vXiYDyKzhqRDrAoTsDbqFEDf
        sxPxpX8bT7tC24Li3nM+9AB42oBzZFbf2opbH9poaGxSRKf0lZRBtWjNbnAf8Cky
        5yZJp0OCmhcr8D14MSJ55jm+xFauwdRjl1AJrCkHeZDXmyjWmfuQkKOSivh9o9yd
        8vnfo6Ofr7woxQ==
X-ME-Sender: <xms:hadIYGlLOPcFY4bJK_L9qDfmBenKxG1qOqW0RfWafFUxRmsU6W_dFw>
    <xme:hadIYN2NerFPIJ_tgZfZk631v8szY0zA5_le-8Hhl5eQYMO10BseyuyEAne4WijZQ
    aZzvnoz3-heZDo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddukedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:hqdIYEpNvxEz4YVM-KPVv6MS_sX6MUmDqcegyMM2PsiuRNph24qShQ>
    <xmx:hqdIYKnQ_x4BPBckBSZU0sjZmTtLuba6VtG1EVBZZ69LLwcV8brfUA>
    <xmx:hqdIYE1ycy5fa5F84aKdU5JYbcJ0kej_JRqOSXgQaGJmy9ac9iQ4yw>
    <xmx:hqdIYI-xD1-P8xMnIF51zqYFvG1iI8m1LNBgKQi9VMOsG62zMmcMUw>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 94B661080059;
        Wed, 10 Mar 2021 06:03:31 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        danieller@nvidia.com, amcohen@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/6] mlxsw: spectrum: Reword an error message for Q-in-Q veto
Date:   Wed, 10 Mar 2021 13:02:15 +0200
Message-Id: <20210310110220.2534350-2-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310110220.2534350-1-idosch@idosch.org>
References: <20210310110220.2534350-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

'Uppers' is not clear enough for all users when referring to upper
devices.

Reword the error message so it will be clearer.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 1650d9852b5b..5d2b965f934f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4283,7 +4283,7 @@ static int mlxsw_sp_netdevice_bridge_event(struct net_device *br_dev,
 		if (br_vlan_enabled(br_dev)) {
 			br_vlan_get_proto(br_dev, &proto);
 			if (proto == ETH_P_8021AD) {
-				NL_SET_ERR_MSG_MOD(extack, "Uppers are not supported on top of an 802.1ad bridge");
+				NL_SET_ERR_MSG_MOD(extack, "Upper devices are not supported on top of an 802.1ad bridge");
 				return -EOPNOTSUPP;
 			}
 		}
-- 
2.29.2

