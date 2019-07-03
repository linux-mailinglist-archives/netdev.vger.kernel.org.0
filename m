Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C98035EE7C
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 23:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfGCV1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 17:27:50 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55733 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbfGCV1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 17:27:49 -0400
Received: by mail-wm1-f65.google.com with SMTP id a15so3644767wmj.5;
        Wed, 03 Jul 2019 14:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t9ppNu+tTe8IMaz8VD3GfS+xRVxRIJDS97FL0GEnxCo=;
        b=JeLJ6Y3ufQlegAik9zWghxwF/mrLQWjE5NIpiZJd699FR9cSWOLeh3FrojugG83BwJ
         DyldNdCjU7FbDJclPm2i6bzFggqRqbxYU4H8uVEYA7A4FE6t6vHcZYZJMWZOyhnZjyhe
         RUZyVEQe2OLYC81n+dKvND0ZeU6SmUb5qUG73qB8B1baVlp/I0BvnYcmM3AvqbZhXo8I
         hknyeLUpIF/3L5dxRTm65VR/Cg9AqKFgcu2xstwC2NWcYGp9SRKbJlOj7n7pVOIqXwYO
         8VztMEobWnweJL4tmuEidzUCY/pVUyAoF2HDryk/LYahWYfk/VoKMP9rKWe6tpITqRtg
         Qb8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t9ppNu+tTe8IMaz8VD3GfS+xRVxRIJDS97FL0GEnxCo=;
        b=r5bgVdt+H06tfx7kBORttd8AFUUCSh22eIoazPBWsonPj3CjMePaoreWx6o5C8SX4K
         vNuEfZsDjkdy+js9M56R7N9nLGUH91qEXUlOVsH+nhwPxH94dB0bk8jQqrRlgpQAPQq1
         marZ1kYt/+jap7MhtQVBai9cv4eSeulG7Qkykh9UkCDtDZ1JuMRNpDTFGFMpkFd4MADW
         CZm/Q6SaJeCK+AQ1OCOwfgJjVWDUZsQ3ywPMO/7H1Ti9ij5QsjQjIH9SL16JYueLYSmP
         3mBeaBxoeJ6ng85Q2gOpKNp01uHwnhw6HUz7KgCPGRvoJ6MpAIHUx+hP/IYOk+ZfNsVB
         AbOw==
X-Gm-Message-State: APjAAAXmygoDxmPWZUJTWfrCGdFjKHvGQS/PKITbyksgLTO5gt0EAHx5
        Xbt1aCF4gKJrg1WtoRyZwv0=
X-Google-Smtp-Source: APXvYqx2tUA/FQ/KELmCVtbRZYYZSkMb7PcEqhhQv19yjNdu85ImPP9Oy2RQ/bY9Xeq5QyvfBlkFhQ==
X-Received: by 2002:a1c:1f06:: with SMTP id f6mr892554wmf.60.1562189267692;
        Wed, 03 Jul 2019 14:27:47 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:4503:872e:8227:c4e0? (p200300EA8BD60C004503872E8227C4E0.dip0.t-ipconnect.de. [2003:ea:8bd6:c00:4503:872e:8227:c4e0])
        by smtp.googlemail.com with ESMTPSA id a64sm7593935wmf.1.2019.07.03.14.27.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 14:27:47 -0700 (PDT)
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
 <98326ec2-6e90-fd3a-32f5-cf0db26c31a9@gmail.com>
 <20190703212407.GI250418@google.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <3e47639a-bbbb-f438-bc66-a29423090e95@gmail.com>
Date:   Wed, 3 Jul 2019 23:27:41 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190703212407.GI250418@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.07.2019 23:24, Matthias Kaehlcke wrote:
> On Wed, Jul 03, 2019 at 11:01:09PM +0200, Heiner Kallweit wrote:
>> On 03.07.2019 22:36, Matthias Kaehlcke wrote:
>>> On Wed, Jul 03, 2019 at 10:12:12PM +0200, Heiner Kallweit wrote:
>>>> On 03.07.2019 21:37, Matthias Kaehlcke wrote:
>>>>> The RTL8211E has extension pages, which can be accessed after
>>>>> selecting a page through a custom method. Add a function to
>>>>> modify bits in a register of an extension page and a helper for
>>>>> selecting an ext page.
>>>>>
>>>>> rtl8211e_modify_ext_paged() is inspired by its counterpart
>>>>> phy_modify_paged().
>>>>>
>>>>> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
>>>>> ---
>>>>> Changes in v2:
>>>>> - assign .read/write_page handlers for RTL8211E
>>>>
>>>> Maybe this was planned, but it's not part of the patch.
>>>
>>> Oops, it was definitely there when I tested ... I guess this got
>>> somehow lost when changing the patch order and resolving minor
>>> conflicts, seems like I only build tested after that :/
>>>
>> RTL8211E also supports normal pages (reg 0x1f = page).
>> See e.g. rtl8168e_2_hw_phy_config in the r8169 driver, this network
>> chip has an integrated RTL8211E PHY. There settings on page 3 and 5
>> are done.
>> Therefore I would prefer to use .read/write_page for normal paging
>> in all Realtek PHY drivers. Means the code here would remain as it
>> is and just the changelog would need to be fixed.
> 
> Do I understand correctly that you suggest an additional patch that
> assigns .read/write_page() for all entries of realtek_drvs?
> 

No, basically all the Realtek PHY drivers use the following already:
.read_page	= rtl821x_read_page,
.write_page	= rtl821x_write_page,
What I mean is that this should stay as it is, and not be overwritten
with the extended paging.
