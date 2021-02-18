Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDFE31ED57
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234342AbhBRRa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:30:27 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:26610 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbhBROq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 09:46:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613659618; x=1645195618;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dyXayGWuX+Kuke5GEv4XoGnhgT27caNB9nxMLMsNigc=;
  b=rXkelD3hbRU57XQjv8wB1DwbQgL9c0LYk58v+NjV56kEjCD03EdzaH1o
   B8Timc3yr/lHLFfd31tUNuYgK24T+xLB9Bs9W4fixV6T2fmS4W7mjnYVA
   X8L3DnrjsgYUgqNEIKNlqLlrNPN5lFmM1ZQvyWsyBIShpJbX8/1hWO94s
   ZW1U+rqxrmdSoICR3TehXK8jKdtlKQytDym1u6Hy+6DRq2y69jrMWWgCn
   2Y5JDqOJInl5jK6K7z3IiI56QYRqvADGEEg3Z6gAoQZJSofg6zzxDs7cf
   WjkJ1wOuk0kkMWlpbHuNaQw2Srsx/tiTjzwWGjyrh8ZjhthMojpsrY5vb
   Q==;
IronPort-SDR: 0G+IookcOZZ6GuoMFIZiJro017YKfvoo7IPmrCY3Y3QoVUoWHqcXGwaKiCVE0xhTWojL787q/q
 f/toLH0x8pOM44IlYaFvUV8PS41kWNMYkp6IyRwUpHWUbyisdZItMsVkiEL3sjqqMpQehh0rYT
 Fnc9Q26MAeFyMA6fkTJq+5H8l8uGmWRq5TnkVr5bpUmE09CuqXAy71d80n082M1EkvaafRvTuz
 X8N4hjQf2K72b/QOpOjuTur7sOYGFD6dpJsTAToybkuyx9AZKx+t1+4wc9CTDGLQOwdYDX+osH
 pNQ=
X-IronPort-AV: E=Sophos;i="5.81,187,1610434800"; 
   d="scan'208";a="109758822"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Feb 2021 07:45:32 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Feb 2021 07:45:30 -0700
Received: from tyr.hegelund-hansen.dk (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 18 Feb 2021 07:45:28 -0700
Message-ID: <5abbe42602ad92bd4bb0b36b64b8621dee805103.camel@microchip.com>
Subject: Re: [PATCH v14 2/4] phy: Add media type and speed serdes
 configuration interfaces
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Vinod Koul <vkoul@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date:   Thu, 18 Feb 2021 15:45:27 +0100
In-Reply-To: <d5351524-d02d-0bdb-53ba-b5b9a72673f2@ti.com>
References: <20210210085255.2006824-1-steen.hegelund@microchip.com>
         <20210210085255.2006824-3-steen.hegelund@microchip.com>
         <04d91f6b-775a-8389-b813-31f7b4a778cb@ti.com>
         <ffa00a2bf83ffa21ffdc61b380ab800c31f8cf28.camel@microchip.com>
         <704b850f-9345-2e36-e84b-b332fed22270@ti.com> <YCqAMUfinMsnZnrq@lunn.ch>
         <d5b3ccf9df1968671baadcd3c7a5e068d48867c5.camel@microchip.com>
         <d5351524-d02d-0bdb-53ba-b5b9a72673f2@ti.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kishon,

On Tue, 2021-02-16 at 15:54 +0530, Kishon Vijay Abraham I wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you
> know the content is safe
> 
> Hi,
> 
> On 16/02/21 2:07 pm, Steen Hegelund wrote:
> > Hi Andrew and Kishon,
> > 
> > On Mon, 2021-02-15 at 15:07 +0100, Andrew Lunn wrote:
> > > EXTERNAL EMAIL: Do not click links or open attachments unless you
> > > know the content is safe
> > > 
> > > On Mon, Feb 15, 2021 at 05:25:10PM +0530, Kishon Vijay Abraham I
> > > wrote:
> > > > Okay. Is it going to be some sort of manual negotiation where
> > > > the
> > > > Ethernet controller invokes set_speed with different speeds? Or
> > > > the
> > > > Ethernet controller will get the speed using some out of band
> > > > mechanism
> > > > and invokes set_speed once with the actual speed?
> > > 
> > > Hi Kishon
> > > 
> > > There are a few different mechanism possible.
> > > 
> > > The SFP has an EEPROM which contains lots of parameters. One is
> > > the
> > > maximum baud rate the module supports. PHYLINK will combine this
> > > information with the MAC capabilities to determine the default
> > > speed.
> > > 
> > > The users can select the mode the MAC works in, e.g. 1000BaseX vs
> > > 2500BaseX, via ethtool -s. Different modes needs different
> > > speeds.
> > > 
> > > Some copper PHYs will change there host side interface baud rate
> > > when
> > > the media side interface changes mode. 10GBASE-X for 10G copper,
> > > 5GBase-X for 5G COPPER, 2500Base-X for 2.5G copper, and SGMII for
> > > old school 10/100/1G Ethernet.
> > > 
> > > Mainline Linux has no support for it, but some 'vendor crap' will
> > > do
> > > a
> > > manual negotiation, simply trying different speeds and see if the
> > > SERDES establishes link. There is nothing standardised for this,
> > > as
> > > far as i know.
> > > 
> > >     Andrew
> > 
> > Yes, in case I mention the only way to ensure communication is
> > human
> > intervention to set the speed to the highest common denominator.
> 
> Okay.. is it the same case for set_media as well?

Yes, but in the media type case, we should be able to get the type from
the DAC cable EPPROM information as mentioned by Andrew, so human
intervention should not be needed.


> 
> Thanks
> Kishon

Thanks for your comments.

-- 
BR
Steen

-=-=-=-=-=-=-=-=-=-=-=-=-=-=
steen.hegelund@microchip.com

