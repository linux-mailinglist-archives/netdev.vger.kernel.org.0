Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 371B8D703A
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 09:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbfJOHd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 03:33:28 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35361 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbfJOHd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 03:33:28 -0400
Received: by mail-wr1-f65.google.com with SMTP id v8so22495594wrt.2
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 00:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8m9w0jPCAFPjczDL2GRxGXdpZcf7m+AcFKjWCmuIm1I=;
        b=Y+MDRu8ZLPF6bn9sNA7/5PpEzMMDqfi3LQAPfRb8xBk1o1BDTgNl2kMZUdyqH2zUrA
         EBLwD3WiFHTE+vwtBK+zU0syOd/QoKTOLrstOFeuu++RhY4Wx01djjYd0Ft/5EDmwhvf
         1HUOafyrLnwx1zP2chkHC2Me5uK+vHWqwIJrR1G0iWJsYp5I0XunqMXyNKInhDOOFcHz
         6DpeVQufcpVm3JBrn3tn2Af2yGdpHXcLspPpyuVGHlQ7uSjI1RKXb3N6wTJcUngjZYH4
         EEYr6WO9zkIy5OTRFKaGetj7n89x+25ZqmXkUn2PsmJq0/+9Dfcxq3b25x/zNYbl9rf1
         oh8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=8m9w0jPCAFPjczDL2GRxGXdpZcf7m+AcFKjWCmuIm1I=;
        b=c3+8xnWa8LnWEXNg/W67I0F2KlkpZpsCjIngx6ifGRpTaXj7dkh0f4tKX2d58802Xv
         oC/p3xIybYAzFjBjLXUPaYYcU/NKK6hfWAlPo2TfWWG06T2sm/aRvnHWQPpgX95SdMvO
         9o5ac36k8uwqxW43Uq7laSWlRaVz2Pkq5jMAHuzcS8896GaSAeaHjsGNmi9H8NeHNg9a
         FMHyB0ia/TcACGgrBEvsh1OCZ9/uBXnaHxhec1zi5OWPAxuVQ8LR5RQLrSLaIOy5u6jm
         PJwh5OaJCwYjwKe44yZZqlVQ1yRwTXr+AfdJU4ErPg+6FNeHXE1AgSIR/Rs9srS6Boa9
         gGig==
X-Gm-Message-State: APjAAAVX3VmTJFKNYdMiGjwl21lGPr0WqjXnYcrPZwm/uqjK3EakRWw6
        zMswup4zFcz3sfXkKSkQElagAw==
X-Google-Smtp-Source: APXvYqymJLZxQx34CJRLNXOskevkZF0zDosLMz6/ODwdNiPJ59xW768ghS/tAmmXMyNOLOyuyd9pgw==
X-Received: by 2002:a5d:6b03:: with SMTP id v3mr30290423wrw.182.1571124806147;
        Tue, 15 Oct 2019 00:33:26 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:3db8:f58e:db97:45fa? ([2a01:e35:8b63:dc30:3db8:f58e:db97:45fa])
        by smtp.gmail.com with ESMTPSA id l6sm16887580wmg.2.2019.10.15.00.33.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2019 00:33:25 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH iproute2] ipnetns: enable to dump nsid conversion table
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        Petr Oros <poros@redhat.com>
References: <20191007134447.20077-1-nicolas.dichtel@6wind.com>
 <20191014131500.7dd2b1a8@hermes.lan>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <0983aadc-7375-75c7-e8ed-b2f8213e1bca@6wind.com>
Date:   Tue, 15 Oct 2019 09:33:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191014131500.7dd2b1a8@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 14/10/2019 à 22:15, Stephen Hemminger a écrit :
> On Mon,  7 Oct 2019 15:44:47 +0200
> Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
> 
>> This patch enables to dump/get nsid from a netns into another netns.
>>
>> Example:
>> $ ./test.sh
>> + ip netns add foo
>> + ip netns add bar
>> + touch /var/run/netns/init_net
>> + mount --bind /proc/1/ns/net /var/run/netns/init_net
>> + ip netns set init_net 11
>> + ip netns set foo 12
>> + ip netns set bar 13
>> + ip netns
>> init_net (id: 11)
>> bar (id: 13)
>> foo (id: 12)
>> + ip -n foo netns set init_net 21
>> + ip -n foo netns set foo 22
>> + ip -n foo netns set bar 23
>> + ip -n foo netns
>> init_net (id: 21)
>> bar (id: 23)
>> foo (id: 22)
>> + ip -n bar netns set init_net 31
>> + ip -n bar netns set foo 32
>> + ip -n bar netns set bar 33
>> + ip -n bar netns
>> init_net (id: 31)
>> bar (id: 33)
>> foo (id: 32)
>> + ip netns list-id target-nsid 12
>> nsid 21 current-nsid 11 (iproute2 netns name: init_net)
>> nsid 22 current-nsid 12 (iproute2 netns name: foo)
>> nsid 23 current-nsid 13 (iproute2 netns name: bar)
>> + ip -n foo netns list-id target-nsid 21
>> nsid 11 current-nsid 21 (iproute2 netns name: init_net)
>> nsid 12 current-nsid 22 (iproute2 netns name: foo)
>> nsid 13 current-nsid 23 (iproute2 netns name: bar)
>> + ip -n bar netns list-id target-nsid 33 nsid 32
>> nsid 32 current-nsid 32 (iproute2 netns name: foo)
>> + ip -n bar netns list-id target-nsid 31 nsid 32
>> nsid 12 current-nsid 32 (iproute2 netns name: foo)
>> + ip netns list-id nsid 13
>> nsid 13 (iproute2 netns name: bar)
>>
>> CC: Petr Oros <poros@redhat.com>
>> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>> ---
>>  include/libnetlink.h |   5 +-
>>  ip/ip_common.h       |   1 +
>>  ip/ipnetns.c         | 115 +++++++++++++++++++++++++++++++++++++++++--
>>  lib/libnetlink.c     |  15 ++++--
>>  4 files changed, 126 insertions(+), 10 deletions(-)
>>
> 
> Applied. Please send another patch to update man page.
> 
Yes, I will do.
I don't see the patch on kernel.org, am I missing something?


Thank you,
Nicolas
