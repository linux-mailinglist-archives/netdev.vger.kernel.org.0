Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99BD26B871A
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjCNAl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbjCNAl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:41:27 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6703292266;
        Mon, 13 Mar 2023 17:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mt11C8pG4KQZH0zH7DIbpZM/h/ioAC5wjE50g/ZfFOs=; b=bpKbcH4IyXv4pEELYoOpv8Imm3
        6ONgJvPqEVW2sC5HoYxtTfkv3cgzKro1hNz5uaiGaGBh6ypkeJgfI1fP5jqBBDrPgSVfh7FNab/4k
        jgNRJV9SkaR0FtOM8rxAwCzy7bZ38NJNociKOwjsMOFVjRNg6x3HWsbINx55zPpW64mU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pbshb-007FHr-HR; Tue, 14 Mar 2023 01:39:43 +0100
Date:   Tue, 14 Mar 2023 01:39:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 01/13] net: phy: realtek: Fix events detection
 failure in LPI mode
Message-ID: <c87c9964-af29-4885-a977-c8a4a2fe704e@lunn.ch>
References: <20230313224237.28757-1-Sergey.Semin@baikalelectronics.ru>
 <20230313224237.28757-2-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313224237.28757-2-Sergey.Semin@baikalelectronics.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Since this is for net, you need to provide a Fixes: tag.

      Andrew
