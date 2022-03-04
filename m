Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05EDB4CD62D
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 15:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238653AbiCDOSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 09:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbiCDOSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 09:18:12 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60EE01BAF0C;
        Fri,  4 Mar 2022 06:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fc5dWG3q5m1cYUkVdN+LsNuTJy5E+l+aX5nXhLu/16Y=; b=MuHzsVb2Ih5KqtR1+dPpAKS7Ke
        2gyDBuYvz+kI6k6amskMynJewZLZ1P81K54zAOXF/jt73lM4jAbP4/ZE+Zfr3IAjYxyGNsLWlwKq9
        t1CW0dzJFLhLTK0a7TbVu9KnG4/pTB4YEXYcb3P5SLI78oTT+N72RjmV5PoU+1Q0JKL0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nQ8kB-009Eyz-3O; Fri, 04 Mar 2022 15:17:19 +0100
Date:   Fri, 4 Mar 2022 15:17:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     David Miller <davem@davemloft.net>, Divya.Koppera@microchip.com,
        netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, madhuri.sripada@microchip.com,
        manohar.puri@microchip.com
Subject: Re: [PATCH net-next 0/3] Add support for 1588 in LAN8814
Message-ID: <YiIfb821yzXf7YqY@lunn.ch>
References: <20220304093418.31645-1-Divya.Koppera@microchip.com>
 <164639821168.27302.1826304809342359025.git-patchwork-notify@kernel.org>
 <YiIO7lAMCkHhd11L@lunn.ch>
 <20220304.132121.856864783082151547.davem@davemloft.net>
 <20220304140628.GF16032@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304140628.GF16032@hoboy.vegasvil.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 04, 2022 at 06:06:28AM -0800, Richard Cochran wrote:
> On Fri, Mar 04, 2022 at 01:21:21PM +0000, David Miller wrote:
> 
> > Sorry, it seemed satraightforward to me, and I try to get the backlog under 40 patches before
> > I hand over to Jakub for the day.
> 
> Day by day, it seems like there is more and more of this PTP driver
> stuff.  Maybe it is time for me to manage a separate PTP driver tree.
> I could get the reviews and acks, then place a PR to netdev or lkml
> when ready.
> 
> Thoughts?

Hi Richard

My perception is that you also like to sleep at nights, and cannot
keep up with David rapid pace. So setting up your own tree, collecting
reviews and acks yourself will help you and the quality of the PTP
code. So yes, go for it.  I just think it is wrong you have to do
this.

    Andrew
