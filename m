Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 396BC162A33
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 17:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgBRQQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 11:16:45 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35469 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbgBRQQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 11:16:45 -0500
Received: by mail-pf1-f193.google.com with SMTP id y73so10908435pfg.2
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 08:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=3TRSbOfHnf3W1PlV6VvokV/W3FKqZV93JsFjTChGE8Q=;
        b=lvRmPBJNCqwpdtkf2XPe2qVpicU0J48Etx+nxT7VNatgNZBKcNCMMJVET4n1wReQ6h
         B0hu/gNlGF1Hq8uTbR1q1b4YDgTxxERLKywtQWMv1NBeEvqx3/mLaz95s5j6Rl+WW43i
         EaRxaXQfeKuw5HTITMi+gm13ghYlwb+w14PK3E8PJ9SuPDdDtUfXfonun2xzab8KesDe
         jaiCURy5gx6nWaZA0xAQdZ4zuEVziiIO4o6qvAnOAufDfHtQiX07bVRBzHuq1W7olz/H
         uGjcA+jBYq1DkA/j509EhFnH5YaH2XpwVFUW3OMMkVBkz9ZlnweHRqHxkOL56sFKI+hz
         tISg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=3TRSbOfHnf3W1PlV6VvokV/W3FKqZV93JsFjTChGE8Q=;
        b=TwrbFBmF5+D4Pz0HPRNttL8qkUZtG3O0yVO2q6humB8b7RuOJIpxLqlSz5o4nJMAlc
         iNyeGdT/gkOUYmsw83uCCLLWoz4vxfXq3iuyIqgRv6RFVrHxspjx58vZUCYRefIgQetW
         enHDXSSaqB1b/9xoa4NqAQaw2qDv7gJHhtEh4SNNiRWehwsxtTRedS99kFJJEZD4wQ0P
         Qq6/ys9GX6thrwoTAo89CAx6wpOhaKiOOWXArLeIaicwqWAiukoQVetyl1CR3IF3UH7S
         bsFSa4rHhK6IEBJlua0y1IxuKELpfmBtIzFMAm8q/csmQacLKbi5VNkmDB58vJjhsAnL
         9TPA==
X-Gm-Message-State: APjAAAXKL0pjs+iaZQtcqosD2sK+NM5eN34fhVd8ceVgVZlLBAGYVBs8
        JhKnjG+uxv/yULrK4glc9JahW6JLYn5Xsw==
X-Google-Smtp-Source: APXvYqxZsWK1FTELmgga7FRGPthWqcxcuInmyAyX2mMDTLFHYsqhbNflOTmiJHWcxSwSrX1qO0aW8g==
X-Received: by 2002:a63:cc09:: with SMTP id x9mr4508707pgf.339.1582042604416;
        Tue, 18 Feb 2020 08:16:44 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id x21sm4809805pfq.76.2020.02.18.08.16.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 08:16:43 -0800 (PST)
Subject: Re: [PATCH net-next 0/9] ionic: Add support for Event Queues
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20200216231158.5678-1-snelson@pensando.io>
 <20200216.201124.1598095840697181424.davem@davemloft.net>
 <4386aa68-d8c5-d619-4d38-cb3f4d441f56@pensando.io>
 <20200217.140344.810813375227195875.davem@davemloft.net>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <e739ddaf-e04b-302e-9ca2-1700385bc379@pensando.io>
Date:   Tue, 18 Feb 2020 08:16:43 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200217.140344.810813375227195875.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/17/20 2:03 PM, David Miller wrote:
> From: Shannon Nelson <snelson@pensando.io>
> Date: Sun, 16 Feb 2020 22:55:22 -0800
>
>> On 2/16/20 8:11 PM, David Miller wrote:
>>> From: Shannon Nelson <snelson@pensando.io>
>>> Date: Sun, 16 Feb 2020 15:11:49 -0800
>>>
>>>> This patchset adds a new EventQueue feature that can be used
>>>> for multiplexing the interrupts if we find that we can't get
>>>> enough from the system to support our configuration.  We can
>>>> create a small number of EQs that use interrupts, and have
>>>> the TxRx queue pairs subscribe to event messages that come
>>>> through the EQs, selecting an EQ with (TxIndex % numEqs).
>>> How is a user going to be able to figure out how to direct
>>> traffic to specific cpus using multiqueue settings if you're
>>> going to have the mapping go through this custom muxing
>>> afterwards?
>> When using the EQ feature, the TxRx are assigned to the EventQueues in
>> a straight round-robin, so the layout is predictable.  I suppose we
>> could have a way to print out the TxRx -> EQ -> Irq mappings, but I'm
>> not sure where we would put such a thing.
> No user is going to know this and it's completely inconsistent with how
> other multiqueue networking devices behave.

The ionic's main RSS set is limited to number of cpus, so that in normal 
use we remain consistent with other drivers.  With no additional 
configuration, this is the standard behavior, as expected, so most users 
won't need to know or care.

We have a FW configuration option that can be chosen by the customer to 
make use of the much larger set of queues that we have available.  This 
keeps the RSS set limited to the cpu count or less, keeping normal use 
consistent, and makes additional queues available for macvlan offload 
use.  Depending on the customer's configuration, this can be 100's of 
queues, which seems excessive, but we have been given use-cases for 
them.  In these cases, the queues will be wrapped around the vectors 
available with the customer's use case. This is similar to the Intel 
i40e's support for macvlan offload which can also end up wrapping 
around, but they have the number of offload channels constrained to a 
much smaller number.

(BTW, with the ixgbe we can do an ethtool set_channel to get more queues 
than vectors on the PF, which will end up up wrapping the queues around 
the vectors allocated.  Not extremely useful perhaps, but possible.)

We don't have support for the macvlan offload in this upstream driver 
yet, but this patchset allows us to play nicely with that FW configuration.

sln

