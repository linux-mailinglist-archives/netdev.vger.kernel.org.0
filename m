Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02785B62A0
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 23:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiILVWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 17:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiILVWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 17:22:21 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7CD32BB3C;
        Mon, 12 Sep 2022 14:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wSRxuhn+VS6VSIonEQZu8ZxnJXwUcg39yEVJ/+Uso/c=; b=Kq1XTaJpvvKEQnKYz5RG4KWY+Z
        Od6c7E//BhYUQ4rRjd4YL2Mytrj2Aam+BiHMGowgpI2nHE6BJDX/xoOwOPl1JaaD2gxrUBisdbsPH
        4da0PI/16Zm1ard6dSDuq7ci4zbEZ/nvJf+r60vu09Rm7viveRCEGH34iWW3zqAA5c7g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oXqsk-00GWZI-36; Mon, 12 Sep 2022 23:22:18 +0200
Date:   Mon, 12 Sep 2022 23:22:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, Tristram.Ha@microchip.com
Subject: Re: [RFC Patch net-next 1/4] net: dsa: microchip: determine number
 of port irq based on switch type
Message-ID: <Yx+jCnXnOJVTUrhe@lunn.ch>
References: <20220909160120.9101-1-arun.ramadoss@microchip.com>
 <20220909160120.9101-2-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909160120.9101-2-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 09, 2022 at 09:31:17PM +0530, Arun Ramadoss wrote:
> Currently the number of port irqs is hard coded for the lan937x switch
> as 6. In order to make the generic interrupt handler for ksz switches,
> number of port irq supported by the switch is added to the
> ksz_chip_data. It is 4 for ksz9477, 2 for ksz9897 and 3 for ksz9567.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
