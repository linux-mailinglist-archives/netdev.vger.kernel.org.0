Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7673B305E98
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 15:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234542AbhA0Ori (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 09:47:38 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:41909 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234240AbhA0Ora (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 09:47:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611758849; x=1643294849;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QkcXxzNQo+CiSnWQy/sM6qbG/bFI75MPmn6Y5uD/e/U=;
  b=2nndfOLDruO1REt1OcAyYiaKsJuDmJWglVmFnJVQHFmBCagi1eLZXRhM
   2KrGbh0lVjyJB62UePfKQsO8yaaTJs5riI2R9Amr9ZRukQkDNZayMYzU/
   8SF8LQMp2n5ItszouIlsNBY9bMmw37cke536DjC0F/srqrx9+aeX99JKC
   aJApRPhammmAUaVV5GdTD/Tz1aiBPPkqqL5DovE+3MCV+WTgdWm7viPTo
   6wdptYoGeHwDOwXDW4AbVb/YQJWshSebxKQLvOUx4zEkZpyOAxIvUMJXD
   jfnEg//Sx/IFzgMOegEFT3XR65wGULGYmtys3gcw+HsvH+TmiU30hif0i
   Q==;
IronPort-SDR: BcHjX8y/GyigjTmuyfrgx7h2mSYwhbnbjyAFiq2Cjw1F3b6eOvdgio45CkffKkSfE6pXkIc7TK
 xnUaPiPICzjCCNCs90aYUg2/TDVxK07db/QPZzAhqj38kgIh0RJz1B54HJ4yNduvlXrdkVS57t
 kADhIFfF9lcPHipdiC1y4RPlTQjV4/+o25+MOv91zqj4oXVYFnEiIo/FyfabCDnGBc4bS0S2/L
 kHumMp3TltCOVXGKIFLK87KcOz+J+iwVS6FpPi4DaiA/MSkS6xEx+MSaS/kKVqVVWya2nkZUZZ
 Dpo=
X-IronPort-AV: E=Sophos;i="5.79,379,1602572400"; 
   d="scan'208";a="112700639"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2021 07:45:48 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 27 Jan 2021 07:45:48 -0700
Received: from [10.205.21.32] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 27 Jan 2021 07:45:46 -0700
Message-ID: <6221107eae5e749bc7fd75e057209c92c9edd7df.camel@microchip.com>
Subject: Re: [PATCH v12 2/4] phy: Add ethernet serdes configuration option
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>
CC:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Date:   Wed, 27 Jan 2021 15:45:45 +0100
In-Reply-To: <70aa5716-bd14-0a0a-26bc-d3dfa23de47e@ti.com>
References: <20210107091924.1569575-1-steen.hegelund@microchip.com>
         <20210107091924.1569575-3-steen.hegelund@microchip.com>
         <92a943cc-b332-4ac6-42a8-bb3cdae13bc0@ti.com>
         <f35e3c33f011b6aabd96d3b6de3750bf3d04b699.camel@microchip.com>
         <70aa5716-bd14-0a0a-26bc-d3dfa23de47e@ti.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kishon,

On Wed, 2021-01-27 at 18:04 +0530, Kishon Vijay Abraham I wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 

...

> > > 
> > > I'm not familiar with Ethernet. Are these generic media types? what
> > > does
> > > SR or DAC refer to?
> > 
> > The SR stands for Short Reach and is a fiber type connection used by
> > SFPs.  There also other "reach" variants.
> > 
> > DAC stands for Direct Attach Copper and is a type of cable that plugs
> > into an SFP cage and provides information back to the user via its
> > EEPROM regarding supported speed and capabilities in general.  These
> > typically supports speed of 5G or more.
> > 
> > The SFP/Phylink is the "out-of-band" method that provides the type of
> > connection: speed and media type that allows the client to adapt the
> > SerDes configuration to the type of media selected by the user.
> > 
> > > Are there other media types? What is the out-of-band
> > > mechanism by which the controller gets the media type? Why was this
> > > not
> > > required for other existing Ethernet SERDES?
> > 
> > This is probably a matter of the interface speed are now getting higher
> > and the amount of configuration needed for the SerDes have increased,
> > at the same time as this is not being a static setup, because the user
> > an plug and unplug media to the SFP cage.
> > 
> > > Are you aware of any other
> > > vendors who might require this?
> > 
> > I suspect that going forward it will become more widespread, at least
> > we have more chips in the pipeline that need this SerDes for high speed
> > connectivity.
> 
> For this case I would recommend to add new API, something like
> phy_set_media(). Configure() and Validate() is more for probing
> something that is supported by SERDES and changing the parameters. But
> in this case, I'd think the media type is determined by the cable that
> is connected and cannot be changed.
> 
> Thanks
> Kishon

I assume that you would like a separate interface for the speed information as well?

Thanks for your comments.

BR
Steen

