Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB355A63CE
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 14:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiH3Mrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 08:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiH3Mrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 08:47:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86C8ABD64;
        Tue, 30 Aug 2022 05:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3DFiWf/O2nEaK0RaIY+HnSISDVWcCiaB89634qTWNxY=; b=3atNH1u7rzWigXKovzGkZsKbF7
        xfCv9cZKzJPsNhPMA6HAYnjVenVH3yWIRe7VQFK3gBWsdrcpuT/S1bCsXbz15GgyGvCWp1UACwFkj
        GwByX0f2UEQ1e4IQjGqBAHHwIPfezuJM643gdLEFI5I8kwHJbjymxT2AKadDA9bUSm8M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oT0ee-00F4Xx-9h; Tue, 30 Aug 2022 14:47:44 +0200
Date:   Tue, 30 Aug 2022 14:47:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Tristram Ha <Tristram.Ha@microchip.com>
Subject: Re: [RFC Patch net-next v3 2/3] net: dsa: microchip: add reference
 to ksz_device inside the ksz_port
Message-ID: <Yw4G8FA1BjA9hfD4@lunn.ch>
References: <20220830105303.22067-1-arun.ramadoss@microchip.com>
 <20220830105303.22067-3-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830105303.22067-3-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 30, 2022 at 04:23:02PM +0530, Arun Ramadoss wrote:
> struct ksz_port doesn't have reference to ksz_device as of now. In order
> to find out from which port interrupt has triggered, we need to pass the
> struct ksz_port as a host data. When the interrupt is triggered, we can
> get the port from which interrupt triggered, but to identify it is phy
> interrupt we have to read status register. The regmap structure for
> accessing the device register is present in the ksz_device struct. To
> access the ksz_device from the ksz_port, the reference is added to it
> with port number as well.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
