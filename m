Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFD8F617F4B
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 15:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiKCOU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 10:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiKCOU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 10:20:27 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C763F10C0;
        Thu,  3 Nov 2022 07:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vi3CA84GMNxJl3ApSDQcnld/Jhz79UU090agkC2TPTw=; b=ryU5faQ5W+2MDbPbrlDUPeYzQx
        xbjw3P1tBxg8hcM5Bt0n2ZX2pepNPsMb3LGBWnH8kkUCv+9uGlV6KyZeFxbZ4P2XqbJtUAEXYajuR
        x3L9VpW1hhFAvcJMY5lAYCUCANZ6deym2UrrNrS/qESjkpYy8m2xSAl6nsQRdqMV9Ma4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oqb3h-001JTF-9D; Thu, 03 Nov 2022 15:19:05 +0100
Date:   Thu, 3 Nov 2022 15:19:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Frank <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH net] net: phy: fix yt8521 duplicated argument to & or
Message-ID: <Y2PN2dXCEi0zlsz9@lunn.ch>
References: <20221103025047.1862-1-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103025047.1862-1-Frank.Sae@motor-comm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 03, 2022 at 10:50:47AM +0800, Frank wrote:
>  The second YT8521_RC1R_GE_TX_DELAY_xx should be YT8521_RC1R_FE_TX_DELAY_xx.
> 
>  Fixes: 70479a40954c ("[net-next,v8.2] net: phy: Add driver for Motorcomm yt8521 gigabit ethernet phy")
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Julia Lawall <julia.lawall@lip6.fr>
> Signed-off-by: Frank <Frank.Sae@motor-comm.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
