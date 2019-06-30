Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 970615AF42
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 09:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbfF3HqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 03:46:06 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35038 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbfF3HqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 03:46:05 -0400
Received: by mail-wr1-f68.google.com with SMTP id c27so2707235wrb.2
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 00:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:reply-to:to:cc:references:openpgp:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=aI4JMis947/YaweIlcbeJRJAe+5i7Xo4vT3QqcOcqwI=;
        b=bxoRzpsXXMGJOhJ5AI6iSkbmVPtlST6/72n/FRabNwH+mKsNGfcgb1rFXujpIMnr0w
         IVOx3HjRlGQvYnQxekRuVqQhQX/JgUh3EO+D//E/8YkRBhpk0NUb9Fl7Q8gPLSWKylSN
         rQNxYGRGkyAHjCoZ1P3HCfkI+8B7Y9DxYHd/lBqg/nyZM9CK8DBND38rEnXqhezEM61g
         6SsjSeZHoLs7tHdjO5JthihSGbkFD9BBdXDuF0amNjLTx13WannmMG/0Z3XGWfxO6AxA
         f1wr5yNizU7o5Th0lK/i5YQc09XJVcJ7h36D1HA4tyWAKLx6F9Qr1obSWh5lrfnINc7v
         6ijw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:reply-to:to:cc:references:openpgp:autocrypt
         :subject:message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=aI4JMis947/YaweIlcbeJRJAe+5i7Xo4vT3QqcOcqwI=;
        b=lhuaWAAg+RU6QmMajI8RSoWguTwkw/+L44g7znsqky1/CWcPS11hlHHYIl/CJO+Zx9
         qL+hSeh6bnYEPIDPDWBmJBgDN+fdBG/Sm/P6wD3+w2Wc0HN361ILvZcwbL9g7QvB8gG5
         yetDuG7xVGA82VWYpbwqj5FRsEwTD/F8BP2K5MVqVtdCt1KIAwgQL7nh6O5p71DUvRA4
         balD+FHKRAmg2fzmjWJoqkczfdaVf7bkeJCHPxzNSzhLw6P3/E6mKOwBgptVSpfqokwt
         EY44sdRZ6DlASaIaPaTFVX788vL9E4qYeg5qxRWoQyEiZ2M+Dv8DTCIEzycuv0/acbBO
         3s7w==
X-Gm-Message-State: APjAAAXRCIqaEOJI/ER0wwIo9WuQvq4oBm6WuM/XyOy3WFnKskI+lrYS
        phbWz2zXNmB50Xef1NW5Au4=
X-Google-Smtp-Source: APXvYqwGxJG5dGHDAH1QUaJYiazet8JlNUYcQ4G0ttfKP9HBg7X26EyClmPSZb3thcmBCuQjXjjSQw==
X-Received: by 2002:a5d:438f:: with SMTP id i15mr8840058wrq.37.1561880762870;
        Sun, 30 Jun 2019 00:46:02 -0700 (PDT)
Received: from [192.168.84.205] ([46.59.137.91])
        by smtp.gmail.com with ESMTPSA id w25sm1308938wmk.18.2019.06.30.00.46.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 30 Jun 2019 00:46:02 -0700 (PDT)
From:   vtolkm@googlemail.com
X-Google-Original-From: vtolkm@gmail.com
Reply-To: vtolkm@gmail.com
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>
References: <e5252bf0-f9c1-3e40-aebd-8c091dbb3e64@gmail.com>
 <20190629224927.GA26554@lunn.ch>
 <6226b473-b232-e1d3-40e9-18d118dd82c4@gmail.com>
 <20190629231119.GC26554@lunn.ch>
 <53bd8ffc-1c0a-334d-67d5-3a74b76670e8@gmail.com>
 <aa021a99-accd-75ac-47a4-2c11aa791d3c@gmail.com>
 <1696f8e8-6b83-32c1-9ee0-ca973d7fd70d@gmail.com>
Openpgp: id=640E6954D6F535488EDDC809729CFF47A416598B
Autocrypt: addr=vtolkm@gmail.com; prefer-encrypt=mutual; keydata=
 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
Subject: Re: loss of connectivity after enabling vlan_filtering
Message-ID: <a8e4b588-9b99-5293-a177-59310ea21e39@gmail.com>
Date:   Sun, 30 Jun 2019 09:46:00 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1696f8e8-6b83-32c1-9ee0-ca973d7fd70d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 30/06/2019 03:13, vtolkm@gmail.com wrote:
> On 30/06/2019 02:37, vtolkm@gmail.com wrote:
>> On 30/06/2019 01:23, vtolkm@gmail.com wrote:
>>> On 30/06/2019 01:11, Andrew Lunn wrote:
>>>> On Sun, Jun 30, 2019 at 01:04:50AM +0200, vtolkm@googlemail.com wrot=
e:
>>>>> On 30/06/2019 00:49, Andrew Lunn wrote:
>>>>>> On Sun, Jun 30, 2019 at 12:01:38AM +0200, vtolkm@googlemail.com wr=
ote:
>>>>>>> * DSA MV88E6060
>>>>>>> * iproute2 v.5.0.0-2.0
>>>>>>> * OpenWRT 19.07 with kernel 4.14.131 armv7l
>>>>>> The mv88e6060 driver is very simple. It has no support for VLANs. =
It
>>>>>> does not even have support for offloading bridging between ports t=
o
>>>>>> the switch.
>>>>>>
>>>>>> The data sheet for this device is open. So if you want to hack on =
the
>>>>>> driver, you could do.
>>>>>>
>>>>>> 	Andrew
>>>>> Are you sure? That is a bit confusing after reading
>>>>> https://lore.kernel.org/patchwork/patch/575746/
>>>> Quoting that patch:
>>>>
>>>> 	This commit implements the switchdev operations to add, delete
>>>> 	and dump VLANs for the Marvell 88E6352 and compatible switch
>>>> 	chips.
>>>>
>>>> Vivien added support for the 6352. That uses the mv88e6xxx driver, n=
ot
>>>> the mv88e6060. And by compatible switches, he meant those in the 635=
2
>>>> family, so 6172 6176 6240 6352 and probably the 6171 6175 6350 6351.=

>>>>
>>>> 	Andrew
>>> A simple soul might infer that mv88e6xxx includes MV88E6060, at least=

>>> that happened to me apparently (being said simpleton).
>>> That may as it be, and pardon my continued ignorance, how is it
>>> explained then that a command as
>>>
>>> # bridge v a dev {bridge} self vid {n} untagged pvid
>>>
>>> reflects in
>>>
>>> # bridge v s
>>> a/o
>>> # bridge mo
>>>
>>> ?
>>>
>>> If the commands are not implemented one would expect them to fail in =
the
>>> first place or not reflecting a change at all?
>>>
>>>
>> As stated in the initial message - kernel conf
>>
>> CONFIG_NET_DSA_MV88E6060=3Dy
>> CONFIG_NET_DSA_MV88E6XXX=3Dy
>> CONFIG_NET_DSA_MV88E6XXX_GLOBAL2=3Dy
>>
> Just figured that it is a=C2=A0 Marvell 88E6176-TFJ2. Thus that cannot =
be the
> cause, also considering the that the commands are executing and changes=

> being reflected.
>
> However, the loss of access to the node is a mystery.
>
> Apparently the filter is doing its job as in isolating access to the
> bridge if connecting though an enslaved device.
> And yet the bridge is still fully accessible from other devices that or=

> not enslaved by that bridge. As if the filter is inverted.
>

The node's kernel log is showing during boot time repeated entries:

mv88e6085 f1072004.mdio-mii:10 lan{n}: configuring for phy/gmii link mode=

mv88e6085 f1072004.mdio-mii:10: p3: hw VLAN 1 already used by br-{n}

Could there be a correlation with the described issue?

Is there way to debug the issue otherwise?





