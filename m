Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F371CC463
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 22:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgEIUGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 16:06:52 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55043 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728693AbgEIUGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 16:06:48 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 078B85C00CE;
        Sat,  9 May 2020 16:06:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 09 May 2020 16:06:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=guCqX6SQpAvpHmyQACEi8LSi3lZP2Uk+cZAeVRSY3S0=; b=4kGxb13P
        vvD0oPCnTnpVSOP738JIDF/GfmMyMAqRGH/LHSL+g6IPZ13LuLCq/Uee4q+4Zeit
        JM60ebRQuZSiQa3o5lvco3RDz+p6zsACRFW1Jo4sYXOFtUIhmaTmE93B5BB5Z/f5
        ANhGTQEuOdTXgHP4M5DASMvrejkv8RFEFoVxzqMdhejZwiDRrWz1Jab6NkKi3Pkm
        iN1SSHcb3Rwpeb45TumCKEtN7H79aIIel+cZjkSjwptVc1Jnonbnbm5t1UnYq4m+
        KSpmd9EF1a1EwaPImdhjtV22hKLX0fcUBZ7Z24tyXuOW60C0pOAI/xyzvt/cyej0
        nb2EWm0J0fX04Q==
X-ME-Sender: <xms:Vg23XmXJemIcUGt449BlTvTecob1c5rfCGm7dLZDIJuZXRA8lbSjIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrkeehgddugeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Vg23XhR7hJhH3aMGh2XwK4p-hYgdp4HPt1fhSEAtEiGXxyz7KZYWew>
    <xmx:Vg23XtV0chTAlouAjv1sYOe_tWFOyb6-WsLiqhq3WgoG1RIoeEvwrw>
    <xmx:Vg23Xt_jbT4-3nf75bvvEv_kdR7EJ-Tig7j5yvewUslo1JQnQO0S6A>
    <xmx:Vw23XiDwHDMIbyQ5gJPF6oazdG39xtr95-p-9TnmI6MJmfnwMKHyHw>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B319E306612B;
        Sat,  9 May 2020 16:06:45 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 7/9] selftests: mlxsw: rename tc_flower_restrictions.sh to tc_restrictions.sh
Date:   Sat,  9 May 2020 23:06:08 +0300
Message-Id: <20200509200610.375719-8-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200509200610.375719-1-idosch@idosch.org>
References: <20200509200610.375719-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

The file is about to contain matchall restrictions too, so change the
name to make it more generic.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/mlxsw/{tc_flower_restrictions.sh => tc_restrictions.sh}   | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename tools/testing/selftests/drivers/net/mlxsw/{tc_flower_restrictions.sh => tc_restrictions.sh} (100%)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/tc_flower_restrictions.sh b/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
similarity index 100%
rename from tools/testing/selftests/drivers/net/mlxsw/tc_flower_restrictions.sh
rename to tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
-- 
2.26.2

