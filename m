Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A86E05709D2
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 20:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbiGKSVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 14:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiGKSVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 14:21:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB7032468;
        Mon, 11 Jul 2022 11:21:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6C277CE140D;
        Mon, 11 Jul 2022 18:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FACC34115;
        Mon, 11 Jul 2022 18:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657563686;
        bh=Hvuab+BJPtTL2KeqX1EXN+dkDwg1hOiOXl5zkH6UkmU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jiDa2k7Tgjdcq8hRiumQkx460Nf7JmnyEKOsszWE9X+DXPHzqBqF2+6kbzTcgZfRR
         SmhDjH4oeCUgBXKQHfoto3Gw7l6LIVcZJYUP00RfEs81PgiXnwZZawi0YumsgWrHld
         a0LjZfw5aVzzR32Mi76Nt7PT/VXrQwEnD3L4WjhW70GmD2bJ8nXliTXCoApsdePjk/
         nR7fhH7cUh9cVo53mbW2hvM3Wp+wauA3uGe6/aGAUldUuLzYkkddOp2lU8s0nc1b/+
         nUxL4oGuGqRDKijs3EJjIFpeguce4Nnss1OXnm+mm5UmfW9LP5zGVsoE9odafGHEHM
         xabKF+o4xXcYA==
Date:   Mon, 11 Jul 2022 11:21:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        katie.morris@in-advantage.com
Subject: Re: [PATCH v13 net-next 0/9] add support for VSC7512 control over
 SPI
Message-ID: <20220711112116.2f931390@kernel.org>
In-Reply-To: <YsvWh8YJGeJNbQFB@google.com>
References: <20220705204743.3224692-1-colin.foster@in-advantage.com>
        <20220708200918.131c0950@kernel.org>
        <YsvWh8YJGeJNbQFB@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jul 2022 08:51:35 +0100 Lee Jones wrote:
> > Can this go into net-next if there are no more complains over the
> > weekend? Anyone still planning to review?  
> 
> As the subsystem with the fewest changes, I'm not sure why it would.

Yeah, just going by the tag in the subject. I have no preference,
looks like it applies cleanly to Linus'.

> I'd planed to route this in via MFD and send out a pull-request for
> other sub-system maintainers to pull from.
> 
> If you would like to co-ordinate it instead, you'd be welcome to.
> However, I (and probably Linus) would need a succinct immutable branch
> to pull from.

Oh, that'd be perfect, sorry, I didn't realize there was already a plan.
If you're willing to carry on as intended, please do.

Colin if there is another version please make a note of the above
merging plan in the cover letter and drop the net-next tag. 
Just in  case my goldfish brain forgets.
