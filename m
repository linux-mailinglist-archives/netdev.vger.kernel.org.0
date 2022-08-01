Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD0F9586BC2
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 15:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbiHANRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 09:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbiHANR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 09:17:27 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D27033A14
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 06:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=iET4Gd+dzwI9Hl1ttIYQzHG3ExTzRi7Ugvbts3F/At0=; b=jBr9OH6XD43mkeRgCj0RGeawiX
        0RoayRMGyaq5SeKM6AbGpoEWYXJ5G8DNvk57EoYz8z1ois3KVrnJrCVwZYN7HRcpTrMb7LrC2E6Pf
        brmmZDqB2r8pf8jHH9VWKQQ/zNeXOin5+5t9FLFzPDPBod5Oc41Wcq6CucZz/+GL09yk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oIVHv-00C9m1-DF; Mon, 01 Aug 2022 15:16:51 +0200
Date:   Mon, 1 Aug 2022 15:16:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jerome Brunet <jbrunet@baylibre.com>
Cc:     Da Xue <da@lessconfused.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>
Subject: Re: Meson GXL and Rockchip PHY based on same IP?
Message-ID: <YufSQ7o1szPAhAfr@lunn.ch>
References: <ca9560eb-af9c-3cfa-c35e-388e7e71aab7@gmail.com>
 <CAFBinCCMinq1U2Pqn2LPjC9c+HqfHjvW81b1ENMxdoGmB6byEw@mail.gmail.com>
 <88d6ef05-f77a-57a2-f34a-e3998a8d70d4@gmail.com>
 <CACdvmAgSvsYj6zorYDrBaEUvZzPi_c0XpVzx3fz8nHp8+TXMuQ@mail.gmail.com>
 <1jzggowdo5.fsf@starbuckisacylon.baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1jzggowdo5.fsf@starbuckisacylon.baylibre.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Per Jerome, both are OmniPHY IP.
> >
> 
> I believe it to be the case, yes.
> 
> However, the version of the IP could be different.
> The integration the SoC vendor did is very likely to be different too.

It has been pointed out that they have different quirks. It would be
good to check if any of the quirks in one should be applied to the
other.

	Andrew
