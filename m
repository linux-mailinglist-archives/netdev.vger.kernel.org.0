Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C15A9FA02
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 07:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbfH1Fwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 01:52:30 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52840 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbfH1Fwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 01:52:30 -0400
Received: by mail-wm1-f67.google.com with SMTP id t17so360066wmi.2
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 22:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7R+r4D8jF57pXwTxnGr/HeXPQE+WdlqI7RSJ4/ZG8Gs=;
        b=mBpBZKQj8CbgPjz5MnC55by6xXfgMHmeKkCPlJ8FR7oBI8fAUfdZqTuRPTVV2l/pxK
         ilhgaMnFGOB6OFjOosoB1HNakhWrTR3pzHudHYXrsPKfRnvO4LHkCG03xMs0cYl+reN0
         DOlmiteI0SL+berQhDau5VfTOOOfHNrt9THWKYaRIJbesjVMbf7Jbk51sxW90Bh0mpPw
         STOCFsK7rjtCBQKraLnXj4nUdqlrEcES5Yl7IlnMREr4gk/6J7JoELGhK3HpIv5+neVo
         0AQzpmGqXNUKjSzxsXpZJ4pVApz05Qpi0xYCc3xOIjbJ5GDTYX4X9e7AcoNSVdZQ3hNO
         lX1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7R+r4D8jF57pXwTxnGr/HeXPQE+WdlqI7RSJ4/ZG8Gs=;
        b=GEEGQQqc0J4Ai3eiioCRD/HwRsHHQu4MnNGiHoMYLrUzMue/9PE9lBmz2pPPXe8bkD
         uEsKcB6KiP4v0Dzv3eAJhJv+ZxXNrHgapvV4Lwl00yK2X7On+LDJZ123aG88R4X1oR8K
         K40eUm5tw9ZhAiVQKcKl7PGKZ/eXBn/2K6y9V/YX4EItQm3tzE0QZJuu0RSW6LUmajXp
         M//lO+n4ToVvkeRiA3vYztt9fnrKFcbHI7elIJlSYVEdKo4XPssOA6Y12iQ+kGo4twYe
         Ji7ySbsvYjxUhHvEMbYoHXGortg6WjaJVi8GEoacco/cFC5mOOBc/nnQHBZKakAiGLkG
         nk7A==
X-Gm-Message-State: APjAAAW9DOKAOoPJt14dpUp0CcHpRoGY6L0R87h8LaaGC1tZuD8W1D8d
        9fdjdNsJIh5pUKZ6qGYpjnw=
X-Google-Smtp-Source: APXvYqw+Ec5aSG3F/PpPxUcPhMw7J8Ke5Dto0DrE83xfXkAkQZU0zAfx+TbrsHiugvbUp8zREb53qw==
X-Received: by 2002:a1c:be15:: with SMTP id o21mr2405720wmf.140.1566971548071;
        Tue, 27 Aug 2019 22:52:28 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:3ca9:fbff:ec1b:c219? (p200300EA8F047C003CA9FBFFEC1BC219.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:3ca9:fbff:ec1b:c219])
        by smtp.googlemail.com with ESMTPSA id c11sm1115792wrt.25.2019.08.27.22.52.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 22:52:27 -0700 (PDT)
Subject: Re: [PATCH net-next 1/4] r8169: prepare for adding RTL8125 support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chun-Hao Lin <hau@realtek.com>
References: <55099fc6-1e29-4023-337c-98fc04189e5e@gmail.com>
 <66ac2b09-ea87-a4ba-f6f3-1885e9587298@gmail.com>
 <20190827232713.GE26248@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <d58275fb-b2b5-008c-0805-edfae137678d@gmail.com>
Date:   Wed, 28 Aug 2019 07:52:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190827232713.GE26248@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.08.2019 01:27, Andrew Lunn wrote:
> On Tue, Aug 27, 2019 at 08:41:00PM +0200, Heiner Kallweit wrote:
>> This patch prepares the driver for adding RTL8125 support:
>> - change type of interrupt mask to u32
>> - restrict rtl_is_8168evl_up to RTL8168 chip versions
>> - factor out reading MAC address from registers
>> - re-add function rtl_get_events
>> - move disabling interrupt coalescing to RTL8169/RTL8168 init
>> - read different register for PCI commit
>> - don't use bit LastFrag in tx descriptor after send, RTL8125 clears it
> 
> Hi Heiner
> 
> That is a lot of changes in one patch. Although there is no planned
> functional change, r8169 has a habit of breaking. Having lots of small
> changes would help tracking down which change caused a breakage, via a
> git bisect.
> 
> So you might want to consider splitting this up into a number of small
> patches.
> 
> 	Andrew
> 
Hi Andrew,

most of the changes are trivial, but you're right. I'll split this patch.

Heiner
