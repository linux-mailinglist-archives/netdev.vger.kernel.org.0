Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8551695B
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 19:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbfEGRh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 13:37:58 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45380 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfEGRh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 13:37:58 -0400
Received: by mail-wr1-f65.google.com with SMTP id s15so23468410wra.12;
        Tue, 07 May 2019 10:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=40UowXtkpP66BIbl3jce7jAE3WdJjCT0IpyKnuB4He0=;
        b=j0cHkjSsi4GMJ/ad/c/pkaE1HxB3dW/O3M3UDYXebULmO0NQckgekIf+lW+AjBXnbC
         TRYFw89MTBGLy2xrJN6X36mNMiQTShHVmnq4qHfdlj9Z8nZi1MjjLKjNAf8iRMbJf7z1
         ZSePbrDkKK1+mgiRbjWhGLdOhNMFwBHCFzupIh67vBRFbtXyN0+Ncx+6f9C5YfWaVidu
         wMAev8kuodAc23ugoS/N3ymE1v3PeLWz0dTXILQklCRwTclHJer1ME2QmYxaDmYeM2to
         r7B6+seKqrHw+yVh6x1/M8Ts7+bcSDhx2W68l0mn0l2vakKnO+GCkLkcUWMTWfNiG3OW
         UbEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=40UowXtkpP66BIbl3jce7jAE3WdJjCT0IpyKnuB4He0=;
        b=IN7HUAJWS3N8n3kvxh3tkSDHSpjCwP5u3o1tCxHZmc5UB0t69G7NnUomP27CRD/WOt
         Ub/JJtQT0oJRGALI7ReJ16nI/iU2j5/7dkXCxcV+cOhkvkAG2YIHPJ5nC/zj5J5F/mHc
         G4LIiSswYHxTVOs11gnHP9tzqYS+UzQVOcytpZvMqWpUwvPzEremRWIjNLPbpzB9cfE8
         zIV1QULqsuE/jdpSzBjEvk1vwTTaTfQ1xTq7eMliYMCYg3DFxp1STiNUVW5X/m0wvCg3
         cIi2+8lH7wOzaXkeN8mBTmwTNQFxHtHXADJV6QNOj7QQ7SziQQhPzf+n1e0x2YYs7jwH
         ibvw==
X-Gm-Message-State: APjAAAWFZkdtU7UAnZswE0STUxx2oGdzIG1zhphffVlbZRfhCw+evLFL
        hmpeGIZSuSS1UVPbXB3QeXpTMn1Wy/0=
X-Google-Smtp-Source: APXvYqzS61rWTkm250l2xNEhomi+pyxWDMxDK4eImRQJVBB018K5dDKbnQW61SU8impyaZaBA1gmyQ==
X-Received: by 2002:adf:e74b:: with SMTP id c11mr5557424wrn.172.1557250675226;
        Tue, 07 May 2019 10:37:55 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:75b4:515d:c6e7:711b? (p200300EA8BD4570075B4515DC6E7711B.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:75b4:515d:c6e7:711b])
        by smtp.googlemail.com with ESMTPSA id m25sm14157409wmi.45.2019.05.07.10.37.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 10:37:54 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] net: phy: realtek: Change TX-delay setting for
 RGMII modes only
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Serge Semin <fancer.lancer@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Serge Semin <Sergey.Semin@t-platforms.ru>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
References: <20190426212112.5624-1-fancer.lancer@gmail.com>
 <20190426212112.5624-2-fancer.lancer@gmail.com>
 <20190426214631.GV4041@lunn.ch>
 <20190426233511.qnkgz75ag7axt5lp@mobilestation>
 <f27df721-47aa-a708-aaee-69be53def814@gmail.com>
 <CA+h21hpTRCrD=FxDr=ihDPr+Pdhu6hXT3xcKs47-NZZZ3D9zyg@mail.gmail.com>
 <20190429211225.ce7cspqwvlhwdxv6@mobilestation>
 <CAFBinCBxgMr6ZkOSGfXZ9VwJML=GnzrL+FSo5jMpN27L2o5+JA@mail.gmail.com>
 <20190506143906.o3tublcxr5ge46rg@mobilestation>
 <CAFBinCA=-oK3qhPv-sPge6qAo9jiv8me72_d8HCqKN3g0qiM-A@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <11d22189-79c2-1f4f-a93c-f99e8310ceb7@gmail.com>
Date:   Tue, 7 May 2019 19:37:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAFBinCA=-oK3qhPv-sPge6qAo9jiv8me72_d8HCqKN3g0qiM-A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.05.2019 19:21, Martin Blumenstingl wrote:
> Hi Serge,
> 
> On Mon, May 6, 2019 at 4:39 PM Serge Semin <fancer.lancer@gmail.com> wrote:
> [...]
>>> the changes in patch 1 are looking good to me (except that I would use
>>> phy_modify_paged instead of open-coding it, functionally it's
>>> identical with what you have already)
>>>
>>
>> Nah, this isn't going to work since the config register is placed on an extension
>> page. So in order to reach the register first I needed to enable a standard page,
>> then select an extended page, then modify the register bits.
> I'm probably missing something here. my understanding about
> phy_modify_paged is that it is equal to:
> - select extension page
> - read register
> - calculate the new register value
> - write register
> - restore the original extension page
> 
What maybe causes the confusion: Realtek has two kinds of pages.
First there is the following, let's call it simple page:
You select a page via register 0x1f and then access the paged register.

Then there are extended pages. First you select a page via register 0x1f,
then the extended page via register 0x1e, and then the paged register.

> if phy_modify_paged doesn't work for your use-case then ignore my comment.
> 
> [...]
>>>> (Martin, I also Cc'ed you in this discussion, so if you have anything to
>>>> say in this matter, please don't hesitate to comment.)
>>> Amlogic boards, such as the Hardkernel Odroid-C1 and Odroid-C2 as well
>>> as the Khadas VIM2 use a "RTL8211F" RGMII PHY. I don't know whether
>>> there are multiple versions of this PHY. all RTL8211F I have seen so
>>> far did behave exactly the same.
>>>
>>> I also don't know whether the RX delay is configurable (by pin
>>> strapping or some register) on RTL8211F PHYs because I don't have
>>> access to the datasheet.
>>>
>>>
>>> Martin
>>
>> Ok. Thanks for the comments. I am sure the RX-delay is configurable at list
>> via external RXD pin strapping at the chip powering up procedure. The only
>> problem with a way of software to change the setting.
>>
>> I don't think there is going to be anyone revealing that realtek black boxed
>> registers layout anytime soon. So as I see it it's better to leave the
>> rtl8211f-part as is for now.
> with the RTL8211F I was not sure whether interrupt support was
> implemented correctly in the mainline driver.
> I asked Realtek for more details:
> initially they declined to send me a datasheet and referred me to my
> "partner contact" (which I don't have because I'm doing this in my
> spare time).
> I explained that I am trying to improve the Linux driver for this PHY.
> They gave me the relevant bits (about interrupt support) from the
> datasheet (I never got the full datasheet though).
> 
Same with me for the r8169 driver: They answer single questions quite
exact and fast, but no chance to get a datasheet or errata even for
10 yrs old chips.

> if you don't want to touch the RTL8211F part for now then I'm fine
> with that as well
> 
> 
> Regards
> Martin
> 
Heiner
