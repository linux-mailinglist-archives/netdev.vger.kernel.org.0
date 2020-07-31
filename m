Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8A6234A6B
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 19:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733236AbgGaRpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 13:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729018AbgGaRpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 13:45:06 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE40DC061574;
        Fri, 31 Jul 2020 10:45:05 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id h19so33245101ljg.13;
        Fri, 31 Jul 2020 10:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qif3gPM+i0kd4n51TWspAAp0VCMEW9fIt4GS0n1sm60=;
        b=gg3aX+m6V9TMBElSz2Y8AZQ+70XjTLFowfhk9QlSoLeXXvcyUjLlEIjLOkB5fd9cTe
         G+XzBrvsinyc1AzAMUx+x6NcAztg6iwmPLTdFwYqW5A6zg886z0EP7gB85/onxyuRB+Q
         Qyf5G/nxmM2ajGKDcvGwo52iZoCDuSwPWFIneV4O9vnF23AARSYrZPCPSks6JikrVL7q
         vbsKO0gXIpmhGcK25uU40hDRBBs6J9njwkwgknUhW3s8uEz+sgzJPy8R+StMZrtUviit
         r1IoO5o44OqaZO7qT3AJIWMzpL0xgYvj7OoiW2RRN5gefBYcSPbDNqixAUUsazauMUK3
         4C4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qif3gPM+i0kd4n51TWspAAp0VCMEW9fIt4GS0n1sm60=;
        b=C/Lhv+6biZxUItCsasIc1c7ylwFDNzni7tFKpJVe7PmoD+kBbmqAYAHxgWicGXAxFQ
         oBpOW5Zgpqo9hPPslHV4BvHqGw0NWQDonqRD4Rv7zK5+DLPoW4b3Se7UpBtQ3/lLoXYy
         zMIbxJMTsM6mJIwD+PUCzJIAGQeUidR4cF3kTn2UT85AMRGOrELO3L6GjLTnNEAHqUQ7
         DL0xQNn+PlE6p4l0BxxnvtV2Mu+FpRZeArMh3+bpnwDCIfpwYy6am4g3h64px1EwtrJm
         IfaNDvSZXOBycx5+v4SVW3EEAGvtWV8x+KOQPk7KHy5+NEm1MNsFVuuGoniiwVNjWk2t
         imaA==
X-Gm-Message-State: AOAM5301P18dh+PDZ2TBjPro/RbzY9YKn22CcCHBh9JWsal8L9peH7Ch
        QLk74+ew0pQ7hy09KdnWhtrHMLRV
X-Google-Smtp-Source: ABdhPJwQzDzwgm9Hh0DSRuGfpROIhbFTc3Gm/wnM89vgURm2Go3AiX/Dh+CS+kFYS8SDjlOMP75wtA==
X-Received: by 2002:a2e:7c14:: with SMTP id x20mr2300295ljc.41.1596217504038;
        Fri, 31 Jul 2020 10:45:04 -0700 (PDT)
Received: from wasted.omprussia.ru ([2a00:1fa0:225:dc3:11c8:9b9e:ad39:92d0])
        by smtp.gmail.com with ESMTPSA id i21sm2072334lfe.50.2020.07.31.10.45.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2020 10:45:03 -0700 (PDT)
Subject: Re: [PATCH v2] ravb: Fixed the problem that rmmod can not be done
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
References: <20200730035649.5940-1-ashiduka@fujitsu.com>
 <20200730100151.7490-1-ashiduka@fujitsu.com>
 <TY2PR01MB36928342A37492E8694A7625D8710@TY2PR01MB3692.jpnprd01.prod.outlook.com>
 <793b7100-9a3a-11fd-f0cd-bf225b958775@gmail.com>
 <TY2PR01MB3692A94CD6479F2976458B0FD84E0@TY2PR01MB3692.jpnprd01.prod.outlook.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <97569264-fcf8-58cb-3ce7-9d569ad176e5@gmail.com>
Date:   Fri, 31 Jul 2020 20:45:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <TY2PR01MB3692A94CD6479F2976458B0FD84E0@TY2PR01MB3692.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!


On 7/31/20 9:43 AM, Yoshihiro Shimoda wrote:

>>>> From: Yuusuke Ashizuka, Sent: Thursday, July 30, 2020 7:02 PM
>>>> Subject: [PATCH v2] ravb: Fixed the problem that rmmod can not be done
>>>
>>> Thank you for the patch! I found a similar patch for another driver [1].
>>
>>    It's not the same case -- that driver hadn't had the MDIO release code at all
>> before that patch.
> 
> You're correct. I didn't realized it...

   The patch description was somewhat incomplete there...

>>> So, we should apply this patch to the ravb driver.
>>
>>    I believe the driver is innocent. :-)
> 
> I hope so :)

   Looks like I was wrong in this case. It's very fortunate that the MDIO bitbang
is not as popular as I thought.

> <snip>
>>>> $ lsmod
>>>> Module                  Size  Used by
>>>> ravb                   40960  1
>>>> $ rmmod ravb
>>>> rmmod: ERROR: Module ravb is in use
>>
>>    Shouldn't the driver core call the remove() method for the affected devices
>> first, before checking the refcount?
> 
> In this case, an mii bus of "mdiobb_ops bb_ops" is affected "device" by the ravb driver.
> And the ravb driver sets the owner of mii bus as THIS_MODULE like below:
> 
> static struct mdiobb_ops bb_ops = {
>         .owner = THIS_MODULE,
>         .set_mdc = ravb_set_mdc,
>         .set_mdio_dir = ravb_set_mdio_dir,
>         .set_mdio_data = ravb_set_mdio_data,
>         .get_mdio_data = ravb_get_mdio_data,
> };
> 
> So, I don't think the driver core can call the remove() method for the mii bus
> because it's a part of the ravb driver...

   And because the MDIO module just doesn't have the usual method! :-)
(I meant the EtherAVB driver's remove() method, and that one would be called after
a successful reference count check...)

> By the way, about the mdio-gpio driver, I'm wondering if the mdio-gpio
> driver cannot be removed by rmmod too. (perhaps, we need "rmmod -f" to remove it.)

   You're on your own here. It's fortunate for this patch that I'm not currently loaded
at work! :-)

>>> By the way, I think you have to send this patch to the following maintainers too:
>>> # We can get it by using scripts/get_maintainers.pl.
>>> David S. Miller <davem@davemloft.net> (maintainer:NETWORKING DRIVERS,commit_signer:8/8=100%)
>>> Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING DRIVERS)

   Not critical, as DaveM uses the patchwork anyway. He started to be CC'ed on netdev patches
only recently. :-)

[...]

> Best regards,
> Yoshihiro Shimoda

MBR, Sergei
