Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C9562379D
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 00:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbiKIXlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 18:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiKIXlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 18:41:39 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E128819016
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 15:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=MK5qPWfNerpL7Z4fS45CNfbh2JTpnvr3eo+HR6G5smM=; b=ZvQHLT7ZUh28WUTA2CNNynqSXs
        5JWtvCrP48Gyc2j3X2wpFioKVE/d5MQOu6OerJ62zlSD7FCuGFCrLI7bvuKoyXpAFn8sopiowgnR6
        lbwLcM/Jp4zfoMM0sELowsBFxuhdxlB/0Q3lVhVinM94tAybZDS3hRc9f277GYbZZ43I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1osuhM-001xrp-D5; Thu, 10 Nov 2022 00:41:36 +0100
Date:   Thu, 10 Nov 2022 00:41:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net] MAINTAINERS: Move Vivien to CREDITS
Message-ID: <Y2w6sKkmjXzBgRTF@lunn.ch>
References: <20221109231907.621678-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109231907.621678-1-f.fainelli@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 03:19:07PM -0800, Florian Fainelli wrote:
> Last patch from Vivien was nearly 3 years ago and he has not reviewed or
> responded to DSA patches since then, move to CREDITS.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Yes, i think it is time.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
