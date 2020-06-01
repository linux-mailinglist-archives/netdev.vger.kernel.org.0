Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEBC01EA51E
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 15:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgFANkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 09:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbgFANkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 09:40:15 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C1FC061A0E;
        Mon,  1 Jun 2020 06:40:15 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id g5so3480323pfm.10;
        Mon, 01 Jun 2020 06:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T+tbUzmqUtPdaDA66y4P6TRaUz7TGSaGcJXEbYmiSzg=;
        b=uLtD6u/XsIMVTNcATS2idiC4if137SRCOEPB45k8KxH13VvUwDWSAiISAG8jYS8on4
         4Btd2LjJH46nl8L4BDNSEKoUtMQoz/tmgdIq2erS9GZEBO8eDKqduJ2f+PbjhyrxXnob
         JSadCGwfAuXhxmuWp/kwWNRBYH0LWrbV6OlibwU+HBufVwFPpi1ZttgLz2rL7V685xRW
         WfoXhM+0M95NEiE9EQniCHzFmMa5Z9WCwzKR/Fs4Jw+tU47HKXGjOEfUaepQE96aSEvb
         tb7+uhR0LcmlYbf4lSQCj0Ki0esHpTikVtgdcWnmS2BDrCrAqGz1lsREF2rPVx3nqBiM
         RK5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=T+tbUzmqUtPdaDA66y4P6TRaUz7TGSaGcJXEbYmiSzg=;
        b=YF47ddKP9KuMXN26HOjSNVvtH/FIOXQu2s2uC1o3qvspEZetANzyRkeGrJRFAJWeVG
         XV7ClSllLhLuH9pLco2FZAhEqZH25l/DcVLFp0AR3kgQyJ9xFwrwjzz82e6Wxe0Ttod7
         qUVogFyVrfFKMCOU5WG936lBP9xtmktVctbxHw4X235OPJzr/n++JsswL4STU/6ZJGgo
         UapFWWLi0RWUVIk5A2aLzu+McrLyll1js7ZgCiUzbdQkvTILlNxJM01gT6X/78tJSGxT
         aqd6plFpks4WA7weMsLn8p00QLfCFCHVC1fXjldQD/HwPMmUJueeHWrjItqC0wfBxry5
         zRwQ==
X-Gm-Message-State: AOAM532CEWKSuohRm0GE4m0+xuN8aO2kPoRJUwsquV+mxCsU5DZapEio
        /OV8v/TGEvwq7EumvT5Tl5M=
X-Google-Smtp-Source: ABdhPJz9uZmUvDPe8JKDfXKHXvArOKo2nWSjDoBahLC2TKpkgYBovP1dvZKrdW+w+hKyGCgq2vUEew==
X-Received: by 2002:aa7:85c1:: with SMTP id z1mr19639747pfn.184.1591018814740;
        Mon, 01 Jun 2020 06:40:14 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 3sm4088275pfe.85.2020.06.01.06.40.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 06:40:14 -0700 (PDT)
Subject: Re: [PATCH v4 06/11] thermal: Add mode helpers
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc:     linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        kernel@collabora.com, Fabio Estevam <festevam@gmail.com>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Allison Randal <allison@lohutok.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Darren Hart <dvhart@infradead.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Len Brown <lenb@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Ido Schimmel <idosch@mellanox.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Orson Zhai <orsonzhai@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Support Opensource <support.opensource@diasemi.com>,
        Enrico Weigelt <info@metux.net>,
        Peter Kaestle <peter@piie.net>,
        Sebastian Reichel <sre@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Shawn Guo <shawnguo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Andy Shevchenko <andy@infradead.org>
References: <20200529155206.GA158553@roeck-us.net>
 <526286da-70d2-7c55-3c41-15fd2c969a39@collabora.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 xsFNBE6H1WcBEACu6jIcw5kZ5dGeJ7E7B2uweQR/4FGxH10/H1O1+ApmcQ9i87XdZQiB9cpN
 RYHA7RCEK2dh6dDccykQk3bC90xXMPg+O3R+C/SkwcnUak1UZaeK/SwQbq/t0tkMzYDRxfJ7
 nyFiKxUehbNF3r9qlJgPqONwX5vJy4/GvDHdddSCxV41P/ejsZ8PykxyJs98UWhF54tGRWFl
 7i1xvaDB9lN5WTLRKSO7wICuLiSz5WZHXMkyF4d+/O5ll7yz/o/JxK5vO/sduYDIlFTvBZDh
 gzaEtNf5tQjsjG4io8E0Yq0ViobLkS2RTNZT8ICq/Jmvl0SpbHRvYwa2DhNsK0YjHFQBB0FX
 IdhdUEzNefcNcYvqigJpdICoP2e4yJSyflHFO4dr0OrdnGLe1Zi/8Xo/2+M1dSSEt196rXaC
 kwu2KgIgmkRBb3cp2vIBBIIowU8W3qC1+w+RdMUrZxKGWJ3juwcgveJlzMpMZNyM1jobSXZ0
 VHGMNJ3MwXlrEFPXaYJgibcg6brM6wGfX/LBvc/haWw4yO24lT5eitm4UBdIy9pKkKmHHh7s
 jfZJkB5fWKVdoCv/omy6UyH6ykLOPFugl+hVL2Prf8xrXuZe1CMS7ID9Lc8FaL1ROIN/W8Vk
 BIsJMaWOhks//7d92Uf3EArDlDShwR2+D+AMon8NULuLBHiEUQARAQABzTJHdWVudGVyIFJv
 ZWNrIChMaW51eCBhY2NvdW50KSA8bGludXhAcm9lY2stdXMubmV0PsLBgQQTAQIAKwIbAwYL
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4ACGQEFAlVcphcFCRmg06EACgkQyx8mb86fmYFg0RAA
 nzXJzuPkLJaOmSIzPAqqnutACchT/meCOgMEpS5oLf6xn5ySZkl23OxuhpMZTVX+49c9pvBx
 hpvl5bCWFu5qC1jC2eWRYU+aZZE4sxMaAGeWenQJsiG9lP8wkfCJP3ockNu0ZXXAXwIbY1O1
 c+l11zQkZw89zNgWgKobKzrDMBFOYtAh0pAInZ9TSn7oA4Ctejouo5wUugmk8MrDtUVXmEA9
 7f9fgKYSwl/H7dfKKsS1bDOpyJlqhEAH94BHJdK/b1tzwJCFAXFhMlmlbYEk8kWjcxQgDWMu
 GAthQzSuAyhqyZwFcOlMCNbAcTSQawSo3B9yM9mHJne5RrAbVz4TWLnEaX8gA5xK3uCNCeyI
 sqYuzA4OzcMwnnTASvzsGZoYHTFP3DQwf2nzxD6yBGCfwNGIYfS0i8YN8XcBgEcDFMWpOQhT
 Pu3HeztMnF3HXrc0t7e5rDW9zCh3k2PA6D2NV4fews9KDFhLlTfCVzf0PS1dRVVWM+4jVl6l
 HRIAgWp+2/f8dx5vPc4Ycp4IsZN0l1h9uT7qm1KTwz+sSl1zOqKD/BpfGNZfLRRxrXthvvY8
 BltcuZ4+PGFTcRkMytUbMDFMF9Cjd2W9dXD35PEtvj8wnEyzIos8bbgtLrGTv/SYhmPpahJA
 l8hPhYvmAvpOmusUUyB30StsHIU2LLccUPPOwU0ETofVZwEQALlLbQeBDTDbwQYrj0gbx3bq
 7kpKABxN2MqeuqGr02DpS9883d/t7ontxasXoEz2GTioevvRmllJlPQERVxM8gQoNg22twF7
 pB/zsrIjxkE9heE4wYfN1AyzT+AxgYN6f8hVQ7Nrc9XgZZe+8IkuW/Nf64KzNJXnSH4u6nJM
 J2+Dt274YoFcXR1nG76Q259mKwzbCukKbd6piL+VsT/qBrLhZe9Ivbjq5WMdkQKnP7gYKCAi
 pNVJC4enWfivZsYupMd9qn7Uv/oCZDYoBTdMSBUblaLMwlcjnPpOYK5rfHvC4opxl+P/Vzyz
 6WC2TLkPtKvYvXmdsI6rnEI4Uucg0Au/Ulg7aqqKhzGPIbVaL+U0Wk82nz6hz+WP2ggTrY1w
 ZlPlRt8WM9w6WfLf2j+PuGklj37m+KvaOEfLsF1v464dSpy1tQVHhhp8LFTxh/6RWkRIR2uF
 I4v3Xu/k5D0LhaZHpQ4C+xKsQxpTGuYh2tnRaRL14YMW1dlI3HfeB2gj7Yc8XdHh9vkpPyuT
 nY/ZsFbnvBtiw7GchKKri2gDhRb2QNNDyBnQn5mRFw7CyuFclAksOdV/sdpQnYlYcRQWOUGY
 HhQ5eqTRZjm9z+qQe/T0HQpmiPTqQcIaG/edgKVTUjITfA7AJMKLQHgp04Vylb+G6jocnQQX
 JqvvP09whbqrABEBAAHCwWUEGAECAA8CGwwFAlVcpi8FCRmg08MACgkQyx8mb86fmYHNRQ/+
 J0OZsBYP4leJvQF8lx9zif+v4ZY/6C9tTcUv/KNAE5leyrD4IKbnV4PnbrVhjq861it/zRQW
 cFpWQszZyWRwNPWUUz7ejmm9lAwPbr8xWT4qMSA43VKQ7ZCeTQJ4TC8kjqtcbw41SjkjrcTG
 wF52zFO4bOWyovVAPncvV9eGA/vtnd3xEZXQiSt91kBSqK28yjxAqK/c3G6i7IX2rg6pzgqh
 hiH3/1qM2M/LSuqAv0Rwrt/k+pZXE+B4Ud42hwmMr0TfhNxG+X7YKvjKC+SjPjqp0CaztQ0H
 nsDLSLElVROxCd9m8CAUuHplgmR3seYCOrT4jriMFBtKNPtj2EE4DNV4s7k0Zy+6iRQ8G8ng
 QjsSqYJx8iAR8JRB7Gm2rQOMv8lSRdjva++GT0VLXtHULdlzg8VjDnFZ3lfz5PWEOeIMk7Rj
 trjv82EZtrhLuLjHRCaG50OOm0hwPSk1J64R8O3HjSLdertmw7eyAYOo4RuWJguYMg5DRnBk
 WkRwrSuCn7UG+qVWZeKEsFKFOkynOs3pVbcbq1pxbhk3TRWCGRU5JolI4ohy/7JV1TVbjiDI
 HP/aVnm6NC8of26P40Pg8EdAhajZnHHjA7FrJXsy3cyIGqvg9os4rNkUWmrCfLLsZDHD8FnU
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <c5780899-c471-4ce3-7581-5ab39a3cf219@roeck-us.net>
Date:   Mon, 1 Jun 2020 06:40:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <526286da-70d2-7c55-3c41-15fd2c969a39@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/1/20 4:16 AM, Andrzej Pietrasiewicz wrote:
> Hi Guenter,
> 
> W dniu 29.05.2020 o 17:52, Guenter Roeck pisze:
>> On Thu, May 28, 2020 at 09:20:46PM +0200, Andrzej Pietrasiewicz wrote:
>>> Prepare for making the drivers not access tzd's private members.
>>>
>>> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> 
> <snip>
> 
>>> +
>> Nit: unnecessary empty line.
>>
>>> +        return ret;
> 
> <snip>
> 
>>> +    return thermal_zone_device_set_mode(tz, THERMAL_DEVICE_ENABLED);
>>> +}
>>> +EXPORT_SYMBOL(thermal_zone_device_enable);
>>
>> Other exports in thermal/ use EXPORT_SYMBOL_GPL.
> 
> Other than that does it look good to you?

Yes, it does.

> I can send a v5 where the two above will be corrected, but did you have
> a chance to review patches 7-11?
> 
Not yet. I got distracted, sorry. Hopefully I'll get to it
today or tomorrow.

Guenter
