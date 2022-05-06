Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C3351E260
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 01:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377293AbiEFWtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 18:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382591AbiEFWtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 18:49:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0466211C
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 15:45:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 781CC616FE
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 22:45:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E03C385A8;
        Fri,  6 May 2022 22:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651877114;
        bh=o08Atq5UUyUxoJEozvVLyBmsGX0rIAFFluXWNmDyEYg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bS1fmw+LeZODK1NNBkO+kI3HhIQGLFEatDWx0BhPXVHKWmx3HM0AR1mpqxC132OAN
         jsHZWJXoSf8uclWuPDS2OPzjiF63rEj8OJTgdoTUyNdnvdQ/P+W+M3OZTJOCgZKC7H
         b21+TL2JMUZWYwpInrfAVgH7dIz3kLZmhLc2P/9Odc7+kL4eN7rywDrxnBUK345Bgz
         tEOv5dk1mUF1Y5WxbGZb45DMkbw7zhadW3sPOQuQKNBz3hMpZEZXsPUDkODNNBurYT
         rs4XmyimcxrTxtxZsqubnH0tv+CWjvHB58TtnNEtCuzTFXVV0J6DVP/JJRtgZVFFW8
         edKmX8UHTRKcg==
Date:   Fri, 6 May 2022 15:45:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Yuiko Oshino <yuiko.oshino@microchip.com>,
        woojung.huh@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, ravi.hegde@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v4 net-next 2/2] net: phy: smsc: add LAN8742 phy
 support.
Message-ID: <20220506154513.48f16e24@kernel.org>
In-Reply-To: <YnQlicxRi3XXGhCG@lunn.ch>
References: <20220505181252.32196-1-yuiko.oshino@microchip.com>
        <20220505181252.32196-3-yuiko.oshino@microchip.com>
        <YnQlicxRi3XXGhCG@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 May 2022 21:29:13 +0200 Andrew Lunn wrote:
> On Thu, May 05, 2022 at 11:12:52AM -0700, Yuiko Oshino wrote:
> > The current phy IDs on the available hardware.
> >         LAN8742 0x0007C130, 0x0007C131
> > 
> > Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

The comments which I think were requested in the review of v2 and
appeared in v3 are now gone, again. Is that okay?
