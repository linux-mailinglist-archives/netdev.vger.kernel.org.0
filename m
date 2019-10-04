Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76AA3CBEAF
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 17:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389700AbfJDPLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 11:11:16 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44896 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389086AbfJDPLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 11:11:16 -0400
Received: by mail-qt1-f196.google.com with SMTP id u40so8975066qth.11;
        Fri, 04 Oct 2019 08:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LaVRRMK9qu3AK/IDimN49Clff2cxJBO8xmfUwWCrdGI=;
        b=tjSLjRjBQ/Xb2EqjJJ+ELbHOAgSrTFA+9NuNuwVMn3f3zUpKLba1tmgGG7J3PqGWpL
         YojUhXkcYDU2KT72YIx57K67hJyb3+qHTD97X1wsw+NT+8PIvHMY0vE/yoLlEk8zUXZY
         bm9smuVFB7rUNUdyca3xT3LTMoNVt9nQj9LEQQ1lTbHf61rh9Uu273MLj6UHCI6XqhS+
         oO4drxzBQzXLuMTeuWQPT6Npshp1oHDiNwq//3S2OzzJldXhEqiEdWmDuvDNLXNCJg9w
         L5vG2Bvw9m9cabO2En6WYF7Ootl6qsBuZJGMHdACd7b+4QSR0JvGsZ57KAPq1UUXtS3J
         /rOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LaVRRMK9qu3AK/IDimN49Clff2cxJBO8xmfUwWCrdGI=;
        b=E1iH6ccYBkF8eE7a6FJr0g174k20IMcoPz2Hdd4DjdFeKt7XjjOGS7AUwfrqJ7J/9p
         OaCva6MJLWBrrS4tH728YgdI7oE3vYU7vRUj+POpefeyDRd7X59EE0tvo9tGRgBzoFY9
         DkbgBZ33SQGGiwS25mGjC2ojamPGi0cv4bsM1f8tFS4yaPaIqTpe081O0PoxDTypYjM+
         nJloBLaBrqFt2q6ogoiSTk0M0jpoEC7Xe63uE8b8bnDV2Rm8QbTHjcd0Rot646EpsH8u
         Vvq5YDN1/rfX7iSZlWQ78+RfNqRo8glT8hUXsYTn4tXSNaGWeEabQV3U3DXi4VvmAWt9
         A3vg==
X-Gm-Message-State: APjAAAXwON33sHRtQmbONOYu5PmyOsrOF1XLOGR7q5Iv1pf4pA5N92u+
        /yEmreBgWT1jBma3hFIDsTA=
X-Google-Smtp-Source: APXvYqzS2WPllmpeWzWMvLD7ans2wlPHGenq0xVVA5BS1uVMyNVlrgiV+KuHd5KyDDonyc0Im9VzRQ==
X-Received: by 2002:ac8:5554:: with SMTP id o20mr16339768qtr.282.1570201874942;
        Fri, 04 Oct 2019 08:11:14 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a3:10fb:a464:42a6:e226:d387? ([2620:10d:c091:500::2:9b70])
        by smtp.gmail.com with ESMTPSA id 139sm3317840qkf.14.2019.10.04.08.11.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2019 08:11:14 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH v2] rtl8xxxu: add bluetooth co-existence support for
 single antenna
To:     Chris Chiu <chiu@endlessm.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>
References: <20190911025045.20918-1-chiu@endlessm.com>
 <0c049f46-fb15-693e-affe-a84ea759b5d7@gmail.com>
 <CAB4CAweXfhLc8ATWg87ydadCKVqj3SnG37O5Hyz8uP8EkPrg9w@mail.gmail.com>
Message-ID: <5dad1fd1-ef0b-b5d9-02ea-7fc3bf7f8576@gmail.com>
Date:   Fri, 4 Oct 2019 11:11:12 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <CAB4CAweXfhLc8ATWg87ydadCKVqj3SnG37O5Hyz8uP8EkPrg9w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/2/19 9:19 PM, Chris Chiu wrote:
> On Wed, Oct 2, 2019 at 11:04 PM Jes Sorensen <jes.sorensen@gmail.com> wrote:
>>
>>
>> In general I think it looks good! One nit below:
>>
>> Sorry I have been traveling for the last three weeks, so just catching up.
>>
>>
>>> +void rtl8723bu_set_coex_with_type(struct rtl8xxxu_priv *priv, u8 type)
>>> +{
>>> +     switch (type) {
>>> +     case 0:
>>> +             rtl8xxxu_write32(priv, REG_BT_COEX_TABLE1, 0x55555555);
>>> +             rtl8xxxu_write32(priv, REG_BT_COEX_TABLE2, 0x55555555);
>>> +             rtl8xxxu_write32(priv, REG_BT_COEX_TABLE3, 0x00ffffff);
>>> +             rtl8xxxu_write8(priv, REG_BT_COEX_TABLE4, 0x03);
>>> +             break;
>>> +     case 1:
>>> +     case 3:
>>
>> The one item here, I would prefer introducing some defined types to
>> avoid the hard coded type numbers. It's much easier to read and debug
>> when named.
>>
> Honestly, I also thought of that but there's no meaningful description for these
> numbers in the vendor driver. Even based on where they're invoked, I can merely
> give a rough definition on 0. So I left it as it is for the covenience
> if I have to do
> cross-comparison with vendor driver in the future for some possible
> unknown bugs.
> 
>> If you shortened the name of the function to rtl8723bu_set_coex() you
>> won't have problems with line lengths at the calling point.
>>
> I think the rtl8723bu_set_ps_tdma() function would cause the line length problem
> more than rtl8723bu_set_coex_with_type() at the calling point. But as the same
> debug reason as mentioned, I may like to keep it because I don't know how to
> categorize the 5 magic parameters. I also reference the latest rtw88
> driver code,
> it seems no better solution so far. I'll keep watching if there's any
> better idea.

Personally I would still prefer to name it COEX_TYPE_1 etc. but I can 
live with this. Would you mind at least adding some comments in the code 
about it?

Cheers,
Jes


