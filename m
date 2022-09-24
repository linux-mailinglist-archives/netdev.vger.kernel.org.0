Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5D8F5E88E8
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 08:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbiIXG5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 02:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233339AbiIXG5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 02:57:15 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B80AD11A02;
        Fri, 23 Sep 2022 23:57:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2A0D7CE0A26;
        Sat, 24 Sep 2022 06:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27A3C433C1;
        Sat, 24 Sep 2022 06:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664002631;
        bh=RjJjcNJ/URRIy/zLeVjpveh9l8Vl/MNtMcQNad0U4Ug=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AED4EE94LTWktqgVptY3m+vsWQWH8pOA08gxMZEBjm2+DEGAKATC8DrpMtFd6fIVI
         wrk8gcRBoC8IHegSC/v7SPKICZ/mxxKyl6g7/PDu3s1MZA8prTLBc8jc6vPQuxBeP6
         uidFkUuQrApcisWGBcDhefXbu0F1pORiVpUh374kh6G7tLcBCMPyWNscyZuT5tiVHn
         vFKQ/GvweVCAPYgLyJqS6+cpmmrBfJ9ugOYJaJCM+IiqKqgP0GXUsMeyJ/e6+Tj1Df
         zSUIeM0AtWB5ZyNuRDr6is7Os2cdO1fGStCzcswzcIM2gXc4wkojXBjNLSgwQQcWQF
         7WO++ScFM38gA==
Date:   Sat, 24 Sep 2022 12:27:07 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, "kishon@ti.com" <kishon@ti.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH v2 0/8] treewide: Add R-Car S4-8 Ethernet Switch support
Message-ID: <Yy6qQ/CKfshid/B7@matsya>
References: <20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com>
 <20220921074004.43a933fe@kernel.org>
 <TYBPR01MB534186B5BA8E5936C46E3B6DD84E9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYBPR01MB534186B5BA8E5936C46E3B6DD84E9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22-09-22, 00:46, Yoshihiro Shimoda wrote:
> Hi Jakub,
> 
> Thank you for your comment!
> 
> > From: Jakub Kicinski, Sent: Wednesday, September 21, 2022 11:40 PM
> > 
> > On Wed, 21 Sep 2022 17:47:37 +0900 Yoshihiro Shimoda wrote:
> > > Subject: [PATCH v2 0/8] treewide: Add R-Car S4-8 Ethernet Switch support
> > 
> > I think you may be slightly confused about the use of the treewide
> > prefix. Perhaps Geert or one of the upstream-savvy contractors could
> > help you navigate targeting the correct trees?
> 
> I thought we have 2 types about the use of the treewide:
> 1) Completely depends on multiple subsystems and/or
>    change multiple subsystems in a patch.
> 2) Convenient for review.
> 
> This patch series type is the 2) above. However, should I use
> treewide for the 1) only?

No, How is it convenient for review.. I would like to see a series just
for phy... I dont need to see the whole other things...

Maybe Convenient for you to toss the pile to upstream reviewers, surely
not for us!

-- 
~Vinod
