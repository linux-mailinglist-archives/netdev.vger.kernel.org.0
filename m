Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBCC3211B6
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 09:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbhBVIBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 03:01:42 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:46414 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbhBVIBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 03:01:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613980900; x=1645516900;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=P0o5DN0lY6yEsmT8esXd7RX4Q3WcQqTQdIg9plIuWPk=;
  b=JkrkWbu5dF8GdKBCoh3JV27JehMP0lJMuHByytdEkoEWUlShykE1Z4AI
   3FjYbeaKKt8fJfKT+yRpcj+yGqN/fUl34NuD0tkSHpN5oWtgqECLT+UcJ
   h10vO4E4ji80UL5CquHhNskXwaLxITtkInB5TZ3bm78A73mFyl/J/GKrU
   0b85LzCjKJ+Q79JPqQF0eEp5XREcYMwaQqOpX/npzVejNxq3ex2Nd2RVT
   5IRK8Lwqz6tPcuSU7RPDKU0tDJFwh47UBWZ9X4BxuXRVxbsl4WY26oCrR
   x8gAOT/GM3/TOE7eR65x1NJpgWWoga5lG6MRkapYcI84D9t+It5HNU1wB
   w==;
IronPort-SDR: gsGFcwC09d2OowkY2hkdMoSh/rnZbzj232smMpDS0c05TvdDoajmeNV2jdUAcQC+sN7Ao2ZZev
 vvynz0CaKUbAGkPODzu/JVDabQrj31SfPBj6M2sdXlVFaQS8LH+jOk/vz3r2nn3jGhNnQkpP3i
 ZqtrvfnaqcehO9cfTwbDer3FeJIrEaMeQWLtfPxyDLnmp6lxXEjFqAnPNiOAyxcyA2ok3jIjrI
 i6+8uMmFewCGMBh8W9/ionhfFRrKcaHzCZJZVzvP6mV2R7KSBPD0feOeoLfF1piTqwabvkHPsY
 arE=
X-IronPort-AV: E=Sophos;i="5.81,196,1610434800"; 
   d="scan'208";a="44973098"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Feb 2021 01:00:23 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 22 Feb 2021 01:00:23 -0700
Received: from tyr.hegelund-hansen.dk (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 22 Feb 2021 01:00:20 -0700
Message-ID: <94dad8f439dd870b3488130e82f50e28b81fccf1.camel@microchip.com>
Subject: Re: [PATCH v15 2/4] phy: Add media type and speed serdes
 configuration interfaces
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Date:   Mon, 22 Feb 2021 09:00:20 +0100
In-Reply-To: <YDH20a2hP+HtBqHz@unreal>
References: <20210218161451.3489955-1-steen.hegelund@microchip.com>
         <20210218161451.3489955-3-steen.hegelund@microchip.com>
         <YDH20a2hP+HtBqHz@unreal>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leon,

On Sun, 2021-02-21 at 07:59 +0200, Leon Romanovsky wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you
> know the content is safe
> 
> On Thu, Feb 18, 2021 at 05:14:49PM +0100, Steen Hegelund wrote:
> > Provide new phy configuration interfaces for media type and speed
> > that
> > allows e.g. PHYs used for ethernet to be configured with this
> > information.
> > 
> > Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
> > Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> > ---
> > 

...

> >  int phy_validate(struct phy *phy, enum phy_mode mode, int submode,
> >                union phy_configure_opts *opts);
> > @@ -344,6 +356,20 @@ static inline int phy_set_mode_ext(struct phy
> > *phy, enum phy_mode mode,
> >  #define phy_set_mode(phy, mode) \
> >       phy_set_mode_ext(phy, mode, 0)
> > 
> > +static inline int phy_set_media(struct phy *phy, enum phy_media
> > media)
> > +{
> > +     if (!phy)
> > +             return 0;
> 
> I'm curious, why do you check for the NULL in all newly introduced
> functions?
> How is it possible that calls to phy_*() supply NULL as the main
> struct?
> 
> Thanks

I do not know the history of that, but all the functions in the
interface that takes a phy as input and returns a status follow that
pattern.  Maybe Kishon and Vinod knows the origin?

> 
> > +     return -ENODEV;
> > +}
> > +
> > +static inline int phy_set_speed(struct phy *phy, int speed)
> > +{
> > +     if (!phy)
> > +             return 0;
> > +     return -ENODEV;
> > +}
> > +
> >  static inline enum phy_mode phy_get_mode(struct phy *phy)
> >  {
> >       return PHY_MODE_INVALID;
> > --
> > 2.30.0
> > 

Best Regards
Steen

