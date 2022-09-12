Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC905B62C9
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 23:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbiILVdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 17:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiILVdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 17:33:38 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF634B4A1;
        Mon, 12 Sep 2022 14:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Xq2iOEzVHorImSs+U7Cqx1HvegvtoeOSLKhQVjGEu5M=; b=kyLMJCDtNsqqNNB+RSYoT8PzbC
        /M2cBErMkpSM9NJbnHIrcrAtP+/bxj9eJpvNE1G5i5PX3647gM5NIFraDi3muBEqFtY1BBZk0ZNcj
        U68ajft11E+ZONtTRJ1y3+DdJiUv33dvERrQlPeuMht6pM/qII1N96CGTKum/v+Q7hbI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oXr3g-00GWcj-Bq; Mon, 12 Sep 2022 23:33:36 +0200
Date:   Mon, 12 Sep 2022 23:33:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, Tristram.Ha@microchip.com
Subject: Re: [RFC Patch net-next 0/4] net: dsa: microchip: ksz9477: enable
 interrupt for internal phy link detection
Message-ID: <Yx+lsOg3f3PVbcGZ@lunn.ch>
References: <20220909160120.9101-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909160120.9101-1-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 09, 2022 at 09:31:16PM +0530, Arun Ramadoss wrote:
> This patch series implements the common interrupt handling for ksz9477 based
> switches and lan937x. The ksz9477 and lan937x has similar interrupt registers
> except ksz9477 has 4 port based interrupts whereas lan937x has 6 interrupts.
> The patch moves the phy interrupt hanler implemented in lan937x_main.c to
> ksz_common.c, along with the mdio_register functionality.

It is a good idea to state why it is an RFC. What sort of comments do
you want?

    Andrew
