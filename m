Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4341E472D33
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 14:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233368AbhLMNZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 08:25:49 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:45527 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237462AbhLMNZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 08:25:49 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 3C3B85C0113;
        Mon, 13 Dec 2021 08:25:48 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 13 Dec 2021 08:25:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=DDnhlZ
        KC6XyDruk2BpxFq5djd7b5Vh6i4oMXct5kRM4=; b=TMurrTL1DLyxLuvVsGufSy
        Kcra7SrQ8M+q35aqv8X9yP6Cqcksqva1xOqfx0YucHjZ7yuQwz1jDzVJuACbN70j
        oFj9I+z+fZQMXAeRXIKhgfAyC8TlRgUbm+N6+FdsK/X5yCOzLCTcLiKJJp97g5Gt
        2Gg5Rwty8ho7cDLwW4lbXZPsYTAEnjp5jKv2FpQHxEXgpTQOfz18j4tFwfMQWzUt
        PEccfsGjFF/npR42Aln+xSrtZ9ydTkaVp0F8WtDzmfqBpJ4duEDXXw6f6q1AySUP
        8E77yrT9Dj+RBzbC2R0tvE0bp+jokrep/M1H8sotQp/boswt5EV0oU90HStPYYQQ
        ==
X-ME-Sender: <xms:20m3YQFbBT_5z1uARYIIG2veRq3NWdZBH_XxAA5bXbNJh3ZUA98_hA>
    <xme:20m3YZXB7K9B4HGtk1Qfz7foBnVfp1Em6OdJ5YPUiAE0xOyasVb5RqYeQstpRSqxw
    qh-4XLR85r4mfY>
X-ME-Received: <xmr:20m3YaKidkAQEAO_FQ51-Cgq5nzjTmS3N_3AEJjJ3tjiqLe2dQj48SKTWlvhyORRKkwmedjc8yL1fy19_m1BRsqQQqfSDQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrkeekgdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:20m3YSE33LaRSVPMuO2DH4qf8KmQyKucNT55UkbO_sAxeQspzQem2w>
    <xmx:20m3YWXj-mF9XF6S8R0B-3wEtqQMKaK1z7AAbKGxzkCP2LDjrFTkEw>
    <xmx:20m3YVMsItgb6PWF1yQRjlqbYS69f27Xj3f4e_R2ZQTAxPDok4m8OA>
    <xmx:3Em3YTgY98lN57uwbIQ8Fao9SbBL19aM4ERIng_D9igFEFUO7uF9VQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Dec 2021 08:25:47 -0500 (EST)
Date:   Mon, 13 Dec 2021 15:25:43 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Stephen Suryaputra <ssuryaextr@gmail.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] selftest/net/forwarding: declare NETIFS p9 p10
Message-ID: <YbdJ1wYOHl+gMQxI@shredder>
References: <20211213083600.2117824-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213083600.2117824-1-liuhangbin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 04:36:00PM +0800, Hangbin Liu wrote:
> The resent GRE selftests defined NUM_NETIFS=10. If the users copy

s/resent/recent/

> forwarding.config.sample to forwarding.config directly, they will get
> error "Command line is not complete" when run the GRE tests, because
> create_netif_veth() failed with no interface name defined.
> 
> Fix it by extending the NETIFS with p9 and p10.
> 
> Fixes: 2800f2485417 ("selftests: forwarding: Test multipath hashing on inner IP pkts for GRE tunnel")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
