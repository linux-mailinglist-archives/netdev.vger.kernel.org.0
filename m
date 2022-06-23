Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 174DE5575E6
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 10:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiFWIvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 04:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiFWIvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 04:51:18 -0400
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C424927B;
        Thu, 23 Jun 2022 01:51:17 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id E52909C0212;
        Thu, 23 Jun 2022 04:51:15 -0400 (EDT)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id T_83_HGiNVQI; Thu, 23 Jun 2022 04:51:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 5B9509C021C;
        Thu, 23 Jun 2022 04:51:15 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.savoirfairelinux.com 5B9509C021C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=savoirfairelinux.com; s=DFC430D2-D198-11EC-948E-34200CB392D2;
        t=1655974275; bh=lhOLCZ50lFMUjFOmeM4U2uMx85/lWA0tpTfLwy28wyc=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=aZ80V7BIhL+Vs4KnkcoSbTQ++bJ6w6zDDtlYtGzHuROI1uZg80MLmSRENlmvubI/I
         kWJtykqOv6rK2k4OVZqtYTW0UXTFe7t4ZwL6Bt+nf/f4gc/TjUMYW/a5mh6bzS6Wom
         9I4PGguUcYZ+uIQ5FEcg0aysjS1Febwk8o9T0/LEv+sm1yH2AkWCNoNRYkwjjOuUqc
         iNjo6XTvCUwmpURPIrJ64O14aTEcqFX8vnyQ/Hg51PLXduoPnWKXgr560d4gCgQpxj
         3FU4Ea/G3QKGLWCsioTXStZ16jh6YgeBI7aIAZgm+ypN2wzVkjX4mpGfSusgHGMUw5
         OgsQ9dzEI/hRQ==
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id p_cEGiCigj1l; Thu, 23 Jun 2022 04:51:15 -0400 (EDT)
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [192.168.48.237])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 32DAC9C0212;
        Thu, 23 Jun 2022 04:51:15 -0400 (EDT)
Date:   Thu, 23 Jun 2022 04:51:14 -0400 (EDT)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux <linux@armlinux.org.uk>,
        hkallweit1 <hkallweit1@gmail.com>
Message-ID: <1303327043.278846.1655974274654.JavaMail.zimbra@savoirfairelinux.com>
In-Reply-To: <YqzAKguRaxr74oXh@lunn.ch>
References: <20220617134611.695690-1-enguerrand.de-ribaucourt@savoirfairelinux.com> <YqzAKguRaxr74oXh@lunn.ch>
Subject: Re: [PATCH] net: dp83822: disable false carrier interrupt
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.8.15_GA_4272 (ZimbraWebClient - FF100 (Linux)/8.8.15_GA_4257)
Thread-Topic: dp83822: disable false carrier interrupt
Thread-Index: pc35/nt1s87DA3eqQvFMw8ab/z6cIw==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- Original Message -----
> From: "Andrew Lunn" <andrew@lunn.ch>
> To: "Enguerrand de Ribaucourt" <enguerrand.de-ribaucourt@savoirfairelinux.com>
> Cc: davem@davemloft.net, "netdev" <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org, "linux"
> <linux@armlinux.org.uk>, "hkallweit1" <hkallweit1@gmail.com>
> Sent: Friday, June 17, 2022 7:55:54 PM
> Subject: Re: [PATCH] net: dp83822: disable false carrier interrupt

> On Fri, Jun 17, 2022 at 03:46:11PM +0200, Enguerrand de Ribaucourt wrote:
> > When unplugging an Ethernet cable, false carrier events were produced by
> > the PHY at a very high rate. Once the false carrier counter full, an
> > interrupt was triggered every few clock cycles until the cable was
> > replugged. This resulted in approximately 10k/s interrupts.

> > Since the false carrier counter (FCSCR) is never used, we can safely
> > disable this interrupt.

> > In addition to improving performance, this also solved MDIO read
> > timeouts I was randomly encountering with an i.MX8 fec MAC because of
> > the interrupt flood. The interrupt count and MDIO timeout fix were
> > tested on a v5.4.110 kernel.

>> Signed-off-by: Enguerrand de Ribaucourt
> > <enguerrand.de-ribaucourt@savoirfairelinux.com>
> > ---
> > drivers/net/phy/dp83822.c | 1 -
> > 1 file changed, 1 deletion(-)

> > diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
> > index e6ad3a494d32..95ef507053a6 100644
> > --- a/drivers/net/phy/dp83822.c
> > +++ b/drivers/net/phy/dp83822.c
> > @@ -230,7 +230,6 @@ static int dp83822_config_intr(struct phy_device *phydev)
> > return misr_status;

> > misr_status |= (DP83822_RX_ERR_HF_INT_EN |
> > - DP83822_FALSE_CARRIER_HF_INT_EN |

> Does the same problem exist for RX_ERR_HF_INT ? That appears to be
> that the RX error counter has reached half full. I don't see anything
> using register 0x15.

> Andrew

I can produce RX errors using improper ethtool speed settings, which can be seen
in the statistics, but they do not increment register 0x15. However, RX errors due 
to cable disconnection do increase it. After the counter is half full (0x7fff, 
the datasheet is wrong), interrupts that we don't need were indeed generated.

I measured a ~3k/s interrupt flood which also kept going even if I stopped the 
RX errors transfer so we should definitively disable RX_ERR_HF_INT as well.

I'll send a separate patch for RX_ERR_HF_INT_EN to have clear commmit messages.

Thanks,
Enguerrand
