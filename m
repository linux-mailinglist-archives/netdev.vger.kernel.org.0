Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02AFE624D6F
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 23:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiKJWGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 17:06:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiKJWGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 17:06:44 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1660E2A94F
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 14:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Cx6vNLRsNc+1LWMVheGdPfQJ3fstY/1r1HJNFE5netE=; b=L0JVzICA4A/zqX6xrCXKMXTEgg
        I502iHIOQDkSR6zoxbiOzmL51m5dJfWJr4xhF4cIdU2oMpv8UbuTb/G1Yt+qkxI6xi8qQVXX3vwGk
        HuHGIdCuOd3VH7LZwmdyXwunOwj7MtScERq1KVibkk5zJQvvaPbdNCaR/CVYNA49/qm0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1otFg4-0024RY-MR; Thu, 10 Nov 2022 23:05:40 +0100
Date:   Thu, 10 Nov 2022 23:05:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: Re: [PATCH 1/9] net: dsa: allow switch drivers to override default
 slave PHY addresses
Message-ID: <Y211tK/kjSAL4qKb@lunn.ch>
References: <20221108082330.2086671-1-lukma@denx.de>
 <20221108082330.2086671-2-lukma@denx.de>
 <Y2pX0qrLs/OCQOFr@lunn.ch>
 <20221110163425.7b4974d5@wsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110163425.7b4974d5@wsk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> It depends if the HW designer set this bootstrap pin low or high :-)
> (often this pin is not concerned until mainline/BSP driver is not
> working :-) )
> 
> As it costs $ to fix this - it is easier to add "quirk" to the code.

Can you read the strapping configuration via the scratch registers?
Then you can detect it at probe time and do the right thing.

     Andrew
