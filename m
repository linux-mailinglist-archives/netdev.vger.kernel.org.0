Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D414C649411
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 13:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbiLKMCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 07:02:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiLKMCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 07:02:34 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620931180D
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 04:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=150qKh/O8Bdd1rAEjYOOnl98T1Ymu3M7uex5xDxl9+w=; b=tw
        FdLVpKhYLu2dxNXocNw3TGDH7SxDF4jo8qnOm31nnRBnEjRHlkahx1kMaWm/GO76RNH1fExiGnT7f
        wa1Yv9UCGMXrj6q9Eb4kdZBYG2Och9UCLEV5lXEp+Z+beYkGpHh2Q9VViDCc1raKDWtUhd2x428v9
        J9m6Pn11bDTi7vE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p4L2I-0050zQ-6b; Sun, 11 Dec 2022 13:02:26 +0100
Date:   Sun, 11 Dec 2022 13:02:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next v2] net: ngbe: Add ngbe mdio bus driver.
Message-ID: <Y5XG0uHwz3om0gLA@lunn.ch>
References: <20221206114035.66260-1-mengyuanlou@net-swift.com>
 <Y5RjwYgetMdzlQVZ@lunn.ch>
 <8BEEC6D9-EB5F-4A66-8BFD-E8FEE4EB723F@net-swift.com>
 <Y5W+86YXppK2NocE@lunn.ch>
 <63385120-46C9-4D9E-81C7-9E72C3371C2C@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <63385120-46C9-4D9E-81C7-9E72C3371C2C@net-swift.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > If you don't have the I2C bus, i'm wondering how you can actually
> > driver the SFP and the MAC. You have no idea what has been
> > inserted. Is it actually an SFF, not an SFP? Do you have any of the
> > GPIOs normally associated with an SFP? TX_DISABLE, LOS, TX_FAULT?
> > 
> 1、Yeah. We can't know what module is inserted

That is a very odd design. You are going to get all sorts of reports
of it being broken when some random module is interested.

If it was my design, i would not use an SFP socket. I would solder
down an SFF. They should be pin compatible. You then know exactly what
you have, and how the MAC needs to be configured.

      Andrew
