Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33AD5673FCA
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 18:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjASRWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 12:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjASRWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 12:22:04 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9865593D9;
        Thu, 19 Jan 2023 09:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=cqG1MRAXLPrHaT+eAcJye0uuBLqSJFewuZYbSXYEZvo=; b=Tz5pVxX1z7Y3PKklioNj4Bdv+a
        lKq0NRHt9xkawqp2p35oH+WxcKLOX4kbAKNFCeCazSgl8RH4codmTFH5O50dWAtK6ml20dbiw7FDY
        wNqYUBRBj2I0LBJt2Hb8WNMo4SRjg3C4K3y5QnAhPWuHlOfEWNX169BgrAghaR6dd8Ic=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pIYbs-002c3x-Pa; Thu, 19 Jan 2023 18:21:56 +0100
Date:   Thu, 19 Jan 2023 18:21:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jerome Brunet <jbrunet@baylibre.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Da Xue <da@lessconfused.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: mdio: add amlogic gxl mdio mux support
Message-ID: <Y8l8NJdulOTX4GpI@lunn.ch>
References: <20230116091637.272923-1-jbrunet@baylibre.com>
 <Y8dimCI7ybeL09j0@lunn.ch>
 <1jr0vqyet1.fsf@starbuckisacylon.baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1jr0vqyet1.fsf@starbuckisacylon.baylibre.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I usually avoid doing this since the DT part is intended for another
> maintainer. The idea is make life easy for them and let them pick the
> entire series (or not). I don't mind sending the DT update along if it
> is the perferred way with netdev.
> 
> FYI, the DT update would look like this :
> https://gitlab.com/jbrunet/linux/-/commit/1d38ccf1b9f264111b1c56f18cfb4804227d3894.patch
> 
> >
> >> This has been tested on the aml-s905x-cc (LePotato) for the internal path
> >> and the aml-s912-pc (Tartiflette) for the external path.
> >
> > So these exist in mainline, which is enough for me.
> 
> Yes the boards exists in mainline, there are still using the mdio-mux-mmioreg driver
> ATM

The point of posting the actual users is sometimes we get vendor crap
with no actual in tree users. We want to avoid that. It can be enough
to mention in the cover letter than a future patchset will change the
DT files X, Y and Z, making it clear there are in tree users.

   Andrew
