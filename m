Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C93C351CE5
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 23:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbfFXVQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 17:16:05 -0400
Received: from mail-io1-f53.google.com ([209.85.166.53]:38193 "EHLO
        mail-io1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbfFXVQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 17:16:05 -0400
Received: by mail-io1-f53.google.com with SMTP id j6so4183947ioa.5
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 14:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h8aI2OpY2BAfzDNvFZ3TNgMEvHw9WrhdG1WTVU1HZ6o=;
        b=WmmeTTYCDtwI4cez2hHskkUb/f2zbtWIh47Df+A+CnCvmcBAuRgvczUyHTEzoPuaOy
         nz0iE6NjoFm/iSfcWNaG/Rnc4zBH+8Ub2s3s1W00ct5bJSD25gtV8X7Y1nMnaA+f2mgH
         SK2FkRdOCuVN8B3n6loqxPcgQWPa2Z6rZGAR/gdHVascBNuyUBqnoAk7iJTUVZOmN9O5
         qfWHW4qlLOKBI3JPmFNiAMJCIp47VsfCY7mgmyLWnw9OAj7MjtaTlDsqTGL9mFXpNs+S
         cDExxp6hBELeQ9dmnkBmRJmLYoXcwt6EdCIB6LlhUTSXJpkAs5TJYKzeNoU4Y2nvLhoh
         p5dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h8aI2OpY2BAfzDNvFZ3TNgMEvHw9WrhdG1WTVU1HZ6o=;
        b=XhTWeL3FismFtSmqQFU/ZJp3fCuXVbMkdeCbkPX7e4NgOSkkK+cR/vFSNumEZX0iz/
         lHu3IzaXfFwhSDO7oqsTeUlLYevuS218sfHuN535RqqxHrGOM2H2cLKB7ZxeNKlP9XaA
         ueGza2bx2vnw7FEkwvy0KWmFw8eacJ0h/yI0xhph74HIz6SM4RY4IJwISORjipjcUbp9
         HSZWMwwo+NdWGl+hODGdzd86ES4EeLn0tS5uEZdLLLxA0tmeRCEo4bb2dhSKXepC98mM
         kxnNtYYVbZgnEGAWfsJbr5oFZE5DfDgbe9f+eN4301wTtqQWV9S/Hd+Ma/N/TttS+e8i
         Bs7w==
X-Gm-Message-State: APjAAAXInzuGv0cKM9k3kBlUbiyd7P4wo0UOaSaflTw7kRlKc+C8jnX1
        1d2DbzQkLIdPZMd+L4NY9m1DvQ==
X-Google-Smtp-Source: APXvYqy4nre2bpmlOpNAx5x3/VmpcP2S2sogYaxvXfJ/DXgJGUOK7qTbZPzOuG02VdqeuOf5/6uAEg==
X-Received: by 2002:a6b:b709:: with SMTP id h9mr3662071iof.2.1561410964319;
        Mon, 24 Jun 2019 14:16:04 -0700 (PDT)
Received: from [172.22.22.26] (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.googlemail.com with ESMTPSA id p3sm14613932iog.70.2019.06.24.14.16.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 14:16:03 -0700 (PDT)
Subject: Re: WWAN Controller Framework (was IPA [PATCH v2 00/17])
To:     Dan Williams <dcbw@redhat.com>, davem@davemloft.net, arnd@arndb.de,
        bjorn.andersson@linaro.org, ilias.apalodimas@linaro.org
Cc:     evgreen@chromium.org, benchan@google.com, ejcaruso@google.com,
        cpratapa@codeaurora.org, syadagir@codeaurora.org,
        subashab@codeaurora.org, abhishek.esse@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
References: <20190531035348.7194-1-elder@linaro.org>
 <23ff4cce-1fee-98ab-3608-1fd09c2d97f1@linaro.org>
 <f0fcee096d779837abc46e7badae9105ee8aaecf.camel@redhat.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <ad84c95a-1283-c0f5-0fb7-0909d07ee692@linaro.org>
Date:   Mon, 24 Jun 2019 16:16:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <f0fcee096d779837abc46e7badae9105ee8aaecf.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/19 2:54 PM, Dan Williams wrote:
> On Mon, 2019-06-24 at 11:30 -0500, Alex Elder wrote:
>> OK I want to try to organize a little more concisely some of the
>> discussion on this, because there is a very large amount of volume
>> to date and I think we need to try to narrow the focus back down
>> again.
>>
>> I'm going to use a few terms here.  Some of these I really don't
>> like, but I want to be unambiguous *and* (at least for now) I want
>> to avoid the very overloaded term "device".
>>
>> I have lots more to say, but let's start with a top-level picture,
>> to make sure we're all on the same page.
>>
>>          WWAN Communication
>>          Channel (Physical)
>>                  |     ------------------------
>> ------------     v     |           :+ Control |  \
>>>          |-----------|           :+ Data    |  |
>>>    AP    |           | WWAN unit :+ Voice   |   > Functions
>>>          |===========|           :+ GPS     |  |
>> ------------     ^     |           :+ ...     |  /
>>                  |     -------------------------
>>           Multiplexed WWAN
>>            Communication
>>          Channel (Physical)
>>
>> - The *AP* is the main CPU complex that's running Linux on one or
>>   more CPU cores.
>> - A *WWAN unit* is an entity that shares one or more physical
>>   *WWAN communication channels* with the AP.
> 
> You could just say "WWAN modem" here.

That sounds great to me.

>> - A *WWAN communication channel* is a bidirectional means of
>>   carrying data between the AP and WWAN unit.
>> - A WWAN communication channel carries data using a *WWAN protocol*.
>> - A WWAN unit implements one or more *WWAN functions*, such as
>>   5G data, LTE voice, GPS, and so on.
> 
> Go more generic here. Not just 5G data but any WWAN IP-based data
> (GPRS, EDGE, CDMA, UMTS, EVDO, LTE, 5G, etc). And not just LTE voice
> but any voice data; plenty of devices don't support LTE but still have
> "WWAN logical communication channels"

I really meant *any* sort of function, and was only trying
to give a few examples.  So yes, my meaning was completely
generic, as you suggest.

>> - A WWAN unit shall implement a *WWAN control function*, used to
>>   manage the use of other WWAN functions, as well as the WWAN unit
>>   itself.
>> - The AP communicates with a WWAN function using a WWAN protocol.
>> - A WWAN physical channel can be *multiplexed*, in which case it
>>   carries the data for one or more *WWAN logical channels*.
> 
> It's unclear to me what "physical" means here. USB Interface or
> Endpoint or PCI Function or SMD channel? Or kernel TTY device?

I'm trying to distinguish between (let's say) "hardware" communication
channels (such as what IPA basically provides) and logical ones,
whose data is multiplexed over a "hardware"/"physical" channel.
Maybe "link" would be a better term for what I referred to as a
physical channel, and then have "channels" be multiplexed over a link.
If you have a good suggestion, please offer it.

But I think yes, USB interface, TTY device, etc. are what I mean.
I wanted to capture the fact that there might be more than one of
these (for example a user space QMI link for control, and IPA link
for data?), and that any one of these might also be multiplexed.

Multiplexing is a pretty basic capability of a network link, and I
think the only reason I called it out separately is to be explicit
that it is needs to be supported.

> For example on Qualcomm-based USB dongles a given USB Interface's
> Endpoint represents a QMAP "IP data" channel which itself could be
> multiplexed into separate "IP data" channels.  Or that USB Endpoint(s)
> could be exposed as a TTY which itself can be MUX-ed dynamically using
> GSM 07.10.

Yeah.  In this case the hardware connection between the AP and the
USB dongle would provide a WWAN link (which I think corresponds to
the QMAP "IP data" channel).  And if you wanted to multiplex that
you would use a multiplexing protocol (like QMAP).  And that protocol
would carry one or more logical channels, each using its own WWAN
protocol.  It sounds like GSM 07.10 would be another WWAN multiplexing
protocol.

> To me "physical" usually means the bus type (PCI, USB, SMD, whatever).
> A Linux hardware driver (IPA, qmi_wwan, option, sierra, etc) binds to
> that physical entity using hardware IDs (USB or PCI VID/PID, devicetree
> properties) and exposes some "WWAN logical communication channels".

(Or perhaps exposes the ability to create "WWAN logical channels.")

"Physical" is probably not a good term.  And perhaps focusing
on the transport isn't right--maybe the focus should mainly be on
the WWAN modem entity.  But one of the things we're trying to
address here is that there might be several distinct "physical"
paths through which the AP and modem can communicate, so a driver's
ability to provide such a path should be a sort of first class
abstraction.

I'm really trying to get this discussion to converge a little, to
have a few anchor points to build on.  I hope we're getting there.

> Those logical channels might be multiplexed and another driver (rmnet)
> could handle exposing the de-muxed logical channels that the muxed
> logical channel carries.
> 
>> - A multiplexed WWAN communication channel uses a *WWAN wultiplexing
>>   protocol*, which is used to separate independent data streams
>>   carrying other WWAN protocols.
>> - A WWAN logical channel carries a bidirectional stream of WWAN
>>   protocol data between an entity on the AP and a WWAN function.
> 
> It *usually* is bidirectional. For example some GPS logical
> communication channels just start spitting out NMEA when you give the
> control function a command. The NMEA ports themselves don't accept any
> input.

That's fine...  I don't think there's anything wrong with a
particular application not using both directions.

>> Does that adequately represent a very high-level picture of what
>> we're trying to manage?
> 
> Yes, pretty well. Thanks for trying to specify it all.

I think we're making progress.  I have some more thoughts but I
think I'll wait until tomorrow to share them.

Thanks a lot Dan.  At some point it might be better to have a
conference call to make better progress, but I'm not suggesting
that yet.

					-Alex

>> And if I understand it right, the purpose of the generic framework
>> being discussed is to define a common mechanism for managing (i.e.,
>> discovering, creating, destroying, querying, configuring, enabling,
>> disabling, etc.) WWAN units and the functions they implement, along
>> with the communication and logical channels used to communicate with
>> them.
> 
> Yes.
> 
> Dan
> 
>> Comments?
>>
>> 					-Alex
> 

