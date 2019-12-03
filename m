Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 944061104B3
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 20:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfLCTFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 14:05:38 -0500
Received: from mail-lj1-f172.google.com ([209.85.208.172]:37554 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbfLCTFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 14:05:38 -0500
Received: by mail-lj1-f172.google.com with SMTP id u17so5104384lja.4
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 11:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GaTQD28jqeY1uZuNCy2RfhuMDPy13kbGw+fQoeSdAA8=;
        b=NdSLDwRsDNZmkYYK7Z7wILk5WAeEjh1Hwf97Vt7IGGqB0Vetf6nADZmoeqw0eG8FFf
         YlDgi+s0pMIiMlhMg5u7bHX5OBwwN1jOSNPCrR3R8IHDYAxIcDjzummm4AuzwZjyDlvr
         xzWKBDQ+/+RtAWtkikMFOy9yqKlwjuEOMpdBFQ8iaEGR+2PH/118Jvw6uPTdVWFQuEet
         FinfRQJidnlhdSA4s+u+TSWqLwuly0lIMCr/xXOCB0kLrJld71WMJXq7GeOktkJjr6OE
         jHDJBpfet6tZ7eZuax9BNIXDNXWPADy4f5X7pgghkj2y6zESDu1JJUOaZVSk/qQNg9+H
         aNuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GaTQD28jqeY1uZuNCy2RfhuMDPy13kbGw+fQoeSdAA8=;
        b=Uxmn1hVNfVxFbioWrQ0ZezPXh0ZaMwixMtkYEIDpQOPIs/WOyeO/Gu5f8GDBzeQtDk
         DdYjQakugVQTcUet8rhdfYcW38tlr06/zZhn4fu20cSKlUeB4MjHR/yEM4LwAJUxXEDq
         C5Nzdq8rRmWWPtg+BxY22c8D2V2gWV15Pdd579pAYK+tsFWX23YXDgYDf3sHNW4GEyUT
         UhY9sr06qbCKDsuRVGm14MYXfHYPVjkVxPqjfnq2KWMoJa9TKmXoxwpsn9gHznzmmxoX
         evHiq4CKWCRuuAgP6WOCnYwpL/l0zcIRket6/l1JsBxm/hwakK46HoY44riNqOLwahYG
         UBdg==
X-Gm-Message-State: APjAAAXD7nRsQ8Z1tP5mWICLrYLvAai//1H35YuCgpvGe7t4xV6bHRIj
        C3RIyJoHkEpIc1GmImhNDHz/pg==
X-Google-Smtp-Source: APXvYqwY+PRYhZCTT4jOWYcEzYZUVM4GUkLJCGBY6kUHeDm3jt/4TqJQ07Btsdiukuy+qm7Af1mpLw==
X-Received: by 2002:a05:651c:112d:: with SMTP id e13mr3035349ljo.99.1575399935551;
        Tue, 03 Dec 2019 11:05:35 -0800 (PST)
Received: from khorivan (57-201-94-178.pool.ukrtel.net. [178.94.201.57])
        by smtp.gmail.com with ESMTPSA id n11sm1821904lfe.75.2019.12.03.11.05.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 11:05:34 -0800 (PST)
Date:   Tue, 3 Dec 2019 21:05:33 +0200
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Jesus Sanchez-Palencia <jesus.sanchez-palencia@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: tperf: An initial TSN Performance Utility
Message-ID: <20191203190531.GE2680@khorivan>
References: <BN8PR12MB3266E99E5C289CB6B77A5C58D3420@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20191203142745.GA2680@khorivan>
 <87blsp9vdc.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <87blsp9vdc.fsf@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 03, 2019 at 09:22:55AM -0800, Vinicius Costa Gomes wrote:
>Hi,
>
>Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> writes:
>
>> On Tue, Dec 03, 2019 at 10:00:15AM +0000, Jose Abreu wrote:
>>>Hi netdev,
>>>
>>>[ I added in cc the people I know that work with TSN stuff, please add
>>>anyone interested ]
>>>
>>>We are currently using a very basic tool for monitoring the CBS
>>>performance of Synopsys-based NICs which we called tperf. This was based
>>>on a patchset submitted by Jesus back in 2017 so credits to him and
>>>blames on me :)
>>>
>>>The current version tries to send "dummy" AVTP packets, and measures the
>>>bandwidth of both receiver and sender. By using this tool in conjunction
>>>with iperf3 we can check if CBS reserved queues are behaving correctly
>>>by reserving the priority traffic for AVTP packets.
>>>
>>>You can checkout the tool in the following address:
>>>	GitHub: https://github.com/joabreu/tperf
>>>
>>>We are open to improve this to more robust scenarios, so that we can
>>>have a common tool for TSN testing that's at the same time light
>>>weighted and precise.
>>>
>>>Anyone interested in helping ?
>
>@Jose, that's really nice. I will play with it for sure.
>
>>
>> I've also have tool that already includes similar functionality.
>>
>> https://github.com/ikhorn/plget
>>
>> It's also about from 2016-2017 years.
>> Not ideal, but it helped me a lot for last years. Also worked with XDP, but
>> libbpf library is old already and should be updated. But mostly it was used to
>> get latencies and observe hw ts how packets are put on the line.
>>
>> I've used it for CBS and for TAPRIO scheudler testing, observing h/w ts of each
>> packet, closed and open gates, but a target board should support hw ts to be
>> accurate, that's why ptp packets were used.
>>
>> It includes also latency measurements based as on hw timestamp as on software
>> ts.
>
>@Ivan, I took a look at plget some time ago. One thing that I missed is
>a test method that doesn't use the HW transmit timestamp, as retrieving
>the TX timestamp can be quite slow, and makes it hard to measure latency
>when sending something like ~10K packet/s.

Usually I use less rate, depends on robustness of implementation also.
For am5/am3/am6 TI SoC I was able to retrieve hw ts on 10K rate (500B size).
Everything has its limitation and different modes for different purposes ofc.
Just measuring bw it's quite primitive for testing shapers.
But, not a problem to add bw measurements just on app interval.
Actually it's added but with priority: hw ts, if not than sw ts, if no then app
ts. A little modification and it can do more.

>
>What I mean is something like this: the transmit side takes a timestamp,
>stores it in the packet being sent and sends the packet, the receive
>side gets the HW receive timestamp (usually faster) and calculates the
>latency based on the HW receive timestamp and the timestamp in the
>packet. I know that you should take the propagation delay and other
>stuff into account. But on back-to-back systems (at least) these other
>delays should be quite small compared to the whole latency.
>
>Do you think adding a test method similar to this would make sense for
>plget?

First of all, I can add everything that possible to add to plget.
It's a quite specific for TSN only, and any mode that is useful can be added.

However, for hw ts, there is no capability to set it to the packet as it becomes
available only after packet was sent. The method you've described only possible
with sw ts, but for this the driver has to be modified also. The plget doesn't
suppose driver modifications (except XDP sockets for now, and "bad" drivers),
But, h/w ts can be sent with next packet....

If use only sw timestamps from user app not a problem to add it. But accuracy of
this is nothing compared with hw ts (I mean for latency not bw), only some
average values can be more a while close to reality, but how accurate, it's
hard to say .... Frankly for most latency/timestamp tests the method you've
described is not needed. With hw ts I can measure latency only on one board,
second board is needed only for connection. For instance to get cycle interval
picture for taprio hw offload, showing me each schedule I used only hw ts of
receive board, seeing ipg between each received packet on destination point.
I don't need even synchronization of ptp clocks, seeing relative time is enough.
(Also there is problem to sync them and get hw ts for data flow based on ptp in
the same time .... but that's another usecase)

Any kind of bw measurements, based on priorities or other sockets flags, that
are useful or represent any tsn usecase can be added as separate mode. Mostly
it was based on hw ts as I debugged swithdev + cbs, taprio and more, measuring
bw and more parameters. I've tried to keep it simple, but it's hard when you
do it for yourself. Should be simplified.

Nothing against tperf, it's good idea!, but the tool has to have smth specific
but not duplicate functionality, just measuring bw that can be done with iperf
for instance, why not to modify iperf a little to get similar then? Or at least
try before...

-- 
Regards,
Ivan Khoronzhuk
