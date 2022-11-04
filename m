Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F02D618F56
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 05:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiKDEBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 00:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiKDEB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 00:01:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB2C1D679;
        Thu,  3 Nov 2022 21:01:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F41D61FC0;
        Fri,  4 Nov 2022 04:01:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F144C433D6;
        Fri,  4 Nov 2022 04:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667534486;
        bh=WuJW+uuO8TeM/6fod4sapYBm3CSeI8w0DSzwMpGbSw8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iOpoB13S0QYGy+F0D8nRQ8PPcpX+L/IxQhcBlPPkAkEAMRvH8+xkd7uIk48wJung7
         ujXUBeOBp60iFhHK6iLnoV4YlTHaLCwV2WCi500Oop/tdal2WGqGCxQkBMRx3D9FzF
         OVYjgLa6BvAOlQrscmxo4Cd4xGez4fUFG4DeGUGXEGlsA/gy7jRWQ7JvruPxsE5dJh
         Ou60Wd8zj4DwtX/ksCZbUno7UAf87iz0oRClSZi8erujcHdOyScSQ3OO+3r0VW0ihT
         n9ErIPSY05p0vISwzxHvW6JV5Y8qKbNr740yUuBV/RTmob1OI8w9Z8mfXolPFbemhS
         jm21n5ZBGLxyg==
Date:   Thu, 3 Nov 2022 21:01:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Frank <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH net] net: phy: fix yt8521 duplicated argument to & or
Message-ID: <20221103210125.255dea97@kernel.org>
In-Reply-To: <20221103025047.1862-1-Frank.Sae@motor-comm.com>
References: <20221103025047.1862-1-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Nov 2022 10:50:47 +0800 Frank wrote:
>  The second YT8521_RC1R_GE_TX_DELAY_xx should be YT8521_RC1R_FE_TX_DELAY_xx.
> 
>  Fixes: 70479a40954c ("[net-next,v8.2] net: phy: Add driver for Motorcomm yt8521 gigabit ethernet phy")

There's a spurious space before the Fixes tag, please remove it.

The patches does not apply to the net tree:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/

please rebase and repost.

> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Julia Lawall <julia.lawall@lip6.fr>
> Signed-off-by: Frank <Frank.Sae@motor-comm.com>
