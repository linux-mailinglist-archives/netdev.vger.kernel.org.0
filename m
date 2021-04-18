Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0150363451
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 10:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhDRIUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 04:20:37 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:48045 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229671AbhDRIUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 04:20:36 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D21135C06B1;
        Sun, 18 Apr 2021 04:20:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 18 Apr 2021 04:20:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=d7X8OG
        FVFOhDXCmZyOMBVNJkgbqgwpPEDeOT/pCuT34=; b=Dh6/1Ts7vLH5n4pGhm1xhd
        aQ/i6HcTldn9WUZgqC4sbDS8cpKl8VWoZj3NvlgaZg1bPjxTr8alz4kvw7+3c/HB
        //PFNCckLCK/aXm1Q5RspG0Z6r0+t3/hH7TXaY6kZwL4xbQP223ptLwl8Nu4N3wd
        pv5VhzG5Wtl27IHcns6YoCfQ1LlACSVDCKQuGQVG2f6E9zZ7YjBg21tU2Xl6vJds
        4T6pkmCwZ1u8qsML3FjmjmGjD+pG3DGHXdwBOQ8dXtZoOoPxwB/anUC8kjehr0O6
        /rvVjCUa7WwLSA2QuBp5qwHojBngxirZY+3BpVKcNx1qGdf5mTugwz+VOLPTEgaw
        ==
X-ME-Sender: <xms:t-t7YDTPEuM9ThqQYF7DfZF0CzdCyXBi4w76by2KrbWu7Q4ZFGUuLQ>
    <xme:t-t7YEwNEfkxq6dCAoUAtVrjpJeyG7goCuHZ94QrsvgF55h67Zfaga9Gcsa3lB4nD
    Zu_eBz2kCvY-vs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelkedgfeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnheptdffkeekfeduffevgeeujeffjefhte
    fgueeugfevtdeiheduueeukefhudehleetnecukfhppeduleefrdegjedrudeihedrvdeh
    udenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:t-t7YI1JpX9cN09hPz5qfwjONnfVINEqLOsofYN1NKSlzRH5HWJh2g>
    <xmx:t-t7YDBrVDLUn9iq3DWnLyTrcQ8eMPRFxabFIwBSnXLN19YHPmWtkg>
    <xmx:t-t7YMiHwvJMAYqx7WT2b7ahA6t9knImOmjWbO74oCZMU2IYB_04YA>
    <xmx:uOt7YEcTQIGt_1Rzzhz3qNHCwyL1WmUxFmVZ9520BfB6g2yBuTugUA>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3A22D1080063;
        Sun, 18 Apr 2021 04:20:07 -0400 (EDT)
Date:   Sun, 18 Apr 2021 11:20:04 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, idosch@nvidia.com, saeedm@nvidia.com,
        michael.chan@broadcom.com
Subject: Re: [PATCH net-next v2 3/9] ethtool: add a new command for reading
 standard stats
Message-ID: <YHvrtGSbYbVm/xLK@shredder>
References: <20210416192745.2851044-1-kuba@kernel.org>
 <20210416192745.2851044-4-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416192745.2851044-4-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 12:27:39PM -0700, Jakub Kicinski wrote:
> +static int stats_prepare_data(const struct ethnl_req_info *req_base,
> +			      struct ethnl_reply_data *reply_base,
> +			      struct genl_info *info)
> +{
> +	const struct stats_req_info *req_info = STATS_REQINFO(req_base);
> +	struct stats_reply_data *data = STATS_REPDATA(reply_base);
> +	struct net_device *dev = reply_base->dev;
> +	int ret;
> +
> +	ret = ethnl_ops_begin(dev);
> +	if (ret < 0)
> +		return ret;
> +

Nit: A comment here would be nice. Something like:

Mark all stats as unset (see ETHTOOL_STAT_NOT_SET) to prevent them from
being reported to user space in case driver did not set them.

> +	memset(&data->phy_stats, 0xff, sizeof(data->phy_stats));
> +
> +	if (test_bit(ETHTOOL_STATS_ETH_PHY, req_info->stat_mask) &&
> +	    dev->ethtool_ops->get_eth_phy_stats)
> +		dev->ethtool_ops->get_eth_phy_stats(dev, &data->phy_stats);
> +
> +	ethnl_ops_complete(dev);
> +	return 0;
> +}
