Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C366F3AAC89
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 08:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhFQGl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 02:41:57 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49281 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229551AbhFQGl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 02:41:56 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id AAA3F5C013E;
        Thu, 17 Jun 2021 02:39:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 17 Jun 2021 02:39:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=/DzQCe
        zx4ySB6yO+xHiB8fElUQ69/Gax99EYsyjZLbc=; b=DntMJCOWRDqEesqmaPOHiy
        a7Jux6Uw0HlgUcZ9tw04JsiHBUiyXpY5BfbB8kTt6m6qPkeuquN7uPa16Zn1gINB
        +lP/sspwcsvvcWXzqhcciJPMd33Gi6wRYctCcHYmFP1Mi51RgrmkVLoCcWKzGtgL
        FIKbyan2V1Stij809d/Eup6MIGyfyOKICM4aKqEKadaB9zMlgKfSSkpYp8jXEPTR
        jDN8S1GOF0qPgTAAQHYLWft0nPpiKxpkIzxkV7/hkmr1GJ6gVUInRGKL8b0hdmBY
        Ye87ucfuhJbQu92+zwBFDP3hh/qzywtKPTZvA92wQe+p7FenfAwcP0OKaVsIuF3w
        ==
X-ME-Sender: <xms:NO7KYOLB8lGY762oZBmjGKurjkjjkkkVu82sPOc0wSTvsv9NxCIUbQ>
    <xme:NO7KYGK12_7DhC4Z-_J2xcWQkda0o2VC-NGEbSruscgvn4ur5NXX6pBVu92Kk3br5
    raXa9oTFzNeUtM>
X-ME-Received: <xmr:NO7KYOueOhKBbZf0lv0AdVptIH2Go5xnZplVMIr_BJBa6f8cxe6Vlwc89oz1CwRVx0S58RbJ_VJyIOCjK0wPJU270R6aVQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeftddguddtiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:NO7KYDY4RP0fevjDUjdYvc_f7CRglEgYBg2LKXkgvJuUkiVU9jNYNA>
    <xmx:NO7KYFY3mAJFY-xa3ym5xjMLOl_4Hz5XJc9wVHYRsQCEWFjGBcxs_g>
    <xmx:NO7KYPBvtfTnE63PztnfQLpcEKwsoLXcJjmjr0qPkXr0aPAUO9rpIA>
    <xmx:NO7KYEXKwSHKIQuh2jPHswkZhkGvf2mDPFoO2MarUIsQ7XP7xe9CqA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 17 Jun 2021 02:39:47 -0400 (EDT)
Date:   Thu, 17 Jun 2021 09:39:43 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     jiri@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vadym Kochan <vadym.kochan@plvision.eu>
Subject: Re: [PATCH net-next] drivers: net: netdevsim: fix devlink_trap
 selftests failing
Message-ID: <YMruL84N3A3yq1qy@shredder>
References: <20210616183405.3715-1-oleksandr.mazur@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616183405.3715-1-oleksandr.mazur@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 09:34:05PM +0300, Oleksandr Mazur wrote:

You need to add a proper commit message here

> Fixes: a7b3527a43fe ("drivers: net: netdevsim: add devlink trap_drop_counter_get implementation")
> 

No blank line between Fixes and SoB

> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> ---
> Test-results:
> selftests: drivers/net/netdevsim: devlink_trap.sh
> TEST: Initialization                                                [ OK ]
> TEST: Trap action                                                   [ OK ]
> TEST: Trap metadata                                                 [ OK ]
> TEST: Non-existing trap                                             [ OK ]
> TEST: Non-existing trap action                                      [ OK ]
> TEST: Trap statistics                                               [ OK ]
> TEST: Trap group action                                             [ OK ]
> TEST: Non-existing trap group                                       [ OK ]
> TEST: Trap group statistics                                         [ OK ]
> TEST: Trap policer                                                  [ OK ]
> TEST: Trap policer binding                                          [ OK ]
> TEST: Port delete                                                   [ OK ]
> TEST: Device delete                                                 [ OK ]

This can be in the commit message

> ---
>  drivers/net/netdevsim/dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index d85521989753..aad5e3d4a2b6 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -269,7 +269,7 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
>  		err = PTR_ERR(nsim_dev->nodes_ddir);
>  		goto err_out;
>  	}
> -	debugfs_create_bool("fail_trap_counter_get", 0600,
> +	debugfs_create_bool("fail_trap_drop_counter_get", 0600,
>  			    nsim_dev->ddir,
>  			    &nsim_dev->fail_trap_counter_get);

Please change the name of the variable to match the name of the
corresponding debugfs file

>  	nsim_udp_tunnels_debugfs_create(nsim_dev);
> -- 
> 2.17.1
> 
