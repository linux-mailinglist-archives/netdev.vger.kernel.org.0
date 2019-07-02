Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBA5D5C919
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 08:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbfGBGIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 02:08:05 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51564 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfGBGIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 02:08:05 -0400
Received: by mail-wm1-f65.google.com with SMTP id 207so1640350wma.1;
        Mon, 01 Jul 2019 23:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lve1vjRn+vNM45mBAySyDNXYT3W/b0QVj9SHJfPanGs=;
        b=EvNkQbbCBhYPT6j/WduVkVn8+LUaU/B/JfHuplh25DI4oTX4Npui55yQSKeHG329Hy
         gCL9EqIlKU7jcje5b5EPrcg6vdjIeZ+u4N65WKIxXgHSzU7nBK7XA1yYS0yspuqSxQNg
         dnAEu3wbTD9zYGH8BHPoPq1/dMHJDJaGF+mBGG8BA7O+r48NrJqczPzhQwCUr23T0rNC
         vxwQdCvoXH8elH2k6kyIjF6EehZjgPtUPvGFWTq+U9pgX73HSbjjF5zDVUfa0lGbbh7B
         sKn6aJt9MMiET/+fRcr+KBk73mUCXGRrv3XHdr1+8XUiUGGtrVTUbbMPAjF0DCCGCOhx
         j6Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lve1vjRn+vNM45mBAySyDNXYT3W/b0QVj9SHJfPanGs=;
        b=SlGlB784VxE1SLWVGikHXVizM3qad9RGRiqQ9uHZx9JQowyhMPML4w18eGRjYLUPk7
         oInF9ayMas1uxDp4NRGA2sU5qSQGEx399dEFCY7GIEcIBV+5MPVmImMK2I4ddJhyIdfM
         3bkHsG0KeYGinXL9Z2P23RIGR/oSWfcVuY/SIzQLluVuOlpepj3l2zNz8GeSCzf19W4M
         8mXe3VI9rZ5XC3Jd4f2VeXXQyWwgGiKG2qKvDvbc2VZm5VfBZxtcrZOgrODCjGPDMjub
         Iia+wT/hrloouOKI4oDwwLx8bBX6xOa74yPvugGVMmwBA7y6+cdhH1S7x1c83/bNlwiP
         hiYw==
X-Gm-Message-State: APjAAAWH7s0Vu6kheJVgqdNnVvFt6V+0W/V5WmUWMWt2vsRhR98qnVFf
        G+6bjWTFVfO3FXT+PpXXhWU=
X-Google-Smtp-Source: APXvYqwJvKbLRroUbMo4RgCa43Mv0w3ssqvmo6D0RZbveWlTcKdX2RcWfLq7Kn2wc8fxaCgcGtpbcA==
X-Received: by 2002:a7b:c04f:: with SMTP id u15mr1188846wmc.106.1562047683475;
        Mon, 01 Jul 2019 23:08:03 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:d5f3:78fc:5357:f218? (p200300EA8BD60C00D5F378FC5357F218.dip0.t-ipconnect.de. [2003:ea:8bd6:c00:d5f3:78fc:5357:f218])
        by smtp.googlemail.com with ESMTPSA id h19sm25332448wrb.81.2019.07.01.23.08.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 23:08:02 -0700 (PDT)
Subject: Re: [PATCH 2/3] net: phy: realtek: Enable accessing RTL8211E
 extension pages
To:     Matthias Kaehlcke <mka@chromium.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
References: <20190701195225.120808-1-mka@chromium.org>
 <20190701195225.120808-2-mka@chromium.org> <20190701200248.GJ30468@lunn.ch>
 <35db1bff-f48e-5372-06b7-3140cb7cbb71@gmail.com>
 <20190701210902.GL30468@lunn.ch> <20190702000925.GD250418@google.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <bdacdf76-8eae-e865-9c00-8e70a12ad303@gmail.com>
Date:   Tue, 2 Jul 2019 08:07:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190702000925.GD250418@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.07.2019 02:09, Matthias Kaehlcke wrote:
> On Mon, Jul 01, 2019 at 11:09:02PM +0200, Andrew Lunn wrote:
>> On Mon, Jul 01, 2019 at 10:37:16PM +0200, Heiner Kallweit wrote:
>>> On 01.07.2019 22:02, Andrew Lunn wrote:
>>>> On Mon, Jul 01, 2019 at 12:52:24PM -0700, Matthias Kaehlcke wrote:
>>>>> The RTL8211E has extension pages, which can be accessed after
>>>>> selecting a page through a custom method. Add a function to
>>>>> modify bits in a register of an extension page and a few
>>>>> helpers for dealing with ext pages.
>>>>>
>>>>> rtl8211e_modify_ext_paged() and rtl821e_restore_page() are
>>>>> inspired by their counterparts phy_modify_paged() and
>>>>> phy_restore_page().
>>>>
>>>> Hi Matthias
>>>>
>>>> While an extended page is selected, what happens to the normal
>>>> registers in the range 0-0x1c? Are they still accessible?
>>>>
>>> AFAIK: no
>>
>> This it would be better to make use of the core paged access support,
>> so that locking is done correctly.
> 
> Do I understand correctly that this would involve assigning
> .read/write_page and use phy_select_page() and phy_restore_page()?
> 
> Besides the benefit of locking this would also result in less code and
> we could get rid of the custom _restore_page().
> 
Interestingly certain Realtek PHY's (incl. RTL8211E) support two paging
mechanisms.

1. Normal paging (set reg 0x1f to page number) - set by core paging
2. Extended pages (set reg 0x1f to 7, and reg 0x1e to ext. page number)

Newer Realtek PHY's use normal paging only.
