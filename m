Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD752AE608
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 02:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732595AbgKKBsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 20:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731805AbgKKBsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 20:48:35 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BEBBC0613D1;
        Tue, 10 Nov 2020 17:48:35 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id z3so561679pfb.10;
        Tue, 10 Nov 2020 17:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SXxBuciLME+eq+2+VtydJ0drxhhSOrRSIjNrBJLqPAc=;
        b=p0lZ3WotwcaKB1WyfkbFkABG0Erc9IO2fmeBI3qrIChwhDwsBdtOAFnjuVGSZ4bRWl
         MJkNlNebTM4GF91n4AJIzqwkeYOxbCVCmJGhmQPha73mKWUCbma36nE5WTyD/P/Lofol
         4nHLP9J+G+XUc9DNIKrm8I5flPejH8e/LaXV1AqkbTjhLBsllp9R4wkPD3tZfqcxnEd/
         KZSwIinVLpD2Yng+TgXEIF9AtHwp1AfXjsljpSahcrwLnM1cbL6fihKwrp35Ei7GEloE
         A00RRI5qnWgYnE1Zmv6VqVsAyy926jKXc3tDh/mg8VBQKTvHuvpKFEBqlACvkhxFR91t
         2Ngw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SXxBuciLME+eq+2+VtydJ0drxhhSOrRSIjNrBJLqPAc=;
        b=g8/71dayegOudc7hgUzjsnIkEyVtm/FGauOIgmVp31Zy+wyfvSbYAlGLA5/pQ8rrAe
         CjM5dnfs8Gd1HZmX6wRDU5dB5KHEu/r77MY7oG5uXZyAWbW2X57g/pXSYJg0nniUuCyv
         Ax9KBspNOwJVl/wI1WD0rcncjnDHAIZTU0lQ79zGkiY3MXgXm8SpWeyKI8hcvSjvlZ3K
         szodwQ92KOHKPl78MPPWgJgi0a9LUo0+k5o8WzOuBZu3Lz5XTGT0NjBJU1b1F7lXI65S
         FkgskCFmcnxIOqPuUKTQvPrTnDCfnsy/uwjk+LOdXZr91lzooaCbp+j7sNtJ+yl7kR4m
         0W2Q==
X-Gm-Message-State: AOAM533QizjcrpwG66zwgBHUKFMMYZAhMYWnxUx4DCgUny3MuIO06SXX
        WugGVYbCQ4E7V5NycNrK+88=
X-Google-Smtp-Source: ABdhPJxNKnW5WM1SySEOZZ4u7oyjWRLfOS9WAoyADjxHs9GJr3tapskVeXgi9e4CQ4CitWce0XQj5A==
X-Received: by 2002:a65:6219:: with SMTP id d25mr18935944pgv.1.1605059315012;
        Tue, 10 Nov 2020 17:48:35 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 203sm376959pfw.116.2020.11.10.17.48.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 17:48:33 -0800 (PST)
Subject: Re: [PATCH 05/10] ARM: dts: BCM5301X: Provide defaults ports
 container node
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "maintainer:BROADCOM IPROC ARM ARCHITECTURE" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:BROADCOM IPROC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Kurt Kanzenbach <kurt@kmk-computers.de>
References: <20201110033113.31090-1-f.fainelli@gmail.com>
 <20201110033113.31090-6-f.fainelli@gmail.com>
 <20201110221221.4sxx5h3346no7y3y@skbuf>
 <3e87038f-9e2e-676c-a000-0e6c0e8b6ae4@gmail.com>
Message-ID: <cf7f91fc-8bff-68ee-cf68-072e2c795814@gmail.com>
Date:   Tue, 10 Nov 2020 17:48:32 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <3e87038f-9e2e-676c-a000-0e6c0e8b6ae4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/10/2020 2:13 PM, Florian Fainelli wrote:
> On 11/10/20 2:12 PM, Vladimir Oltean wrote:
>> On Mon, Nov 09, 2020 at 07:31:08PM -0800, Florian Fainelli wrote:
>>> Provide an empty 'ports' container node with the correct #address-cells
>>> and #size-cells properties. This silences the following warning:
>>>
>>> arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dt.yaml:
>>> ethernet-switch@18007000: 'oneOf' conditional failed, one must be fixed:
>>>         'ports' is a required property
>>>         'ethernet-ports' is a required property
>>>         From schema:
>>> Documentation/devicetree/bindings/net/dsa/b53.yaml
>>>
>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>> ---
>>>  arch/arm/boot/dts/bcm5301x.dtsi | 4 ++++
>>>  1 file changed, 4 insertions(+)
>>>
>>> diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
>>> index 807580dd89f5..89993a8a6765 100644
>>> --- a/arch/arm/boot/dts/bcm5301x.dtsi
>>> +++ b/arch/arm/boot/dts/bcm5301x.dtsi
>>> @@ -489,6 +489,10 @@ srab: ethernet-switch@18007000 {
>>>  		status = "disabled";
>>>  
>>>  		/* ports are defined in board DTS */
>>> +		ports {
>>> +			#address-cells = <1>;
>>> +			#size-cells = <0>;
>>> +		};
>>
>> This look a bit 'lone wolf' here. Not sure how much time you intend to
>> spend on this, but FWIW, others prefer to declare all ports in the SoC
>> DTSI with status = "disabled", and just enable the ones used per-board,
>> and add labels and PHY handles also per-board. Example: fsl-ls1028a.dtsi
>> and fsl-ls1028a-rdb.dts.
> 
> That's a good suggestion, I could do that.

There is quite a bit of variation between designs and how the ports are
assigned and it would end up being quite verbose, so I will punt that
for now.
-- 
Florian
