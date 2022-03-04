Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8534CD56F
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 14:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233886AbiCDNsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 08:48:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbiCDNsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 08:48:41 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE035B890;
        Fri,  4 Mar 2022 05:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=yUfWjX3h8CMnaiUpvCJtN8WVKzX4/Iy7kNdpr2Dj4L0=; b=hCJ6g8iobtGAt7/ncSptnHELQS
        zHMPqNTfCpH6vXUOB0yHhwmczFsgRSrExG+znU0KFY137mkYrMNxLC1ACUutekXxG24EI4rcbBTO0
        m7Vm7LsgkJXyCzITwB9ezWMTQ0eeykMTSfbowaROAqO31Xjz8V1YQwyR4F4NiHCQ3KJk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nQ8Hc-009EkS-PE; Fri, 04 Mar 2022 14:47:48 +0100
Date:   Fri, 4 Mar 2022 14:47:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     Divya.Koppera@microchip.com, netdev@vger.kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, kuba@kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        richardcochran@gmail.com, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, madhuri.sripada@microchip.com,
        manohar.puri@microchip.com
Subject: Re: [PATCH net-next 0/3] Add support for 1588 in LAN8814
Message-ID: <YiIYhDzOiRnLbzQy@lunn.ch>
References: <20220304093418.31645-1-Divya.Koppera@microchip.com>
 <164639821168.27302.1826304809342359025.git-patchwork-notify@kernel.org>
 <YiIO7lAMCkHhd11L@lunn.ch>
 <20220304.132121.856864783082151547.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304.132121.856864783082151547.davem@davemloft.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 04, 2022 at 01:21:21PM +0000, David Miller wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> Date: Fri, 4 Mar 2022 14:06:54 +0100
> 
> > On Fri, Mar 04, 2022 at 12:50:11PM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> >> Hello:
> >> 
> >> This series was applied to netdev/net-next.git (master)
> >> by David S. Miller <davem@davemloft.net>:
> > 
> > Hi David
> > 
> > Why was this merged?
> 
> Sorry, it seemed satraightforward to me, and I try to get the backlog under 40 patches before
> I hand over to Jakub for the day.
> 
> If you want to review, reply to the thread immediately saying so, don't wait until you haver time for the
> full review.

This patchset was on the list for less than 5 hours before it got
merged. I tend to sleep for 8 to 10 hours. Making it impossible for me
to react any faster. At an absolute minimum, you need to wait 12
hours, if you expect anybody to have a fair chance of being able to
say, hold on, i want to comment on this patchset.

I also don't like the metric of 40 patches backlog. Is the size of
backlog more important than the quality of the patches? Don't we care
about the quality of the code any more? Don't we care about getting
code reviewed any more?

     Andrew
