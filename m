Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4BA438F89
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 08:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhJYGdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 02:33:32 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:48869 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230369AbhJYGdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 02:33:31 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 4419B5C0178;
        Mon, 25 Oct 2021 02:31:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 25 Oct 2021 02:31:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=XH3xdt
        bLhapmmW0JYmN5pD0fjj0gtqEc7lDkeWFuh3o=; b=Yu51eIJfHMCYnk01d/iAoa
        724YShrQPbLtKdi0ukgyahPHDyYPYDQbjQ3r0wG9B90G/xYbi9KPIJ9i5Nf1ibWa
        TfwCz4el+keN0w/cBANLpr2mUgW9lGEIdUVy7n0vGJAyo7U6FGRoNRXYL3hEa14D
        h/T8JzCoi/9QsR5PL+j/gM9m64r4EhepbBQN6t/YZ3e6bA4iJAMg548HX98exKQU
        fc6yiuhKxOh+gmzuhR2/VKplv9nPzDe/jx2c0qAUme4UsWtdXQXVOkOC62gpRFjB
        3VbacqHY5xLUWqm7dns1kFpGbyzMV4w7ZMDbtCms8Q2OoaiU46pqbeDPbJ87wCoQ
        ==
X-ME-Sender: <xms:LE92YVQSafIH0CLsUelwfQoMv5h9cA3haHYo26u-1cMOhgL1Bcd4EQ>
    <xme:LE92YexhmqJA_pNtmW4xMKR94ohD_aGolrCwLYtNaeD6X309abkEM0TYJgMRAEgtE
    jt5VP8uFHsxTmk>
X-ME-Received: <xmr:LE92Ya0RptTljgks0vgfx7dL3j2msyXHjZZKoppEr0xV53VYC-LJjJhc86_ZV0wAQhK_5x9v1qnmdW_UEqyBNevXI_o>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefgedguddtiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:LE92YdBg9lQMX4kBB7KhwGQqilSHN2S6yUPXrrgou2F2Snp-MzZmdQ>
    <xmx:LE92Yejc5WMoWthGNo6pbQ8mLbY9u7kzDdmWhAG3-9Adjs451nF_iw>
    <xmx:LE92YRobHmQhzKGgCPDiaPq_xpgA4xSoOxXke1-6ddgFlnFti63BnQ>
    <xmx:LU92YQb56BhiT645waIomlLOgFXtQUWOA88EJBnQAK38gVPEvoJ2IA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 Oct 2021 02:31:07 -0400 (EDT)
Date:   Mon, 25 Oct 2021 09:31:03 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     jiri@nvidia.com, idosch@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] mlxsw: spectrum: Use 'bitmap_zalloc()' when applicable
Message-ID: <YXZPJxuPEDbPV5w7@shredder>
References: <daae11381ba197d91702cb23c6c1120571cb0b87.1635103002.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <daae11381ba197d91702cb23c6c1120571cb0b87.1635103002.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 24, 2021 at 09:17:51PM +0200, Christophe JAILLET wrote:
> Use 'bitmap_zalloc()' to simplify code, improve the semantic and avoid
> some open-coded arithmetic in allocator arguments.
> 
> Also change the corresponding 'kfree()' into 'bitmap_free()' to keep
> consistency.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

For net-next:

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Thanks
