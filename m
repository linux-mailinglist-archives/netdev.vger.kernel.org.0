Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 093524F6B80
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 22:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbiDFUkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 16:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234864AbiDFUkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 16:40:04 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409F4398201;
        Wed,  6 Apr 2022 11:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eiI7X6dT42yKGQJQb30m9eUSmBWaGsGGkVUqKrcoGx4=; b=LWDVJ/ZSal1eHjVTrYsVrSwlKr
        ApMgW1FbcuXL6b0jKhUUkux08j2su2wbZQVFTnKaDbAHeeOMeUJAHsUkUueocktlsREn/Und0NI2w
        Rq5fOth9IRM6Zcba/37iVrBgL+A3k/9IMSPHfKgIJEdWCX+LwPMUq5sA3UOl4OjCWG8E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ncAr5-00EVUY-Ni; Wed, 06 Apr 2022 20:58:11 +0200
Date:   Wed, 6 Apr 2022 20:58:11 +0200
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
Subject: Re: [PATCH net-next RESEND v2 1/3] net: mdio: aspeed: move reg
 accessing part into separate functions
Message-ID: <Yk3iw0ENOYUBrXK2@lunn.ch>
References: <20220406170055.28516-1-potin.lai@quantatw.com>
 <20220406170055.28516-2-potin.lai@quantatw.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406170055.28516-2-potin.lai@quantatw.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 01:00:53AM +0800, Potin Lai wrote:
> Add aspeed_mdio_op() and aseed_mdio_get_data() for register accessing.
> 
> aspeed_mdio_op() handles operations, write command to control register,
> then check and wait operations is finished (bit 31 is cleared).
> 
> aseed_mdio_get_data() fetchs the result value of operation from data
> register.
> 
> Signed-off-by: Potin Lai <potin.lai@quantatw.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
