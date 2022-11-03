Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F128B617547
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 04:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbiKCDwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 23:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbiKCDwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 23:52:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A21118B39;
        Wed,  2 Nov 2022 20:50:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 241F3B8265F;
        Thu,  3 Nov 2022 03:50:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B2EC433D6;
        Thu,  3 Nov 2022 03:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667447448;
        bh=97A59RvEtfi2e8kl+dyOvFuWFGowJpW0X0t7rEKcyX4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V2BXynUsIxv9yyu0yDjU5qQNw8X3Uj8NlaB0ZjCE7DV+jdTrPr9SCNoeFiwjiwRQQ
         gD/WWbsUb5p4yaim9iwGe/VEsaXRkabiioDsV9YW5eCkIZyD/LVPxyFgKVvWAp4VaP
         pRj0GnkP7aB3mtfYTasFXbP9o39NpC+0n0C5INd2P5uUk/doMh+e15hkiwGi6JxNlh
         WulZdWgXG0N+N061NUOv76FJ1h9M4cnzJnof5m8l+2oNAOx166AAi3r0vvWcgqHBLp
         1glovQOcLIII3ouCkyc2uIuh9atqmTW9xTbOi5WRYY/GWum4L883XaiaetNY1Wf1BJ
         eHCZoAv73W4XA==
Date:   Wed, 2 Nov 2022 20:50:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>
Subject: Re: [PATCH net-next 6/6] net: dsa: microchip: add dev_err_probe in
 probe functions
Message-ID: <20221102205047.10867032@kernel.org>
In-Reply-To: <20221102041058.128779-7-rakesh.sankaranarayanan@microchip.com>
References: <20221102041058.128779-1-rakesh.sankaranarayanan@microchip.com>
        <20221102041058.128779-7-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Nov 2022 09:40:58 +0530 Rakesh Sankaranarayanan wrote:
> +			return dev_err_probe(&mdiodev->dev,
> +					     PTR_ERR(dev->regmap[i])
> +					     "Failed to initialize regmap%i\n",
> +					     ksz8863_regmap_config[i].val_bits);
>  		}

Does not build.
