Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F1F65E75B
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 10:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbjAEJHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 04:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232066AbjAEJHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 04:07:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 900CF3AAA2
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 01:07:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 280356192A
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 09:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10658C433D2;
        Thu,  5 Jan 2023 09:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672909638;
        bh=ZBllUO9pdJ1+Bbn2oBkBxkiqpBr9yNmvlidbGB79xwQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qqgwg8zg/g8W+EOvWv2aNHhT37lVX09YltnjGtPdnOhvMRXQrmYVixCbYBNg4ugGS
         HE8M+WIou4/pjomN2jzfKTMYsYb0ytsJDqp4w5b5N34g+ERjVBOIPHXzgrrp9TULDi
         mCYKiR8uWdK0L2/uy8GbeyaWb2TL9lycTfT7RNLAevnopLidXJ9s+BnksbmLHHXx1D
         ImuGOZQ+zTzD6MtTRsvNDe9HNpp+sG0Gup6JDthrESMSW1IwsniyP7nRAp5pEcflF+
         0u3CrHv5USwn+0+BqpRRwBZBPP5m8aCDSmmRcnsZRh7+LTbKUIQ6529kLCnbuqSMxo
         OQJWQCs3wU+mw==
Date:   Thu, 5 Jan 2023 11:07:14 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com
Subject: Re: [PATCH v2 net-next 2/3] net: ethernet: enetc: get rid of
 xdp_redirect_sg counter
Message-ID: <Y7aTQuklChAmRp8b@unreal>
References: <cover.1672840490.git.lorenzo@kernel.org>
 <681a7f4f2ead18decd3841ee1b92e47ced9cab1f.1672840490.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <681a7f4f2ead18decd3841ee1b92e47ced9cab1f.1672840490.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 02:57:11PM +0100, Lorenzo Bianconi wrote:
> Remove xdp_redirect_sg counter and the related ethtool entry since it is
> no longer used.
> 
> Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/freescale/enetc/enetc.h         | 1 -
>  drivers/net/ethernet/freescale/enetc/enetc_ethtool.c | 2 --
>  2 files changed, 3 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
