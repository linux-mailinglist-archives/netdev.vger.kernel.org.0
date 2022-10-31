Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C396132D2
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 10:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbiJaJfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 05:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiJaJfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 05:35:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890B46353;
        Mon, 31 Oct 2022 02:35:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38AA8B8133A;
        Mon, 31 Oct 2022 09:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233A8C43470;
        Mon, 31 Oct 2022 09:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667208908;
        bh=IzjdJvJoYXUsl9z05KFgJWsGxn4+PzgaGUgkMQtF2zU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CilgLNxMqlIsiOz8YJhBdKUZDEvjiQH9oUgaCv4ADWHQ6JnyBsFFVMqOE4y1bt3QY
         Dadygk4vA3yniWmt9ardJvt0jHxcGi2VxnsxLKqyCSDljOBNoBMOu6sngn0taHim9e
         SAS/rTtcBM6rnSC3nNK634YR6va0seVSbVxaspD4LHuQvI6KUAinmq+mzqSOSVziQh
         ja3Z2UWJoi+dcZGsNaQjozhp5Fdp7W4xP/I2bcTbJkQkazoHkF5j4ELoKyVjfRjNMf
         D4jMbu5aBYd1NdC6YG5b7CvzHcyqQ975+Voo5vStfLLs71AzzRKnUdDWr8dNtvmsNN
         OjlnZ4P/UvIBg==
Date:   Mon, 31 Oct 2022 09:35:01 +0000
From:   Lee Jones <lee@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [RFC v4 net-next 12/17] mfd: ocelot: add shared resource names
 for switch functionality
Message-ID: <Y1+Wxaub15XveooC@google.com>
References: <20221008185152.2411007-1-colin.foster@in-advantage.com>
 <20221008185152.2411007-13-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221008185152.2411007-13-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 08 Oct 2022, Colin Foster wrote:

> The switch portion of the Ocelot chip relies on several resources. Define
> the resource names here, so they can be referenced by both the switch
> driver and the MFD.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
> 
> v4
>     * New patch. Previous versions had entire structures shared,
>       this only requires that the names be shared.
> 
> ---
>  include/linux/mfd/ocelot.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/include/linux/mfd/ocelot.h b/include/linux/mfd/ocelot.h
> index dd72073d2d4f..b80f2f5ff1d6 100644
> --- a/include/linux/mfd/ocelot.h
> +++ b/include/linux/mfd/ocelot.h
> @@ -13,6 +13,15 @@
>  
>  struct resource;
>  
> +#define OCELOT_RES_NAME_ANA	"ana"
> +#define OCELOT_RES_NAME_QS	"qs"
> +#define OCELOT_RES_NAME_QSYS	"qsys"
> +#define OCELOT_RES_NAME_REW	"rew"
> +#define OCELOT_RES_NAME_SYS	"sys"
> +#define OCELOT_RES_NAME_S0	"s0"
> +#define OCELOT_RES_NAME_S1	"s1"
> +#define OCELOT_RES_NAME_S2	"s2"

I've never been a fan of defining name strings.

The end of the define name is identical to the resource names.

This also makes grepping that much harder for little gain.

-- 
Lee Jones [李琼斯]
