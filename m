Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270A7319F78
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 14:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbhBLNHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 08:07:07 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:24972 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbhBLNG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 08:06:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613135216; x=1644671216;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wem8VWP1r4deBj6bYzYai383jsYUEwEf4qxZfo8ZsX4=;
  b=D+WjCn7o3q/Bo8qyl1GqZU2Ogro3YHmEJJySzYKgqVrY2Nj3tC0hgL+N
   dyJFsAp4gCL+Xh0pQRQBC3NW1Gk5lkYF8xCMABbhnz0nzbYkM0+t5q8iN
   q/8AkeB6GqtLDUHdcTEn0LWf/1RITWP3EwJiTO73U559XRMof/EzEjLS3
   2W24enpIfnjfgas/jMoWefpl65JhAHhZICgrB9hn2uLiVysTJbAK1frXC
   Y7aRhHVSnwRz7UXJb2ltTRgw720EmXvXSOCSJkNYq963D3GSKRHehGgtK
   0pAY51oUp3a0WLiFp3TNuGlexjhFEAA/AWS9DoSjv1IGH99QO9Ko4RMMQ
   A==;
IronPort-SDR: UA3b4W1c0SlI9aKmkIjd+jY1LFF7qGeq/5N6cNleHFkJgTI1Nb3gEtW7qkr6vL3LEHB1m1e2q+
 l8+EMK1xP6dLCDqD5pYM9dr1wfDNACiJC/ri3+nnnXR0iTDLi3V+1xFoIvsX/lys01UfEPsjQp
 FrgHn542jIcnh7IEToG5oMrQcL5bTaCxLbArIzatyNusIODdO4FZ4fpM81S77KPdLl7eXUR+G0
 mTAVDFveQmMGjQ5/OrnluvmIvgLBoGWMWFy0zFT03elcI/R9fPGpktLjhBvcD8sW6pylNzOkCs
 7dY=
X-IronPort-AV: E=Sophos;i="5.81,173,1610434800"; 
   d="scan'208";a="103556667"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Feb 2021 06:05:38 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 12 Feb 2021 06:06:00 -0700
Received: from tyr.hegelund-hansen.dk (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 12 Feb 2021 06:05:58 -0700
Message-ID: <ffa00a2bf83ffa21ffdc61b380ab800c31f8cf28.camel@microchip.com>
Subject: Re: [PATCH v14 2/4] phy: Add media type and speed serdes
 configuration interfaces
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>
CC:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Date:   Fri, 12 Feb 2021 14:05:35 +0100
In-Reply-To: <04d91f6b-775a-8389-b813-31f7b4a778cb@ti.com>
References: <20210210085255.2006824-1-steen.hegelund@microchip.com>
         <20210210085255.2006824-3-steen.hegelund@microchip.com>
         <04d91f6b-775a-8389-b813-31f7b4a778cb@ti.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kishon,

On Fri, 2021-02-12 at 17:02 +0530, Kishon Vijay Abraham I wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you
> know the content is safe
> 
> Hi Steen,
> 
> On 10/02/21 2:22 pm, Steen Hegelund wrote:
> > Provide new phy configuration interfaces for media type and speed
> > that
> > allows allows e.g. PHYs used for ethernet to be configured with
> > this
> > information.
> > 
> > Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
> > Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> > ---
> >  drivers/phy/phy-core.c  | 30 ++++++++++++++++++++++++++++++
> >  include/linux/phy/phy.h | 26 ++++++++++++++++++++++++++
> >  2 files changed, 56 insertions(+)
> > 
> > diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> > index 71cb10826326..ccb575b13777 100644
> > --- a/drivers/phy/phy-core.c
> > +++ b/drivers/phy/phy-core.c
> > @@ -373,6 +373,36 @@ int phy_set_mode_ext(struct phy *phy, enum
> > phy_mode mode, int submode)
> >  }
> >  EXPORT_SYMBOL_GPL(phy_set_mode_ext);
> > 
> > +int phy_set_media(struct phy *phy, enum phy_media media)
> > +{
> > +     int ret;
> > +
> > +     if (!phy || !phy->ops->set_media)
> > +             return 0;
> > +
> > +     mutex_lock(&phy->mutex);
> > +     ret = phy->ops->set_media(phy, media);
> > +     mutex_unlock(&phy->mutex);
> > +
> > +     return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(phy_set_media);
> > +
> > +int phy_set_speed(struct phy *phy, int speed)
> > +{
> > +     int ret;
> > +
> > +     if (!phy || !phy->ops->set_speed)
> > +             return 0;
> > +
> > +     mutex_lock(&phy->mutex);
> > +     ret = phy->ops->set_speed(phy, speed);
> > +     mutex_unlock(&phy->mutex);
> > +
> > +     return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(phy_set_speed);
> 
> Can't speed derived from mode? Do we need a separate set_speed
> function?
> 
> Thanks
> Kishon

Yes the client will need to be able to choose the speed as needed: 
e.g. lower than the serdes mode supports, in case the the media or the
other end is not capable of running that speed.  

An example is a 10G and 25G serdes connected via DAC and as there is no
inband autoneg, the 25G client would have to manually select 10G speed
to communicate with its partner.

> 
> > +
> >  int phy_reset(struct phy *phy)
> >  {
> >       int ret;
> > diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
> > index e435bdb0bab3..e4fd69a1faa7 100644
> > --- a/include/linux/phy/phy.h
> > +++ b/include/linux/phy/phy.h
> > @@ -44,6 +44,12 @@ enum phy_mode {
> >       PHY_MODE_DP
> >  };
> > 
> > +enum phy_media {
> > +     PHY_MEDIA_DEFAULT,
> > +     PHY_MEDIA_SR,
> > +     PHY_MEDIA_DAC,
> > +};
> > +
> >  /**
> >   * union phy_configure_opts - Opaque generic phy configuration
> >   *
> > @@ -64,6 +70,8 @@ union phy_configure_opts {
> >   * @power_on: powering on the phy
> >   * @power_off: powering off the phy
> >   * @set_mode: set the mode of the phy
> > + * @set_media: set the media type of the phy (optional)
> > + * @set_speed: set the speed of the phy (optional)
> >   * @reset: resetting the phy
> >   * @calibrate: calibrate the phy
> >   * @release: ops to be performed while the consumer relinquishes
> > the PHY
> > @@ -75,6 +83,8 @@ struct phy_ops {
> >       int     (*power_on)(struct phy *phy);
> >       int     (*power_off)(struct phy *phy);
> >       int     (*set_mode)(struct phy *phy, enum phy_mode mode, int
> > submode);
> > +     int     (*set_media)(struct phy *phy, enum phy_media media);
> > +     int     (*set_speed)(struct phy *phy, int speed);
> > 
> >       /**
> >        * @configure:
> > @@ -215,6 +225,8 @@ int phy_power_off(struct phy *phy);
> >  int phy_set_mode_ext(struct phy *phy, enum phy_mode mode, int
> > submode);
> >  #define phy_set_mode(phy, mode) \
> >       phy_set_mode_ext(phy, mode, 0)
> > +int phy_set_media(struct phy *phy, enum phy_media media);
> > +int phy_set_speed(struct phy *phy, int speed);
> >  int phy_configure(struct phy *phy, union phy_configure_opts
> > *opts);
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
> > +     return -ENOSYS;
> > +}
> > +
> > +static inline int phy_set_speed(struct phy *phy, int speed)
> > +{
> > +     if (!phy)
> > +             return 0;
> > +     return -ENOSYS;
> > +}
> > +
> >  static inline enum phy_mode phy_get_mode(struct phy *phy)
> >  {
> >       return PHY_MODE_INVALID;
> > 


Thanks for your comments.


-- 
BR
Steen

-=-=-=-=-=-=-=-=-=-=-=-=-=-=
steen.hegelund@microchip.com

