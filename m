Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9665661EB31
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 07:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiKGGxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 01:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiKGGxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 01:53:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17FF1277D;
        Sun,  6 Nov 2022 22:53:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6157EB80B8D;
        Mon,  7 Nov 2022 06:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17AC2C433D6;
        Mon,  7 Nov 2022 06:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667803996;
        bh=hFSwA4D2HRstbkfDZryZkIMXCM2YSD++NhNBLJZwGUE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SDTy4s/wNH2TzvyPyY1NYadZz2lYdjEHiQ6kgwQ9QQZ1rUYOkhrgtCPBDp9YPLuOZ
         mOPBzXD8iYuV/mswtBI5KNFkgclZwgHk7KviPxtWh2JDQBDB9eSi4U3JqTsFAQUwxr
         itpUvbZOz1RERIdpUkE9FOWUPTPe3zFsplFfLj9XVsccRbnk5LUCkXSknPMAcXe8CW
         sUyaZ2eJBdor5GX4HFzEkZRkjPCHj9K5hC+B6BP2jK5jq9JdMAD+7kyUATzk/UuEk9
         swTnRDfrg4AHARUxcpNDaTEsha/BLEDiKBeD7uPpJgsmnLm3m/u5NinAL0g5SfGNWy
         Z6TGjFwh480qQ==
Date:   Mon, 7 Nov 2022 08:53:12 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Roman Gushchin <roman.gushchin@linux.dev>
Cc:     netdev@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: macb: implement live mac addr change
Message-ID: <Y2irWEE08Ejelppn@unreal>
References: <20221104204837.614459-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104204837.614459-1-roman.gushchin@linux.dev>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 01:48:37PM -0700, Roman Gushchin wrote:
> Implement live mac addr change for the macb ethernet driver.
> 
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>  drivers/net/ethernet/cadence/macb_main.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
