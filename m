Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884B431C778
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 09:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhBPIlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 03:41:40 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:43134 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbhBPIjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 03:39:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613464754; x=1645000754;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Nq9yQxYqOwgVE/65sX+lXgjLa7zjX+KlCrzRlYHvhQs=;
  b=vGjwDVf5ZswNQj53LopgZf7VVuNK4TOiydcBOadih3KcrvquHAH9gufE
   6n5d3iYiP2VpkYclZtmxu/E/8vQpyaVcaklBLfV70GmwwRDNP4afNHRxd
   OyXQGMl85yBmBOpmSjhufZh46h7CKqj91fW4aHlRuxRXfqjkir1zohAW5
   gBvnrwDOXmVsPfzKQ3xLkMwhawguD3Jj8dpqu8EkW5tttqKHYGkZnhcm/
   dJvtZOqTB7AustwMEK+XALMNuBF59AU8bdqyOG48qRS3babikOyQNd1z2
   k41QtWN0B6i8S0/SdT2zQ2u85MCrLcXUgnQH9cw75TRzIMC27I0VeoFnJ
   g==;
IronPort-SDR: Sy1A1/+uQtytlMN+4nwYKEvrFZK0Jaeu7b9LDMpseh76HQgCs56yX4xguv/ew7lZJE1jC6mui1
 AzaFU56nbzHafne42RLxcSYhou8AW1eGbQ8Wd3DBzlGLyMaBw4OlLtEGRMSBZIqDvvMKj9h9YZ
 iMNxD3Q4coDBC734N4+UfvfEEROWN1A0F3rIdA6qLqKXPF/YHnHLX2oRX5rG8X9X0Pybz2UczT
 wbz7mytxUUshiWSE3LSk3n7AO58Tn26+NCxBBD4GjugxowlTWhvN2sUARRxHlC9y4iO+fNAS+R
 5Do=
X-IronPort-AV: E=Sophos;i="5.81,183,1610434800"; 
   d="scan'208";a="115234890"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Feb 2021 01:37:59 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 16 Feb 2021 01:37:59 -0700
Received: from tyr.hegelund-hansen.dk (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 16 Feb 2021 01:37:57 -0700
Message-ID: <d5b3ccf9df1968671baadcd3c7a5e068d48867c5.camel@microchip.com>
Subject: Re: [PATCH v14 2/4] phy: Add media type and speed serdes
 configuration interfaces
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Kishon Vijay Abraham I <kishon@ti.com>
CC:     Vinod Koul <vkoul@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date:   Tue, 16 Feb 2021 09:37:56 +0100
In-Reply-To: <YCqAMUfinMsnZnrq@lunn.ch>
References: <20210210085255.2006824-1-steen.hegelund@microchip.com>
         <20210210085255.2006824-3-steen.hegelund@microchip.com>
         <04d91f6b-775a-8389-b813-31f7b4a778cb@ti.com>
         <ffa00a2bf83ffa21ffdc61b380ab800c31f8cf28.camel@microchip.com>
         <704b850f-9345-2e36-e84b-b332fed22270@ti.com> <YCqAMUfinMsnZnrq@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew and Kishon,

On Mon, 2021-02-15 at 15:07 +0100, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you
> know the content is safe
> 
> On Mon, Feb 15, 2021 at 05:25:10PM +0530, Kishon Vijay Abraham I
> wrote:
> > Okay. Is it going to be some sort of manual negotiation where the
> > Ethernet controller invokes set_speed with different speeds? Or the
> > Ethernet controller will get the speed using some out of band
> > mechanism
> > and invokes set_speed once with the actual speed?
> 
> Hi Kishon
> 
> There are a few different mechanism possible.
> 
> The SFP has an EEPROM which contains lots of parameters. One is the
> maximum baud rate the module supports. PHYLINK will combine this
> information with the MAC capabilities to determine the default speed.
> 
> The users can select the mode the MAC works in, e.g. 1000BaseX vs
> 2500BaseX, via ethtool -s. Different modes needs different speeds.
> 
> Some copper PHYs will change there host side interface baud rate when
> the media side interface changes mode. 10GBASE-X for 10G copper,
> 5GBase-X for 5G COPPER, 2500Base-X for 2.5G copper, and SGMII for
> old school 10/100/1G Ethernet.
> 
> Mainline Linux has no support for it, but some 'vendor crap' will do
> a
> manual negotiation, simply trying different speeds and see if the
> SERDES establishes link. There is nothing standardised for this, as
> far as i know.
> 
>     Andrew

Yes, in case I mention the only way to ensure communication is human
intervention to set the speed to the highest common denominator.

BR
Steen



