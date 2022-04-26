Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 757A95102FA
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 18:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352708AbiDZQRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 12:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242334AbiDZQRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 12:17:35 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FBE9E9CA
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 09:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=OYQgAkh42FZNma83bHjfle2PqllHeem2AflBIg8urq0=; b=Um
        fSgCVx76BT04jxtycD9xWMZ5omQ40MMkfBOk41r+QC0s4U6dyippyWA6WAAcQrYjOZOvutd6QTEXJ
        ymPB99j12+EciAl+Sprnoim3i62Zbe4c0XqlVAhp302phjt1c3yNihpInTqovw2pftJJSKFaZuT+Q
        GIXhJA/2IMdz1LQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1njNpX-00Ha1H-3n; Tue, 26 Apr 2022 18:14:23 +0200
Date:   Tue, 26 Apr 2022 18:14:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [PATCH v2 net-next 07/10] net: dsa: request drivers to perform
 FDB isolation
Message-ID: <YmgaX4On/2j3lJf/@lunn.ch>
References: <20220225092225.594851-1-vladimir.oltean@nxp.com>
 <20220225092225.594851-8-vladimir.oltean@nxp.com>
 <867d7bga78.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <867d7bga78.fsf@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > @@ -941,23 +965,29 @@ struct dsa_switch_ops {
> >  	 * Forwarding database
> >  	 */
> >  	int	(*port_fdb_add)(struct dsa_switch *ds, int port,
> > -				const unsigned char *addr, u16 vid);
> > +				const unsigned char *addr, u16 vid,
> > +				struct dsa_db db);
> 
> Hi! Wouldn't it be better to have a struct that has all the functions
> parameters in one instead of adding further parameters to these
> functions?
> 
> I am asking because I am also needing to add a parameter to
> port_fdb_add(), and it would be more future oriented to have a single
> function parameter as a struct, so that it is easier to add parameters
> to these functions without havíng to change the prototype of the
> function every time.

Hi Hans

Please trim the text to only what is relevant when replying. It is
easy to miss comments when having to Page Down, Page Down, Page down,
to find comments.

   Andrew
