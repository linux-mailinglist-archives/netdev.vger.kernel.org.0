Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE2C56ECB18
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 13:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbjDXLOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 07:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjDXLOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 07:14:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC7830DB;
        Mon, 24 Apr 2023 04:14:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3954861E02;
        Mon, 24 Apr 2023 11:14:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035B4C433D2;
        Mon, 24 Apr 2023 11:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682334892;
        bh=cwGo+ngdI1ixtzZcTiwtleXirbr7LoJyLktw2MG3xC4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BaUFbWjXQ8bRFJpd/oSqzF+N5hRMTZ9yCtdSMyuiqDXrVH4ViEDmgK1NcYJmpgsiH
         In1s3zRge+ok6le+mXb2Q8WnWdWKMIMyp3N9OaL34yUYAiYbitKaxTken+8KiJGuPl
         h0NfB+mTw2XI6C2Ye5fUaLknfPjKNA4JAJZIL0yv3kENvyIQLSSbZsGLp7+WY05+tB
         nc2ecrXsxq5loaDucHRhkKJ8+39cs64T0/xyxwHWGBvpK89xtXsr98ns7/JTfckZFl
         hMhWr+5uYKnPu0AVzwIPsa32DFEAhjuSzY8kT4Ov2hTZ/MdD7SyhqGQnC73N7xldhJ
         E1GrjooV+ff3g==
Date:   Mon, 24 Apr 2023 14:14:49 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     wuych <yunchuan@nfschina.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: phy: dp83867: Remove unnecessary (void*) conversions
Message-ID: <20230424111449.GB10583@unreal>
References: <20230424101550.664319-1-yunchuan@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424101550.664319-1-yunchuan@nfschina.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 06:15:50PM +0800, wuych wrote:
> Pointer variables of void * type do not require type cast.
> 
> Signed-off-by: wuych <yunchuan@nfschina.com>
> ---
>  drivers/net/phy/dp83867.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
