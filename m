Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1893C30B014
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 20:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbhBATJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 14:09:48 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:34843 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231243AbhBATJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 14:09:46 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 41E6A5C01B5;
        Mon,  1 Feb 2021 14:09:00 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 01 Feb 2021 14:09:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=xKnx/a
        Po6GjLtPcvtC/0YV330Fe9kERZySQmW8OrSxc=; b=fpILj+fAKtq8qUJQG2pi67
        sdSaY0ENbNhq7XJfaYQbOwwJb39LHNR0844bLKcxyX5qb3maLoTtGItQ1AKOki63
        fOchrBxyb2PmgVoA5MfApRtsjtBhXYT4A0cT8HQG5+9IQ8iS2u/3IwCJ4xlvjr+X
        EDtX58Zyx5IAtvLjokRQN24NQzT1RumlMYyUZJ9yYDDlkSqwNKZ6SoKL+c5D1RJg
        EeVmA1fG4piy7RVrKmcEAIapLfsWKqWV4x9vzeW/iquEDm3I0mzIpqFWbQW3JYO0
        f1GujpfTPuV6nxP3NfHoW1EsfFWGP61Iztfh9fXwrHL0Tde7/1PpTMvoZYNYpspw
        ==
X-ME-Sender: <xms:y1EYYJHcaJYw3jpKHP5QBI70U48cqMrQYvaIMG3gfe3o1zq6DTNEKQ>
    <xme:y1EYYGyKP51S4Od09eISfdgUnnccrcC9V3mk7wMpuj927uxTXc9fvqBguPNpfkwAz
    GoLRNyIJHudbNc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgdduvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:y1EYYLln6DGcyiX1tfUUR6oY8W56TuBNJKZlwjg7udiuDdt5Eugb4A>
    <xmx:y1EYYPkuJoBh47lsosdjvYSsHtGdgnWO9MDxuZrANafkh0cQ6BiDjQ>
    <xmx:y1EYYNzUManIPo50qjuQmo4It64AnfnuQGIZqv1YymFpyLjceGLaNQ>
    <xmx:zFEYYOspK3RfgVCeTzuHJeOZAiJDXaeHSLmy4jFY7a6G3lx9n7avnA>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 83CF824005C;
        Mon,  1 Feb 2021 14:08:59 -0500 (EST)
Date:   Mon, 1 Feb 2021 21:08:56 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     netdev@vger.kernel.org, jiri@nvidia.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, kuba@kernel.org
Subject: Re: [RFC v3 net-next] net: core: devlink: add 'dropped' stats field
 for DROP trap action
Message-ID: <20210201190856.GA3458001@shredder.lan>
References: <20210125123856.1746-1-oleksandr.mazur@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125123856.1746-1-oleksandr.mazur@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I missed this patch. Please Cc me on future versions given I commented
on previous versions.

On Mon, Jan 25, 2021 at 02:38:56PM +0200, Oleksandr Mazur wrote:
> Whenever query statistics is issued for trap with DROP action,
> devlink subsystem would also fill-in statistics 'dropped' field.
> In case if device driver did't register callback for hard drop
> statistics querying, 'dropped' field will be omitted and not filled.
> Add trap_drop_counter_get callback implementation to the netdevsim.
> Add new test cases for netdevsim, to test both the callback
> functionality, as well as drop statistics alteration check.
> 
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>

[...]

> +static int devlink_trap_stats_put(struct sk_buff *msg, struct devlink *devlink,
> +				  const struct devlink_trap_item *trap_item)
> +{
> +	struct devlink_stats stats;
> +	struct nlattr *attr;
> +	u64 drops = 0;
> +	int err;
> +
> +	if (trap_item->action == DEVLINK_TRAP_ACTION_DROP &&
> +	    devlink->ops->trap_drop_counter_get) {
> +		err = devlink->ops->trap_drop_counter_get(devlink,
> +							  trap_item->trap,
> +							  &drops);
> +		if (err)
> +			return err;
> +	}
> +
> +	devlink_trap_stats_read(trap_item->stats, &stats);
> +
> +	attr = nla_nest_start(msg, DEVLINK_ATTR_STATS);
> +	if (!attr)
> +		return -EMSGSIZE;
> +
> +	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_STATS_RX_DROPPED, drops,
> +			      DEVLINK_ATTR_PAD))

Commit message says: "In case if device driver did't register callback
for hard drop statistics querying, 'dropped' field will be omitted and
not filled."

But looks like this attribute is always reported to user space.

> +		goto nla_put_failure;
> +
> +	if (trap_item->action == DEVLINK_TRAP_ACTION_DROP &&
> +	    devlink->ops->trap_drop_counter_get &&
> +	    nla_put_u64_64bit(msg, DEVLINK_ATTR_STATS_RX_PACKETS,
> +			      stats.rx_packets, DEVLINK_ATTR_PAD))

This is needed for DEVLINK_ATTR_STATS_RX_DROPPED, not for
DEVLINK_ATTR_STATS_RX_PACKETS.

I don't think it makes sense for a counter to come and go based on the
action. It should always be reported (if device supports it), regardless
of current action. Note that the first check will result in this counter
being reported as zero when the action is not drop, but as non-zero
otherwise. That's not good because the basic property of a counter is
that it is monotonically increasing.

> +			goto nla_put_failure;
> +
> +	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_STATS_RX_BYTES,
> +			      stats.rx_bytes, DEVLINK_ATTR_PAD))
> +		goto nla_put_failure;
> +
> +	nla_nest_end(msg, attr);
> +
> +	return 0;
> +
> +nla_put_failure:
> +	nla_nest_cancel(msg, attr);
> +	return -EMSGSIZE;
> +}
