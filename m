Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD6F459D35
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 08:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbhKWH6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 02:58:15 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:48985 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234274AbhKWH6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 02:58:13 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 061485C026F;
        Tue, 23 Nov 2021 02:55:06 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 23 Nov 2021 02:55:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=gk5v/nVRKWhkRhH5D
        ayxznddQ+GdKdiRRpFlhBih6yQ=; b=QZEDkiuDZTKZV05HLmwppiFF88TNaXVab
        bTZrnM3SA7amlxtUAakCkjhip7E26xFS8isryHOHMfnGip5WgfEU0r0d1kchmqW1
        q7m2LgX7h9+j7Ifl/5J9r534i98b+dvVFVcAPRFuU3ajl2jQD1S9jTJpS9LtZqfr
        t3qLZ6lNO926uu6Rv0hU73bAncpYG3ON/VtXVYibesxjpKPoKl2ZPC1fHTY15ui1
        mNWr98sKosknKq8fF9M4Zm5fhMZ5bZfErQULdzwnrYbiXOEJ9FQ/3UPlzwsehsDn
        6Cox7NYwCjliixf+1np32T2tlceHzoF1SU1XajEfwMGMefIP4dsyQ==
X-ME-Sender: <xms:WZ6cYS9X5C_gLUkzVWvKSSSc8NJgMa8V-kQSc92JxGEaGM9joM3GaQ>
    <xme:WZ6cYSt11_MnZuIDezp1ftB8JQZ23AfNNAGU8N2lPP_Pkp3B9v0uMO1C4mwbDikPe
    UEU98Y4g0-l5oE>
X-ME-Received: <xmr:WZ6cYYDdBaudul-WISI80K6nkmnl4Hs3XfUGofiBauCmLjNEbYU1E_0v-JkN4qgRidK5KhikN9K40noo4UydvepWngBKJQ0LNFaUmeaDhY7mYw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeehgddutdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecuvehluhhsthgvrhfuihiivgepudenucfrrghr
    rghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:WZ6cYae7Y42rAb0pN3R4UbW6eS4IcQbq-_d4em3-Gq7QcdsBNQidDQ>
    <xmx:WZ6cYXO0RtqkT-lFjlugpCY1eklTfd7JzMvM6Wc86fFr_Lusl8RKPQ>
    <xmx:WZ6cYUnDJAvMNP2tNMKjxCqRnoHwB5HUiug7ltLNE68Kvk7bDswTjw>
    <xmx:Wp6cYQrpPLuBBEAb3VgzmQ-aVLxviSogFFmf6Z-aTayvrTbAa2Yq7Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Nov 2021 02:55:04 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/2] mlxsw: Various updates
Date:   Tue, 23 Nov 2021 09:54:45 +0200
Message-Id: <20211123075447.3083579-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Patch #1 removes deadcode reported by Coverity.

Patch #2 adds a shutdown method in the PCI driver to ensure the kexeced
kernel starts working with a device that is in a sane state.

Danielle Ratson (2):
  mlxsw: spectrum_router: Remove deadcode in
    mlxsw_sp_rif_mac_profile_find
  mlxsw: pci: Add shutdown method in PCI driver

 drivers/net/ethernet/mellanox/mlxsw/pci.c             | 1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 3 ---
 2 files changed, 1 insertion(+), 3 deletions(-)

-- 
2.31.1

