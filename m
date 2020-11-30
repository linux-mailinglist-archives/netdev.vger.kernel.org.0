Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07802C881F
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 16:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbgK3PfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 10:35:05 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:64057 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726928AbgK3PfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 10:35:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1606750505; x=1638286505;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yh/9jyNbC+WVXDi5gTOo7nbFLVqD5gAEtCs3OlVUV5c=;
  b=otYauxxxaFJLaKF8XCxJIBLHD6hJCFXn/pi4SW2IQsJwHYvRoe8RQlDW
   WMYJp+aQATc/hzNYK62iWjYGRXcucASBhHMQcrn+UvpAg6UnYU3o97i08
   h0tp5CVuturieEPbz6IOMbhywQ0Yev2v8fls8MYtyUPqvKgE0WE22zOxS
   EcPz3BQMb+SAGApHWNp96HU0KyD+ZEfi1E1BojRWhiv6h+tW4aS4/bqHk
   rOKumBOxg6RderBv6Z6qt10amjBKkmME0EktsmD3PtMAtTw0Oy31LPQY6
   Y+cyxvN1m1hRMK7L6s7LIhkglps7Aglx4RgqEMHgVzqPkItmDHJuySBgS
   Q==;
IronPort-SDR: bzhUfiUFICS5zgjeIeTJJUPHRcQwbgscyBA6rtzQMEgNq/SoPoZiHqPj7vUpxv+xLqyuysml3P
 YSnCFn4OXuUm4SATy9ddWJWjM01zCw+6eFB9uVf+aR12puPBw5DjrZmQlZlzycIyycrSS3HTje
 JOlhOMEscmaYSSfCO9BcQ3Qe/YEvj6gpPtl/WOxyO4coASZ6VdaWmcfljYLS87rCsqf7WoxM97
 fCWeNdu9UMHpJA4r7gA6z9VvsBy/xY8y50z0ysn3rZ1/4Cb5aEELO1F7ApScErD6//KJR9UIhm
 1uE=
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="100244328"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2020 08:34:00 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 30 Nov 2020 08:33:58 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 30 Nov 2020 08:33:58 -0700
Date:   Mon, 30 Nov 2020 16:33:57 +0100
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microsemi List <microsemi@lists.bootlin.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 1/3] dt-bindings: net: sparx5: Add sparx5-switch
 bindings
Message-ID: <20201130153357.d6tiqgedzlnrpm2y@mchp-dev-shegelun>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-2-steen.hegelund@microchip.com>
 <20201127170052.GV2073444@lunn.ch>
 <20201130130934.o47mdjiqidtznm2t@mchp-dev-shegelun>
 <20201130140516.GC2073444@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20201130140516.GC2073444@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.11.2020 15:05, Andrew Lunn wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>On Mon, Nov 30, 2020 at 02:09:34PM +0100, Steen Hegelund wrote:
>> On 27.11.2020 18:00, Andrew Lunn wrote:
>> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>> >
>> > > +  reg-names:
>> > > +    minItems: 153
>> > > +    items:
>> > > +      - const: dev2g5_0
>> > > +      - const: dev5g_0
>> > > +      - const: pcs5g_br_0
>> > > +      - const: dev2g5_1
>> > > +      - const: dev5g_1
>> > ...
>> > > +      - const: ana_ac
>> > > +      - const: vop
>> >
>> > > +    switch: switch@600000000 {
>> > > +      compatible = "microchip,sparx5-switch";
>> > > +      reg = <0x10004000 0x4000>, /* dev2g5_0 */
>> > > +        <0x10008000 0x4000>, /* dev5g_0 */
>> > > +        <0x1000c000 0x4000>, /* pcs5g_br_0 */
>> > > +        <0x10010000 0x4000>, /* dev2g5_1 */
>> > > +        <0x10014000 0x4000>, /* dev5g_1 */
>> >
>> > ...
>> >
>> > > +        <0x11800000 0x100000>, /* ana_l2 */
>> > > +        <0x11900000 0x100000>, /* ana_ac */
>> > > +        <0x11a00000 0x100000>; /* vop */
>> >
>> > This is a pretty unusual binding.
>> >
>> > Why is it not
>> >
>> > reg = <0x10004000 0x1af8000>
>> >
>> > and the driver can then break up the memory into its sub ranges?
>> >
>> >    Andrew
>> Hi Andrew,
>>
>> Since the targets used by the driver is not always in the natural
>> address order (e.g. the dev2g5_x targets), I thought it best to let the DT
>> take care of this since this cannot be probed.  I am aware that this causes
>> extra mappings compared to the one-range strategy, but this layout seems more
>> transparent to me, also when mapped over PCIe.
>
>The question is, do you have a device tree usage for this? Are there
>devices in the family which have the regions in a different order?
>

Hi Andrew,

Yes we do have more chips in the pipeline that we expect to be able to
use this driver.  But I see your point.  The new chips most certainly will
have a different number of targets (that will most likely map to different
addresses).

The bindings will need to be able to cope with the different number of
targets, and I think that will be difficult.

So all in all I think I will rework this, and make the mapping in the
driver instead.

>You can easily move this table into the driver, and let the driver
>break the region up. That would be normal.
>
>      Andrew

BR
Steen

---------------------------------------
Steen Hegelund
steen.hegelund@microchip.com
