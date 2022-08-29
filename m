Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 646295A5582
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 22:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiH2U0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 16:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiH2U0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 16:26:54 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D7684EEC
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 13:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FsiOi/MKNshkwXrXXDUR96Js8Cbk4s9g2JOQwV2l54g=; b=45kO2lSm7Do44GycqIeHSRQGUE
        OEnx6q4PR6O1TtZuZ7NNn2gRbbVG3Ow7+PykXfjwXZ/bs0BLrnRitRuzX23nXMom2dD5tFvERN8xB
        TBF4JRjNNlWgrbgITVdUbbCl5zW9rmnYn6A14ikqQGVQeuR+WEy4rXMyem91n/xmQelQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oSlLG-00F08X-J7; Mon, 29 Aug 2022 22:26:42 +0200
Date:   Mon, 29 Aug 2022 22:26:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: smsc: use device-managed clock API
Message-ID: <Yw0hAgJa9hRNOQYR@lunn.ch>
References: <b222be68-ba7e-999d-0a07-eca0ecedf74e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b222be68-ba7e-999d-0a07-eca0ecedf74e@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 28, 2022 at 07:26:55PM +0200, Heiner Kallweit wrote:
> Simplify the code by using the device-managed clock API.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
