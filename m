Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62AD96AFC8E
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 02:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjCHB4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 20:56:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjCHB4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 20:56:21 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AE8A7684
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 17:56:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Z134OQdU0mMcZl5sVaFmWpqNiSG+jPzPQGPz/WyE8Wo=; b=oy4u2qaXNB/H1AR+QM0ZhzjMUg
        WcJLDyUPWcxnd2XAJipJMGsIxng8BOEUoGAbqYCUSljIxofuD52EQ7ZctIPowbz17n4j0X3KUhk5N
        MsZfSwXd3bzdxOA9oBWwde7Cg5eMpuqjWtaT/KonQUJTCANI5F6JieGDmgq7KTwagge4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pZj2H-006j8J-Tr; Wed, 08 Mar 2023 02:56:09 +0100
Date:   Wed, 8 Mar 2023 02:56:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: improve phy_read_poll_timeout
Message-ID: <622f2444-a559-4934-aab6-4be1bee458dc@lunn.ch>
References: <6d8274ac-4344-23b4-d9a3-cad4c39517d4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d8274ac-4344-23b4-d9a3-cad4c39517d4@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 10:51:35PM +0100, Heiner Kallweit wrote:
> cond sometimes is (val & MASK) what may result in a false positive
> if val is a negative errno. We shouldn't evaluate cond if val < 0.
> This has no functional impact here, but it's not nice.
> Therefore switch order of the checks.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
