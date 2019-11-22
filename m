Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25230107588
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 17:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbfKVQO4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 22 Nov 2019 11:14:56 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:45539 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfKVQOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 11:14:55 -0500
Received: from marcel-macbook.fritz.box (p4FF9F0D1.dip0.t-ipconnect.de [79.249.240.209])
        by mail.holtmann.org (Postfix) with ESMTPSA id BE461CED23;
        Fri, 22 Nov 2019 17:24:00 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3601.0.10\))
Subject: Re: [PATCH v6 3/4] dt-bindings: net: broadcom-bluetooth: Add pcm
 config
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CAL_JsqKso2Us5VW-Qp8mENAkMmoEh7YDT+HfhRMD1BKi7q=qAw@mail.gmail.com>
Date:   Fri, 22 Nov 2019 17:14:53 +0100
Cc:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        devicetree <devicetree@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ondrej Jirman <megous@megous.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <FBAB12FA-8EAD-424C-9DF3-770E7D172AFD@holtmann.org>
References: <20191118192123.82430-1-abhishekpandit@chromium.org>
 <20191118110335.v6.3.I18b06235e381accea1c73aa2f9db358645d9f201@changeid>
 <20191121212923.GA24437@bogus>
 <06AE1B9D-F048-4AF1-9826-E8CAFA44DD58@holtmann.org>
 <CAL_JsqKso2Us5VW-Qp8mENAkMmoEh7YDT+HfhRMD1BKi7q=qAw@mail.gmail.com>
To:     Rob Herring <robh@kernel.org>
X-Mailer: Apple Mail (2.3601.0.10)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

>>>> Add documentation for pcm parameters.
>>>> 
>>>> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
>>>> ---
>>>> 
>>>> Changes in v6: None
>>>> Changes in v5: None
>>>> Changes in v4: None
>>>> Changes in v3: None
>>>> Changes in v2: None
>>> 
>>> Really? I'm staring at v2 that looks a bit different.
>>> 
>>>> .../bindings/net/broadcom-bluetooth.txt       | 16 ++++++++++
>>>> include/dt-bindings/bluetooth/brcm.h          | 32 +++++++++++++++++++
>>>> 2 files changed, 48 insertions(+)
>>>> create mode 100644 include/dt-bindings/bluetooth/brcm.h
>>>> 
>>>> diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
>>>> index c749dc297624..8561e4684378 100644
>>>> --- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
>>>> +++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
>>>> @@ -29,10 +29,20 @@ Optional properties:
>>>>   - "lpo": external low power 32.768 kHz clock
>>>> - vbat-supply: phandle to regulator supply for VBAT
>>>> - vddio-supply: phandle to regulator supply for VDDIO
>>>> + - brcm,bt-sco-routing: PCM, Transport, Codec, I2S
>>>> + - brcm,bt-pcm-interface-rate: 128KBps, 256KBps, 512KBps, 1024KBps, 2048KBps
>>>> + - brcm,bt-pcm-frame-type: short, long
>>>> + - brcm,bt-pcm-sync-mode: slave, master
>>>> + - brcm,bt-pcm-clock-mode: slave, master
>>> 
>>> Little of this seems unique to Broadcom. We already have some standard
>>> audio related properties for audio interfaces such as 'format',
>>> 'frame-master' and 'bitclock-master'. Ultimately, this would be tied
>>> into the audio complex of SoCs and need to work with the audio
>>> bindings. We also have HDMI audio bindings.
>>> 
>>> Maybe sco-routing is unique to BT and still needed in some form though
>>> if you describe the connection to the SoC audio complex, then maybe
>>> not? I'd assume every BT chip has some audio routing configuration.
>> 
>> so we tried to generalize this some time before and failed to get a proper consensus.
>> 
>> In general I am with you that we should just expose generic properties from the attached audio codec, but nobody has come up with anything like that. And I think aligning all chip manufacturers will take some time.
>> 
> 
> That shouldn't be hard. It's a solved problem for codecs and HDMI. I
> don't think BT is any more complicated (ignoring phones). I suspect
> it's not solved simply because no one wants to do the work beyond
> their 1 BT device they care about ATM.

we tried, but nobody can agree on these right now. I would be happy if others come forward and tell us how they wired up their hardware, but it hasn’t happened yet.

>> Maybe in the interim we just use brcm,bt-pcm-int-params = [00 00 ..] as initially proposed.
> 
> What's the device using this? Some chromebook I suppose. I think it
> would be better to first see how this fits in with the rest of the
> audio subsystem. Until then, the driver should probably just default
> to "transport" mode which I assume is audio routed over the UART
> interface. That should work on any platform at least, but may not be
> optimal.

SCO over UART doesn’t really work. Long time ago, some car kits might have done it, but in the Chromebook cases this will just not work. We need to configure the PCM settings of the Bluetooth chip.

If we don’t do it via DT, then this gets hardcoded in the driver source and that is not helping either. So until we get anything better, lets use brcm,bt-pcm-int-params = [00 00 ..] and get this supported upstream.

Regards

Marcel

