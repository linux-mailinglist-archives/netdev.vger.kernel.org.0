Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB0748EEF3
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 18:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243705AbiANRD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 12:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243706AbiANRD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 12:03:28 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65BCC061574
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 09:03:28 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id p7so13159436iod.2
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 09:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=tU/IzgNcwbtNdLNNhH5tHp8MgfDNSFRQ24LLFnqR/CI=;
        b=MBIEYWkVTGzr/X6ESXAQmW4/s8H2n7bY6+dzs1Od+NaWM5m3hxsIHx/g49bwcvQDUM
         quLFIbjBdWgKg+BT/v75rcgi8RfT0v/RkgtfVPusTeFW0Fk4jeYx0qVaOxmZowH5pky8
         cUe8gRasUSoo7lQbD3c7pyLN6KztLFqOkeQGF0UDz5AzxA+3Y9QiGYbFTAZgyZVDL+tY
         jy5v6xPBY2sH21/Y45tD/sOmmZWaggiWLR0S8NDwp3H064sMkhzTXtlmFG9dew7HfB9y
         JjLU+NnawsyjclERjNpZR2l6WBVzmCnAodVjiz/iTFoGv7fDJIXbDtGkGSE5MbuoYj3f
         P/FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=tU/IzgNcwbtNdLNNhH5tHp8MgfDNSFRQ24LLFnqR/CI=;
        b=4FodJ/0tOeB1eOxg/uwgkI98DrCZlHvZRw642yBH98rErZXkuouBqaNweax4bjYtkc
         NU7yrU5rQsnJ/OhbYiClkTaWedArN+hSS4MvwzcwKWpDoKqSLJQF37G+tXD33/yFLlbd
         zhG7aBrBIMeJZAPUUxx3rYQPF97BCKjUxM2et26fY/rGz5yWJxEGW+JuDlVj512fVzNB
         Pd5GNPQbiotW9K97eZUatFBdSpWsVe7jV0KH3HS3ufvrUl1Py/mLf/EQiG1cnB0bsWBC
         O9pIv4s1fp3+/NdmlDS3wjkcX73vd79On3r3dwztWNehUcnDIyKSC0CgNN+d9JHW9kR5
         hHBA==
X-Gm-Message-State: AOAM533ZNts7wZofBdATkgu5upTIkz/nnrjG/C29kmwYsykuHV+QQqJN
        hbunscr/RybvNjtW487mO+WHm0L8iIvM7A==
X-Google-Smtp-Source: ABdhPJyjTHK1+31Ahzp8E6rPRcgScb6BtwETIrb7DCABhnTdeDEh837ozEchtOShdxClpeU45qC/Fg==
X-Received: by 2002:a05:6602:1407:: with SMTP id t7mr4987934iov.78.1642179807776;
        Fri, 14 Jan 2022 09:03:27 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id f25sm4561278ioj.52.2022.01.14.09.03.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jan 2022 09:03:27 -0800 (PST)
Message-ID: <9da2f1f6-fc7c-e131-400d-97ac3b8cdadc@linaro.org>
Date:   Fri, 14 Jan 2022 11:03:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: Port mirroring, v2 (RFC)
Content-Language: en-US
From:   Alex Elder <elder@linaro.org>
To:     Network Development <netdev@vger.kernel.org>
Cc:     "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
 <e666e0cb-5b65-1fe9-61ae-a3a3cea54ea0@linaro.org>
In-Reply-To: <e666e0cb-5b65-1fe9-61ae-a3a3cea54ea0@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yikes!  I don't know why that turned out double-spaced.  I hope
this one turns out better.

					-Alex

This is a second RFC for a design to implement new functionality
in the Qualcomm IPA driver.  Since last time I've looked into some
options based on feedback.  This time I'll provide some more detail
about the hardware, and what the feature is doing.  And I'll end
with two possible implementations, and some questions.

My objective is to get a general sense that what I plan to do
is reasonable, so the patches that implement it will be acceptable.


The feature provides the AP access to information about the packets
that the IPA hardware processes as it carries them between its
"ports".  It is intended as a debug/informational interface only.
Before going further I'll briefly explain what the IPA hardware
does.

The upstream driver currently uses the hardware only as the path
that provides access to a 5G/LTE cellular network via a modem
embedded in a Qualcomm SoC.

        \|/
         |
   ------+-----   ------
   | 5G Modem |   | AP |
   ------------   ------
              \\    || <-- IPA channels, or "ports"
             -----------
             |   IPA   |
             -----------

But the hardware also provides a path to carry network traffic to
and from other entities as well, such as a PCIe root complex (or
endpoint).  For example an M.2 WiFi card can use a PCIe slot that
is IPA connected, and the IPA hardware can carry packets between
the AP and that WiFi card.  (A separate MHI host driver manages the
interaction between PCIe and IPA in this case.)

        \|/                PCIe bus --.     \|/
         |                            |      |
   ------+-----  ------   ----------- v ------+-----
   | 5G Modem |  | AP |...| PCIe RC |===| M.2 WiFi |
   ------------  ------   -----------   ------------
              \\   ||    // <-- IPA channels
               -----------
               |   IPA   |
               -----------

In the above scenario, the IPA hardware is actually able to directly
route packets between the embedded modem and the WiFi card without
AP involvement.  But supporting that is a future problem, and I
don't want to get ahead of myself.

The point is that the IPA hardware can carry network packets between
any pair of its "ports".  And the AP can get information about all
of the traffic the IPA handles, using a special interface.

The "information" consists of replicas of each packet transferred
(possibly truncated), each preceded by a fixed-size "status" header.
It amounts to a stream of packets delivered by the IPA hardware to
the AP.  This stream is distinct from "normal" traffic (such as
packets exchanged between the AP and modem); but note that even
those packets would be replicated.


I originally described this feature as "port mirroring" because it
seemed to be similar to that feature of smart network switches.  But
the "mirroring" term was interpreted as a something Linux would do,
so at a minimum, that's the wrong term.  Andrew Lunn (and others)
suggested that WiFi monitor mode might be a good model.  I looked
into that, and I don't think that quite fits either.  I really think
this should be represented separate from the "normal" network
devices associated with IPA.


Below I will describe two possible implementations I'm considering.
I would like to know which approach makes the most sense (or if
neither does, what alternative would be better).  On top of that I
guess I'd like suggestions for the *name* for this (i.e., what
should I call the interface that implements this?).

The two alternative implementations I'm considering are a network
device, and a "misc" (character) device.  In both cases, a user
space program would open the interface and read from it.  The data
read would just be the raw data received--a stream of the (possibly
truncated) packets together with their "status" headers.  I envision
either one could be a source of packets processed by libpcap/tcpdump.

My preference is to use a network device.  I think it fits the
"stream of packets" best, and existing networking code would take
care of all the details of queueing and packet management.  One down
side is that this is not a "normal" network interface--there is no
reason to associate it with an IP stack, for example.

A misc device would avoid the interface being treated as a "normal"
network device.  It could present all packet data to user space, but
the IPA driver would have to manage buffering, including limiting
the amount of received buffers.  Implementing this would be fine,
but I think it would just be nicer to use the network model.


So bottom line, given what I've described above:
- Is a distinct network device a reasonable and acceptable way of
   implementing this feature?  If not, why not?
- Would implementing this as a misc device be preferable?  Why?
- Is there a better alternative than either of the above?
- Can anyone suggest a name for this functionality, something that
   is meaningful but would not be confused with other existing terms?

Thanks.

					-Alex
