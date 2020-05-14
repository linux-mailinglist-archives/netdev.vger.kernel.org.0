Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBCA1D3A3B
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 20:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbgENSyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 14:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729237AbgENSyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 14:54:52 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7DEC061A0E;
        Thu, 14 May 2020 11:54:52 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id f83so4042749qke.13;
        Thu, 14 May 2020 11:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lynNWrHQUN3W407q/Yp3KSzCn2DuA1Pg90UjJME068Q=;
        b=Vo5qO7tz6jbYDkPK5+vqymTquRRMb8HYm95nt2QeVfrzL96G0YzQseqt4w1J/28nfs
         gHLXz/H8vSCiNlZsv7pYHtdPtKrUSe/akTNuEyHxuhlrpchdjDQsRSOKgBX9pUp0Lbf8
         ZJXE9rTF++JnLbJn8VCv7fEx2RzfwOKmdaKw2sjbU3NEC2DHfvltFYooYihrO3BZ3bVC
         YWgFeF3QRGiU5EOgflO5bEw239p1NUb+AbMVb4pZ0LASwDEjJ8QUvLJyngtIZFJLKSyG
         YxtQ1ZpKYDRa2AuoqdR2UAUZN81PnZuOZ3f0cEiYSDyah7SdsDNu9/FWJZ2kTY1jK0tG
         loJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lynNWrHQUN3W407q/Yp3KSzCn2DuA1Pg90UjJME068Q=;
        b=i7KtyFCHlbPEJJ1KYyWGQIXV3Nut7rOIdPAm1amyDWPAdO+EpSrGi/JZ7k579JH5pr
         ANUVrTzZVU0BvsYMQspKag4DnmfZD5XqJM1pee8c6/nAd6Sw2eNNngVPjoaef7oT+sua
         Z8RbP1vxGnyly38g1sYh9SzrIIeVRX5CLw+6K/9ptm1/8dMmvblE6OFE8HeT4l9TAiq0
         CMmAROUewqMMpKrE7QYDpp9pGu4PPXfW1Sw6kDfux5k8WaY5Zl0HSVY17BTjAkBsm8wN
         ecLikHIrvhFTOzGWmmyl8aMUyyeXYyc5paCiy8Ge87NJGP4241+/O5SB0uOG46sSpkmE
         eHog==
X-Gm-Message-State: AOAM530LcHsBIfFIu+uVZz8oN+a6qiFbe0cX9NGOk1QJe2AZeyv0ZlK+
        sG2MLQ8QRVSyY9AN5gH1X9o=
X-Google-Smtp-Source: ABdhPJwsx1/0nhTNwJ+lepvv/DMYz6022NXwBlGHkdJLTPcVUnS2jl3PzVO0VPHkUXBqc79cmNEEiw==
X-Received: by 2002:a05:620a:1524:: with SMTP id n4mr6459565qkk.490.1589482491783;
        Thu, 14 May 2020 11:54:51 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:3140:7ba:69e7:d3b1? ([2601:282:803:7700:3140:7ba:69e7:d3b1])
        by smtp.googlemail.com with ESMTPSA id z50sm3499498qta.18.2020.05.14.11.54.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2020 11:54:51 -0700 (PDT)
Subject: Re: "Forwarding" from TC classifier
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Martynas Pumputis <m@lambda.lt>,
        kernel-team <kernel-team@cloudflare.com>
References: <CACAyw9_4Uzh0GqAR16BfEHQ0ZWHKGUKacOQwwhwsfhdCTMtsNQ@mail.gmail.com>
 <b93b4ad2-0cf0-81e0-b2b0-664248b3630f@gmail.com>
 <CACAyw9-95He2yq0qoxuWFy3wqQt1kAtAQcRw2UTrqse2hUq1tA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5cca7bce-0052-d854-5ead-b09d43cb9eb9@gmail.com>
Date:   Thu, 14 May 2020 12:54:49 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CACAyw9-95He2yq0qoxuWFy3wqQt1kAtAQcRw2UTrqse2hUq1tA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/14/20 9:41 AM, Lorenz Bauer wrote:
> On Wed, 13 May 2020 at 18:48, David Ahern <dsahern@gmail.com> wrote:
>>
>> On 5/13/20 10:40 AM, Lorenz Bauer wrote:
>>> We've recently open sourced a key component of our L4 load balancer:
>>> cls_redirect [1].
>>> In the commit description, I call out the following caveat:
>>>
>>>     cls_redirect relies on receiving encapsulated packets directly
>>> from a router. This is
>>>     because we don't have access to the neighbour tables from BPF, yet.
>>
>> Can you explain more about this limitation? Why does access to neighbor
>> tables solve the problem?
> 
> We want to forward the packet to another machine, based on an IP address
> stored in our custom encapsulation header.
> If we always receive packets from a router we can plug in the new IP, swap
> the MAC and send the packet back to the router. Inefficient, but it means we
> don't have to deal with MAC addresses ourselves.

Ok, so swapping source and destination addresses in the IP header, doing
a fib lookup and redirecting to an interface based on the lookup. That
does require a neighbor entry for the dest address. Access to the
neighbor table does not directly solve that problem - if it is not there
for the fib lookup, it won't be there for the straight neigh lookup.

You could let the first packet go up the stack to create and resolve the
neighbor entry. At that point follow on packets will take the fast path.

Alternatively, you can create static entries in the table for known
forwarding addresses or have a process on the server initiate neighbor
resolution for none forwarding addresses.
>>
>> Usually, 'output' is for locally generated traffic headed out. XDP
>> programs run on ingress are from an Rx perspective and do the lookup
>> from the perspective of 'is this forwarded or locally delivered'.
> 
> What if the XDP encapsulates the packet? At this point I know that I
> want to forward it elsewhere. Would that use LOOKUP_OUTPUT?

Yes, if you want the lookup to respond as if it is a locally sent packet
versus a forwarded packet.
