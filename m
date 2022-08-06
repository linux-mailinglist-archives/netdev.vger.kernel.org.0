Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B117058B666
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 17:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbiHFPXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Aug 2022 11:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbiHFPXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Aug 2022 11:23:09 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250D712AA4;
        Sat,  6 Aug 2022 08:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LsVNe76Un0AnuesL7EI/gnhf6nk5hE/4yiJkLEtbPAU=; b=OTYJtH4/uMQh0hpBBIEx/vbAwJ
        CmhYJ2CzuLT69dmAy1HeVbF/h3cRy+9GCtEKYSdFbmnWhlTct8pCxWZilOSEImkd40BzZAAH2ZvJD
        OtSdn7ET/a1JGeGy/sdtylNG+lK0BQVwpNY00aovvPAg2JM9Ad6r2D6KOlMxxsw7H99w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oKLdo-00CZsW-7y; Sat, 06 Aug 2022 17:23:04 +0200
Date:   Sat, 6 Aug 2022 17:23:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jose Alonso <joalonsof@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Ronald Wahl <ronald.wahl@raritan.com>
Subject: Re: [PATCH v2 net] net: usb: ax88179_178a have issues with
 FLAG_SEND_ZLP
Message-ID: <Yu6HWK/vQaJjHdjW@lunn.ch>
References: <9a6829ee42e4e88639d35428c378f9da7802245b.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a6829ee42e4e88639d35428c378f9da7802245b.camel@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 05, 2022 at 05:27:33PM -0300, Jose Alonso wrote:
> To: David S. Miller <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>, Ronald Wahl <ronald.wahl@raritan.com>
> 
>     [PATCH net] net: usb: ax88179_178a have issues with FLAG_SEND_ZLP
>     The usage of FLAG_SEND_ZLP causes problems to other firmware/hardware
>     versions that have no issues.
>     
>     The FLAG_SEND_ZLP is not safe to use in this context.
>     See:
>     https://patchwork.ozlabs.org/project/netdev/patch/1270599787.8900.8.camel@Linuxdev4-laptop/#118378
>     
>     Reported-by: Ronald Wahl <ronald.wahl@raritan.com>
>     Link: https://bugzilla.kernel.org/show_bug.cgi?id=216327
>     Link: https://bugs.archlinux.org/task/75491
>     
>     Fixes: 36a15e1cb134 ("net: usb: ax88179_178a needs FLAG_SEND_ZLP")
>     Signed-off-by: Jose Alonso <joalonsof@gmail.com>
>     
>     --

Please take a read of:

https://kernel.org/doc/html/latest/process/submitting-patches.html

It should explain all the things you are getting wrong.

It is also worth looking at a few patches on the mailing list which do
get accepted. Look at there format and copy them.

   Andrew
