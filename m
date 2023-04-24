Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE7D6ECFA7
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 15:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbjDXNwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 09:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbjDXNwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 09:52:24 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E2B83C5
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 06:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=K2rXEsxqUzDvDqW9dKStsn0Q0k2J7NDjTmnp/RdyW4Y=; b=GPUnuUdOQmAbs5ZVc+YFkIS4M9
        blSaSRncQ7hU80p8ABiT6GSEYugdaM8+3P/Ci0lZvcZ8WWhQdj6osKagKMEPycQg3bzl1nCNlF6JF
        V8pgmBvbQrT5V3kTS1v/nRLw+PZaEOXpwzzyuuZx0f7vKbbe0KoNmfSj3RkE13MqqYiU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pqwbM-00B66Z-2u; Mon, 24 Apr 2023 15:51:32 +0200
Date:   Mon, 24 Apr 2023 15:51:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexander Stein <alexander.stein@ew.tq-group.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net: phy: dp83867: Add led_brightness_set support
Message-ID: <82043096-636a-41ec-bf97-94f22f1920ce@lunn.ch>
References: <20230424134625.303957-1-alexander.stein@ew.tq-group.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424134625.303957-1-alexander.stein@ew.tq-group.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 03:46:25PM +0200, Alexander Stein wrote:
> Up to 4 LEDs can be attached to the PHY, add support for setting
> brightness manually.

Hi Alexander

Please see https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html

You should put in the subject line which network tree this is for.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
