Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1488D49DD9D
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 10:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbiA0JQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 04:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiA0JQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 04:16:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7802C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 01:16:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66B1861B95
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 09:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3E5C340E4;
        Thu, 27 Jan 2022 09:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643274971;
        bh=A9vp8c8ZpwHkWeD8WUMc5vPvhRV6/QMvKA5mN+Eiicg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T4kIbO3JDeKw3Ug29f6ujSnzZVMTlvYsToDuGTrJrvh9kS6g0cjGIJF/SL0y4vkBt
         RZuC6xH93SeM/gftrGovxlZ8KDRU/+9AGjvfxzISdhsQf1iYKeYED5p3KlYGt3tFFU
         A0zzrm7nXvqaE8W4wr3IODpQZUz21KRJK7sTx0mqG3Qem+p9p562/EQtzLBHvbl4gc
         V5GLM4Zx6N/H1HznZkUWrjF8bX7TsiL396T7YBdP70Qh2HeZ9wMeB4DZVCCx1BZ5zY
         8R4zi8va6ObY4Xux2eOsbM9zScClUHlRNICWMsj4CVqsuiwg+RTGTW+CylUsRZic5H
         ILf7D18jE5xSg==
Date:   Thu, 27 Jan 2022 11:16:07 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jian Shen <shenjian15@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linuxarm@openeuler.org
Subject: Re: [RFCv2 net-next 000/167] net: extend the netdev_features_t
Message-ID: <YfJi10IcxtYQ7Ttr@unreal>
References: <20210929155334.12454-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210929155334.12454-1-shenjian15@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 11:50:47PM +0800, Jian Shen wrote:
> For the prototype of netdev_features_t is u64, and the number
> of netdevice feature bits is 64 now. So there is no space to
> introduce new feature bit.
>=20
> This patchset try to solve it by change the prototype of
> netdev_features_t from u64 to bitmap. With this change,
> it's necessary to introduce a set of bitmap operation helpers
> for netdev features. Meanwhile, the functions which use
> netdev_features_t as return value are also need to be changed,
> return the result as an output parameter.
>=20
> With above changes, it will affect hundreds of files, and all the
> nic drivers. To make it easy to be reviewed, split the changes
> to 167 patches to 5 parts.
>=20
> patch 1~22: convert the prototype which use netdev_features_t
> as return value
> patch 24: introduce fake helpers for bitmap operation
> patch 25~165: use netdev_feature_xxx helpers
> patch 166: use macro __DECLARE_NETDEV_FEATURE_MASK to replace
> netdev_feature_t declaration.
> patch 167: change the type of netdev_features_t to bitmap,
> and rewrite the bitmap helpers.
>=20
> Sorry to send a so huge patchset, I wanna to get more suggestions
> to finish this work, to make it much more reviewable and feasible.
>=20
> The former discussing for the changes, see [1]
> [1]. https://www.spinics.net/lists/netdev/msg753528.html
>=20

------------------------------------------------

Is anyone actively working on this task?

Thanks
