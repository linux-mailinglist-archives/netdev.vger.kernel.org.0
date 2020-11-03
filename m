Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66032A4814
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 15:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbgKCO07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 09:26:59 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:55335 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729341AbgKCOYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 09:24:36 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 1FCC4D1B;
        Tue,  3 Nov 2020 09:24:35 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 03 Nov 2020 09:24:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=t4GCzx
        CDcyGCxLCHhgl39P4PXqDlTCWAZNa1eT18kIw=; b=IIcL6IHK7nm3YvkxGIKvcn
        V1Ybc8ZwKMBGQvhyE5FMgb+xq3jqji2W1b8p8tgdKCO2EUeHicTnho2Gf/yeZUQS
        zA1iNluWCGdn2CWxWOa5YQtnDQOHnm/98Zezs8LTExHDFSMDiJbqun9eiwBE+p6P
        0F0+0xZADPLDNrLm93/iq9Ae4zommvr49SQCvYIceyoj23+1vVSwRxt14C+NaEMy
        9kkaDd3Ly6cWB/64AiddWN+v8aC7fvpPJOxwoBmBfroTbXcw5X52qauVtsYmS3nc
        7uUbwnIqslfs/lrpRwdIpsOpX2Joy8vhB7FlYscHLn+4WwUWTJw1nmEO9bAdFUhA
        ==
X-ME-Sender: <xms:ImihX_CWZqhM68vwCY0kdDLznkwiqcMTerSE5CPq0s99M98ahqXbmA>
    <xme:ImihX1gAgGyXN1l41rkpgkmGqoIoqAXewg3rf5R9hrtmRX39OoBn5_eFd0HVbk-pU
    6qw6uM3XoWUJVM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeehhfdthfduueehgfekkefhhedutddvveefteehteekleevgfegteevueelheek
    ueenucffohhmrghinhepghhithhhuhgsrdgtohhmnecukfhppeekgedrvddvledrudehfe
    drvdehvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:ImihX6mNT8sFVvjxiPwfYrZePoTvdW3lwSLAi25AEZ7AXZZXdceETw>
    <xmx:ImihXxyT1HSutuFfrW_BwOrpDprbte-sM-B6wsh3GN9-hFCDGfGlEA>
    <xmx:ImihX0SPwdxRDHwuokfRCSOd0dvq3MOzNBRnVAQqn1W_R5GIp800Dg>
    <xmx:ImihX_JlKNkFmv8oQLOqIroV5cgFhpi5nRHtZ6CJNHe7qpAZIh6fGQ>
Received: from localhost (igld-84-229-153-252.inter.net.il [84.229.153.252])
        by mail.messagingengine.com (Postfix) with ESMTPA id A1CF8306467D;
        Tue,  3 Nov 2020 09:24:33 -0500 (EST)
Date:   Tue, 3 Nov 2020 16:24:30 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH ethtool] ethtool: Improve compatibility between
 netlink and ioctl interfaces
Message-ID: <20201103142430.GA951743@shredder>
References: <20201102184036.866513-1-idosch@idosch.org>
 <20201102225803.pcrqf6nhjlvmfxwt@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201102225803.pcrqf6nhjlvmfxwt@lion.mk-sys.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 11:58:03PM +0100, Michal Kubecek wrote:
> On Mon, Nov 02, 2020 at 08:40:36PM +0200, Ido Schimmel wrote:
> > +static int linkmodes_reply_adver_all_cb(const struct nlmsghdr *nlhdr,
> 
>                               ^^^^^ advert?
> 
> > +					void *data)
> > +{
> > +	const struct nlattr *bitset_tb[ETHTOOL_A_BITSET_MAX + 1] = {};
> > +	const struct nlattr *tb[ETHTOOL_A_LINKMODES_MAX + 1] = {};
> > +	DECLARE_ATTR_TB_INFO(bitset_tb);
> > +	struct nl_context *nlctx = data;
> > +	struct nl_msg_buff *msgbuff;
> > +	DECLARE_ATTR_TB_INFO(tb);
> > +	struct nl_socket *nlsk;
> > +	struct nlattr *nest;
> > +	int ret;
> > +
> > +	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
> > +	if (ret < 0)
> > +		return ret;
> > +	if (!tb[ETHTOOL_A_LINKMODES_OURS])
> > +		return -EINVAL;
> > +
> > +	ret = mnl_attr_parse_nested(tb[ETHTOOL_A_LINKMODES_OURS], attr_cb,
> > +				    &bitset_tb_info);
> > +	if (ret < 0)
> > +		return ret;
> > +	if (!bitset_tb[ETHTOOL_A_BITSET_SIZE] ||
> > +	    !bitset_tb[ETHTOOL_A_BITSET_VALUE] ||
> > +	    !bitset_tb[ETHTOOL_A_BITSET_MASK])
> > +		return -EINVAL;
> > +
> > +	ret = netlink_init_ethnl2_socket(nlctx);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	nlsk = nlctx->ethnl2_socket;
> > +	msgbuff = &nlsk->msgbuff;
> > +
> > +	ret = msg_init(nlctx, msgbuff, ETHTOOL_MSG_LINKMODES_SET,
> > +		       NLM_F_REQUEST | NLM_F_ACK);
> > +	if (ret < 0)
> > +		return ret;
> > +	if (ethnla_fill_header(msgbuff, ETHTOOL_A_LINKMODES_HEADER,
> > +			       nlctx->devname, 0))
> > +		return -EMSGSIZE;
> > +
> > +	if (ethnla_put_u8(msgbuff, ETHTOOL_A_LINKMODES_AUTONEG, AUTONEG_ENABLE))
> > +		return -EMSGSIZE;
> > +
> > +	/* Use the size and mask from the reply and set the value to the mask,
> > +	 * so that all supported link modes will be advertised.
> > +	 */
> > +	ret = -EMSGSIZE;
> > +	nest = ethnla_nest_start(msgbuff, ETHTOOL_A_LINKMODES_OURS);
> > +	if (!nest)
> > +		return -EMSGSIZE;
> > +
> > +	if (ethnla_put_u32(msgbuff, ETHTOOL_A_BITSET_SIZE,
> > +			   mnl_attr_get_u32(bitset_tb[ETHTOOL_A_BITSET_SIZE])))
> > +		goto err;
> > +
> > +	if (ethnla_put(msgbuff, ETHTOOL_A_BITSET_VALUE,
> > +		       mnl_attr_get_payload_len(bitset_tb[ETHTOOL_A_BITSET_MASK]),
> > +		       mnl_attr_get_payload(bitset_tb[ETHTOOL_A_BITSET_MASK])))
> > +		goto err;
> > +
> > +	if (ethnla_put(msgbuff, ETHTOOL_A_BITSET_MASK,
> > +		       mnl_attr_get_payload_len(bitset_tb[ETHTOOL_A_BITSET_MASK]),
> > +		       mnl_attr_get_payload(bitset_tb[ETHTOOL_A_BITSET_MASK])))
> > +		goto err;
> > +
> > +	ethnla_nest_end(msgbuff, nest);
> 
> To fully replicate ioctl code behaviour, we should only set the bits
> corresponding to "real" link modes, not "special" ones (e.g.
> ETHTOOL_LINK_MODE_TP_BIT).

Michal,

I have the changes you requested here:
https://github.com/idosch/ethtool/commit/b34d15839f2662808c566c04eda726113e20ee59

Do you want to integrate it with your nl_parse() rework or should I?

Thanks
