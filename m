Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467A74CE59D
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 16:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbiCEPqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 10:46:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbiCEPqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 10:46:47 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96C040E45;
        Sat,  5 Mar 2022 07:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=KTaxi+VjxQloBsr2gUQQMZC/bCUg45g0x+XpL+FdNfA=; b=ydvYvtbFKoicxn+qQTW9aOnDEh
        rVms2Kyl/zddzxygQQWD3XIhcy3qPCm/qvqq9+83gN3gAo4Jzelc2nehaEZrhTSf+fZVGHraQushq
        EbWqp+q3exDOjTp8pPa0YVykvuQwlmEBKtpHt9LmzYx6abYKpFfvrWbIFb73GX7rmKeI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nQWbS-009Od8-6K; Sat, 05 Mar 2022 16:45:54 +0100
Date:   Sat, 5 Mar 2022 16:45:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Zheyu Ma <zheyuma97@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ethernet: sun: Free the coherent when failing in probing
Message-ID: <YiOFslV7l82AkQ3Y@lunn.ch>
References: <1646492104-23040-1-git-send-email-zheyuma97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1646492104-23040-1-git-send-email-zheyuma97@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 05, 2022 at 02:55:04PM +0000, Zheyu Ma wrote:
> When the driver fails to register net device, it should free the DMA
> region first, and then do other cleanup.
> 
> Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
