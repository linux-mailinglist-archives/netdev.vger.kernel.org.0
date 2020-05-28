Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A1D1E70D1
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437761AbgE1Xws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437693AbgE1Xwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 19:52:40 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F70C08C5C8;
        Thu, 28 May 2020 16:31:49 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id z26so211127pfk.12;
        Thu, 28 May 2020 16:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E+nZrtxSAOnTyef/x7Km+Sp4EW2/Q1B3nXudz3MSLgQ=;
        b=ESFcXUSymq2cv/URV30y1IePV5mEmk0jutEFxX+IRLPY7hL/BuEIO90Gq/u//dR2u2
         HV+9w2+KjR81hNmlYtkrQgXHdIaLuN/qMB82se2kxWc4o8Kjkp8vWOxPQZ3mSFAc32nT
         oDbZqC8T99UCIwbnu3LQfY+kKBdRNX2L46mVS4aDqhaf/lhSXos5EKijCMbrNj1X4V4i
         N2Mur8Dozz1IgRYKN5AOMc9esRddWs+8HothP5zvzD5HapxpMQxi3BLcQDDkvO9S4glM
         1fdu9CSY8Mq07UIWW68Ghx8wIHOmOhnwLqoyaUFpURlmzBUhRsoy3C36DlMMjUFqO/+v
         of8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E+nZrtxSAOnTyef/x7Km+Sp4EW2/Q1B3nXudz3MSLgQ=;
        b=M+xDyWZLV1Hshk702U7XnOfIORmC+X13FzHO7HLzNilCwXEARAU6D9K+z8+EbR08H/
         3sGuIGUyeCOih4gjPji0efjD2YaarSYvCkoRU/3ylStBw/C+CGzCd+l4y8KlX3gvq9hs
         eVn1HR1aaLlVbmoYrzOqjKPX+lTkXx1ktQ6F1GgTzItY63SECDENQBfLdMWS6m3Tp+U4
         6EMRhP1geB06dLtN3QVmaGxRAt+EIS9+yIMUaW6nNjkCXNHoVlW1JRqfVesF3iKxOhj5
         8jqtSYLeYn5+SnRznjCbS2HO39Sk8qGblXBsUyhIXFwQ9SGvBFvamx7rr/Rssj76+5kW
         Fo5Q==
X-Gm-Message-State: AOAM532cLQciKQC+OwM9AbMpbmNAOHN6y640AYwEKGUhbtNKEvIfEYxC
        +CbqGloHlS3l1qmpjXLjgog=
X-Google-Smtp-Source: ABdhPJx27VlmPXA/JP81DuWPq/Ao6qL/fLP+X6SwDDBAAR8wX2gdY/zj4C7a43HpJAJN5nlEpMNlOw==
X-Received: by 2002:a62:ed10:: with SMTP id u16mr5783670pfh.0.1590708709128;
        Thu, 28 May 2020 16:31:49 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g18sm5319097pgn.47.2020.05.28.16.31.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 16:31:48 -0700 (PDT)
Subject: Re: [PATCH net-next v3] net: phy: micrel: add phy-mode support for
 the KSZ9031 PHY
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Philippe Schenker <philippe.schenker@toradex.com>
Cc:     "o.rempel@pengutronix.de" <o.rempel@pengutronix.de>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sergei.shtylyov@cogentembedded.com" 
        <sergei.shtylyov@cogentembedded.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "david@protonic.nl" <david@protonic.nl>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "kazuya.mizuguchi.ks@renesas.com" <kazuya.mizuguchi.ks@renesas.com>
References: <20200422072137.8517-1-o.rempel@pengutronix.de>
 <CAMuHMdU1ZmSm_tjtWxoFNako2fzmranGVz5qqD2YRNEFRjX0Sw@mail.gmail.com>
 <20200428154718.GA24923@lunn.ch>
 <6791722391359fce92b39e3a21eef89495ccf156.camel@toradex.com>
 <CAMuHMdXm7n6cE5-ZjwxU_yKSrCaZCwqc_tBA+M_Lq53hbH2-jg@mail.gmail.com>
 <20200429092616.7ug4kdgdltxowkcs@pengutronix.de>
 <CAMuHMdWf1f95ZcOLd=k1rd4WE98T1qh_3YsJteyDGtYm1m_Nfg@mail.gmail.com>
 <3a6f6ecc5ea4de7600716a23739c13dc5b02771e.camel@toradex.com>
 <CAMuHMdWnSPrAX1=Q3PQNr3QaE3nrtfr4jbE_r1_BmKke-rC92w@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9eb1d7db-2762-fcec-673d-1f5bd38aaa58@gmail.com>
Date:   Thu, 28 May 2020 16:31:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <CAMuHMdWnSPrAX1=Q3PQNr3QaE3nrtfr4jbE_r1_BmKke-rC92w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/28/2020 5:51 AM, Geert Uytterhoeven wrote:
> Hi Philippe,
> 
> On Thu, May 28, 2020 at 10:20 AM Philippe Schenker
> <philippe.schenker@toradex.com> wrote:
>> On Wed, 2020-05-27 at 21:11 +0200, Geert Uytterhoeven wrote:
>>> On Wed, Apr 29, 2020 at 11:26 AM Oleksij Rempel <
>>> o.rempel@pengutronix.de> wrote:
>>>> On Wed, Apr 29, 2020 at 10:45:35AM +0200, Geert Uytterhoeven wrote:
>>>>> On Tue, Apr 28, 2020 at 6:16 PM Philippe Schenker
>>>>> <philippe.schenker@toradex.com> wrote:
>>>>>> On Tue, 2020-04-28 at 17:47 +0200, Andrew Lunn wrote:
>>>>>>> On Tue, Apr 28, 2020 at 05:28:30PM +0200, Geert Uytterhoeven
>>>>>>> wrote:
>>>>>>>> This triggers on Renesas Salvator-X(S):
>>>>>>>>
>>>>>>>>     Micrel KSZ9031 Gigabit PHY e6800000.ethernet-
>>>>>>>> ffffffff:00:
>>>>>>>> *-skew-ps values should be used only with phy-mode = "rgmii"
>>>>>>>>
>>>>>>>> which uses:
>>>>>>>>
>>>>>>>>         phy-mode = "rgmii-txid";
>>>>>>>>
>>>>>>>> and:
>>>>>>>>
>>>>>>>>         rxc-skew-ps = <1500>;
>>>>>>>>
>>>>>>>> If I understand
>>>>>>>> Documentation/devicetree/bindings/net/ethernet-
>>>>>>>> controller.yaml
>>>>>>>> correctly:
>>>>>>>
>>>>>>> Checking for skews which might contradict the PHY-mode is new.
>>>>>>> I think
>>>>>>> this is the first PHY driver to do it. So i'm not too
>>>>>>> surprised it has
>>>>>>> triggered a warning, or there is contradictory documentation.
>>>>>>>
>>>>>>> Your use cases is reasonable. Have the normal transmit delay,
>>>>>>> and a
>>>>>>> bit shorted receive delay. So we should allow it. It just
>>>>>>> makes the
>>>>>>> validation code more complex :-(
>>>>>>
>>>>>> I reviewed Oleksij's patch that introduced this warning. I just
>>>>>> want to
>>>>>> explain our thinking why this is a good thing, but yes maybe we
>>>>>> change
>>>>>> that warning a little bit until it lands in mainline.
>>>>>>
>>>>>> The KSZ9031 driver didn't support for proper phy-modes until now
>>>>>> as it
>>>>>> don't have dedicated registers to control tx and rx delays. With
>>>>>> Oleksij's patch this delay is now done accordingly in skew
>>>>>> registers as
>>>>>> best as possible. If you now also set the rxc-skew-ps registers
>>>>>> those
>>>>>> values you previously set with rgmii-txid or rxid get
>>>>>> overwritten.
>>>
>>> While I don't claim that the new implementation is incorrect, my
>>> biggest
>>> gripe is that this change breaks existing setups (cfr. Grygorii's
>>> report,
>>> plus see below).  People fine-tuned the parameters in their DTS files
>>> according to the old driver behavior, and now have to update their
>>> DTBs,
>>> which violates DTB backwards-compatibility rules.
>>> I know it's ugly, but I'm afraid the only backwards-compatible
>>> solution
>>> is to add a new DT property to indicate if the new rules apply.
>>>
>>>>>> We chose the warning to occur on phy-modes 'rgmii-id', 'rgmii-
>>>>>> rxid' and
>>>>>> 'rgmii-txid' as on those, with the 'rxc-skew-ps' value present,
>>>>>> overwriting skew values could occur and you end up with values
>>>>>> you do
>>>>>> not wanted. We thought, that most of the boards have just
>>>>>> 'rgmii' set in
>>>>>> phy-mode with specific skew-values present.
>>>>>>
>>>>>> @Geert if you actually want the PHY to apply RXC and TXC delays
>>>>>> just
>>>>>> insert 'rgmii-id' in your DT and remove those *-skew-ps values.
>>>>>> If you
>>>>>
>>>>> That seems to work for me, but of course doesn't take into account
>>>>> PCB
>>>>> routing.
>>>
>>> Of course I talked too soon.  Both with the existing DTS that triggers
>>> the warning, and after changing the mode to "rgmii-id", and dropping
>>> the
>>> *-skew-ps values, Ethernet became flaky on R-Car M3-W ES1.0.  While
>>> the
>>> system still boots, it boots very slow.
>>> Using nuttcp, I discovered TX performance dropped from ca. 400 Mbps to
>>> 0.1-0.3 Mbps, while RX performance looks unaffected.
>>>
>>> So I did some more testing:
>>>   1. Plain "rgmii-txid" and "rgmii" break the network completely, on
>>> all
>>>      R-Car Gen3 platforms,
>>>   2. "rgmii-id" and "rgmii-rxid" work, but cause slowness on R-Car M3-
>>> W,
>>>   3. "rgmii" with *-skew-ps values that match the old values (default
>>>      420 for everything, but default 900 for txc-skew-ps, and the 1500
>>>      override for rxc-skew-ps), behaves exactly the same as "rgmii-
>>> id",
>>>   4. "rgmii-txid" with *-skew-ps values that match the old values does
>>> work, i.e.
>>>      adding to arch/arm64/boot/dts/renesas/salvator-common.dtsi:
>>>      +               rxd0-skew-ps = <420>;
>>>      +               rxd1-skew-ps = <420>;
>>>      +               rxd2-skew-ps = <420>;
>>>      +               rxd3-skew-ps = <420>;
>>>      +               rxdv-skew-ps = <420>;
>>>      +               txc-skew-ps = <900>;
>>>      +               txd0-skew-ps = <420>;
>>>      +               txd1-skew-ps = <420>;
>>>      +               txd2-skew-ps = <420>;
>>>      +               txd3-skew-ps = <420>;
>>>      +               txen-skew-ps = <420>;
>>>
>>> You may wonder what's the difference between 3 and 4? It's not just
>>> the
>>> PHY driver that looks at phy-mode!
>>> drivers/net/ethernet/renesas/ravb_main.c:ravb_set_delay_mode() also
>>> does, and configures an additional TX clock delay of 1.8 ns if TXID is
>>> enabled.  Doing so fixes R-Car M3-W, but doesn't seem to be needed,
>>> or harm, on R-Car H3 ES2.0 and R-Car M3-N.
>>
>> Sorry for chiming in on this topic but I also did make my thoughts about
>> this implementation.
>>
>> The documentation in Documentation/devicetree/bindings/net/ethernet-
>> controller.yaml clearly states, that rgmii-id is meaning the delay is
>> provided by the PHY and MAC should not add anything in this case.
> 
> Thank you for your very valuable comment!
> That means the semantics are clear, and is the reason behind the existence
> of properties like "amlogic,tx-delay-ns", which do apply to the MAC.

They are clear now, but they were not always clear which is why it is
possible that some Ethernet MACs act on the phy_interface_t value when
they should not. There is not a good way to guard against such things
other than reviewing drivers carefully, RGMII was not designed with plug
and play in mind, just reduced pin count.
-- 
Florian
