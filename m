Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 002874E52A9
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 13:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242773AbiCWM7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 08:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241584AbiCWM7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 08:59:40 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2CD5F9F;
        Wed, 23 Mar 2022 05:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=GJ4Y9HiyyNz6X3B1gn5Z+YSl3636N+rO7MjkOGgWPZw=; b=x4
        mG4nXxnbsaiAINyAFHNIezoTEsy8ZkkHgGQ7dr0cCoRmFZ4B6Hvw9j6jxc7Z5pJVXdjGKwVYUFxOC
        SJgDRMqZJFC2QjeL+xfTA+yEy3HxV8ZsHzhKm2qtSoG/35PnWXZA7dvr/+A2zUfBZq9RBhT91A+Wi
        KFKZBr1OC+7O99g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nX0Yn-00CHSl-EL; Wed, 23 Mar 2022 13:57:57 +0100
Date:   Wed, 23 Mar 2022 13:57:57 +0100
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
Subject: Re: [PATCH net-next] net: dsa: realtek: make interface drivers
 depend on OF
Message-ID: <YjsZVblL11w8IuRH@lunn.ch>
References: <20220323124225.91763-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220323124225.91763-1-alvin@pqrs.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 23, 2022 at 01:42:25PM +0100, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> The kernel test robot reported build warnings with a randconfig that
> built realtek-{smi,mdio} without CONFIG_OF set. Since both interface
> drivers are using OF and will not probe without, add the corresponding
> dependency to Kconfig.
> 
> Link: https://lore.kernel.org/all/202203231233.Xx73Y40o-lkp@intel.com/
> Link: https://lore.kernel.org/all/202203231439.ycl0jg50-lkp@intel.com/
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>

Hi Alvin

This looks like something which could go into net, not net-next. Could
you add a Fixes: tag.

Otherwise

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
