Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC0F35EE08
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 23:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfGCVBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 17:01:17 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52382 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbfGCVBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 17:01:16 -0400
Received: by mail-wm1-f68.google.com with SMTP id s3so3588805wms.2;
        Wed, 03 Jul 2019 14:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O5mjHEyyQQkiLh5Up22wt5nKlLtgmdpJScImI/v8OHE=;
        b=KuQRKQQMiUyn/mEYHP8l7RfGi82CVVDVV8Ef1SC+fEeanNO9oSq1e+Eog4pEHXKTIA
         zjKTTX9glenJDaMz1YqmpRKM1Qlteqju555xYy/tRjjiq3Gw2wxfxvr58CKxnkTKe9d2
         OJihtY8+TvWcAhw2eXr2BazXDg3+emDwZJiZtPOjjvQbNaEYTXBNjMQo5CN3yjUdB4Oe
         2Njm+wYvS/b7cisXrRgI3fvZ5KwgU+1CKwcKnlVOnfS2FtNYxL5xwlIZTs8IR94pzHr9
         XGuEq7ipXvetUe0BqPlNVSjzss6jrgsSF3YDSOLJwoRUN2S0bS2KfVHkA/ErTxeXXnAB
         /p1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O5mjHEyyQQkiLh5Up22wt5nKlLtgmdpJScImI/v8OHE=;
        b=lIQORgBkvgQXANQ9yg+GTEpGY+Lefd4pyWzDNl4/0Sqiq45LLDGzWxmicrnxekrlcH
         JckitOjypeMYRM2Gk1FPyMaCcj6D9AXIRYNzIxiiXna4zRNi24sfXd7lhIpsbU9+YHmb
         pa6CnEHMr8GbAAJoS0XLRagXNBxDTCg04hKBx9NpvwKPbSp+pgILu12BsqEn/Du/jNAX
         NjK6/0WLAItwSXsrmprXK9iy0fkRLU6TlUCZasUMPWuyLu1CeeY02g0uZALRWyDb4yq9
         HEJfFJg0yCiEzM7fAo+IznKgcGPwEzb+YYRZYmwJtHoZXRsfFqCFfWfVUcriDAhrw6fV
         ls/w==
X-Gm-Message-State: APjAAAUQCLGQ8CFDlThh42NHHmtohIwFy6dZ6zp6GvgQA1svbtjDPnhL
        sYuRE4nmBdHvXz2tVrLL1h8=
X-Google-Smtp-Source: APXvYqw7nza0CIx11VSOyLu+1b7J9ZLTIPdsFXw/RRAoWGk33ZrGVGtvuDADudw9OdBwYTs1L18H/Q==
X-Received: by 2002:a1c:630a:: with SMTP id x10mr9912693wmb.113.1562187674357;
        Wed, 03 Jul 2019 14:01:14 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:4503:872e:8227:c4e0? (p200300EA8BD60C004503872E8227C4E0.dip0.t-ipconnect.de. [2003:ea:8bd6:c00:4503:872e:8227:c4e0])
        by smtp.googlemail.com with ESMTPSA id o4sm3241406wmh.35.2019.07.03.14.01.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 14:01:13 -0700 (PDT)
Subject: Re: [PATCH v2 4/7] net: phy: realtek: Enable accessing RTL8211E
 extension pages
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
References: <20190703193724.246854-1-mka@chromium.org>
 <20190703193724.246854-4-mka@chromium.org>
 <dd7a569b-41e4-5925-88fc-227e69c82f67@gmail.com>
 <20190703203650.GF250418@google.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <98326ec2-6e90-fd3a-32f5-cf0db26c31a9@gmail.com>
Date:   Wed, 3 Jul 2019 23:01:09 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190703203650.GF250418@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.07.2019 22:36, Matthias Kaehlcke wrote:
> On Wed, Jul 03, 2019 at 10:12:12PM +0200, Heiner Kallweit wrote:
>> On 03.07.2019 21:37, Matthias Kaehlcke wrote:
>>> The RTL8211E has extension pages, which can be accessed after
>>> selecting a page through a custom method. Add a function to
>>> modify bits in a register of an extension page and a helper for
>>> selecting an ext page.
>>>
>>> rtl8211e_modify_ext_paged() is inspired by its counterpart
>>> phy_modify_paged().
>>>
>>> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
>>> ---
>>> Changes in v2:
>>> - assign .read/write_page handlers for RTL8211E
>>
>> Maybe this was planned, but it's not part of the patch.
> 
> Oops, it was definitely there when I tested ... I guess this got
> somehow lost when changing the patch order and resolving minor
> conflicts, seems like I only build tested after that :/
> 
RTL8211E also supports normal pages (reg 0x1f = page).
See e.g. rtl8168e_2_hw_phy_config in the r8169 driver, this network
chip has an integrated RTL8211E PHY. There settings on page 3 and 5
are done.
Therefore I would prefer to use .read/write_page for normal paging
in all Realtek PHY drivers. Means the code here would remain as it
is and just the changelog would need to be fixed.


>>> - use phy_select_page() and phy_restore_page(), get rid of
>>>   rtl8211e_restore_page()
>>> - s/rtl821e_select_ext_page/rtl8211e_select_ext_page/
>>> - updated commit message
>>> ---
>>>  drivers/net/phy/realtek.c | 42 +++++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 42 insertions(+)
>>>
>>> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
>>> index eb815cbe1e72..9cd6241e2a6d 100644
>>> --- a/drivers/net/phy/realtek.c
>>> +++ b/drivers/net/phy/realtek.c
>>> @@ -27,6 +27,9 @@
>>>  #define RTL821x_EXT_PAGE_SELECT			0x1e
>>>  #define RTL821x_PAGE_SELECT			0x1f
>>>  
>>> +#define RTL8211E_EXT_PAGE			7
>>> +#define RTL8211E_EPAGSR				0x1e
>>> +
>>>  /* RTL8211E page 5 */
>>>  #define RTL8211E_EEE_LED_MODE1			0x05
>>>  #define RTL8211E_EEE_LED_MODE2			0x06
>>> @@ -58,6 +61,44 @@ static int rtl821x_write_page(struct phy_device *phydev, int page)
>>>  	return __phy_write(phydev, RTL821x_PAGE_SELECT, page);
>>>  }
>>>  
>>> +static int rtl8211e_select_ext_page(struct phy_device *phydev, int page)
>>> +{
>>> +	int ret, oldpage;
>>> +
>>> +	oldpage = phy_select_page(phydev, RTL8211E_EXT_PAGE);
>>> +	if (oldpage < 0)
>>> +		return oldpage;
>>> +
>>> +	ret = __phy_write(phydev, RTL8211E_EPAGSR, page);
>>> +	if (ret)
>>> +		return phy_restore_page(phydev, page, ret);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int __maybe_unused rtl8211e_modify_ext_paged(struct phy_device *phydev,
>>> +				    int page, u32 regnum, u16 mask, u16 set)
>>
>> This __maybe_unused isn't too nice as you use the function in a subsequent patch.
> 
> It's needed to avoid a compiler warning (unless we don't care about
> that for an interim version), the attribute is removed again in the
> next patch.
> 
OK
