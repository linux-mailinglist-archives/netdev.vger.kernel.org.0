Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5C83C2BF6
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 02:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhGJAVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 20:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbhGJAVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 20:21:00 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CE1C0613DD;
        Fri,  9 Jul 2021 17:18:16 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id he13so19233806ejc.11;
        Fri, 09 Jul 2021 17:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RVgW60MDOl6uWKemqlHqCw9aConkcdhnrgPtp8Rc0RI=;
        b=M+60sw0Pvy22zHBAXCujcBAUNtGztcu9v71EyTSqHSU5+jgrlj7O25A6qtXd1Kt3lQ
         yscim0GlDk03ael1UNPJQrPcIinUYLFVagJkM2m1nTG+/IYc9JGY54BakqN0j8M2/TQ7
         kAUEOZJdQrgpepJ9iMaDhnX45wzJo+QA4fHkK00y/BKCKyz5fvXbXWah+Zdk7aEXuxew
         k7CdnjwJfBHTKZjL/8cVuAsKMaBnD2L3bi7YP5YfllgdCUp+61qDLLj0XpsuF8/iH1IB
         uCr7/eqoN4YQZLvtddAl0Ec+YETDo7FEh0PqHCWHFJPTUBH1mD8oytBhhSNtPldLZ2yE
         nEow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RVgW60MDOl6uWKemqlHqCw9aConkcdhnrgPtp8Rc0RI=;
        b=dsIbcp5Vh4pN6XOpZv+t1iYlvhxDDNuBSIJMk6SZLGC6ergiPiy7dvuwmCXJE6pPdQ
         qGpHKI395JVPQPO5+lXZQfCug9yCyIk0flNY5eqoVi0fVylHLPYXhoCQVHPeCNyjNF4A
         asCzRhjnql7fO8bxXBhJ02Bhi/h968p0g+LgZI20cYI/CId4fpFmShw8IDvXMLkOuGI/
         R0PLu4Je86Yx1L4aXFX7JBNt/kKovQQjg8DUOsD9sUHFbAqRxoHznoBEzul9tWppEb0n
         cjQ4qUl00oq08nXE72jVEeu7Ow4k7sbxEVRZV7BX09VTMs598hffYNecyUR9AsVZAkCx
         wniw==
X-Gm-Message-State: AOAM533JC29TY5BYwHHhI8Psv0Ph8HvhAl/R2xQL2XQ1VgVZfZFf4rE1
        nrHdM7O5mue7uMMCtDd5R/8=
X-Google-Smtp-Source: ABdhPJxdBxC7ZsozmFNxrgqfPI8+doDL7hl0F7IbWvfaazjwSuDa0ycHNEqdOmqYJqZ7l7aZY3KtlA==
X-Received: by 2002:a17:906:e099:: with SMTP id gh25mr22527487ejb.346.1625876294756;
        Fri, 09 Jul 2021 17:18:14 -0700 (PDT)
Received: from [192.168.2.202] (pd9e5a098.dip0.t-ipconnect.de. [217.229.160.152])
        by smtp.gmail.com with ESMTPSA id ce21sm468202ejc.25.2021.07.09.17.18.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jul 2021 17:18:14 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] mwifiex: pcie: add reset_d3cold quirk for Surface
 gen4+ devices
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
Cc:     =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <20210709173013.vkavxrtz767vrmej@pali>
 <89a60b06-b22d-2ea8-d164-b74e4c92c914@gmail.com>
 <20210709184443.fxcbc77te6ptypar@pali>
 <251bd696-9029-ec5a-8b0c-da78a0c8b2eb@gmail.com>
 <20210709194401.7lto67x6oij23uc5@pali>
 <4e35bfc1-c38d-7198-dedf-a1f2ec28c788@gmail.com>
 <20210709212505.mmqxdplmxbemqzlo@pali>
 <bfbb3b4d-07f7-1b97-54f0-21eba4766798@gmail.com>
 <20210709225433.axpzdsfbyvieahvr@pali>
 <89c9d1b8-c204-d028-9f2c-80d580dabb8b@gmail.com>
 <20210710000756.4j3tte63t5u6bbt4@pali>
From:   Maximilian Luz <luzmaximilian@gmail.com>
Message-ID: <1d45c961-d675-ea80-abe4-8d4bcf3cf8d4@gmail.com>
Date:   Sat, 10 Jul 2021 02:18:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210710000756.4j3tte63t5u6bbt4@pali>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/10/21 2:07 AM, Pali Rohár wrote:

[...]

>> Interesting, I was not aware of this. IIRC we've been experimenting with
>> the mwlwifi driver (which that lrdmwl driver seems to be based on?), but
>> couldn't get that to work with the firmware we have.
> 
> mwlwifi is that soft-mac driver and uses completely different firmware.
> For sure it would not work with current full-mac firmware.
> 
>> IIRC it also didn't
>> work with the Windows firmware (which seems to be significantly
>> different from the one we have for Linux and seems to use or be modeled
>> after some special Windows WiFi driver interface).
> 
> So... Microsoft has different firmware for this chip? And it is working
> with mwifiex driver?

I'm not sure how special that firmware really is (i.e. if it is Surface
specific or just what Marvell uses on Windows), only that it doesn't
look like the firmware included in the linux-firmware repo. The Windows
firmware doesn't work with either mwlwifi or mwifiex drivers (IIRC) and
on Linux we use the official firmware from the linux-firmware repo.
