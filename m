Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 244C94A335
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 16:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729614AbfFROBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 10:01:00 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:43883 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729336AbfFROBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 10:01:00 -0400
Received: by mail-io1-f67.google.com with SMTP id k20so29959952ios.10
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 07:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T08//zG45sCSOuqyl+ULwBSrl0f1cak1EG68a6PEKJ8=;
        b=DCfVfJ+4RhCLmqXG1I+bfNn3kR7BJa6paHvS14hZvfHAQIpw8sApKrLm4OOwt55yRX
         pUar7QENZ5rVi3vx5xBpoFxAeP7AAkq93rBdji27/dyohyKc32Ip9YAXESCu0LZLO+U+
         QNLBbnsHtVHcCKHo465UicQL3IhBbM1bwr713lG8frsOCsMS9C1QyL5GZ16MgqszmYrZ
         Ag/3p1Kqo7TzdO6dBp14GtnIgZA0QhDBM7NfUSf1RZGe1gAl4i0TtLlhUXiXblQHoR5o
         dlI9cWo5/AWnl4H4pUUbTDN3/cZY2D9M3uCuUQZGsKY2bqlmwj2g8YJMDzWpESxnTyeN
         yrGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T08//zG45sCSOuqyl+ULwBSrl0f1cak1EG68a6PEKJ8=;
        b=GFBs3GyvtO/ML1r3j6PwzqPHIZRCHDPZrzLpnqWOnKv/+EWn3QGayrkh1+MGJtOSfx
         ibPy/V2lBp5ZBEVxKl/1Sz8APLJDCAmn3joI8GlAWlKvf5Z5+fLH8Q1JEaaswKFGC5Bf
         GG5fU0zD1KC90oHQLhThHBbkyYw1juSE61ooiC1/M4ZOuMa6r6aueVBPp3Udo7yxDNem
         Wyv+kuyPA+3ukt3KxkJopsorl9Lqn27aNRrV5a/rYIsdbyYSKnT32VE5XlyMfjQ2bXo+
         w4xx2ylkbWIr52GZw0axfwxHpnKIsyQNpotLk3v3BULEIuD0kHoy4YhRJb3/BqV2aTrJ
         MCnQ==
X-Gm-Message-State: APjAAAUM5zodqkUWDG5g0nJh8xe+tpBHAiyUHYTOHlW5xfOCcFRq3sfw
        a8nxIUO0P/okj5c+C45lbXF4iQ==
X-Google-Smtp-Source: APXvYqyeM5LvRvVxTEQ8tVA4GnMVkdsL650S6irQ2mz0DzREgjKLrfiwAVj0tKHMvYligiNiFkETlQ==
X-Received: by 2002:a02:9143:: with SMTP id b3mr2339682jag.12.1560866459394;
        Tue, 18 Jun 2019 07:00:59 -0700 (PDT)
Received: from [172.22.22.26] (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.googlemail.com with ESMTPSA id x22sm14207341iob.84.2019.06.18.07.00.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 07:00:58 -0700 (PDT)
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
To:     Johannes Berg <johannes@sipsolutions.net>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     abhishek.esse@gmail.com, Ben Chan <benchan@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        cpratapa@codeaurora.org, David Miller <davem@davemloft.net>,
        Dan Williams <dcbw@redhat.com>,
        DTML <devicetree@vger.kernel.org>,
        Eric Caruso <ejcaruso@google.com>, evgreen@chromium.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        syadagir@codeaurora.org
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
 <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
 <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
 <583907409fad854bd3c18be688ec2724ad7a60e9.camel@sipsolutions.net>
From:   Alex Elder <elder@linaro.org>
Message-ID: <31c2c94c-c6d3-595b-c138-faa54d0bfc00@linaro.org>
Date:   Tue, 18 Jun 2019 09:00:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <583907409fad854bd3c18be688ec2724ad7a60e9.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/17/19 7:14 AM, Johannes Berg wrote:
> On Tue, 2019-06-11 at 13:56 +0200, Arnd Bergmann wrote:
> 
> [...]
> 
> Looking at the flags again,

I sort of talked about this in my message a little earlier, but I
now see I was partially mistaken.  I thought these flags were
used in messages but they're real device ("port") configuration
flags.

>> #define RMNET_FLAGS_INGRESS_DEAGGREGATION         (1U << 0)
> 
> This one I'm not sure I understand - seems weird to have such a
> fundamental thing as a *configuration* on the channel.

Let me use the term "connection" to refer to the single pathway
that carries data between the AP and modem.  And "channel" to
refer to one of several multiplexed data streams carried over
that connection.  (If there's better terminology, please say
so; I just want to be clear in what I'm talking about.)

Deaggregation is a connection property, not a channel property.
And it looks like that's exactly how it's used in the rmnet
driver.  The hardware is capable of aggregating QMAP packets
arriving on a connection into a single buffer, so this provides
a way of requesting it do that.

>> #define RMNET_FLAGS_INGRESS_MAP_COMMANDS          (1U << 1)
> 
> Similar here? If you have flow control you probably want to use it?

I agree with that, though perhaps there are cases where it
is pointless, or can't be supported, so one might want to
simply *not* implement/advertise the feature.  I don't know.

>> #define RMNET_FLAGS_INGRESS_MAP_CKSUMV4           (1U << 2)
> 
> This again looks like a hardware specific feature (ipv4 checksum)? Not
> sure why this is set by userspace.
> 
>> #define RMNET_FLAGS_EGRESS_MAP_CKSUMV4            (1U << 3)
> 
> This could be set with ethtool instead, I suppose.

As I said in my earlier message, I think I concur about this.
I think the IPA driver could easily hide the checksum offload
capability, and if it can truly be controlled as needed
using existing methods there's no need to encumber the
WWAN framework with it.

					-Alex


> johannes
> 

