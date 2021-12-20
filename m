Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B9247B3DD
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 20:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbhLTTmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 14:42:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbhLTTmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 14:42:01 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E51C061574
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 11:42:01 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id m12so8502219ild.0
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 11:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dS0CqgnJ6a7PTI6ekIx5KsY/4VUMxVzGFajo8yFCnKo=;
        b=l2Ps2y+ynpItPr8ACCEUfmFFniLt3WfQasaKeYZK3C+F/3PaFVx6BoHxGj1W2TEGMe
         uxRMV8v0GGuZlHhdCMc4bQpbBeB+Qo9dJQx3pR5bXVFGmZe37zbS7vQ7GjYIjOPPfTFh
         /Kg1bBOhjaVLJeKEVOOWd3S35cPec5Q0Eiol42ABJjyR9cGtILqgEDyesKzZ/skwrvVD
         ZW9odsPIXfqKDFEX0xvfJMm3aPL1rFf4KO0A8ZLg3tNnFYmTQLvnzF6qa6xfOTMsNCyk
         i7z09Erikwkn+ym5JhSOifc9AXI5wEDDCTd5S3UvmL4oNsFwWMUKnU49PQXRqjBClzAa
         e1eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dS0CqgnJ6a7PTI6ekIx5KsY/4VUMxVzGFajo8yFCnKo=;
        b=jkuGuaDIddrmUZhto8wGSsQ34Ls62YXSnDuQT3GQFRSduBm2gpfmfZ0A4GKzuNJ8ye
         61qsT8Kuts27Lc0SGQF3YPiV1F7K/Q8nN5q4sNC2yLneSCL0U43MFzGHDx7ZbZ0P2beb
         jeKaTT7zyBoaXusqE6UWxjLtHd8ORLfbS43U6e4DrPSp65SnQ/u+T/yxzBBAWG4BI74O
         nW9buiixjib1aj9wmfHcgQxL/qJwy5EhJApMhmtgouojly6YVYKlrA0EGj1GCRmQXKC/
         +p6yAc3ac9mvyBbKAxwSSe67vPNkEIPkky38MPKRguo4kr5Odgyd0RKKJvbdu1LBKYIF
         RveA==
X-Gm-Message-State: AOAM532rqIg3V4VCsSptdc4YR1MQMef+xCByYSPFOVjDqpqnqyxmvtjo
        VskCr4pxXlxChb5p0kth249I2Q==
X-Google-Smtp-Source: ABdhPJzfpczAMLdMv4wYjhOJQeVr6hhAV56h6LUJSDFGv3vnNUnFEkeaRBVJWSkIHYnj1rqOwzIxGQ==
X-Received: by 2002:a05:6e02:545:: with SMTP id i5mr8740333ils.128.1640029320335;
        Mon, 20 Dec 2021 11:42:00 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id g7sm9477208iln.67.2021.12.20.11.41.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 11:41:59 -0800 (PST)
Message-ID: <041b479a-0812-f293-94ef-c6a11ba68a16@linaro.org>
Date:   Mon, 20 Dec 2021 13:41:59 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: Port mirroring (RFC)
Content-Language: en-US
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Cc:     "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>
References: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
 <7cf5a995-8e59-93cd-ccab-243a4c24cedc@gmail.com>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <7cf5a995-8e59-93cd-ccab-243a4c24cedc@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/15/21 11:48 AM, Florian Fainelli wrote:
> On 12/14/21 6:47 AM, Alex Elder wrote:
>> I am implementing what amounts to port mirroring functionality
>> for the IPA driver.
>>
>> The IPA hardware isn't exactly a network switch (it's sort of
>> more than that), but it has the ability to supply replicas of
>> packets transferred within it to a special (read only) interface.
>>
>> My plan is to implement this using a new "ipa_mirror" network
>> device, so it could be used with a raw socket to capture the
>> arriving packets.  There currently exists one other netdev,
>> which represents access through a modem to a WWAN network.
>>
>> I would like some advice on how to proceed with this.  I want
>> the result to match "best practice" upstream, and would like
>> this to be as well integrated possible with existing network
>> tools.
>>
>> A few details about the stream of packets that arrive on
>> this hardware interface:
>> - Packet data is truncated if it's larger than a certain size
>> - Each packet is preceded by a fixed-size header describing it
>> - Packets (and their headers) are aggregated into a buffer; i.e.
>>    a single receive might carry a dozen (truncated) packets
> 
> Andrew has already responded, but there are currently sort of two ways
> that mirroring is implemented in upstream supported drivers:
> 
> - for "classic" Ethernet switches mirroring is typically from one port,
> or a set of ports, to another with a choice in whether you want to
> capture ingress, egress, or both towards that port. Because each port is
> a netdev already you just run tcpdump/pcap the way you normally do on
> your Ethernet NIC and get the captured packets. Configuration is via
> offloading the tc_mired action.

I read about switch port mirroring, and it sounded along the
lines of what I'm trying to implement, which is why I suggested
this might be a case of "port mirroring."  That said, it is
not configurable in the same way.  Here, we really have a
dedicated port through which replicated packets arrive.  It is
not possible to just use one of the existing switch ports.  So
it isn't really the same.

> - mlxsw implements devlink traps which is not exaclty designed for
> capturing mirrored packets but more like management events such as why
> the packet was trapped etc. You could however imagine using devlink
> traps for that purpose of capturing mirrored packets in the absence of a
> suitable network device

Just your description tells me this approach is probably not right.
But I'll look into it some more.

> Not sure if this helps, but that is the situation.

Right now I find it useful to hear about anything, even things
I might not ultimately use.

>> Here are a few specific questions, but I would love to get
>> *any* feedback about what I'm doing.
>> - Is representing this as a separate netdev a reasonable
>>    thing to do?
> 
> I would think so, given this allows standard tools to work.

It's reassuring knowing there isn't disagreement.

>> - Is there anything wrong with making a netdev read-only?
>>    (Any packets supplied for transmit would be dropped)
> 
> This looks reasonable.
> 
>> - Are there things I should do so it's clear this interface
>>    does not carry IP traffic (or even UDP, etc.)?
> 
> There were various patches in the past to prevent a network device from
> getting any IP stack to be configured:
> 
> https://yhbt.net/lore/all/20150825232021.GA8482@Alexeis-MacBook-Pro-2.local/t/
> 
> I forgot whether as a driver you can just refuse to have an IP address
> assigned to your network device, AFAIR it requires changes to the
> network stack as proposed in the patch set.

Thanks, I'll follow up with that as well.

>> - Should the driver de-aggregate the received packets, i.e.
>>    separating each into a separate SKB for reading?
> 
> If this is truly a mirroring device, you would expect it to "render" the
> mirrored packets exactly the way they are, maybe add an ethtool private
> option to de-aggregate packets if this helps debugging?

I have some details to work out before I can implement such a
thing, but this would be helpful.

Thanks a lot for your input.

					-Alex

>> I might have *many* more questions, but I'd just like to make
>> sure I'm on the right track, and would like both specific and
>> general suggestions about how to do this the right way.
>>
>> Thanks.
>>                      -Alex
> 
> 

