Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33454986F4
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 18:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241883AbiAXRe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 12:34:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236694AbiAXRe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 12:34:27 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E82C06173B;
        Mon, 24 Jan 2022 09:34:27 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id g2so16003468pgo.9;
        Mon, 24 Jan 2022 09:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZyDNjyTk1g5RHID85BarMSjV5u48polFgmuVs6EELTc=;
        b=fQlDXQHTJYMjYvbnXqHdGAykkgWwHhP7VJ3dDIAvDCxb2ywj07Dqxr41jgWLAdNqii
         qnXkcy2N4001VUlkE9BEdGglIc80QYhxCXNqMpA6APHgPkf7P0Wp+P2v53QSKsHw1jAD
         mhlgR4MVK7YdVIBk9Y3lJyLPWufxeyInJnEgfYHwvoIHDGPsJkDGuJDhydy+sFq6zMjt
         lxmIueLbwLWOMcQSm+8xV8JSSz1sGtRzeIbAQhXc5aXsKexJIDVuwby1fzWnPgIvd5a5
         ZBWlhnDmQXzjZM0ySO0G/wtPCji8sG/KUPwDjGbEBnnQOldBiHMWKEIK7MDEX7jHHK6R
         xnKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZyDNjyTk1g5RHID85BarMSjV5u48polFgmuVs6EELTc=;
        b=k+t7Eg4K9sTf4H7wxMmvGPOX5jnkumRw8ezm1FT5ZcxBUuDiZtLYy6nFxpkH8tTTI+
         yhD1bcCJw+pVuPqUpFgqY0GciGCwyujf14BL/x8+H14GJWXGcTGt0U2IY0QhnsYD1rHY
         Q9x+IgjKgKIpFgFzjmc0Zk03pFCtBEqsB8Vc2ri+gRoXdzpm/AMIsYHKqky/eXAPBZLt
         r72HZ30JiTVwI9sHi/PDVw0IEPWQM/VXjkZMgJMwzRKo7V26thzpmP6aZH8N1wnRydzZ
         d6dZdPUZ1pRQktLlhMEgBPagvIDzK4DBkqPKZFgJSD1cm5vC83vXzM1MkWpFBo/p2SFE
         Ooiw==
X-Gm-Message-State: AOAM532RVzaI5twxsiv853TRcCFTZXU/b4e1laQ7Ex8OJaj1YdjG/wm+
        t1XjkMWhOv0YsHiEAeZW/uk=
X-Google-Smtp-Source: ABdhPJxEMy4wan/+d+ujiXjIpF3AAO0pFS5nxHMHA0D8KpXdACgqaIiBMtuARCp2I3vT/O90wVTDvw==
X-Received: by 2002:a63:87c6:: with SMTP id i189mr5221362pge.261.1643045666452;
        Mon, 24 Jan 2022 09:34:26 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id o11sm12949904pgj.33.2022.01.24.09.34.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 09:34:25 -0800 (PST)
Message-ID: <4fd93933-9b98-175a-d6f2-8cb3ddc30c51@gmail.com>
Date:   Mon, 24 Jan 2022 09:34:23 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: MT7621 SoC Traffic Won't Flow on RGMII2 Bus/2nd GMAC
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Siddhant Gupta <siddhantgupta416@gmail.com>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>, linux-mips@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, openwrt-devel@lists.openwrt.org,
        erkin.bozoglu@xeront.com
References: <83a35aa3-6cb8-2bc4-2ff4-64278bbcd8c8@arinc9.com>
 <CALW65jZ4N_YRJd8F-uaETWm1Hs3rNcy95csf++rz7vTk8G8oOg@mail.gmail.com>
 <02ecce91-7aad-4392-c9d7-f45ca1b31e0b@arinc9.com> <Ye1zwIFUa5LPQbQm@lunn.ch>
 <acf98ec3-1120-bcc0-2a2f-85d97c48febd@gmail.com>
 <Ye7hMWRR4URUnSFp@shell.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <Ye7hMWRR4URUnSFp@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/24/2022 9:26 AM, Russell King (Oracle) wrote:
> On Mon, Jan 24, 2022 at 09:13:38AM -0800, Florian Fainelli wrote:
>> On 1/23/2022 7:26 AM, Andrew Lunn wrote:
>>> On Sun, Jan 23, 2022 at 11:33:04AM +0300, Arınç ÜNAL wrote:
>>>> Hey Deng,
>>>>
>>>> On 23/01/2022 09:51, DENG Qingfang wrote:
>>>>> Hi,
>>>>>
>>>>> Do you set the ethernet pinmux correctly?
>>>>>
>>>>> &ethernet {
>>>>>        pinctrl-names = "default";
>>>>>        pinctrl-0 = <&rgmii1_pins &rgmii2_pins &mdio_pins>;
>>>>> };
>>>>
>>>> This fixed it! We did have &rgmii2_pins on the gmac1 node (it was originally
>>>> on external_phy) so we never thought to investigate the pinctrl
>>>> configuration further! Turns out &rgmii2_pins needs to be defined on the
>>>> ethernet node instead.
>>>
>>> PHYs are generally external, so pinmux on them makes no sense. PHYs in
>>> DT are not devices in the usual sense, so i don't think the driver
>>> core will handle pinmux for them, even if you did list them.
>>
>> Not sure I understand your comment here, this is configuring the pinmux on
>> the SoC side in order for the second RGMII interface's data path to work.
> 
> The pinmux configuration was listed under the external PHY node, which
> is qutie unusual. In the case of phylib and external ethernet PHYs,
> this can be a problem.
> 
> The pinmux configuration is normally handled at device probe time by
> the device model, but remember phylib bypasses that when it attaches
> the generic PHY driver - meaning you don't get the pinmux configured.
> 
> What this means is that pinmux configuration in ethernet PHY nodes is
> unreliable. It will only happen if we have a specific driver for the
> PHY and the driver model binds that driver.
> 
> Of course, if we killed the generic driver, that would get around this
> issue by requiring every PHY to have its own specific driver, but there
> would be many complaints because likely lots would stop working.

I suppose that explains why this is still in staging then :) Andrew's 
answer makes more sense now, thanks.
-- 
Florian
