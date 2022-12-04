Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5C1641B6F
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 09:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiLDIA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 03:00:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiLDIA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 03:00:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7072417A95
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 00:00:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13411B8091B
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 08:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C57C433B5;
        Sun,  4 Dec 2022 08:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670140820;
        bh=BGt9IN4sRlO1sLUu3YUsBT/nTusEQMKMDzntWU7ek1w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jJSUulI8R1lXeM2eObWknfeh3Qd+K7+Tq3/cUpxYsL389ScjpWv1mp/GO9gC9QXqB
         X2eWzy15mpYuQeqvIhJG1F1T2mjey5xAZLrQMlLxvYdOlXax211CgxBp3xfB6KW1yH
         8H8eq2d9tHoIY5mwv6Ltc6kIagWlF6qbPLwr4FJZXVj/oWsB0WXIbEzRwI2H/kjt9U
         5aKCmPX0R8l6SB23WemP20Vu5zDXQIoxDp2/AYbjSoLBGI8R9hii3iZavmDSJI61ON
         c9FC7XTKiWSn7HjbKFA8zoqnY1aN2KLxfaNyjhYBLJ5BosPqQHARCTCCuK9HgF0d5W
         TXju5LnWoMV7Q==
Date:   Sun, 4 Dec 2022 10:00:16 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH xfrm-next v10 0/8] Extend XFRM core to allow packet
 offload configuration
Message-ID: <Y4xTkImiAiXavCAN@unreal>
References: <cover.1670005543.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1670005543.git.leonro@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 08:41:26PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The following series extends XFRM core code to handle a new type of IPsec
> offload - packet offload.

<...>

> Leon Romanovsky (8):
>   xfrm: add new packet offload flag
>   xfrm: allow state packet offload mode
>   xfrm: add an interface to offload policy
>   xfrm: add TX datapath support for IPsec packet offload mode
>   xfrm: add RX datapath protection for IPsec packet offload mode
>   xfrm: speed-up lookup of HW policies
>   xfrm: add support to HW update soft and hard limits
>   xfrm: document IPsec packet offload mode

Hi Steffen,

Like we discussed on v9 of this series, I do prefer to see this code
merged before merge window. It will simplify so much for me, like
UAPI exposure for iproute2 and *swan* forks. The internal API for
our mlx5 refactoring e.t.c.

The code in our regression is all time and it is completely safe for any
non-packet offload devices.

Thanks
