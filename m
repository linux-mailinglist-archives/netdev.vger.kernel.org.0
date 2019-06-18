Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9294E4A52C
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 17:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbfFRPUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 11:20:43 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:43051 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728982AbfFRPUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 11:20:42 -0400
Received: by mail-io1-f65.google.com with SMTP id k20so30645044ios.10
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 08:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Gm6zrt3+jyOk79FjVLjqIif+2ZGmPF1/TjoosYPa/aY=;
        b=HhgTn3B5frcZ87brr7+01lN2WHNxic6G3R1o8OJlYQqfp1hc1M3WllIY/XNiGPHaCI
         Y49KrIQF61r5gxzA3PSinDixPJnXEsEXx6srKhi+lH5frsHNq772xLo9rU0uJRQ0ebi3
         3w56DiGhe4EdCPahcmsF3c9JTDGkepUtjqCViyswiVcC0HxhoXjc78KopLoqO0ENMWUL
         AWvZTUtqNEkFjvosSqLLdX6t7RDLdskTguOS4heP41b4rfNadXsjMO1ltzxQBUjRiV9x
         3lNj2/XsHUqF5UiCjHgOaLMMf59YVbkgLlt7NZqFdjvl3iv8Wi3VgT4dH65UXvzeg9f7
         8obg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gm6zrt3+jyOk79FjVLjqIif+2ZGmPF1/TjoosYPa/aY=;
        b=KmLv+NFBy2XtCQYSYUWWa6H6O1FMffSyLhgw/wBT38vIwil3zjTJop+bOfMKGQygod
         EPw/3zm/ZZeJrrEgiUj4VR/1x6rZUn479HkKAgJBPyAiryZE+NjQpZ2aNQJ1vZ4deTQq
         1CrZ2yKTj4niJInHzFY4yQhzxmdp+8RjJx/RVwRrPyecxEyURJvP7ed2Jb6WE8Madw/0
         uh7j0cliJiSdQcfLLWxgl3L05HcXhOqR0YQbl2ohgLGd6WJKwUXWrWK+3068GJtKWvw7
         941OFF6+SyQXGnnn5I/N4Qxlk50TVEo/YCKHf17b2COw133LBEoGu2yFp87TbaUllNLH
         ViwA==
X-Gm-Message-State: APjAAAXeYCtFJIHF8azKsFuZ0JQgDn/yWK7MeSRFVTeZl4dvhAelfjCO
        MMhx9duXhNIxkBdEEmNpEdiytMw69dA=
X-Google-Smtp-Source: APXvYqzN+CqWZh0iUp59ZmRZ1rXHigzZ346x42zx/+UeRjEIKpJjL/46ZcKoAoNJbjiPleDHtpFqWg==
X-Received: by 2002:a5d:9d90:: with SMTP id 16mr1935330ion.132.1560871241374;
        Tue, 18 Jun 2019 08:20:41 -0700 (PDT)
Received: from [172.22.22.26] (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.googlemail.com with ESMTPSA id h18sm12796116iob.80.2019.06.18.08.20.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 08:20:40 -0700 (PDT)
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
To:     Johannes Berg <johannes@sipsolutions.net>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <dcbw@redhat.com>
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        abhishek.esse@gmail.com, Ben Chan <benchan@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        cpratapa@codeaurora.org, David Miller <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Eric Caruso <ejcaruso@google.com>, evgreen@chromium.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        syadagir@codeaurora.org
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
 <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
 <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
 <fc0d08912bc10ad089eb74034726308375279130.camel@redhat.com>
 <36bca57c999f611353fd9741c55bb2a7@codeaurora.org>
 <153fafb91267147cf22e2bf102dd822933ec823a.camel@redhat.com>
 <CAK8P3a2Y+tcL1-V57dtypWHndNT3eDJdcKj29c_v+k8o1HHQig@mail.gmail.com>
 <f4249aa5f5acdd90275eda35aa16f3cfb29d29be.camel@redhat.com>
 <CAK8P3a2nzZKtshYfomOOSYkqx5HdU15Wr9b+3va0B1euNhFOAg@mail.gmail.com>
 <dbb32f185d2c3a654083ee0a7188379e1f88d899.camel@sipsolutions.net>
 <e6ba8a9063e63506c0b88a70418d74ca4efe85cd.camel@sipsolutions.net>
From:   Alex Elder <elder@linaro.org>
Message-ID: <850eed1d-0fec-c396-6e91-b5f1f8440ded@linaro.org>
Date:   Tue, 18 Jun 2019 10:20:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <e6ba8a9063e63506c0b88a70418d74ca4efe85cd.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/17/19 7:25 AM, Johannes Berg wrote:
> On Mon, 2019-06-17 at 13:42 +0200, Johannes Berg wrote:
> 
>> But anyway, as I alluded to above, I had something like this in mind:
> 
> I forgot to state this here, but this was *heavily* influenced by
> discussions with Dan - many thanks to him.

Thanks for getting even more concrete with this.  Code is the
most concise way of describing things, once the general ideas
seem to be coming together.

I'm not going to comment on the specific code bits, but I have
some more general questions and comments on the design.  Some
of these are simply due to my lack of knowledge of how WWAN/modem
interactions normally work.

First, a few terms (correct or improve as you like):
- WWAN device is a hardware device (like IPA) that presents a
  connection between AP and modem, and presents an interface
  that allows the use of that connection to be managed.
- WWAN netdevice represents a Linux network interface, with its
  operations and queues, etc., but implements a standardized
  set of WWAN-specific operations.  It represents a logical
' channel whose data is multiplexed over the WWAN device.
- WWAN channel is a user space abstraction that corresponds
  with a WWAN netdevice (but I'm not clear on all the ways
  they differ or interact).
- The WWAN core is kernel code that presents abstractions
  for WWAN devices and netdevices, so they can be managed
  in a generic way.  It is for configuration and communication
  and is not at all involved in the data path.

You're saying that the WWAN driver space calls wwan_add()
to register itself as a new WWAN device.

You're also saying that a WWAN device "attaches" a WWAN
netdevice, which is basically notifying the WWAN core
that the new netdev/channel is available for use.
- I trust that a "tentative" attachement is necessary.  But
  I'm not sure what makes it transition into becoming a
  "real" one, or how that event gets communicated.

Some questions:
- What causes a new channel to be created?  Is it initiated
  by the WWAN device driver?  Does the modem request that
  it get created?  User space?  Both?
- What causes a created channel to be removed?
- You distinguish between attaching a netdevice and (what
  I'll call) activating it.  What causes activation?
- How are the attributes of a WWAN device or channel set,
  or communicated?
- Are there any attributes that are only optionally supported,
  and if so, how are the supported ones communicated?
- Which WWAN channel attributes must be set *before* the
  channel is activated, and can't be changed?  Are there any
  that can be changed dynamically?

And while the whole point of this is to make things generic,
it might be nice to have a way to implement a new feature
before it can be "standardized".

Thanks.

					-Alex

PS  I don't want to exclude anybody but we could probably start
    a different mail chain on this topic...

>> driver_dev
>>   struct device *dev (USB, PCI, ...)
>>   net_device NA
>>   net_device NB
>>   tty TA
>>  ...
>>

. . .
