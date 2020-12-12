Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B0A2D86F4
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 14:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394867AbgLLNlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 08:41:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgLLNlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 08:41:42 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13045C0613CF
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 05:41:02 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id a8so18605529lfb.3
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 05:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VzibsGltOGic8ExQhiIfvXfZs9+DgPlIslvwg8cuIxk=;
        b=xbfBKS1/L74PgeAZkSZywC4RrVLvzELMZM0N1wDhtU/L9hygKrhcjCeKa1zoSZRDhN
         3kMH+QLvCXtKSzICaZ1/sE1vFbx07WEIG2IJYDx2+TBZ9EhjHi/V++LTVGcUzXevEjfA
         efRZ2EdBZ7NHFfE6otaZylpCNKa/X0LemrIcBjalxibkg6sBQRu786owns/HdgPL5Dpl
         rwNAvlcJmIhp0FDmUt4h/61LBxXPkEX2mZHgoqVTvJPf0p4MXYbUWBnkLf9WbQ1hwJeX
         6nt8SrftHbBr0dMZdL2ZIQxUgtFgqbMaSnOb/JKP/CGW32misTv2NMTnbwTx2CFarNZM
         rFgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VzibsGltOGic8ExQhiIfvXfZs9+DgPlIslvwg8cuIxk=;
        b=GQdYzCVUeeLcD+L/24+EuTAJ9H8K+l1QXux9cGvHZtWkgYuZOjLbRBqc6nbz0LH0oB
         uQNkk45aOAK1AIsryRS8CsgBcyNGls8t2lRRDAYjOKRysiFo2zyw07aN9uvucucBFK4H
         /bn6IfN9DwxBTFXIaIpiBJnDnbhSWw8fe6gWzZsNCfMTkZpiScghu1mrzZiEcjkSOy8Y
         ERu18uxYFcDrTcpaKi48vbGzwTBtXG247UYaM7CWO0nrbHqDcrBV3SOnK9TA1UzrKMkl
         iD6h5iGKjbV1MGlMl0wyM2354VmjAXIXGkVhS3IsY+9gLkvUFpF3u/rJx2WHPR4YoRQU
         opiQ==
X-Gm-Message-State: AOAM532y0MAIQ3mZcO+UUAABBW0hkGs5vE1YdVpcWBFxOFaOAmqL7ZaC
        d1UGPUs3nFsMnV06x+s9YgCLZiA/S4tDyw==
X-Google-Smtp-Source: ABdhPJyDpq/L4/yHeXcL+SxGU8d2XfWOarL3Jl69TvSUer15us+UMkuxDs3Fd4T8BIB9sZ2DA0dsig==
X-Received: by 2002:a19:6a08:: with SMTP id u8mr5799319lfu.217.1607780460636;
        Sat, 12 Dec 2020 05:41:00 -0800 (PST)
Received: from [192.168.1.157] (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id p24sm762366lfo.53.2020.12.12.05.40.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Dec 2020 05:41:00 -0800 (PST)
Subject: Re: [PATCH net-next v2 07/12] gtp: use ephemeral source port
To:     Harald Welte <laforge@gnumonks.org>
Cc:     netdev@vger.kernel.org, pablo@netfilter.org
References: <20201211122612.869225-1-jonas@norrbonn.se>
 <20201211122612.869225-8-jonas@norrbonn.se> <X9SWSYXxzYQoaCt7@nataraja>
From:   Jonas Bonn <jonas@norrbonn.se>
Message-ID: <ef85ca00-96c9-7e79-f694-d44ba0f756a1@norrbonn.se>
Date:   Sat, 12 Dec 2020 14:40:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <X9SWSYXxzYQoaCt7@nataraja>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Harald,

On 12/12/2020 11:07, Harald Welte wrote:
> Hi Jonas,
> 
> On Fri, Dec 11, 2020 at 01:26:07PM +0100, Jonas Bonn wrote:
>>  From 3GPP TS 29.281:
>> "...the UDP Source Port or the Flow Label field... should be set dynamically
>> by the sending GTP-U entity to help balancing the load in the transport
>> network."
> 
> You unfortuantely didn't specifiy which 3GPP release you are referring to.
> 

Sorry about that.  I'm looking at v16.1.0.

> At least in V15.7.0 (2020-01)  Release 15 I can only find:
> 
> "For the messages described below, the UDP Source Port (except as
> specified for the Echo Response message) may be allocated either
> statically or dynamically by the sending GTP-U entity.  NOTE: Dynamic
> allocation of the UDP source port can help balancing the load in the
> network, depending on network deployments and network node
> implementations."
> 
> For GTPv0, TS 29.060 states:
> 
> "The UDP Source Port is a locally allocated port number at the sending
> GSN/RNC."
> 
> unfortuantely it doesn't say if it's a locally allocated number globally
> for that entire GSN/RNC, or it's dynamic per flow or per packet.

I could interpret that to mean that the receiving end shouldn't be too 
bothered about what port a packet happens to come from...  That said, 
dynamic per flow is almost certainly what we want here as this is mostly 
about being able to trigger receive side scaling for network cards that 
can't look at inner headers.

> 
> As I'm aware of a lot of very tight packet filtering between GSNs,
> I would probably not go for fully dynamic source port allocation
> without some kind of way how the user (GTP-control instance) being
> able to decide on that policy.
> 

Sure... sounds reasonable.  A flag on the link setup indicating dynamic 
source port yes/no should be sufficient, right?

/Jonas

