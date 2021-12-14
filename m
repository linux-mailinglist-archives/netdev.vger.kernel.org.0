Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611DE474E3C
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 23:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbhLNWz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 17:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234975AbhLNWz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 17:55:29 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ECB7C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 14:55:29 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id 14so26883683ioe.2
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 14:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=EDHcUN/a8YzochDyOEdr4oiQk6lxDkZ6bVg77BIbjig=;
        b=OUFf3YKlYpoYVc8C13f3NOzaAGShl/26r8BXG8cQdKAb3Jc6j7KMAiFiXBXR3oEOaj
         8PfDmDYR7BpG1EIZCO8YnTdSnkdXyfWbRnuyp43Qur/bkQT/9jpBs1Gw1ONhIzWGxAcx
         nMzWEIZI1c5ZcymA4BTIWHkHgRNmkMuhKjtNdCh87VDukAeOpYEnhyacuFgyQA+unfF6
         nIp6reX40kk2MIi6CGMiAF14Bb6YkqiXoTQjjC4SZ79pq/fvU04jngzIDpKhzgEriXWk
         jbQmKD2iNpe672x9VEqFbXWtCTfUP7jx5KGRuqqD6J8uKSz6tQRO/iLuyh/6sGu/LbFo
         wcTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EDHcUN/a8YzochDyOEdr4oiQk6lxDkZ6bVg77BIbjig=;
        b=Lb9NU7ibbiF5QzHglDu75NJibDPH+unqWGldMLFoBT4CXtpg8aEVAY9lqjREVtNib2
         R/skQRj1kPbT8x+Wr7Um/iTl5bPISEz4+N7ob1C4CXtAnuSCykGWDCd5Xf98Ly8fipD3
         SK5GvAavozIXoIdD/OxXjmwe45OlNkw6tVTS0hIImdSZWLVyP5S2NiQ0Bwgr0AHj31Hq
         w6PlufcgSt2vBOF1zgDHEsV4fo3LZL1WqgzAEZtxfIbR4yNfuV6BkcvaVwM/JeOeDAXO
         O/00y7UUUM4xr+HXDVk/Q8SrKUU6fKqsjRRwklT93Y+GDblRexsuPDEnvQTuwLUm0QFA
         AkzA==
X-Gm-Message-State: AOAM530M4esxeflsoLJdG5luV4Cia1xQdw0TUMSADOKh9pafaU7rVjEZ
        WrYlP/xP2A3zUhgenTnV6RZ/lU7yna0jpP2m
X-Google-Smtp-Source: ABdhPJzOSaPcUiMpSvX4VOHhwmfFdg14iJ86v17slG9YwnQnQm/o5s6ZgRSTNul03EVeN2dcsKWkRg==
X-Received: by 2002:a02:cc03:: with SMTP id n3mr4689027jap.778.1639522528268;
        Tue, 14 Dec 2021 14:55:28 -0800 (PST)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id h14sm113122ild.16.2021.12.14.14.55.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 14:55:27 -0800 (PST)
Message-ID: <3bd97657-7a33-71ce-b33a-e4eb02ee7e20@linaro.org>
Date:   Tue, 14 Dec 2021 16:55:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: Port mirroring (RFC)
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Network Development <netdev@vger.kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>
References: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
 <YbjiCNRffWYEcWDt@lunn.ch>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <YbjiCNRffWYEcWDt@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/14/21 12:27 PM, Andrew Lunn wrote:
> On Tue, Dec 14, 2021 at 08:47:12AM -0600, Alex Elder wrote:
>> I am implementing what amounts to port mirroring functionality
>> for the IPA driver.
>>
>> The IPA hardware isn't exactly a network switch (it's sort of
>> more than that), but it has the ability to supply replicas of
>> packets transferred within it to a special (read only) interface.
> 
> I think you need to explain "within it" in a bit more detail. Where
> are these packets coming from/going to?

Sorry, I didn't want to dive into too much detail up front.

IPA is a device that sits between the main CPU and a modem,
carrying WWAN network data between them.

In addition, there is a small number of other entities that
could be reachable through the IPA hardware, such as a WiFi
device providing access to a WLAN.

Packets can travel "within IPA" between any of these
"connected entities."  So far only the path between the
AP and the modem is supported upstream, but I'm working
on enabling more capability.

Technically, the replicated packets aren't visible on
any one port; the only way to see that traffic is in
using this special port.  To me this seemed like port
mirroring, which is why I suggested that.  I'm want to
use the proper model though, so I appreciate your
response.

>> My plan is to implement this using a new "ipa_mirror" network
>> device, so it could be used with a raw socket to capture the
>> arriving packets.  There currently exists one other netdev,
>> which represents access through a modem to a WWAN network.
>>
>> I would like some advice on how to proceed with this.  I want
>> the result to match "best practice" upstream, and would like
>> this to be as well integrated possible with existing network
>> tools.
>>
>> A few details about the stream of packets that arrive on
>> this hardware interface:
>> - Packet data is truncated if it's larger than a certain size
>> - Each packet is preceded by a fixed-size header describing it
>> - Packets (and their headers) are aggregated into a buffer; i.e.
>>    a single receive might carry a dozen (truncated) packets
> 
> So this sounds something more like what you would attach pcap/tcpdump
> to.  I'm not sure port mirroring is the correct model here. Maybe take
> a look at wifi adaptors and their monitor mode? See if that fits
> better?

Yes, pcap and tcpdump are exactly the model I envisioned.  I had
heard of monitoring but hadn't looked at it closely, so I will.

Thanks a lot for the suggestion.

					-Alex
>   
> 	Andrew
> 

