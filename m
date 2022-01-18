Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28622492C85
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 18:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236112AbiARRhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 12:37:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236042AbiARRhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 12:37:07 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A51C061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 09:37:07 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id i82so26491316ioa.8
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 09:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hJJV0+Ag/rgPNWIjWXREbGJm8rvuY4MJHpgwrf2oFzk=;
        b=Mr+cgZDtQ7dfCNZh0/DSMyWEqTHlKJOt3mEeHTUAIWEaSft4omQZAVAZYcmPC22Min
         9u32VVG4kJLVwaeUCsOqFPFdgXkdWllEundNDfNmM0dKPm/nN/2WxeQ8RH2wQh3QG54f
         YqITvrUk/6xidKKnzggYOzHSy46pxswl1EwLhqTIIvq5BGCt9VkRyNIWEEnRkJw2ZuYQ
         k+kYditxWeajwADRB0ZQ3YlmxnAKbvNTOFXOYGZux6rRFOWZ+zsKhCv6U+W37cw88OOo
         FU2zL3KscEZlC1XrpFo+8hNf3fPLPJwnsfVFmG2mx0s3ySkyUk8C4hX+nYfq/6TkUnhG
         4vJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hJJV0+Ag/rgPNWIjWXREbGJm8rvuY4MJHpgwrf2oFzk=;
        b=Mdi0cKcXVqu+/c3y4CQF0wJ0Z9jpopvY7wOQlk3yCxoV/2X0j15l7ACs4/jd0HMwPe
         zPQQ4as0sGWboWBnAuueZTDd2jYUMbA0zZcMn9ozxi04HzxpCPuWAcOGMVmMufgsRkBb
         ucCGvO7XUCxSUbH3eg2nWhwGtXeKM+Z2X0beQTkBvFnauzSNy8G/fgG9MvpeCl8pRgbp
         uTtm865bOOGwmNPl0vTbmYCzSUzGT4uWzLFWk0NHlHEt0ygU/2USjQPp6FJvaNfSUFe+
         VWMZMOC3OcUROCmwLrW+iEDheYZVKEP4HvjzF64W6a4FzmdT3FWX6zxd+BBUL/4DLG+l
         nyEw==
X-Gm-Message-State: AOAM530DJld/s4qVyDdWy4eSf7184/d2143yv4PT45rgBdR0NLvveM/n
        48qYPXXTeQNCZ2LmTihWpQzBLA==
X-Google-Smtp-Source: ABdhPJzlrgIZs2pyp8ssldXBDAgmcotkR8tq0zEdr4OtUfWzvlckdXrzc/jZC+det5ssh38dBlR4Yg==
X-Received: by 2002:a05:6638:389b:: with SMTP id b27mr574904jav.106.1642527426658;
        Tue, 18 Jan 2022 09:37:06 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id h5sm11907305ili.12.2022.01.18.09.37.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 09:37:06 -0800 (PST)
Message-ID: <c9db7b36-3855-1ac1-41b6-f7e9b91e2074@linaro.org>
Date:   Tue, 18 Jan 2022 11:37:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: Port mirroring, v2 (RFC)
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Network Development <netdev@vger.kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
 <e666e0cb-5b65-1fe9-61ae-a3a3cea54ea0@linaro.org>
 <9da2f1f6-fc7c-e131-400d-97ac3b8cdadc@linaro.org> <YeLk3STfx2DO4+FO@lunn.ch>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <YeLk3STfx2DO4+FO@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/15/22 9:14 AM, Andrew Lunn wrote:
>> Below I will describe two possible implementations I'm considering.
>> I would like to know which approach makes the most sense (or if
>> neither does, what alternative would be better).
> 
> Hi Alex
> 
> Another corner of the kernel you could look for inspiration is usbmon.
> 
> https://www.kernel.org/doc/html/latest/usb/usbmon.html

Yes this looks very similar.  However IPA only carries
network traffic, unlike USB.  The "peripherals" (packet
sources) are all generating IP packets.

> This is similar to your misc char device, but it is actually
> implemented as a pseudo filesystem. It is intended for libpcap based
> applications and i've used it with tcpdump and wireshark. So exactly
> your use cases.

I suppose I could represent each possible source of packets
with a file system entry.  But that would require the IPA
driver to parse the received data and buffer each packet
separately (with others from its source).  Kind of messy.

I feel like it would be much better to just have one interface,
and have the filtering software exclude things that aren't
interesting.

> Because it is not a network device, the extra header does not cause
> problems, and there is no confusion about what the 'monitoring' netdevs
> are good for.

Yes, agreed.

> Since you are talking 5G and WiFi, you have a lot of packets
> here. Being able to use BPF with libpcap is probably useful to allow
> filtering of what packets are passed to user space. I've never looked
> at how the BPF core is attached to a netdev. But i suspect your extra

I haven't either.  But this too is something I've generally
thought I'd have to investigate.

> header could be an issue. So you are going to need some custom code to
> give it an offset into the packet to the Ethernet header?

Yes I think so.  No Ethernet header though.

> Humm, actually, you called the IPA the IP accelerator. Are these L2
> frames or L3 packets? Do you see 3 or even 4 MAC addresses in an
> 802.11 header? Two MAC addresses in an 802.3 header? etc.

L3 packets.  Except they are truncated if they're long, and they
have a metadata header prepended.

No MAC addresses, no 802.11 header.  Generally speaking, these
packets will start with 4 or 6 as the upper nibble of the first
byte (IP packet).  And of course, this follows the fixed-length
32-byte "status" header.

Here's are IPv4 and IPv6 ICMP examples.

00: 45 00 00 54 ac 5a 40 00 40 01 be 3c c0 00 00 02

10: 08 08 08 08 08 00 10 cf 11 c0 00 03 4f f4 e6 61

20: ac 14 08 00 08 09 0a 0b 0c 0d 0e 0f 10 11 12 13

30: 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23

40: 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f 30 31 32 33

50: 34 35 36 37


00: 66 00 00 00 00 40 3a 70 26 07 77 00 00 00 00 2d

10: 00 00 00 01 08 08 08 08 26 07 fb 90 99 41 19 56

20: 00 c0 00 00 02 00 00 00 81 00 13 1f 11 c0 00 03

30: 4f f4 e6 61 ac 14 08 00 08 09 0a 0b 0c 0d 0e 0f

40: 10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f

50: 20 21 22 23 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f

60: 30 31 32 33 34 35 36 37



I'm basically ready to go on this, either way (using a
misc device, or--preferably--using a netdev).

I'm just trying to avoid getting that fully working,
then learning when I submit patches that someone thinks
it's the wrong way to go about it.

If a netdev is acceptable, my remaining issues are:
- Whether/how to avoid having the device be treated
   as if it needed support from the network stack
   (i.e., as a "real" network interface, serving to
   send and receive packets).
- Similar, whether there are special configuration
   options that should be used, given the device's
   purpose.
- What to call this functionality.  I'll avoid "mirror"
   and will try to come up with something reasonable,
   but suggestions are welcome.

Thanks.

					-Alex

>         Andrew
> 

