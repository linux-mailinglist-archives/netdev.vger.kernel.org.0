Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD778205B8D
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 21:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387509AbgFWTOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 15:14:21 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54601 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387463AbgFWTOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 15:14:20 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id AC4CF5C0112;
        Tue, 23 Jun 2020 15:14:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 23 Jun 2020 15:14:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=uqxGz+3LHrmLv2uy+
        vIPLB8A4C4OOG36IqxSB72jZHU=; b=kNrm7oK2JdeRocabyf9F/gLopqC3JaWAt
        v9bYxMTMnYyu2nWY08D398gCsz+NS7Ak8hwrnBVowLJFrKbR8BcGx9sZ0bSLShh5
        I5kupQch3tSdjoRaZ2M1Y0NFlQMYoiNGh6TivOGWaHhgw9rQQ8uvN9Wp/8p4RYU+
        xPkQvWdeGc9ZIZxMeiNNDqCgA2HMYPxxPXvaJQ1xvXgdhspzVdlN8uWzy2MvpIq4
        wo3TeHirM+0sPoQf2T//4o8F9StBfDIDgjQzYHCuLkBqDdukKc5LkKTdik83akas
        iuEZm0xeAG7DDzB9CEkn00ydgdeFvXqzJFCho0aTT8MFCjBYvlt4Q==
X-ME-Sender: <xms:ilTyXqq9yiRltuzHZ8ALeA2aojsU6HQmN8INdWLhP2nOEGC4DFyxAA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekhedguddtjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuhe
    ehteffieekgeehveefvdegledvffduhfenucfkphepjeelrddukeefrdeihedrkeejnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ilTyXoqZZ13RFtRy-t_Ue5BpHmQWc3J2ntiOyglb9rBLSms-Ckf8Bg>
    <xmx:ilTyXvOzpgcvT7dhR6DAZAW9jU_88UtIuKOVWKablvT6CTdH8BDR5g>
    <xmx:ilTyXp5cjuqZcMl6V9yid4Jn20R_aXJeB-2Q8qNVBRNAGiDTAli_sA>
    <xmx:ilTyXpFK4LHRWiC8dFS4BjYlws32m34_fUSeyui7DLBeqdhDdLQF8g>
Received: from shredder.mtl.com (bzq-79-183-65-87.red.bezeqint.net [79.183.65.87])
        by mail.messagingengine.com (Postfix) with ESMTPA id BCBE33280064;
        Tue, 23 Jun 2020 15:14:16 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@mellanox.com,
        jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/2] mlxsw: Bump firmware version to XX.2007.1168
Date:   Tue, 23 Jun 2020 22:13:44 +0300
Message-Id: <20200623191346.75121-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Petr says:

In patch #1, bump the firmware version required by the driver to
XX.2007.1168. This version fixes several issues observed in the
offloaded datapath.

In patch #2, add support for requiring FW version on Spectrum-3 (so far
only Spectrum-1 and Spectrum-2 have had this requirement). Demand the
same version as mentioned above.

Petr Machata (2):
  mlxsw: Bump firmware version to XX.2007.1168
  mlxsw: Enforce firmware version for Spectrum-3

 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 26 ++++++++++++++++---
 1 file changed, 22 insertions(+), 4 deletions(-)

-- 
2.26.2

