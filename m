Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCCD4FE75C
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 19:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352374AbiDLRmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 13:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351704AbiDLRmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 13:42:02 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F2F4F9E8;
        Tue, 12 Apr 2022 10:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=GqUPsB0RxV4YHXw9ZT+wqqKYjhpEzdwTZJ084YnLISw=; b=Dc
        m0+jjljkXdImyjJiS9JfrITD9lPe5/d71jL/BoNmf/5IiInH1hpjaVmQiR8bfGMA4A8jnZbhG0ny7
        sVb9cS3j9+MNPDNhRnbSKA154kAIRZT926ySypROSD2QgRdOmuCYH4QGYl3jYc8N+YFL6OIxP0GuA
        J0okT0pid0LFka8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1neKUI-00FUhA-Uz; Tue, 12 Apr 2022 19:39:34 +0200
Date:   Tue, 12 Apr 2022 19:39:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: realtek: don't parse compatible string for
 RTL8366S
Message-ID: <YlW5VsakqDCzTz9x@lunn.ch>
References: <20220412155749.1835519-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220412155749.1835519-1-alvin@pqrs.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 05:57:49PM +0200, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> This switch is not even supported, but if someone were to actually put
> this compatible string "realtek,rtl8366s" in their device tree, they
> would be greeted with a kernel panic because the probe function would
> dereference NULL. So let's just remove it.
> 
> Link: https://lore.kernel.org/all/CACRpkdYdKZs0WExXc3=0yPNOwP+oOV60HRz7SRoGjZvYHaT=1g@mail.gmail.com/
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
