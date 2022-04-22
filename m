Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B5F50BF2B
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 20:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiDVSCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 14:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235772AbiDVR7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 13:59:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F50C0E5F;
        Fri, 22 Apr 2022 10:56:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2959260C4F;
        Fri, 22 Apr 2022 17:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB90EC385A4;
        Fri, 22 Apr 2022 17:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650650178;
        bh=pELO3OB3ysuZ0HLLVF+76Td+K+2oS2riNU2A6pWuAQQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=onsonSbGFnf70GvkcHnOGcW60J4t+hCRPSu27HBZyLxIKZue1AzAFSAp7gjH7msAy
         t0bWaVEpRA3WGOcgHuNeTG/TtRZ6zffLZCIUwOnkpyZuVEPHXLRWW2Cal/dtJ12T5v
         nTpxci8oAWZSo5QBpzz4QmqdenLo4Zdre1qx51M/ZAJWSaYp0pLZwwlIpuSxFUBSas
         9FbqfJRUNPSMmuAUcLXE7jpiZa5GdlBpR92NXQldxxWavP+ByXXe8cui3KbuaeSaMp
         59jKUGcsn/PmnuFTs4UduUHL6KQwJQrU9bAyp8M/VwDEzFcbNdGhncx4chluhE/ar/
         WfBea4fkJeprA==
Date:   Fri, 22 Apr 2022 10:56:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, krzk+dt@kernel.org,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] dt-bindings: net: dsa: realtek: cleanup
 compatible strings
Message-ID: <20220422105616.15f4695d@kernel.org>
In-Reply-To: <CAJq09z5zU1WT4bHjv-=aX49XweKnOmLhnL2w8gSaBe7=Ov1APw@mail.gmail.com>
References: <20220418233558.13541-1-luizluca@gmail.com>
        <165044941250.8751.17513068846690831070.git-patchwork-notify@kernel.org>
        <CAJq09z5zU1WT4bHjv-=aX49XweKnOmLhnL2w8gSaBe7=Ov1APw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Apr 2022 17:29:00 -0300 Luiz Angelo Daros de Luca wrote:
> > This series was applied to netdev/net-next.git (master)
> > by David S. Miller <davem@davemloft.net>:
> >
> > On Mon, 18 Apr 2022 20:35:57 -0300 you wrote:  
> > > Compatible strings are used to help the driver find the chip ID/version
> > > register for each chip family. After that, the driver can setup the
> > > switch accordingly. Keep only the first supported model for each family
> > > as a compatible string and reference other chip models in the
> > > description.
> > >
> > > The removed compatible strings have never been used in a released kernel.
> > >
> > > [...]  
> >
> > Here is the summary with links:
> >   - [net,v2,1/2] dt-bindings: net: dsa: realtek: cleanup compatible strings
> >     https://git.kernel.org/netdev/net-next/c/6f2d04ccae9b
> >   - [net,v2,2/2] net: dsa: realtek: remove realtek,rtl8367s string
> >     https://git.kernel.org/netdev/net-next/c/fcd30c96af95
> >  
> 
> I was expecting to get those patches merged to net as well. Otherwise,
> the "realtek,rtl8367s" we are removing will get into a released
> kernel.

Seems reasonable. Unless someone objects I'll "yolo it" and apply 
the patches to net as well.
