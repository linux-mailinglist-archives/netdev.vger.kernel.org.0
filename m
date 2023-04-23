Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B900D6EC132
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 18:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjDWQwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 12:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjDWQwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 12:52:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7A51701;
        Sun, 23 Apr 2023 09:52:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 815AA60F7A;
        Sun, 23 Apr 2023 16:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E77FC433EF;
        Sun, 23 Apr 2023 16:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682268732;
        bh=PB08aDW0cTYvbXemFXw/b311nnJVY0AnTDE0hJjddzs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FStSQT1kbjlWhJ95M02fD/VJD/fOHWget/dCThyEfnTIYVatyz50owf0Pl4lqUGgT
         T0QDS2fVg8yL5KMEuTJK7ZxTEZ9AmTaG51NKzIxpyEYYcw+u3SnIEaBBtNcD24ii4o
         CGFEEd4IbWMh1WTXsOBp/ZPjpRUfQvSa7aMWgNEdMFhvDmcDjhdb42QbP0AAhU7EZD
         Y1QVYOWDnIpFfjCoWsZio2EewB6c0YZSNq/TC2tZlJCdlXGTJAK+DueJK7ozxjsaUt
         ryz5OtbnvUjEBaL95clPEEGPP0QDoosQsLT+TxJYTbx7Eso/ZY8mC7GbQSAMqg17jJ
         NoOWJLzXFZOcg==
Date:   Sun, 23 Apr 2023 19:52:08 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, richardcochran@gmail.com, sgoutham@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com
Subject: Re: [net PATCH 6/9] octeontx2-pf: mcs: Match macsec ethertype along
 with DMAC
Message-ID: <20230423165208.GI4782@unreal>
References: <20230423095454.21049-1-gakula@marvell.com>
 <20230423095454.21049-7-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230423095454.21049-7-gakula@marvell.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 03:24:51PM +0530, Geetha sowjanya wrote:
> From: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> On CN10KB silicon a single hardware macsec block is
> present and offloads macsec operations for all the
> ethernet LMACs. TCAM match with macsec ethertype 0x88e5
> alone at RX side is not sufficient to distinguish all the
> macsec interfaces created on top of netdevs. Hence append
> the DMAC of the macsec interface too. Otherwise the first
> created macsec interface only receives all the macsec traffic.
> 
> Fixes: c54ffc73601c ("octeontx2-pf: mcs: Introduce MACSEC hardware offloading")
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> ---
>  .../net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c  | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
