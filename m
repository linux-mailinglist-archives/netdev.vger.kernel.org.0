Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3328363F877
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 20:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiLATka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 14:40:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiLATk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 14:40:29 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8A49790F;
        Thu,  1 Dec 2022 11:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=8ohI0dOzt+JffUBvEqUqyBPSGVnWVbhSEHTKkIfOYI4=; b=Q6qnuuPcY3Z+rEmj6GcAyBWSdY
        qskQtUoTBkfExug3nBVa5Hhz1yjm3eMUDAqKqqHW7bcGwVQoGAoCzfsdcoceFdgLNCHrzy1ZwDAPQ
        RJwsZzOga9P+Guy7gWvRUTR5ytFFMGk1OGGwIDrQrHsvZ7XBnutFu9hXEI0TxKKAbYcw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0pQ0-0045i8-NG; Thu, 01 Dec 2022 20:40:24 +0100
Date:   Thu, 1 Dec 2022 20:40:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Tim Harvey <tharvey@gateworks.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Subject: Re: [PATCH 0/3] add dt configuration for dp83867 led modes
Message-ID: <Y4kDKI0NCFRt/jBv@lunn.ch>
References: <20221118001548.635752-1-tharvey@gateworks.com>
 <Y3bRX1N0Rp7EDJkS@lunn.ch>
 <CAJ+vNU3P-t3Q1XZrNG=czvFBU7UsCOA_Ap47k9Ein_3VQy_tGw@mail.gmail.com>
 <Y3eEiyUn6DDeUZmg@lunn.ch>
 <CAJ+vNU2pAQh6KKiX5x7hFuVpN68NZjhnzwFLRAzS9YZ8bWm1KA@mail.gmail.com>
 <Y3q5t+1M5A0+FQ0M@lunn.ch>
 <CAJ+vNU0yjsJjQLWbtZmswQOyQ6At-Qib8WCcVcSgtDmcFQ3hGQ@mail.gmail.com>
 <6388f310.050a0220.532be.7cd5@mx.google.com>
 <CAJ+vNU2AbaDAMhQ0-mDh6ROC7rdkbmXoiSijRTN2ryEgT=QHiQ@mail.gmail.com>
 <6388f4ab.5d0a0220.a137.068e@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6388f4ab.5d0a0220.a137.068e@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> But I never got a review from LED team and that result in having the
> patch stalled and never merged... But ok I will recover the work and
> recheck/retest everything from the start hoping to get more traction
> now...

There are a few emails suggesting the LED team has disappeared, and
there are a lot of patches waiting to be merged. I think they were
asking GregKH if he could do something about this.

https://lore.kernel.org/netdev/Y3zQ5ZtAU4NL3hG4@smile.fi.intel.com/

I don't know if anything has changed since then.

Until this is solved, i don't think you will get much from the LED
people. Best you can get is more netdev reviews.

	Andrew
