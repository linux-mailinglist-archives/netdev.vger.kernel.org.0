Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 307636876B8
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 08:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbjBBHrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 02:47:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbjBBHrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 02:47:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE9083957;
        Wed,  1 Feb 2023 23:47:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 371946185D;
        Thu,  2 Feb 2023 07:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196A4C433D2;
        Thu,  2 Feb 2023 07:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675323975;
        bh=J1MFEvoEvd3HFsnM+pgg3Al2cUiHeLh3YiuSWcUjCJo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=isyqmSbnJ3CHa16Pu5K7VPGelrABwmnr/UkJvQQf0sVLXBYpCkbXCM+yiZDaxfoyP
         79VIfrwP49DTyf+kqtfJfZQ8oLfdEkS2mTqrPgU2CFVc74Zdz/+LXOlfL5ppnhQ1w7
         dilGryeElofmrG8nq2TYbdoB6tGtweGXxeRwZ3mT13r49u1xHrPiAEUtm32CX8tRCw
         NfUztxb5cJEFkRAOxv83D5X+Hi8+v5aSah0nsQZTKQKLuEJulnLZm323LS2AJGLizI
         V0KBOHUMyPnkoHhtIitKXbqryi/IajGgIchZ6WeTzzXyz7z60jAVqpp4w1sNnRFTEx
         3wAtah/Mmoybg==
Date:   Thu, 2 Feb 2023 09:46:11 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next 2023-01-24 V2
Message-ID: <Y9tqQ0RgUtDhiVsH@unreal>
References: <20230126230815.224239-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230126230815.224239-1-saeed@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 03:08:15PM -0800, Saeed Mahameed wrote:
> Hi,=20
>=20
> This pulls mlx5-next branch which includes changes from [1]:
>=20
> 1) From Jiri: fixe a deadlock in mlx5_ib's netdev notifier unregister.
> 2) From Mark and Patrisious: add IPsec RoCEv2 support.
>=20
> [1] https://lore.kernel.org/netdev/20230105041756.677120-1-saeed@kernel.o=
rg/
>=20
> Please pull into net-next and rdma-next.


Hi,=20

I don't see it in net-next yet, can you please pull it?

There are outstanding RDMA patches which depend on this shared branch.
https://lore.kernel.org/all/cover.1673960981.git.leon@kernel.org

Thanks
