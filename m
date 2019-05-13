Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 886B61BE6C
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 22:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbfEMUNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 16:13:06 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40253 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbfEMUNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 16:13:05 -0400
Received: by mail-wr1-f65.google.com with SMTP id h4so16696294wre.7;
        Mon, 13 May 2019 13:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cRRBqLbvbj90dnuit0x8d7ovpvx/asJQqIIKZ6ub/Sw=;
        b=CGp23cHqHxvrMsZIUwiTaGkO5AOngN5Zihv4SIcvPVlsotObpyVLovD7d08wPi/yuN
         O2SnfUncMBPq0xXgqpJCAnYHcoTxJ/MsxtD5T4uC6WmOhZ1NVOFnoMHNxVa0pKBtnupb
         n6b7fxFV/T54Wex9jbYqWsHXlWKEvAMRmNHL8wVydIAVQb53+qvm0jmS+GpFbv06lYcp
         HLzUozQH0socB52LmcgRk7dAmpw/oAIWzqAk6TCLNG5idcNYF6DLbzKGzpDwbflpKOHg
         SVwfuFIVmtUEM396wtHkSjv6pGGYbzRDzAzT7GJPWf6E0sEzYm//ujxyso4VyanLj93a
         E+aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cRRBqLbvbj90dnuit0x8d7ovpvx/asJQqIIKZ6ub/Sw=;
        b=QYfBofEnHNY12AEtcXgq3xtNQyEYJpLsK/F3BwgBDxpyx5+AWQYMdHTgFKUiHs7iXw
         QB0hMREF1ujNo/5oomxyD7xOqogqg+V8422Zjd+Vaazq1ij90Zb+PGkhyzkomZPT+hhi
         kCBBJu6I1gFLEitAsmUOBTfT7XJQWT83vK5HgHmCzlSrgcYQDUfYonsHnL9L8yXtzvtY
         gkZ3lWfB+ivJ3DpXMcYl7e6NAyWfJGPzsKJgWygBlyByvKsCLjw1CtJ4gVTZHw6SxIrj
         R05INAnGscw5PxgYTpPF5hTD5f4TgqmsfleJioGmA8ePKRXKx5leU2wa1nBpTQxzTuqB
         jC3A==
X-Gm-Message-State: APjAAAUGE1QPgd8m8W6LLd5rA8G80YZc7yVHQcmJjx6OcxHFphvpaATv
        Ef2dwb0Rbdr/sV/En2xqtxWncGNiDMk=
X-Google-Smtp-Source: APXvYqxfj7bjNtCNJtNEJzvPTH1HD2+VNTdO/IlPOiXKPmLMpoz1r7v0mT+cgjKs4c8EcZg7nn+Vvg==
X-Received: by 2002:a5d:4cc4:: with SMTP id c4mr6069700wrt.164.1557778383095;
        Mon, 13 May 2019 13:13:03 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:291f:455f:c298:ea7f? (p200300EA8BD45700291F455FC298EA7F.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:291f:455f:c298:ea7f])
        by smtp.googlemail.com with ESMTPSA id y6sm23846065wrw.60.2019.05.13.13.13.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 13:13:02 -0700 (PDT)
Subject: Re: [PATCH 5/5] net: phy: dp83867: Use unsigned variables to store
 unsigned properties
To:     Trent Piepho <tpiepho@impinj.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
References: <20190510214550.18657-1-tpiepho@impinj.com>
 <20190510214550.18657-5-tpiepho@impinj.com>
 <49c6afc4-6c5b-51c9-74ab-9a6e8c2460a5@gmail.com>
 <3a42c0cc-4a4b-e168-c03e-1cc13bd2f5d4@gmail.com>
 <1557777496.4229.13.camel@impinj.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <b246b18d-5523-7b8b-9cd0-b8ccb8a511e9@gmail.com>
Date:   Mon, 13 May 2019 22:12:58 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1557777496.4229.13.camel@impinj.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.05.2019 21:58, Trent Piepho wrote:
> On Sat, 2019-05-11 at 14:32 +0200, Heiner Kallweit wrote:
>> On 11.05.2019 12:41, Heiner Kallweit wrote:
>>> On 10.05.2019 23:46, Trent Piepho wrote:
>>>> The variables used to store u32 DT properties were signed
>>>> ints.  This
>>>> doesn't work properly if the value of the property were to
>>>> overflow.
>>>> Use unsigned variables so this doesn't happen.
>>>>
>>>
>>> In patch 3 you added a check for DT properties being out of range.
>>> I think this would be good also for the three properties here.
>>> The delay values are only 4 bits wide, so you might also consider
>>> to switch to u8 or u16.
>>>
>>
>> I briefly looked over the rest of the driver. What is plain wrong
>> is to allocate memory for the private data structure in the
>> config_init callback. This has to be done in the probe callback.
>> An example is marvell_probe(). As you seem to work on this driver,
>> can you provide a patch for this?
> 
> It only allocates the data once, so it is not a memory leak.  But yes,
> totally wrong place to do it.  I can fix this.  It also does not set
> the signal line impedance from DT value unless unless also configuring
> clock skew, even though they are orthogonal concepts.  And fails to
> verify anything read from the DT.
> 
> Perhaps you could tell me if the approach I've taken in patch 3, 
> "Add ability to disable output clock", and patch 4, "Disable tx/rx
> delay when not configured", are considered acceptable?  I can conceive
> of arguments for alternate approaches.  I would like to add support for
>  these into u-boot too, but typically u-boot follows the kernel DT
> bindings, so I want to finalize the kernel DT semantics before sending
> patches to u-boot.
> 
I lack experience with these TI PHY's. Maybe Andrew or Florian can advise.

>>> Please note that net-next is closed currently. Please resubmit the
>>> patches once it's open again, and please annotate them properly
>>> with net-next.
> 
> Sorry, didn't know about this policy.  Been years since I've submitted
> net patches.  Is there a description somewhere of how this is done? 
> Googling net-next wasn't helpful.  I gather new patches are only
> allowed when the kernel merge window is open?  And they can't be queued
> on patchwork or a topic branch until this happens?
> 
https://www.kernel.org/doc/Documentation/networking/netdev-FAQ.txt

And the easy way to check whether net-next is open:
http://vger.kernel.org/~davem/net-next.html
