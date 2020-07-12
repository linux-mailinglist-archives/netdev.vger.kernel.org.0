Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DFB21C804
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 10:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgGLIOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 04:14:12 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47303 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725974AbgGLIOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 04:14:11 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 8B74E5C011C;
        Sun, 12 Jul 2020 04:14:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 12 Jul 2020 04:14:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=uBCQof
        JMbqxdoHW5wGnGN4ldgC9ziYSok5JMRenEKPE=; b=Svm+U9v5HLdx78j9DdLwSW
        fGYyQY4q+QY6c1+VdxC/ciHkWj60GUxBW/APZZlwORpCQ7RTKGjiNRGSruFyCgI6
        mhHyAwnNkHMB4rRNX5eoQRsKT/TB2200NHBEnr1f/n3WADYSqAyUoYHOQPHclcpm
        wl9E9AB4V/rXNciyA9Uma/QcQLexC4YhcgsZ6NbV8COaSkapSvRsnrmrysfAd+/V
        czha+BNr2nbA8yiDnmL1UBkAaEwgp8YtSZq263V7AUsuF/qbiNZhJQJBYJSwSgnc
        3KOrJOhB7Fjd7d8/ffdb+HMCdpkE1fLCzEUAkbTe22vgMA7T+pM79r8E041m9fow
        ==
X-ME-Sender: <xms:UsYKX1c-Fix1NPtFvdEhcgg7LDYjvY5cwJKP41tK-BdJZBlE5-h3Rg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrvdeigddtgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppedutdelrdeiiedrudelrddufeefnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:UsYKXzPRpPNmNQwksBcO_0ACxFt_6NPIOECphS-d4LxCALiD1pkwjw>
    <xmx:UsYKX-g8hd1HqxVM7ur_c6804zpzyhcHiVLehV6OFQqgVS-aXG0RQg>
    <xmx:UsYKX-_KNqHPK1uCO4d_71_TiNu8akypXWo1kdsnR5MqQ4lnEIyefg>
    <xmx:UsYKX_0O1lzc1QEblSmNly_sZzc-BbUGa4CWrL2_q59qK0q5dZAAow>
Received: from localhost (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id BB480306005F;
        Sun, 12 Jul 2020 04:14:09 -0400 (EDT)
Date:   Sun, 12 Jul 2020 11:14:06 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Danielle Ratson <danieller@mellanox.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, mlxsw@mellanox.com
Subject: Re: [PATCH iproute2-next 2/3] devlink: Expose number of port lanes
Message-ID: <20200712081406.GA117670@shredder>
References: <20200712080413.15435-1-danieller@mellanox.com>
 <20200712080413.15435-3-danieller@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200712080413.15435-3-danieller@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 12, 2020 at 11:04:12AM +0300, Danielle Ratson wrote:
> Add a new attribute that indicates the port's number of lanes to devlink port.
> 
> Expose the attribute to user space as RO value, for example:
> 
> $devlink port show swp1
> pci/0000:03:00.0/61: type eth netdev swp1 flavour physical port 1 lanes 1
> 
> Signed-off-by: Danielle Ratson <danieller@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  devlink/devlink.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/devlink/devlink.c b/devlink/devlink.c
> index 535c98d1..4aeb9f34 100644
> --- a/devlink/devlink.c
> +++ b/devlink/devlink.c
> @@ -3398,6 +3398,10 @@ static void pr_out_port(struct dl *dl, struct nlattr **tb)
>  	if (tb[DEVLINK_ATTR_PORT_SPLIT_GROUP])
>  		print_uint(PRINT_ANY, "split_group", " split_group %u",
>  			   mnl_attr_get_u32(tb[DEVLINK_ATTR_PORT_SPLIT_GROUP]));
> +	if (tb[DEVLINK_ATTR_PORT_LANES])

I think you need to update 'devlink_policy' with the new attributes

> +		print_uint(PRINT_ANY, "lanes", " lanes %u",
> +			   mnl_attr_get_u32(tb[DEVLINK_ATTR_PORT_LANES]));
> +
>  	pr_out_port_function(dl, tb);
>  	pr_out_port_handle_end(dl);
>  }
> -- 
> 2.20.1
> 
