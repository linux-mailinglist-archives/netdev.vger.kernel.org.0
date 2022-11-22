Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16480633235
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 02:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbiKVBel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 20:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbiKVBej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 20:34:39 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35BDB9623;
        Mon, 21 Nov 2022 17:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=cU0gtzZqWFEZRxviF8+JZyje5su4sIAghwGMYG7LRF8=; b=emainDIiiKJzdmduzCiB1wXgMg
        subP6tb89n5shJmJ2kt1AYNy2XL2riRoamgZRmtT1hzSIywi8yqCtaknG3Dv5+bopDjtF7ABpZVaD
        NcexkYD7wmlSP7teeTq45FmhPP7YVdWhl133/hJWGp4OB+J3CxD9hgjuAsxStO5JR+qA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oxIAm-0034WP-0u; Tue, 22 Nov 2022 02:34:04 +0100
Date:   Tue, 22 Nov 2022 02:34:04 +0100
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
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: add Motorcomm YT8531S phy id.
Message-ID: <Y3wnDOnMPHuFlCaP@lunn.ch>
References: <20221121080638.547-1-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121080638.547-1-Frank.Sae@motor-comm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  #define PHY_ID_YT8511		0x0000010a
>  #define PHY_ID_YT8521				0x0000011A
> +#define PHY_ID_YT8531S				0x4F51E91A

The indentation looks odd here.

>  
> -/* 0xA000, 0xA001, 0xA003 ,and 0xA006 ~ 0xA00A  are common ext registers
> +/* 0xA000, 0xA001, 0xA003 , 0xA006 ~ 0xA00A and 0xA012 are common ext registers

Please remove the space before the ,

> 2.31.0.windows.1

Does that mean you are hosting your Linux builds on Windows machine?

     Andrew
