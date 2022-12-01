Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 006AD63F883
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 20:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbiLATmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 14:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiLATmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 14:42:39 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1235AD2CD;
        Thu,  1 Dec 2022 11:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qHbGOUcw32092wDitkDdj/NcFV0kIbthIjQW9oIXmWU=; b=lebdUAMMbR6wv/+txOdgsXeA7U
        4TR4n6bN4En6BtjDtifGT/jC4Jvz8O/7se6Fv58sfVBmNfYQLzdVlJTvj/tAtIdY+MiIOFdxZLNK+
        OdCqIrxJgG0DHIieV12z+1GboXk0JEpAlwBuqjZYtTtiuRGlpBE065kNMCnr/lfBK5Rk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0pS3-0045jA-0Z; Thu, 01 Dec 2022 20:42:31 +0100
Date:   Thu, 1 Dec 2022 20:42:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Conor Dooley <conor@kernel.org>
Cc:     Yanhong Wang <yanhong.wang@starfivetech.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
Subject: Re: [PATCH v1 7/7] riscv: dts: starfive: visionfive-v2: Add phy
 delay_chain configuration
Message-ID: <Y4kDppmVnL3BV44Z@lunn.ch>
References: <20221201090242.2381-1-yanhong.wang@starfivetech.com>
 <20221201090242.2381-8-yanhong.wang@starfivetech.com>
 <Y4jpDvXo/uj9ygLR@spud>
 <Y4kAyAhBseNmmDo8@spud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4kAyAhBseNmmDo8@spud>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 07:30:16PM +0000, Conor Dooley wrote:
> On Thu, Dec 01, 2022 at 05:49:08PM +0000, Conor Dooley wrote:
> > On Thu, Dec 01, 2022 at 05:02:42PM +0800, Yanhong Wang wrote:
> > > riscv: dts: starfive: visionfive-v2: Add phy delay_chain configuration
> > > 
> > > Add phy delay_chain configuration to support motorcomm phy driver for
> > > StarFive VisionFive 2 board.
> 
> nit: please re-word this commit next time around to actually say what
> you're doing here. I didn't notice it initially, but this patch is doing
> a lot more than adding `delay_chain` configuration. To my dwmac unaware
> brain, there's nothing hits for that term outside of the changelog :(

Hi Conor

I suspect once we see the documentation of the binding, it will get
rejected and implemented differently. So i would not worry too much
about this at the moment.

      Andrew
