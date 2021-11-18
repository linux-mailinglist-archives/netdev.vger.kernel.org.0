Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D21F7455580
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 08:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243534AbhKRHat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 02:30:49 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38059 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243448AbhKRHas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 02:30:48 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2396C5C029D;
        Thu, 18 Nov 2021 02:27:48 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 18 Nov 2021 02:27:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=zXrM10
        1H/f+jiEZ06DZxibjn6Aar3BSIqvGx3FDa+qE=; b=lmgshLAL1KEjVmKGa+CiSr
        zvQzj1yo6YuOV0KstSzWihspeI8d6xnBjoDq+hPnh1Es4hl7GCo7JDrd19amsdX9
        PW8i3XVfnDBCM4zs5zZhTGCR77t9DoYfJfg8/Ccq9Jkwn6/9P/pRAoNFa5B1g4VY
        gdKd/ylN0aRENhkr5wac/tH73C0JhwL3FvA+iSU8u9AhTyWDqQuAITcynqLNSbHt
        cHXlqiO9usK3qmWWAo9LXmhqykse3JiYR2labg4Zm+ZR6bltNjqedJKweyvJhLbm
        yQy/7Sep21INm4rAk7xTLTEqgL56xY+Ei1lweZG8ipp6nPFIv/AWuH2ZC7NY40rA
        ==
X-ME-Sender: <xms:cwCWYSGFqLq-Rb1Nw5ETZ-TdxuHd8Pr362OidTVofjliGnTr2J2bmw>
    <xme:cwCWYTVxvoEcxywSXzdaNsfO1aJAkLX1K69nJkrhsyUzg6AqqQlERqoAli9rnhwxU
    30icqHjjW3kNg0>
X-ME-Received: <xmr:cwCWYcIpCKKnm0-Gsr0vNqlubI_iok87tZQtu-4imeN2J9ke9mjtp2lyR09stRdmyK4CZk4tgGtpBsbs1tKTHgldPhU1uw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrfeehgddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnheptdffkeekfeduffevgeeujeffjefhte
    fgueeugfevtdeiheduueeukefhudehleetnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:dACWYcF_uVJSov7PnBFVqBoBGucaoWs6A10YMESLFLwT0sgCuCeM3Q>
    <xmx:dACWYYWP8kHo8CHGax78MdHa5UwwsyGHAXNcSw4N3RxQcEMIVnbvcA>
    <xmx:dACWYfM1uyYX_9iuA6YqLCxBiLvQbzMS5OdiA_H8QCazG0lw_LqKCA>
    <xmx:dACWYVgobD0P5g7HtHYjabdK0x0_pQcX9xq7heltgiLZVHGpBBhE4Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Nov 2021 02:27:47 -0500 (EST)
Date:   Thu, 18 Nov 2021 09:27:43 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@nvidia.com,
        idosch@nvidia.com
Subject: Re: [PATCH net-next 2/9] mlxsw: constify address in
 mlxsw_sp_port_dev_addr_set
Message-ID: <YZYAb4X/VQFy0iks@shredder>
References: <20211118041501.3102861-1-kuba@kernel.org>
 <20211118041501.3102861-3-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211118041501.3102861-3-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 08:14:54PM -0800, Jakub Kicinski wrote:
> Argument comes from netdev->dev_addr directly, it needs a const.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
