Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED64463DBBE
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbiK3RPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:15:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiK3RPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:15:15 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BC383253;
        Wed, 30 Nov 2022 09:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=aaaRr47iMyz13V4p0s0tz24ija0q5pJXRHrcx6F9yS8=; b=y0zzetYR2G/SyMqKA+rarja+ji
        Iq0ZhlEYsRM/+vBQAxDY4gXvxkMyuRhh9kZ/RXloVXukqYFyB2cbWRbf/pU1Bl34Zs7Ju2OS6heqK
        uhzc241uRl2JFn5NnuvDfIo4NIx3SrSvSeAjmrONDpQQEw/YaLTQpicEGjNw815MSZWs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0QeW-003ynZ-RM; Wed, 30 Nov 2022 18:13:44 +0100
Date:   Wed, 30 Nov 2022 18:13:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Xiaolei Wang <xiaolei.wang@windriver.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v3][net-next][PATCH 1/1] net: phy: Add link between phy dev and
 mac dev
Message-ID: <Y4ePSM1oad5un/4k@lunn.ch>
References: <20221130021216.1052230-1-xiaolei.wang@windriver.com>
 <20221130021216.1052230-2-xiaolei.wang@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130021216.1052230-2-xiaolei.wang@windriver.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 10:12:16AM +0800, Xiaolei Wang wrote:
> If the external phy used by current mac interface is
> managed by another mac interface, it means that this
> network port cannot work independently, especially
> when the system suspends and resumes, the following
> trace may appear, so we should create a device link
> between phy dev and mac dev.
> 
>   WARNING: CPU: 0 PID: 24 at drivers/net/phy/phy.c:983 phy_error+0x20/0x68
>   Modules linked in:
>   CPU: 0 PID: 24 Comm: kworker/0:2 Not tainted 6.1.0-rc3-00011-g5aaef24b5c6d-dirty #34
>   Hardware name: Freescale i.MX6 SoloX (Device Tree)
>   Workqueue: events_power_efficient phy_state_machine
>   unwind_backtrace from show_stack+0x10/0x14
>   show_stack from dump_stack_lvl+0x68/0x90
>   dump_stack_lvl from __warn+0xb4/0x24c
>   __warn from warn_slowpath_fmt+0x5c/0xd8
>   warn_slowpath_fmt from phy_error+0x20/0x68
>   phy_error from phy_state_machine+0x22c/0x23c
>   phy_state_machine from process_one_work+0x288/0x744
>   process_one_work from worker_thread+0x3c/0x500
>   worker_thread from kthread+0xf0/0x114
>   kthread from ret_from_fork+0x14/0x28
>   Exception stack(0xf0951fb0 to 0xf0951ff8)
> 
> Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>

Florian gave you a Reviewed-by and a Tested-by: You should add these
to following versions of the patch, otherwise they can get lost. They
also help speed up merging if they are from trusted reviewers.

   Andrew
