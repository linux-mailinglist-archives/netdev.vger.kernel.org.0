Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9417196066
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 22:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbgC0V05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 17:26:57 -0400
Received: from mail.bugwerft.de ([46.23.86.59]:36030 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727444AbgC0V05 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 17:26:57 -0400
Received: from [192.168.178.200] (pD95EF8FC.dip0.t-ipconnect.de [217.94.248.252])
        by mail.bugwerft.de (Postfix) with ESMTPSA id B786D29C4DE;
        Fri, 27 Mar 2020 21:25:00 +0000 (UTC)
Subject: Re: [PATCH] net: dsa: mv88e6xxx: don't force settings on CPU port
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
References: <20200327195156.1728163-1-daniel@zonque.org>
 <20200327200153.GR3819@lunn.ch>
 <d101df30-5a9e-eac1-94b0-f171dbcd5b88@zonque.org>
 <20200327211821.GT3819@lunn.ch>
From:   Daniel Mack <daniel@zonque.org>
Autocrypt: addr=daniel@zonque.org; prefer-encrypt=mutual; keydata=
 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
Message-ID: <1bff1da3-8c9d-55c6-3408-3ae1c3943041@zonque.org>
Date:   Fri, 27 Mar 2020 22:26:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200327211821.GT3819@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/3/2020 10:18 pm, Andrew Lunn wrote:
> On Fri, Mar 27, 2020 at 09:48:56PM +0100, Daniel Mack wrote:
>> On 27/3/2020 9:01 pm, Andrew Lunn wrote:
>>> On Fri, Mar 27, 2020 at 08:51:56PM +0100, Daniel Mack wrote:
>>>> On hardware with a speed-reduced link to the CPU port, forcing the MAC
>>>> settings won't allow any packets to pass. The PHY will negotiate the
>>>> maximum possible speed, so let's allow the MAC to work with whatever
>>>> is available.
>>>
>>> This will break board which rely on the CPU being forced to the
>>> maximum speed, which has been the default since forever.
>>
>> Will it? Wouldn't the PHY negotiate the maximum speed, and the MAC would
>> follow?
> 
> Most boards just connect the SoC MAC to the switch MAC. No PHY.

Yes, I know. In our design all RGMII ports are in use already, so we had
to go for a transformer-less link on a regular copper port, and connect
a phy on the other side.

> And i guess you are stuck with this design?

Yes.

>> Yes, this is what I have. The maximum speed the is negotiable on that
>> link is 100M, and the PHYs see each other just fine (according to the
>> status registers of the external PHY). The problem is that the MAC
>> inside the switch is forced to 1G, which doesn't match what the PHY
>> negotiated.
> 
> So try a fixed link in the CPU node.
> 
>                                        port@6 {
>                                                 reg = <6>;
>                                                 label = "cpu";
>                                                 ethernet = <&fec1>;
> 
>                                                 fixed-link {
>                                                         speed = <100>;
>                                                         full-duplex;
>                                                 };
>
> This won't work with current net-next, which is broken at the
> moment. But it might work with older kernels.

I tried this as well with v5.5, but that leads to the external phy not
seeing a link at all. Will check again though.

Could you think of a way to make this behavior conditional? Could we
introduce a DT property or something?

Worst case is to keep that one-liner as a downstream patch, but I could
well imagine other people facing the same issue.


Thanks,
Daniel
