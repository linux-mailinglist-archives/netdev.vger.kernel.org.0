Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B70664937A5
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 10:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353138AbiASJpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 04:45:49 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:55049 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352938AbiASJps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 04:45:48 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 16EA33201E5F;
        Wed, 19 Jan 2022 04:45:48 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 19 Jan 2022 04:45:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=VEskvT
        nowRvKDY4hR4JFQyZmf5YvsnZy7Zo1clfOU0E=; b=mFyjtEcI74IdWSRrZCJjLY
        urC245hY/CZNialyPA7iyjSM7xWwtBZ7rgZSSB6WSwBBh359xeJzH3zpFu3otMjP
        fCulwUc383ktfH9TevJcUNB8ePqVTC2ZMdUpWMiyRj+1LJ+hD5bZjXn3eQ+RjZXh
        0w4EMzWDUvltuDx8nSX/KEsPnoIAd/SRCYxMFzC+DMXmRUD7tmSZCHL3YzxMUT94
        LgZOom3XzI4NfBjJCuyOI9XqIHRF95PyQrS0YhALjYr4i0//2vmTUfkeFO8Q+NAL
        KqUhgko/ae+Lzrxh6b9gcAYGQfld/wUoKpX1nSafpV74IbYxABPobtruFMZX8gwQ
        ==
X-ME-Sender: <xms:y93nYajWeBeXfDNgt4N9GTlwA52lJJvwyQ4YfyWLiQ-7WIPTa_MDKQ>
    <xme:y93nYbBxJGrBplakunH0jKcSyZcE_PBd8W_Oi7ZrcOTTrvQbZxr7JFqAXpoM9iauB
    nL0yQddBPagQ5U>
X-ME-Received: <xmr:y93nYSHgSFXQRLprJ1ZsQEsQ8aFOqSO_axF5Ihn6M0SvHR9OVlqCLX08zDvToJZZfsgJvH-UCBTr3gV56lLTo-_L9xJjOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudehgddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:y93nYTSAtEri8yiyyBcOFraQ2cj2Pjjt8B9IxQoN8AO18mCZyPoGAw>
    <xmx:y93nYXwSPX4L_k6tN20-4Yb8x9AH406kOZm4k8b5tRbXzHOYMcHWIg>
    <xmx:y93nYR7j0rEhZ1IE-aI06eWjCCDUi0l2hdw3a7IuomJ0JFLhqlDdKw>
    <xmx:y93nYS9zEaGRPl3PUJvM56872rK5VvCh3pwkEqw-MyZ1B8yBDepktQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 19 Jan 2022 04:45:46 -0500 (EST)
Date:   Wed, 19 Jan 2022 11:45:41 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>, michel@fb.com,
        dcavalca@fb.com
Subject: Re: ethtool 5.16 release / ethtool -m bug fix
Message-ID: <YefdxW/V/rjiiw2x@shredder>
References: <20220118145159.631fd6ed@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118145159.631fd6ed@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 02:51:59PM -0800, Jakub Kicinski wrote:
> Hi Michal!
> 
> Sorry to hasten but I'm wondering if there is a plan to cut the 5.16
> ethtool release? Looks like there is a problem in SFP EEPROM parsing
> code, at least with QSFP28s, user space always requests page 3 now.
> This ends in an -EINVAL (at least for drivers not supporting the paged
> mode).

Jakub, are you sure you are dealing with QSFP and not SFP? I'm asking
because I assume the driver in question is mlx5 that has this code in
its implementation of get_module_eeprom_by_page():

```
switch (module_id) {
case MLX5_MODULE_ID_SFP:
	if (params->page > 0)
		return -EINVAL;
	break;
```

And indeed, ethtool(8) commit fc47fdb7c364 ("ethtool: Refactor
human-readable module EEPROM output for new API") always asks for Upper
Page 03h, regardless of the module type.

It is not optimal for ethtool(8) to ask for unsupported pages and I made
sure it's not doing it anymore, but I believe it's wrong for the kernel
to return an error. All the specifications that I'm aware of mandate
that when an unsupported page is requested, the Page Select byte will
revert to 0. That is why Upper Page 00h is always read-only.

For reference, see section 10.3 in SFF-8472, section 6.2.11 in SFF-8636
and section 8.2.13 in CMIS.

Also, the entire point of the netlink interface is that the kernel can
remain ignorant of the EEPROM layout and keep all the logic in user
space.

> 
> By the looks of it - Ido fixed this in 6e2b32a0d0ea ("sff-8636: Request
> specific pages for parsing in netlink path") but it may be too much code 
> to backport so I'm thinking it's easiest for distros to move to v5.16.

I did target fixes at 'ethtool' and features at 'ethtool-next', but I
wasn't aware of this bug.
