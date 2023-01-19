Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCFA674C5A
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 06:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbjATF3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 00:29:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjATF2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 00:28:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5084B898;
        Thu, 19 Jan 2023 21:23:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10604B82201;
        Thu, 19 Jan 2023 16:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5BDC433F1;
        Thu, 19 Jan 2023 16:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674145450;
        bh=NFTHn/7vSxjzDGwGqFQCBJWVrTJ8XQAglJR613dQjEY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MKzgIOCTg3d6qedJUWFgL4KWQ03dALduzZCSqvSiW85t/TK3CiCbIOAaLjO+sWW/t
         WRGcqG7JcfjP15EOy6TCWFWEOZxwZ/qBdJbIQS8SfjkkipjKRLrRCkZqNsMLrJdcY6
         uWoKnkmgK0qkYw5WCYKUkxfpELNhv4B8p8AIGAK5VtqCOSsnmHgBQyhIVvKBmOozWA
         Di2Im6ZMZlNWbOHF2a5LZMvs10ny24cBZ4MAZSl1u5aDDRVhj2fS51Nv0RWDPj1XrR
         VajHmdobA7iGplscGnOyNFpC4exF3GWKjFa0GdxMnlDJDJXU98X0Xy8Z3dnit2Bnli
         TaFo5S8QsMstA==
Date:   Thu, 19 Jan 2023 16:24:02 +0000
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
Subject: Re: [PATCH v4 10/11] leds: syscon: Get rid of custom
 led_init_default_state_get()
Message-ID: <Y8luolbdQoOZtPrn@google.com>
References: <20230103131256.33894-1-andriy.shevchenko@linux.intel.com>
 <20230103131256.33894-11-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230103131256.33894-11-andriy.shevchenko@linux.intel.com>
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
> ---
>  drivers/leds/leds-syscon.c | 49 ++++++++++++++++++--------------------
>  1 file changed, 23 insertions(+), 26 deletions(-)

Applied, thanks

-- 
Lee Jones [李琼斯]
