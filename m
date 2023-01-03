Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D589665BDCE
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 11:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237317AbjACKO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 05:14:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237352AbjACKOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 05:14:20 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D148E81;
        Tue,  3 Jan 2023 02:14:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4Q1GrCJ59du2h0puSmV0cg1ql+FbTrfyCDAcQA8w9QY=; b=vcyJR7ch1WQslr9S1ETk+Lpgk2
        kdH2Ur811zj51/MrfKpQ+TMRNOAX2myEKZZRg8lbVH6GTtmqOuzjxduFr1/ufIFA2oAwyDavDk82n
        XxzaeZWOeqpEu6fhFWNm11QUrOTJ6ivXB5+0PQ29ana4QgltlEdX0YHCJPalKWGFtt6tC1SPJuDMf
        uqHfjQK3oi3HKlQnt2DHPALizEL2ujd/4Ui8I5dL/q6Z3Kjbtbme9kyEvIXUVTvULO+7ilVLXcOKM
        NuGl5jh7yLr2HV6vg9VP/QIEd4fn+noMAhKNBu/LQnvuwde58x0Kz7HvMw+v8JTAtY015ShiBcz06
        nqFSZ4qg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35910)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pCeIz-0005CD-IB; Tue, 03 Jan 2023 10:14:01 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pCeIt-0001yf-7j; Tue, 03 Jan 2023 10:13:55 +0000
Date:   Tue, 3 Jan 2023 10:13:55 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Michael Walle <michael@walle.cc>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH RFC net-next v2 03/12] net: mdio: mdiobus_register:
 update validation test
Message-ID: <Y7P/45Owf2IezIpO@shell.armlinux.org.uk>
References: <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-3-ddb37710e5a7@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221227-v6-2-rc1-c45-seperation-v2-3-ddb37710e5a7@walle.cc>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

Thanks for picking this up!

On Wed, Dec 28, 2022 at 12:07:19AM +0100, Michael Walle wrote:
> +	if (!bus || !bus->name)
> +		return -EINVAL;
> +
> +	/* An access method always needs both read and write operations */
> +	if ((bus->read && !bus->write) ||
> +	    (!bus->read && bus->write) ||
> +	    (bus->read_c45 && !bus->write_c45) ||
> +	    (!bus->read_c45 && bus->write_c45))

I wonder whether the following would be even more readable:

	if (!bus->read != !bus->write || !bus->read_c45 != !bus->write_c45)

which essentially asserts that the boolean of !method for the read and
write methods must match.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
