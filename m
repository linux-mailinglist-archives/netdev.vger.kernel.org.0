Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52F436ED0F2
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 17:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbjDXPHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 11:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbjDXPHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 11:07:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8941EC6
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 08:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=e49ctt4VIkk+0kX7DHEL7WyFIPi3zVHU2VfdOmLi0sE=; b=DrO0bf0lJw+cP49jBaJ0x8bq7z
        /8qt37hfOdDZ+2y8ZqjWJLNGAM8jXhbKxqG3vNizKi8iYOEf95qLiYgEIfyDx1+jH772JVALP86ob
        ss++Fr2D0ul6AnJdXYBi5YNCoL7aHCYDeirepuijsEqodpjt1V0yuZAT4k/AF5K/mzYg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pqxY6-00B6Jz-5T; Mon, 24 Apr 2023 16:52:14 +0200
Date:   Mon, 24 Apr 2023 16:52:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexander Stein <alexander.stein@ew.tq-group.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net: phy: dp83867: Add led_brightness_set support
Message-ID: <27fd957f-17fe-4ada-890d-865af611b1c3@lunn.ch>
References: <20230424134625.303957-1-alexander.stein@ew.tq-group.com>
 <82043096-636a-41ec-bf97-94f22f1920ce@lunn.ch>
 <2142096.irdbgypaU6@steina-w>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2142096.irdbgypaU6@steina-w>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Please see
> > https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html
> > 
> > You should put in the subject line which network tree this is for.
> 
> Ah, sorry wasn't aware of that.
> 
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> Thanks, you want me to resend a v2 with the subject fixed and your tag added?

No need, just try to remember for future submissions.

   Andrew
