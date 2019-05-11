Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF2A41A828
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 16:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbfEKO5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 May 2019 10:57:05 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44634 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbfEKO5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 May 2019 10:57:04 -0400
Received: by mail-wr1-f66.google.com with SMTP id c5so10690248wrs.11;
        Sat, 11 May 2019 07:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xagJeCmWrwX8fg4zejA2jF3/DsWcj+RzmZOj/KM3CUw=;
        b=aTjdthMzRCw+P/u0hQ2uEZUTfqrP9nrwZJ8tfh3SdFM4GR3KfEB4FUpC0LXemNrdR9
         73ZoBYSIGfGNB8JP7jkfP+P2bTP5Hsd4s9ohKDuSqFJG3Hal9jh13/5lA2qXvq/s/m/e
         4k2aGsxlDsMjPapuJbXT/9G6pHodY5xBFLEE6+vsYnh2X28v/6o+w4a9aR2owPqwdHJ8
         fZ7hvswODmuR/3XXZSSjgfo1XekQahrk7OToQHpWJtDOOuaU61SG1RhP5fIV8X1A6pqz
         XkDBz0IC8twLUVvgCi/n/nMY2UJsgMMV0LQ9gYp0rHXnc9dTsNjY46NnnngnVQQoaIlj
         Vjvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xagJeCmWrwX8fg4zejA2jF3/DsWcj+RzmZOj/KM3CUw=;
        b=s7jWjHt8Ik4x/FdqFVphhZIuSmK/ULTsx6eBcZ81S4/4nCVixF/Xw1JjNziJPpe7+6
         FnKazztDCcb84dwywqkeEj7HPEGvhRx369M0++mj71EwpokGQ8cOxOegI2v05Z5tSDQF
         1GfsRzC5dmzZoyp86uuaiyW+Qwt2lZ5RjVSD3B/5wNbDAgiv217sP+dofBTteUchEh8p
         H+58jWnaD5J6Qs+6zUl16O5KiZl5U8LJWM44xr9CKjdr/IzY+W8ofrpW8zTVEy/1NEYr
         dH3YXb9w3QQ0MASMIxBtRqTnCbdAyula4nhsZYD1i3M+E2P8/7dRxKQA3WC9ueROwOwe
         zawg==
X-Gm-Message-State: APjAAAUgvcjKKPDJ/N6ti3DMJFkzkFKC7VuRFJFZy/vO9YqZCFh6Xz/4
        Eer47sA5GDJarRMddFTlzrCdPYa5oJg=
X-Google-Smtp-Source: APXvYqx/tBCZgDMJ99kkZyLvrfvYLY9f5iwY3R6CoZr7CZJ5yDunrZTekHMJkfFCsi3Dmq7zucr2Hw==
X-Received: by 2002:adf:e649:: with SMTP id b9mr5264676wrn.195.1557586622283;
        Sat, 11 May 2019 07:57:02 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:152f:e071:7960:90b9? (p200300EA8BD45700152FE071796090B9.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:152f:e071:7960:90b9])
        by smtp.googlemail.com with ESMTPSA id t6sm7878406wrn.3.2019.05.11.07.57.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 May 2019 07:57:01 -0700 (PDT)
Subject: Re: net: phy: realtek: regression, kernel null pointer dereference
To:     Vicente Bergas <vicencb@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <16f75ff4-e3e3-4d96-b084-e772e3ce1c2b@gmail.com>
 <742a2235-4571-aa7d-af90-14c708205c6f@gmail.com>
 <11446b0b-c8a4-4e5f-bfa0-0892b500f467@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <61831f43-3b24-47d9-ec6f-15be6a4568c5@gmail.com>
Date:   Sat, 11 May 2019 16:56:56 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <11446b0b-c8a4-4e5f-bfa0-0892b500f467@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.05.2019 16:46, Vicente Bergas wrote:
> On Friday, May 10, 2019 10:28:06 PM CEST, Heiner Kallweit wrote:
>> On 10.05.2019 17:05, Vicente Bergas wrote:
>>> Hello,
>>> there is a regression on linux v5.1-9573-gb970afcfcabd with a kernel null
>>> pointer dereference.
>>> The issue is the commit f81dadbcf7fd067baf184b63c179fc392bdb226e
>>>  net: phy: realtek: Add rtl8211e rx/tx delays config ...
>> The page operation callbacks are missing in the RTL8211E driver.
>> I just submitted a fix adding these callbacks to few Realtek PHY drivers
>> including RTl8211E. This should fix the issue.
> 
> Hello Heiner,
> just tried your patch and indeed the NPE is gone. But still no network...
> The MAC <-> PHY link was working before, so, maybe the rgmii delays are not
> correctly configured.

That's a question to the author of the original patch. My patch was just
meant to fix the NPE. In which configuration are you using the RTL8211E?
As a standalone PHY (with which MAC/driver?) or is it the integrated PHY
in a member of the RTL8168 family?

Serge: The issue with the NPE gave a hint already that you didn't test your
patch. Was your patch based on an actual issue on some board and did you
test it? We may have to consider reverting the patch.

> With this change it is back to working:
> --- a/drivers/net/phy/realtek.c
> +++ b/drivers/net/phy/realtek.c
> @@ -300,7 +300,6 @@
>     }, {
>         PHY_ID_MATCH_EXACT(0x001cc915),
>         .name        = "RTL8211E Gigabit Ethernet",
> -        .config_init    = &rtl8211e_config_init,
>         .ack_interrupt    = &rtl821x_ack_interrupt,
>         .config_intr    = &rtl8211e_config_intr,
>         .suspend    = genphy_suspend,
> That is basically reverting the patch.
> 
> Regards,
>  Vicenç.
> 
>> Nevertheless your proposed patch looks good to me, just one small change
>> would be needed and it should be splitted.
>>
>> The change to phy-core I would consider a fix and it should be fine to
>> submit it to net (net-next is closed currently).
>>
>> Adding the warning to the Realtek driver is fine, but this would be
>> something for net-next once it's open again.
>>
>>> Regards,
>>>  Vicenç.
>>>
>> Heiner
>>
>>> --- a/drivers/net/phy/phy-core.c
>>> +++ b/drivers/net/phy/phy-core.c
>>> @@ -648,11 +648,17 @@
>>>
>>> static int __phy_read_page(struct phy_device *phydev)
>>> { ...
>>
>> Here phydev_warn() should be used.
>>
>>> +        return 0;
>>> +    }
>>>
>>>     ret = phy_write(phydev, RTL821x_EXT_PAGE_SELECT, 0xa4);
>>>     if (ret)
> 
> 

