Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 340AE4309F0
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 17:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241630AbhJQPIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 11:08:32 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:42473 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237285AbhJQPIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 11:08:31 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id D5F4658169C;
        Sun, 17 Oct 2021 11:06:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 17 Oct 2021 11:06:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=5Pe0wu
        t2jSUUZ3JaYsA7RTwVinQOvg8fx604Qjkaovg=; b=inSrWpuNC5gzL0qgSzdrBn
        JvcafU+dtnvVGwYRcd1mJ4NVeud4pltocyB1QVuHXEXfs9SuPj7i6CdCB8jEKGo8
        W4k+LxYLLfxUzk+mJOxk3Z23PMK/xMD0+hVsUIUqL9F5qYiYJxobfAqQsSxpQds1
        p0PrUOeO4Uc3kJsLe7VVl70gzd6pmAgqrq+012yJaIJHWDouUoxp/eqe0frXTrAb
        S8QrtPujr4MZNc3HPqc1/38LVO/c0sFU9rtM9o8HBOMDrNUI2aSlEkK/SN5OhQ1P
        aQh7zlp1NkOZ/+Zs8GwKOJQQsLk/IJ58o4i1vTeHkHDoFaNWtl/BHm85is0T+VOg
        ==
X-ME-Sender: <xms:7DtsYaGopnv86selzyU9UTClpZCdt4S8wZ7fg7GbBKaveUsmviSgOg>
    <xme:7DtsYbWO2LtV8hOfQw-Ap3fSJ6MSWtFz-I8kW5OqBgWaT71LMXVJfeLrkCHwk9q3E
    KG4r41v0z9eMAA>
X-ME-Received: <xmr:7DtsYUK5pwevCD30aRTI2kXxaflM01arJEG69XfvNn-Q7yEPCh5NiBH0lIJh_WVop_yFZA2_1uCQ9PEnOUHeVVeJUy8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddukedgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnheptdffkeekfeduffevgeeujeffjefhte
    fgueeugfevtdeiheduueeukefhudehleetnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:7TtsYUGZljxHZVuIjojNLsvAcpKxGAkVtPA7lZpfeFS-5tDbLm4veg>
    <xmx:7TtsYQVr__sUlw8HS3V3FwlRi34A9ss4IsmSKbRTW-nuJuDKpv1_4g>
    <xmx:7TtsYXOraUWaCHSo3K5ddmQ1MKUR2mYtuzTbmcsQC6XXX-niREFsww>
    <xmx:7TtsYVWxTjVPFeEXOhEPKNIKOHWImIYKUOems5o3ZR9GXqtgjlAN0g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 17 Oct 2021 11:06:20 -0400 (EDT)
Date:   Sun, 17 Oct 2021 18:06:17 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, andrew@lunn.ch,
        f.fainelli@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com, bjarni.jonasson@microchip.com,
        linux-arm-kernel@lists.infradead.org, qiangqing.zhang@nxp.com,
        vkochan@marvell.com, tchornyi@marvell.com, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com
Subject: Re: [RFC net-next 1/6] ethernet: add a helper for assigning port
 addresses
Message-ID: <YWw76V/UfJm3yM2t@shredder>
References: <20211015193848.779420-1-kuba@kernel.org>
 <20211015193848.779420-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015193848.779420-2-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 12:38:43PM -0700, Jakub Kicinski wrote:
> +/**
> + * eth_hw_addr_set_port - Generate and assign Ethernet address to a port
> + * @dev: pointer to port's net_device structure
> + * @base_addr: base Ethernet address
> + * @id: offset to add to the base address
> + *
> + * Assign a MAC address to the net_device using a base address and an offset.
> + * Commonly used by switch drivers which need to compute addresses for all
> + * their ports. addr_assign_type is not changed.
> + */
> +static inline void eth_hw_addr_set_port(struct net_device *dev,
> +					const u8 *base_addr, u8 id)

If necessary, would it be possible to change 'id' to u16?

I'm asking because currently in mlxsw we set the MAC of each netdev to
'base_mac + local_port' where 'local_port' is u8. In Spectrum-4 we are
going to have more than 256 logical ports, so 'local_port' becomes u16.

Regarding the naming, eth_hw_addr_gen() sounds good to me.

Thanks for working on this

> +{
> +	u64 u = ether_addr_to_u64(base_addr);
> +	u8 addr[ETH_ALEN];
> +
> +	u += id;
> +	u64_to_ether_addr(u, addr);
> +	eth_hw_addr_set(dev, addr);
> +}
> +
>  /**
>   * eth_skb_pad - Pad buffer to mininum number of octets for Ethernet frame
>   * @skb: Buffer to pad
> -- 
> 2.31.1
> 
