Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEB2419B48C
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 19:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732316AbgDARLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 13:11:02 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36864 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgDARLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 13:11:02 -0400
Received: by mail-pf1-f196.google.com with SMTP id u65so251622pfb.4;
        Wed, 01 Apr 2020 10:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eDc+GLcRH0tfNbJs/UPViqxttdu3266qdktoOYqJeOk=;
        b=JPtiPqakbKtbxk4W9sGb5jb6TfFITq1ysZlD6bZ+XSywgOObCzurEgmRyewiM+HULu
         gnVaGwn8nUKgqIRgguVKK0ZB6wCrLmS7Z1wjl8g/fIEmwbAVjK46eBKjbUvdpX36EkP5
         A5uXGbC8qTLDfFx87y6wd06nd7I+aepwTc3q7jMbUAkpe/SYlCyCNkyCMTvGRJuNivKL
         c9v7JQKRIsloXEqEjPImV6e/II5Q9psnTmbkD8hVvcV1z+oEx9md9n+plCYCnxRqTyH5
         hAFagYrAkPTY4Wr25t1VdbVwg4QCjTmYgQVYmWoNjl+8XdPdWhRt+/sePPCilrdCr6ja
         2Cug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=eDc+GLcRH0tfNbJs/UPViqxttdu3266qdktoOYqJeOk=;
        b=CJkvnSQVh0UQnu8B3YNZljwUdek/R8DQMDZkxF4wX1ZLriIBiASJSS5I2raVMtiPyM
         QtA1Q44O6tq9TKr1D1aCenq/KlZKHhrFY10XwRjDT9FaFUpPll1aqsP/+aQTEeotWE7b
         ppmkBxQNEJZ8GS4UZKtZWRw+RvS7EcFN0TKJseb+EQ5d1CJq1NmYVfBxiY0p2KL67CXg
         TcmE1glcr0DrjdMqcBaMat4+AjSe1xkvvbxPKuXb1KRzJ6xkG/wE89izUIoyPasDr+lA
         S8JDqdvPktOrk4457jQuCboMTKx+VrOAp8x6ntp0lwv8Rk4zAudSKusDx/xyVVSnMvko
         m+EA==
X-Gm-Message-State: AGi0PuaQ2F6jpaaxn5peo+aUz28UX4srr/JRJbcFccfAIkJ01k8qtBz1
        po6VjKjeuKgbAWeIqwtPjPs=
X-Google-Smtp-Source: APiQypLRKFjQ5DdxIW/cEB5HOWlvkrQkXsnE7nql22MBvRDVHJZMvS4OCf7clECD5hIZ3R/5+7GA4A==
X-Received: by 2002:a63:a35a:: with SMTP id v26mr10553364pgn.40.1585761060501;
        Wed, 01 Apr 2020 10:11:00 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id f22sm1777629pgl.20.2020.04.01.10.10.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2020 10:10:59 -0700 (PDT)
Subject: Re: [PATCH v2] ARM: imx: allow to disable board specific PHY fixups
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        linux-imx@nxp.com, kernel@pengutronix.de,
        David Jander <david@protonic.nl>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20200329110457.4113-1-o.rempel@pengutronix.de>
 <20200329150854.GA31812@lunn.ch>
 <20200330052611.2bgu7x4nmimf7pru@pengutronix.de>
 <40209d08-4acb-75c5-1766-6d39bb826ff9@gmail.com>
 <20200330174114.GG25745@shell.armlinux.org.uk>
 <5ae5c0de-f05c-5e3f-86e1-a9afdd3e1ef1@pengutronix.de>
 <20200331075457.GJ25745@shell.armlinux.org.uk>
 <f1352a82-be3a-cd0a-7cba-6f338f205098@pengutronix.de>
 <20200331081918.GK25745@shell.armlinux.org.uk>
 <20200401063313.5e5r7jm6fjzdqpdg@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <caca25fc-b29e-93f7-a6fa-47bee94ec3f2@gmail.com>
Date:   Wed, 1 Apr 2020 10:10:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200401063313.5e5r7jm6fjzdqpdg@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/31/2020 11:33 PM, Oleksij Rempel wrote:
> On Tue, Mar 31, 2020 at 09:19:18AM +0100, Russell King - ARM Linux admin wrote:
>> On Tue, Mar 31, 2020 at 10:00:12AM +0200, Marc Kleine-Budde wrote:
>>> On 3/31/20 9:54 AM, Russell King - ARM Linux admin wrote:
>>>> On Tue, Mar 31, 2020 at 09:47:19AM +0200, Marc Kleine-Budde wrote:
>>>>> On 3/30/20 7:41 PM, Russell King - ARM Linux admin wrote:
>>>>>>>> arch/arm/mach-imx/mach-imx6q.c:167:		phy_register_fixup_for_uid(PHY_ID_KSZ9021, MICREL_PHY_ID_MASK,
>>>>>>>> arch/arm/mach-imx/mach-imx6q.c:169:		phy_register_fixup_for_uid(PHY_ID_KSZ9031, MICREL_PHY_ID_MASK,
>>>>>>>> arch/arm/mach-imx/mach-imx6q.c:171:		phy_register_fixup_for_uid(PHY_ID_AR8031, 0xffffffef,
>>>>>>>> arch/arm/mach-imx/mach-imx6q.c:173:		phy_register_fixup_for_uid(PHY_ID_AR8035, 0xffffffef,
>>>>>>
>>>>>> As far as I'm concerned, the AR8035 fixup is there with good reason.
>>>>>> It's not just "random" but is required to make the AR8035 usable with
>>>>>> the iMX6 SoCs.  Not because of a board level thing, but because it's
>>>>>> required for the AR8035 to be usable with an iMX6 SoC.
>>>>>
>>>>> Is this still ture, if the AR8035 is attached to a switch behind an iMX6?
>>>>
>>>> Do you know of such a setup, or are you talking about theoretical
>>>> situations?
>>>
>>> Granted, not for the AR8035, but for one of the KSZ Phys. This is why
>>> Oleksij started looking into this issue in the first place.
>>
>> Maybe there's an easy solution to this - check whether the PHY being
>> fixed up is connected to the iMX6 SoC:
>>
>> static bool phy_connected_to(struct phy_device *phydev,
>> 			     const struct of_device_id *matches)
>> {
>> 	struct device_node *np, *phy_np;
>>
>> 	for_each_matching_node(np, matches) {
>> 		phy_np = of_parse_phandle(np, "phy-handle", 0);
>> 		if (!phy_np)
>> 			phy_np = of_parse_phandle(np, "phy", 0);
>> 		if (!phy_np)
>> 			phy_np = of_parse_phandle(np, "phy-device", 0);
>> 		if (phy_np && phydev->mdio.dev.of_node == phy_np) {
>> 			of_node_put(phy_np);
>> 			of_node_put(np);
>> 			return true;
>> 		}
>> 		of_node_put(phy_np);
>> 	}
>> 	return false;
>> }
>>
>> static struct of_device_id imx_fec_ids[] = {
>> 	{ .compatible = "fsl,imx6q-fec", },
>> 	...
>> 	{ },
>> };
>>
>> static bool phy_connected_to_fec(struct phy_device *phydev)
>> {
>> 	return phy_connected_to(phydev, imx_fec_ids);
>> }
>>
>> and then in the fixups:
>>
>> 	if (!phy_connected_to_fec(phydev))
>> 		return 0;
>>
> 
> Ok, i see. We will limit fixup impact to some specific devicetree nodes.
> And if we wont to disable fixup completely, some special devicetree binding will
> be needed. Correct? Is this acceptable mainline way?
> For the usb ethernet fixups we will need some thing similar.

It looks like IMX is using phy_register_fixup_for_uid() which is not
able to scope the fixup against a specific MDIO bus controller name, I
would suggest we introduce one or two variants of that function in order
to allow specifying the scope against a MDIO bus controller name, and
another variant which can take a comparison function, such that the
logic that Russell has suggested above could be passed a as callback to
a new function: phy_register_fixup_cmp() or whatever is an appropriate
name. Internally, those functions would ideal all be implemented by the
same core function which is able to use any key/value as a match.
-- 
Florian
