Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F432AF09B
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 13:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgKKM2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 07:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbgKKM16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 07:27:58 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5394CC0613D1;
        Wed, 11 Nov 2020 04:27:57 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id q19so1847460ljc.10;
        Wed, 11 Nov 2020 04:27:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=W5WHawdyiRL/UDPwiBG0yjJUaw2ChXCIaDxzqyGijTM=;
        b=rgp4iBF7QIwpfxVeWcUQxYv5Jkp6Xu9bjSj0N7rpmVxTxLaHXoguSDfNMidnDczwUM
         VcKGr0eRkofLJ5ta55sg5miFXEdgXXCR85onduPj33m81gi2Pbk6OaJrFnuUxBn8Vo0+
         Ph7+SIiGnaCk0tGPbsl9hQ+pJVG1POv+OJBemTeM0zUrDPvnzXpyXeDOYLvAmClP3DXv
         Jf6oakkXu8+MAPBp+BZ98KPO8nLq/b9V5dQ+2qguSrPT/NC94DP5PhMYkHzTFOOwiZRh
         XFEkbxNseJGfqjKeQ7EkgnTrSZybzeRtwtSF2FWQ6R9es6+p/YhENrnK2q28wvg9WY8p
         Cpsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W5WHawdyiRL/UDPwiBG0yjJUaw2ChXCIaDxzqyGijTM=;
        b=Z16gYPu7OYx4hIQX1aCDyWC7wRjCRp5W/lXmUJg9vy6LfbsLf1rhtrhWIU+YzHF4+R
         p0CB8L5LvRWJqfZ153jWeiVetLewjvH1sPsi9RECZR5rE9DjQYHhqZWK2DBKUHbKNhdE
         4sFRjQZw7lAXkiR0fgsOukHhqFxfPInduZIYMeA+oypWPb0nsrNPavXp4/FkA1tlpNcy
         CMSzYhSVimIhR9cozxw++r0iH65GxuC6Oh70wxlX2QWevMgSuSZREFPNkfe2QPKzdnMa
         m8g/JFPg5CDoiTjaC4lM70Jj3sshf9UFzrVC6Z9Exw1LAM9t1JMa62g1MD0ATo+/Xad8
         wmpQ==
X-Gm-Message-State: AOAM530uRXOqFqQ8LodPuEAWSZXXkQtBHcG1KldUy58vOCd15wqh/wcn
        /sftaeK2d/HtqxdH0eGPYQE=
X-Google-Smtp-Source: ABdhPJyOLm7Uoq0JuJlCCWiprf07q96YUVZNNXHwv5N+mB52A4/YKQP4CeUn7zVBWJjWmngXoqwnEg==
X-Received: by 2002:a2e:9a43:: with SMTP id k3mr10978389ljj.69.1605097675775;
        Wed, 11 Nov 2020 04:27:55 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id x6sm206676lfn.185.2020.11.11.04.27.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2020 04:27:54 -0800 (PST)
Subject: Re: [PATCH 05/10] ARM: dts: BCM5301X: Provide defaults ports
 container node
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "maintainer:BROADCOM IPROC ARM ARCHITECTURE" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
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
 <cf7f91fc-8bff-68ee-cf68-072e2c795814@gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <581c3e62-9d2e-f684-b035-46aeb7a52816@gmail.com>
Date:   Wed, 11 Nov 2020 13:27:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cf7f91fc-8bff-68ee-cf68-072e2c795814@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.11.2020 02:48, Florian Fainelli wrote:
> On 11/10/2020 2:13 PM, Florian Fainelli wrote:
>> On 11/10/20 2:12 PM, Vladimir Oltean wrote:
>>> On Mon, Nov 09, 2020 at 07:31:08PM -0800, Florian Fainelli wrote:
>>>> Provide an empty 'ports' container node with the correct #address-cells
>>>> and #size-cells properties. This silences the following warning:
>>>>
>>>> arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dt.yaml:
>>>> ethernet-switch@18007000: 'oneOf' conditional failed, one must be fixed:
>>>>          'ports' is a required property
>>>>          'ethernet-ports' is a required property
>>>>          From schema:
>>>> Documentation/devicetree/bindings/net/dsa/b53.yaml
>>>>
>>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>>> ---
>>>>   arch/arm/boot/dts/bcm5301x.dtsi | 4 ++++
>>>>   1 file changed, 4 insertions(+)
>>>>
>>>> diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
>>>> index 807580dd89f5..89993a8a6765 100644
>>>> --- a/arch/arm/boot/dts/bcm5301x.dtsi
>>>> +++ b/arch/arm/boot/dts/bcm5301x.dtsi
>>>> @@ -489,6 +489,10 @@ srab: ethernet-switch@18007000 {
>>>>   		status = "disabled";
>>>>   
>>>>   		/* ports are defined in board DTS */
>>>> +		ports {
>>>> +			#address-cells = <1>;
>>>> +			#size-cells = <0>;
>>>> +		};
>>>
>>> This look a bit 'lone wolf' here. Not sure how much time you intend to
>>> spend on this, but FWIW, others prefer to declare all ports in the SoC
>>> DTSI with status = "disabled", and just enable the ones used per-board,
>>> and add labels and PHY handles also per-board. Example: fsl-ls1028a.dtsi
>>> and fsl-ls1028a-rdb.dts.
>>
>> That's a good suggestion, I could do that.
> 
> There is quite a bit of variation between designs and how the ports are
> assigned and it would end up being quite verbose, so I will punt that
> for now.

I agree with Florian, boards (vendors) use ports really randomly so pretty
much every device needs that defined from the scratch.
