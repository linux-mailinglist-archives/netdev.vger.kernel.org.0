Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7151BE6C2
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 20:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgD2S7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 14:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726556AbgD2S7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 14:59:02 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E749C03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 11:59:02 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id l3so2417506edq.13
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 11:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k7iwdVLvgg9ygtyn31oFp22FudXzBTluk+rDXcYnkfE=;
        b=OtobIjFACrIdIGIR/ZgX9bSp5Q/CRMqt+Svdn9Kw5guktqGPor9yXortbV5ACcsxTt
         4Mn7SmoXr5I8SQ1oCVIr9uvq9kvv22U95LcjRLYcO6X/1IyBxQUcLfpXXfmXPdqdHskj
         UIgNIC0ihTvz38UviSU6Q4D/EHPtX2AMkleeD8iPOVLy+jPqCL1viNznvNeES/5kvmFj
         vZPRcPO6UegsaMyqYbdxdvrOi+9AniLAKt8P9C9+n6XZMFulKmcUUZGBLk60m15W+sYW
         xgZmCEpi6fqWqpzBspVnshhdNyu7X0Ny7wUC1IeQQLwUjr5JG60OFNllRjkEMjyRAeAk
         zCGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=k7iwdVLvgg9ygtyn31oFp22FudXzBTluk+rDXcYnkfE=;
        b=NcLwYcsVH2+cnxX7hpJ8KyL0ZhfDyc8Btrr47mB8AJLyYz5y2Bg/8QEFGer0J2cGr4
         yooRAXtSir4w6mQt6NtBbAtVfAvmTItsekX+Oj+d7cf/DzZR3sEUcug1wAdIsiNloqiY
         NT+gBGsn03NbujCwN4dP6PVk/Ql0lNEUWRpceQUkHKYbzf41En70qNx/y1BpMbmXzsaB
         ms6sPBpHwVXQjfr8zYQKhniyz2JJyA0q9SQHE9YosT69ZKtvbaia3UGr4v1TCiS2oN1Z
         BJr04xw5CsSTphs+6dYSu/G8xZUL2+5GJq9rx1TxcQX1mL1oc6mTrGdufD4gAl7RTMvB
         cz5A==
X-Gm-Message-State: AGi0PuaXJL4m87OHZ1ee3Mcp0OVbryEMKaGsI7Pamc+ZtiD28BfK6leL
        4fZkMPbzusIWxAFsTyBeraY+0ZDQ
X-Google-Smtp-Source: APiQypKnbyhGVCukogakZexrLo57aU0aZ/UkBzbIT6rY3uTpYVgDj+a2p5yzzlmNHjtBKiXtT6EyBQ==
X-Received: by 2002:a05:6402:1c07:: with SMTP id ck7mr3945715edb.202.1588186741023;
        Wed, 29 Apr 2020 11:59:01 -0700 (PDT)
Received: from [10.67.49.116] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l20sm715678edr.54.2020.04.29.11.58.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 11:59:00 -0700 (PDT)
Subject: Re: [PATCH net-next v1 4/9] net: ethtool: Add attributes for cable
 test reports
To:     Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>
Cc:     cphealy@gmail.com, davem@davemloft.net, hkallweit1@gmail.com,
        mkubecek@suse.cz, netdev@vger.kernel.org
References: <20200425180621.1140452-5-andrew@lunn.ch>
 <20200429161605.23104-1-michael@walle.cc> <20200429185727.GP30459@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 xsDiBEjPuBIRBACW9MxSJU9fvEOCTnRNqG/13rAGsj+vJqontvoDSNxRgmafP8d3nesnqPyR
 xGlkaOSDuu09rxuW+69Y2f1TzjFuGpBk4ysWOR85O2Nx8AJ6fYGCoeTbovrNlGT1M9obSFGQ
 X3IzRnWoqlfudjTO5TKoqkbOgpYqIo5n1QbEjCCwCwCg3DOH/4ug2AUUlcIT9/l3pGvoRJ0E
 AICDzi3l7pmC5IWn2n1mvP5247urtHFs/uusE827DDj3K8Upn2vYiOFMBhGsxAk6YKV6IP0d
 ZdWX6fqkJJlu9cSDvWtO1hXeHIfQIE/xcqvlRH783KrihLcsmnBqOiS6rJDO2x1eAgC8meAX
 SAgsrBhcgGl2Rl5gh/jkeA5ykwbxA/9u1eEuL70Qzt5APJmqVXR+kWvrqdBVPoUNy/tQ8mYc
 nzJJ63ng3tHhnwHXZOu8hL4nqwlYHRa9eeglXYhBqja4ZvIvCEqSmEukfivk+DlIgVoOAJbh
 qIWgvr3SIEuR6ayY3f5j0f2ejUMYlYYnKdiHXFlF9uXm1ELrb0YX4GMHz80nRmxvcmlhbiBG
 YWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+wmYEExECACYCGyMGCwkIBwMCBBUCCAME
 FgIDAQIeAQIXgAUCVF/S8QUJHlwd3wAKCRBhV5kVtWN2DvCVAJ4u4/bPF4P3jxb4qEY8I2gS
 6hG0gACffNWlqJ2T4wSSn+3o7CCZNd7SLSDOwU0EVxvH8AEQAOqv6agYuT4x3DgFIJNv9i0e
 S443rCudGwmg+CbjXGA4RUe1bNdPHYgbbIaN8PFkXfb4jqg64SyU66FXJJJO+DmPK/t7dRNA
 3eMB1h0GbAHlLzsAzD0DKk1ARbjIusnc02aRQNsAUfceqH5fAMfs2hgXBa0ZUJ4bLly5zNbr
 r0t/fqZsyI2rGQT9h1D5OYn4oF3KXpSpo+orJD93PEDeseho1EpmMfsVH7PxjVUlNVzmZ+tc
 IDw24CDSXf0xxnaojoicQi7kzKpUrJodfhNXUnX2JAm/d0f9GR7zClpQMezJ2hYAX7BvBajb
 Wbtzwi34s8lWGI121VjtQNt64mSqsK0iQAE6OYk0uuQbmMaxbBTT63+04rTPBO+gRAWZNDmQ
 b2cTLjrOmdaiPGClSlKx1RhatzW7j1gnUbpfUl91Xzrp6/Rr9BgAZydBE/iu57KWsdMaqu84
 JzO9UBGomh9eyBWBkrBt+Fe1qN78kM7JO6i3/QI56NA4SflV+N4PPgI8TjDVaxgrfUTV0gVa
 cr9gDE5VgnSeSiOleChM1jOByZu0JTShOkT6AcSVW0kCz3fUrd4e5sS3J3uJezSvXjYDZ53k
 +0GS/Hy//7PSvDbNVretLkDWL24Sgxu/v8i3JiYIxe+F5Br8QpkwNa1tm7FK4jOd95xvYADl
 BUI1EZMCPI7zABEBAAHCwagEGBECAAkFAlcbx/ACGwICKQkQYVeZFbVjdg7BXSAEGQECAAYF
 Alcbx/AACgkQh9CWnEQHBwSJBw//Z5n6IO19mVzMy/ZLU/vu8flv0Aa0kwk5qvDyvuvfiDTd
 WQzq2PLs+obX0y1ffntluhvP+8yLzg7h5O6/skOfOV26ZYD9FeV3PIgR3QYF26p2Ocwa3B/k
 P6ENkk2pRL2hh6jaA1Bsi0P34iqC2UzzLq+exctXPa07ioknTIJ09BT31lQ36Udg7NIKalnj
 5UbkRjqApZ+Rp0RAP9jFtq1n/gjvZGyEfuuo/G+EVCaiCt3Vp/cWxDYf2qsX6JxkwmUNswuL
 C3duQ0AOMNYrT6Pn+Vf0kMboZ5UJEzgnSe2/5m8v6TUc9ZbC5I517niyC4+4DY8E2m2V2LS9
 es9uKpA0yNcd4PfEf8bp29/30MEfBWOf80b1yaubrP5y7yLzplcGRZMF3PgBfi0iGo6kM/V2
 13iD/wQ45QTV0WTXaHVbklOdRDXDHIpT69hFJ6hAKnnM7AhqZ70Qi31UHkma9i/TeLLzYYXz
 zhLHGIYaR04dFT8sSKTwTSqvm8rmDzMpN54/NeDSoSJitDuIE8givW/oGQFb0HGAF70qLgp0
 2XiUazRyRU4E4LuhNHGsUxoHOc80B3l+u3jM6xqJht2ZyMZndbAG4LyVA2g9hq2JbpX8BlsF
 skzW1kbzIoIVXT5EhelxYEGqLFsZFdDhCy8tjePOWK069lKuuFSssaZ3C4edHtkZ8gCfWWtA
 8dMsqeOIg9Trx7ZBCDOZGNAAnjYQmSb2eYOAti3PX3Ex7vI8ZhJCzsNNBEjPuBIQEAC/6NPW
 6EfQ91ZNU7e/oKWK91kOoYGFTjfdOatp3RKANidHUMSTUcN7J2mxww80AQHKjr3Yu2InXwVX
 SotMMR4UrkQX7jqabqXV5G+88bj0Lkr3gi6qmVkUPgnNkIBe0gaoM523ujYKLreal2OQ3GoJ
 PS6hTRoSUM1BhwLCLIWqdX9AdT6FMlDXhCJ1ffA/F3f3nTN5oTvZ0aVF0SvQb7eIhGVFxrlb
 WS0+dpyulr9hGdU4kzoqmZX9T/r8WCwcfXipmmz3Zt8o2pYWPMq9Utby9IEgPwultaP06MHY
 nhda1jfzGB5ZKco/XEaXNvNYADtAD91dRtNGMwRHWMotIGiWwhEJ6vFc9bw1xcR88oYBs+7p
 gbFSpmMGYAPA66wdDKGj9+cLhkd0SXGht9AJyaRA5AWB85yNmqcXXLkzzh2chIpSEawRsw8B
 rQIZXc5QaAcBN2dzGN9UzqQArtWaTTjMrGesYhN+aVpMHNCmJuISQORhX5lkjeg54oplt6Zn
 QyIsOCH3MfG95ha0TgWwyFtdxOdY/UY2zv5wGivZ3WeS0TtQf/BcGre2y85rAohFziWOzTaS
 BKZKDaBFHwnGcJi61Pnjkz82hena8OmsnsBIucsz4N0wE+hVd6AbDYN8ZcFNIDyt7+oGD1+c
 PfqLz2df6qjXzq27BBUboklbGUObNwADBQ//V45Z51Q4fRl/6/+oY5q+FPbRLDPlUF2lV6mb
 hymkpqIzi1Aj/2FUKOyImGjbLAkuBQj3uMqy+BSSXyQLG3sg8pDDe8AJwXDpG2fQTyTzQm6l
 OnaMCzosvALk2EOPJryMkOCI52+hk67cSFA0HjgTbkAv4Mssd52y/5VZR28a+LW+mJIZDurI
 Y14UIe50G99xYxjuD1lNdTa/Yv6qFfEAqNdjEBKNuOEUQOlTLndOsvxOOPa1mRUk8Bqm9BUt
 LHk3GDb8bfDwdos1/h2QPEi+eI+O/bm8YX7qE7uZ13bRWBY+S4+cd+Cyj8ezKYAJo9B+0g4a
 RVhdhc3AtW44lvZo1h2iml9twMLfewKkGV3oG35CcF9mOd7n6vDad3teeNpYd/5qYhkopQrG
 k2oRBqxyvpSLrJepsyaIpfrt5NNaH7yTCtGXcxlGf2jzGdei6H4xQPjDcVq2Ra5GJohnb/ix
 uOc0pWciL80ohtpSspLlWoPiIowiKJu/D/Y0bQdatUOZcGadkywCZc/dg5hcAYNYchc8AwA4
 2dp6w8SlIsm1yIGafWlNnfvqbRBglSTnxFuKqVggiz2zk+1wa/oP+B96lm7N4/3Aw6uy7lWC
 HvsHIcv4lxCWkFXkwsuWqzEKK6kxVpRDoEQPDj+Oy/ZJ5fYuMbkdHrlegwoQ64LrqdmiVVPC
 TwQYEQIADwIbDAUCVF/S8QUJHlwd3wAKCRBhV5kVtWN2Do+FAJ956xSz2XpDHql+Wg/2qv3b
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <743b2495-eab1-01af-1c1c-269f992b802a@gmail.com>
Date:   Wed, 29 Apr 2020 11:58:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200429185727.GP30459@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/20 11:57 AM, Andrew Lunn wrote:
> On Wed, Apr 29, 2020 at 06:16:05PM +0200, Michael Walle wrote:
>> Hi,
>>
>>>>>> +enum {
>>>>>> +	ETHTOOL_A_CABLE_PAIR_0,
>>>>>> +	ETHTOOL_A_CABLE_PAIR_1,
>>>>>> +	ETHTOOL_A_CABLE_PAIR_2,
>>>>>> +	ETHTOOL_A_CABLE_PAIR_3,
>>>>>> +};
>>>>>
>>>>> Do we really need this enum, couldn't we simply use a number (possibly
>>>>> with a sanity check of maximum value)?
>>>>
>>>> They are not strictly required. But it helps with consistence. Are the
>>>> pairs numbered 0, 1, 2, 3, or 1, 2, 3, 4?
>>>
>>> OK, I'm not strictly opposed to it, it just felt a bit weird.
>>
>> Speaking of the pairs. What is PAIR_0 and what is PAIR_3? Maybe
>> it is specified somewhere in a standard, but IMHO an example for
>> a normal TP cable would help to prevent wild growth amongst the
>> PHY drivers and would help to provide consistent reporting towards
>> the user space.
> 
> Hi Michael
> 
> Good question
> 
> Section 25.4.3 gives the pin out for 100BaseT. There is no pair
> numbering, just transmit+, transmit- and receive+, receive- signals.
> 
> 1000BaseT calls the signals BI_DA+, BI_DA-, BI_DB+, BI_DB-, BI_DC+,
> BI_DC-, BI_DDA+, BI_DD-. Comparing the pinout 100BaseT would use
> BI_DA+, BI_DA-, BI_DB+, BI_DB. But 1000BaseT does not really have
> transmit and receive pairs due to Auto MDI-X.
> 
> BroadReach calls the one pair it has BI_DA+/BI_DA-.
> 
> Maybe it would be better to have:
> 
> enum {
> 	ETHTOOL_A_CABLE_PAIR_A,
> 	ETHTOOL_A_CABLE_PAIR_B,
> 	ETHTOOL_A_CABLE_PAIR_C,
> 	ETHTOOL_A_CABLE_PAIR_D,
> };

Yes, that would be clearer IMHO. Broadcom PHYs tend to refer to pairs A,
B, C and D in their datasheets.
-- 
Florian
