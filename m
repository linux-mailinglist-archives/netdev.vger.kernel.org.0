Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7B3107236
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 13:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbfKVMeK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 22 Nov 2019 07:34:10 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:44710 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfKVMeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 07:34:09 -0500
Received: from marcel-macbook.holtmann.net (p4FF9F0D1.dip0.t-ipconnect.de [79.249.240.209])
        by mail.holtmann.org (Postfix) with ESMTPSA id B2E17CED1F;
        Fri, 22 Nov 2019 13:43:14 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3601.0.10\))
Subject: Re: [PATCH v6 3/4] dt-bindings: net: broadcom-bluetooth: Add pcm
 config
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20191121212923.GA24437@bogus>
Date:   Fri, 22 Nov 2019 13:34:06 +0100
Cc:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        devicetree <devicetree@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ondrej Jirman <megous@megous.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <06AE1B9D-F048-4AF1-9826-E8CAFA44DD58@holtmann.org>
References: <20191118192123.82430-1-abhishekpandit@chromium.org>
 <20191118110335.v6.3.I18b06235e381accea1c73aa2f9db358645d9f201@changeid>
 <20191121212923.GA24437@bogus>
To:     Rob Herring <robh@kernel.org>
X-Mailer: Apple Mail (2.3601.0.10)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

>> Add documentation for pcm parameters.
>> 
>> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
>> ---
>> 
>> Changes in v6: None
>> Changes in v5: None
>> Changes in v4: None
>> Changes in v3: None
>> Changes in v2: None
> 
> Really? I'm staring at v2 that looks a bit different.
> 
>> .../bindings/net/broadcom-bluetooth.txt       | 16 ++++++++++
>> include/dt-bindings/bluetooth/brcm.h          | 32 +++++++++++++++++++
>> 2 files changed, 48 insertions(+)
>> create mode 100644 include/dt-bindings/bluetooth/brcm.h
>> 
>> diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
>> index c749dc297624..8561e4684378 100644
>> --- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
>> +++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
>> @@ -29,10 +29,20 @@ Optional properties:
>>    - "lpo": external low power 32.768 kHz clock
>>  - vbat-supply: phandle to regulator supply for VBAT
>>  - vddio-supply: phandle to regulator supply for VDDIO
>> + - brcm,bt-sco-routing: PCM, Transport, Codec, I2S
>> + - brcm,bt-pcm-interface-rate: 128KBps, 256KBps, 512KBps, 1024KBps, 2048KBps
>> + - brcm,bt-pcm-frame-type: short, long
>> + - brcm,bt-pcm-sync-mode: slave, master
>> + - brcm,bt-pcm-clock-mode: slave, master
> 
> Little of this seems unique to Broadcom. We already have some standard 
> audio related properties for audio interfaces such as 'format', 
> 'frame-master' and 'bitclock-master'. Ultimately, this would be tied 
> into the audio complex of SoCs and need to work with the audio 
> bindings. We also have HDMI audio bindings. 
> 
> Maybe sco-routing is unique to BT and still needed in some form though 
> if you describe the connection to the SoC audio complex, then maybe 
> not? I'd assume every BT chip has some audio routing configuration.

so we tried to generalize this some time before and failed to get a proper consensus.

In general I am with you that we should just expose generic properties from the attached audio codec, but nobody has come up with anything like that. And I think aligning all chip manufacturers will take some time.

Maybe in the interim we just use brcm,bt-pcm-int-params = [00 00 ..] as initially proposed.

Regards

Marcel

