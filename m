Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD79673E8A
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 17:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjASQUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 11:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjASQTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 11:19:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545965C0EF;
        Thu, 19 Jan 2023 08:19:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2B976CE24C8;
        Thu, 19 Jan 2023 16:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B973C433EF;
        Thu, 19 Jan 2023 16:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674145168;
        bh=IMLrxZxWaYCzpGqEBY+yM8xhvFB/xzDgIWYBYHHskLw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SZQiTsvESJOuHyvw3KdDpnIrGIlPCsrH2JdzfdFiId4lUHXr/ernvzN23/jChwVBN
         yeTBJfguripySoWqml+eB3PFquRSAhHZW5tbDRJk35OPqgR0XwEJB42kErus3sQHfO
         9QYrYA0r+EnjoC4w4xcle+FHaMROuJTnGjx4xI5umlweOTtntOO9u6P/K0vtdX36+S
         Z6lque8e7pu3dd6DrnbjMN7ESbFCiwmenOlqBmKIUAAVr2IsTldcB4RMKjpUjHorJ0
         gw+RIBX5zvr/DoscGBOqtT/CHtdCKXoGFZHlcaKkDUp1E2iJi+MbYpPeVGcThPX4Ym
         VeZbU4eR9+NNw==
Date:   Thu, 19 Jan 2023 16:19:20 +0000
From:   Lee Jones <lee@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Gene Chen <gene_chen@richtek.com>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v4 04/11] leds: bcm6328: Get rid of custom
 led_init_default_state_get()
Message-ID: <Y8ltiLGDxcZVh4Aq@google.com>
References: <20230103131256.33894-1-andriy.shevchenko@linux.intel.com>
 <20230103131256.33894-5-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230103131256.33894-5-andriy.shevchenko@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 03 Jan 2023, Andy Shevchenko wrote:

> LED core provides a helper to parse default state from firmware node.
> Use it instead of custom implementation.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/leds/leds-bcm6328.c | 49 ++++++++++++++++++-------------------
>  1 file changed, 24 insertions(+), 25 deletions(-)

Applied, thanks

-- 
Lee Jones [李琼斯]
