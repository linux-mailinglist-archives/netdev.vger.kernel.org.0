Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F45F47B440
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 21:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhLTURO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 15:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbhLTURM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 15:17:12 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF85C061574
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 12:17:12 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id b187so14853531iof.11
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 12:17:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LOHDvj0HSieLXhrjN/qhyrNmfRLLm1PLohtGBMJsWhU=;
        b=IVBJgH/PfR6LFs+Oxbyri+VF/K3znbTQY1PXXx3sRp3xTIG6Md8tCzJahflv3XdJ25
         DvZRPhh7cL2zQTSB5oQulAFdKsunwzrarORcFf0VfIhX4t03RuiM75DrQyjtD4qOzxdj
         RPVTijO67VUPRyJ/vHlM5zjMWJxQJAqrM54nz66mJHWS9p91RkUNVDv1X4acTM8kUjwZ
         cC6uIkNizeehFuCHytdt1Imgv0nwEYiSnnMrvRwb1ZQTbG7JV6Hns4FnH1hv1yydGGIx
         eNdv8Aplo84UcbSYZZRD8FfeUl446rRgVGUq35lLizHhkq6scRU5rZIr9JdncYq6UZkP
         QkKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LOHDvj0HSieLXhrjN/qhyrNmfRLLm1PLohtGBMJsWhU=;
        b=Iwsp+6BjHIdJPsTWPrswhu8HBzf3i/3eSeH307RtuosGhSDROuf8EM2bbksFUeKNak
         oHnEjziND2+kEq7kONeLLe+VfIMKvOodE+fw5X7NXMe1ADiScYpVjN8buv8BZlNtNgYU
         Z7xlb0Ni2RNnOIOCHXVgp5WcrrpTm2+zFSuGceKuwf20xDRD/tXcuLla7LTLn1s0CDSY
         /Jraf4wwie9JeUNAq7gF4fDyVmmN/Zxf2XNp2w8HDZbXPy786TblbMA3GWsjHn3hmXyP
         dHAglDpsCCs0iXi3NQWlukgirhsZlCIWGgiVwmsiBlamPpv77d4M3yQyO7SV1K5+5qO9
         Ra+w==
X-Gm-Message-State: AOAM5326TQGZMrKKwcXVqRCUod3w9qpgn6f73wR7rA0bnEg1uoRv1Yxj
        zni0G4c4FouPsrIWOmZz+t/k8Q==
X-Google-Smtp-Source: ABdhPJyR5VB6AwheBNKjueW5Yt53RYgH2M2JarJPy14hvTZx6F6lmjR5U28dlLPKV9Oe4bRcHag2SQ==
X-Received: by 2002:a02:6658:: with SMTP id l24mr5349731jaf.178.1640031431408;
        Mon, 20 Dec 2021 12:17:11 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id z17sm9611029ior.22.2021.12.20.12.17.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 12:17:10 -0800 (PST)
Message-ID: <89462d16-b7f3-86d9-1c35-b9b624fd7112@linaro.org>
Date:   Mon, 20 Dec 2021 14:17:10 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: Port mirroring (RFC)
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>
References: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
 <20211215153310.27367243@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <20211215153310.27367243@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/15/21 5:33 PM, Jakub Kicinski wrote:
> On Tue, 14 Dec 2021 08:47:12 -0600 Alex Elder wrote:
>> I am implementing what amounts to port mirroring functionality
>> for the IPA driver.
>>
>> The IPA hardware isn't exactly a network switch (it's sort of
>> more than that), but it has the ability to supply replicas of
>> packets transferred within it to a special (read only) interface.
>>
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
>>     a single receive might carry a dozen (truncated) packets
>>
>> Here are a few specific questions, but I would love to get
>> *any* feedback about what I'm doing.
>> - Is representing this as a separate netdev a reasonable
>>     thing to do?
>> - Is there anything wrong with making a netdev read-only?
>>     (Any packets supplied for transmit would be dropped)
>> - Are there things I should do so it's clear this interface
>>     does not carry IP traffic (or even UDP, etc.)?
>> - Should the driver de-aggregate the received packets, i.e.
>>     separating each into a separate SKB for reading?
>>
>> I might have *many* more questions, but I'd just like to make
>> sure I'm on the right track, and would like both specific and
>> general suggestions about how to do this the right way.
> 
> Maybe the first question to ask is - why do you need this?

That is a great question.

> Or perhaps - how is it used? There's a significant difference
> between an interface for users and a debug interface.

This would be a debug interface.  That is, it is not intended
as a normal way of delivering packets to Linux, it's meant as
an aid in understanding what's going on inside the hardware
(exposing the packets that are passing through IPA).

> Do you aim to give users control over the forwarding which happens
> on the application processor at some point? If so Andrew and Florian
> give great suggestions but starting from debugging of the forwarding
> feels a little backward.

This actually goes back to what IPA can do, which is allow
certain IP functionality to be offloaded.  Currently, IPA
simply carries packets between the AP and a Qualcomm modem.
It provides the path needed for Linux to access the modem's
WWAN network.

However it is also possible to have the IPA hardware carry
IP packets between the modem and (for example) a USB device,
without the AP being directly involved in the transfer.
But even though Linux would not handle these packets, one
might still (for debugging purposes) like to see (on the
AP) what the packets moved by IPA look like.

That omits many details, some of which I don't think I could
even explain well right now.

But to answer your question, this would *not* be an interface
used by "normal users."  It might be useful to filter these
with networking tools for the benefit of analysis, but there
would be no forwarding of these packets anywhere else.  It
really is meant to be a monitoring interface, to be used for
development and troubleshooting.

					-Alex
