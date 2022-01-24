Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E8E49862F
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 18:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244506AbiAXROX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 12:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244324AbiAXRNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 12:13:53 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911C6C06173D;
        Mon, 24 Jan 2022 09:13:42 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id c3so16161230pls.5;
        Mon, 24 Jan 2022 09:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Yz3Kx4MHq06ExPu9kTL/jl3NneB6Xj2/dNX33XiW2j0=;
        b=gDMwYCxEfk6Fg2wCwnriYNJAh7na79iw0SgOg2pyoNDgmJ0+JZcb8+1nY4Do7tGpe9
         iD7guUzqpQjCPvIwokQ6TOrFznPIeMz5bgsobMpnXcvImycwdHYe/A4AP+Xt2bCGA+Rg
         7e66N7FbFHFicGbWd+/0CRz1wMM6KFbrRUOErGujgym4uTa/x52vDuwHXouuhZt89W/W
         hpQ/PsX3BtXWPEs1MKy6ooB92YI8IWnnyjhSHVRMzwnlWNPr1evKukjfiOEi4IJiidyG
         6XL0OJ8EDODesRjw6utIaE00T5KJcxSY/hSh/DPZHN5gtcXmeLTvCmnRc3GsMaKkaiwq
         I1dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Yz3Kx4MHq06ExPu9kTL/jl3NneB6Xj2/dNX33XiW2j0=;
        b=xG7BijVVPefcVvtj9PDap1UpMIHBnOffwaxcOAPNmm0t2sor17kxeqZvZZG9YVuYEu
         TV5ArczPP3GAw2xghnNW2K8SlvLrBqedgmFnU4swN0MppkqssBProW1lZBnLiZ7faUQp
         jxvYxOTTBjy8R6th5z43pqnOr7anP44Oi9OLlQnzYrx2bILHdCAzUK/I5iZPhfT71qOq
         nJcWKd8Kca3okdmF4u5qyC7JxooQ22Mb/JqLnEkilwy0y7I1TqV6zFpaBwJ9PP14g8X7
         jfZ0S9LtsLfuTnMryyeAzZdBHrgF1NV/sZ7wNz25yeG7fvbcPZcRqGxziUB/4wDwf7ku
         Vftg==
X-Gm-Message-State: AOAM531bx+THV8N2O1RFwxdWpPnCsbDTq1uUCqgq9FJL8Ji34wpLpdFR
        RiIEGlTgKNLXRArDXWcns1Y=
X-Google-Smtp-Source: ABdhPJyt8Q8UYMb8ZPX5O55xt98T26QcckoaPZ4g6z41q+Z+eKVHji1BFoUdALgiWj9A/kZe4ZZ2og==
X-Received: by 2002:a17:90b:4d11:: with SMTP id mw17mr2845071pjb.100.1643044421921;
        Mon, 24 Jan 2022 09:13:41 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id t3sm17894634pfg.28.2022.01.24.09.13.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 09:13:41 -0800 (PST)
Message-ID: <acf98ec3-1120-bcc0-2a2f-85d97c48febd@gmail.com>
Date:   Mon, 24 Jan 2022 09:13:38 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: MT7621 SoC Traffic Won't Flow on RGMII2 Bus/2nd GMAC
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Siddhant Gupta <siddhantgupta416@gmail.com>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Russell King <linux@armlinux.org.uk>,
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
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <Ye1zwIFUa5LPQbQm@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/23/2022 7:26 AM, Andrew Lunn wrote:
> On Sun, Jan 23, 2022 at 11:33:04AM +0300, Arınç ÜNAL wrote:
>> Hey Deng,
>>
>> On 23/01/2022 09:51, DENG Qingfang wrote:
>>> Hi,
>>>
>>> Do you set the ethernet pinmux correctly?
>>>
>>> &ethernet {
>>>       pinctrl-names = "default";
>>>       pinctrl-0 = <&rgmii1_pins &rgmii2_pins &mdio_pins>;
>>> };
>>
>> This fixed it! We did have &rgmii2_pins on the gmac1 node (it was originally
>> on external_phy) so we never thought to investigate the pinctrl
>> configuration further! Turns out &rgmii2_pins needs to be defined on the
>> ethernet node instead.
> 
> PHYs are generally external, so pinmux on them makes no sense. PHYs in
> DT are not devices in the usual sense, so i don't think the driver
> core will handle pinmux for them, even if you did list them.

Not sure I understand your comment here, this is configuring the pinmux 
on the SoC side in order for the second RGMII interface's data path to work.

It is not uncommon for the same set of I/O pads to be used by different 
functions within the chip. For instance the chips I work with happily 
offer RGMII, MTSIF, PDM (I2S), TSIO on the same pads via different 
pinmuxing options.

Also, this is declaring a pinmuxing function for the Ethernet MAC, which 
is a perfectly valid use case and typically how pinmuxing is declared 
for a given SoC.
-- 
Florian
