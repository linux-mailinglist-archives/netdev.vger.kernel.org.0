Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 118D3509F0A
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 13:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382680AbiDULyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 07:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382612AbiDULyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 07:54:53 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A8C2C656;
        Thu, 21 Apr 2022 04:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FkRpbQL2kh2V0VErCDvPMcemB1ZOU18oNdPFn0wD/bY=; b=2vdKGntIznOxZVVgWps6/JiBxl
        YiumyZnB/ml5xDjwSg5y3xafCRuLjUmb59qqIbiT1gfgIm4FpMUszcfBtYVCeVnU59PUQDbvBK2ws
        Y7tThOOclE2g/zUmUzuS/JJk3xoEzuuLJMO2R7wEjxe5OWhOJk43PNPlm4z/1U4oKnIM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nhVLl-00GnKX-Lh; Thu, 21 Apr 2022 13:51:53 +0200
Date:   Thu, 21 Apr 2022 13:51:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] net: phy: marvell: Add LED accessors for Marvell
 88E1510
Message-ID: <YmFFWd42Nol7Lrlm@lunn.ch>
References: <20220420124053.853891-1-kai.heng.feng@canonical.com>
 <20220420124053.853891-5-kai.heng.feng@canonical.com>
 <YmAgq1pm37Glw2v+@lunn.ch>
 <CAAd53p6UAhDC2mGkz3_HgVs7kFgCwjfu2R+9FfROhToH2R6CjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAd53p6UAhDC2mGkz3_HgVs7kFgCwjfu2R+9FfROhToH2R6CjA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This is not feasible.
> If BIOS can define a method and restore the LED by itself, it can put
> the method inside its S3 method and I don't have to work on this at
> the first place.

So maybe just declare the BIOS as FUBAR and move on to the next issue
assigned to you.

Do we really want the maintenance burden of this code for one machines
BIOS? Maybe the better solution is to push back on the vendor and its
BIOS, tell them how they should of done this, if the BIOS wants to be
in control of the LEDs it needs to offer the methods to control the
LEDs. And then hopefully the next machine the vendor produces will
have working BIOS.

Your other option is to take part in the effort to add control of the
LEDs via the standard Linux LED subsystem. The Marvel PHY driver is
likely to be one of the first to gain support this for. So you can
then totally take control of the LED from the BIOS and put it in the
users hands. And such a solution will be applicable to many machines,
not just one.

       Andrew
