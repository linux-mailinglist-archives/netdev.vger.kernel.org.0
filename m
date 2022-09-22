Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E41F5E5C24
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 09:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbiIVHRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 03:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiIVHRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 03:17:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445D35B079
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 00:17:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DF27B834D7
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 07:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAEF0C433C1;
        Thu, 22 Sep 2022 07:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663831055;
        bh=hmVukGjkefafLCoYCbDGBQ75DqQlbsr61ZsOWqAnysc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C0whVEw/4dgB1SAZL5UIS2yhjxGSCGh+0ARpTnUz/9xWws1fiJHbcXu5DLJa51OIQ
         Z1C3sTuj+LxeADYnYs7CjbuZlKicuSERG7qdQevmT64hUngKC05FLQyDFYWBwuuQSD
         fcW90S7gHZi5wZd8qw8vSfgF6JuDqf3BjQUL2zedPDmoFwDosvUDIFZwH5UZqTdxy0
         5QrTcXRWiwQE0gxsZXbo57RaJvDVb0n9CreBX4wlghJElbAL4mytJjZnYdY+VeDaLG
         QJ6dMKTadasNXwboKlmZcDicRyC/ay7sCNEcdrqz2f0MoXfgck/ynkOsXYC31ejfto
         KrAU7+tmLHQtQ==
Date:   Thu, 22 Sep 2022 10:17:31 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH RFC xfrm-next v3 0/8] Extend XFRM core to allow full
 offload configuration
Message-ID: <YywMCztNrTxE5QqC@unreal>
References: <cover.1662295929.git.leonro@nvidia.com>
 <Yyg23x8HtBqiB1Oc@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yyg23x8HtBqiB1Oc@unreal>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 19, 2022 at 12:31:11PM +0300, Leon Romanovsky wrote:
> On Sun, Sep 04, 2022 at 04:15:34PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> 
> <...>
> 
> > Leon Romanovsky (8):
> >   xfrm: add new full offload flag
> >   xfrm: allow state full offload mode
> >   xfrm: add an interface to offload policy
> >   xfrm: add TX datapath support for IPsec full offload mode
> >   xfrm: add RX datapath protection for IPsec full offload mode
> >   xfrm: enforce separation between priorities of HW/SW policies
> >   xfrm: add support to HW update soft and hard limits
> >   xfrm: document IPsec full offload mode
> 
> Kindly reminder.

Hi Steffen,

Can we please progress with the series? I would like to see it is merged
in this merge window, so I will be able to progress with iproute2 and mlx5
code too.

It is approximately 3 weeks already in the ML without any objections.
The implementation proposed here has nothing specific to our HW and
applicable to other vendors as well.

Thanks

> 
> Thanks
