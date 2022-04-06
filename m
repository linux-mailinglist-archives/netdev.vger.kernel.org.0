Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B3C4F6B83
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 22:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbiDFUlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 16:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbiDFUla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 16:41:30 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C7C39CBD3;
        Wed,  6 Apr 2022 11:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=az+EMkieAOyvI81d3hpeZJpyWb3oLqIIHpWPkq2Q19c=; b=diLndcqvIjdj9NUme+9YhsVssI
        Q83zHY5wc/YKvEmnQrDhVzBcW9ihGTSvXx9W7qAMCj7fzAd1MP35RyXX6gAazbbf95NAgRtNKfYHT
        tc9wV77NPB5dpAzKZv/Xzxva307laCQAtR+qcLfOUA5i8xxtK8kNJVF1wAgRY1ZkBSU4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ncArb-00EVV6-Kh; Wed, 06 Apr 2022 20:58:43 +0200
Date:   Wed, 6 Apr 2022 20:58:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Potin Lai <potin.lai@quantatw.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Patrick Williams <patrick@stwcx.xyz>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RESEND v2 2/3] net: mdio: aspeed: Introduce read
 write function for c22 and c45
Message-ID: <Yk3i496mEwOdUEyd@lunn.ch>
References: <20220406170055.28516-1-potin.lai@quantatw.com>
 <20220406170055.28516-3-potin.lai@quantatw.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406170055.28516-3-potin.lai@quantatw.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 01:00:54AM +0800, Potin Lai wrote:
> Add following additional functions to move out the implementation from
> aspeed_mdio_read() and aspeed_mdio_write().
> 
> c22:
>  - aspeed_mdio_read_c22()
>  - aspeed_mdio_write_c22()
> 
> c45:
>  - aspeed_mdio_read_c45()
>  - aspeed_mdio_write_c45()
> 
> Signed-off-by: Potin Lai <potin.lai@quantatw.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
