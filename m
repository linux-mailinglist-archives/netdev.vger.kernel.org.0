Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF911ED3FD
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 18:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbfKCRYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 12:24:16 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:39137 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727444AbfKCRYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 12:24:16 -0500
Received: by mail-il1-f194.google.com with SMTP id f201so7130999ilh.6
        for <netdev@vger.kernel.org>; Sun, 03 Nov 2019 09:24:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nFyRzQix4QobiDUrxXXBfBZHYGTgZYOo/nNtry0Wzuw=;
        b=eOB8MBR+4pk7y6/aspQe/Uc0zegbkRhah2PhBPSfazLRJpREwVUAjdu/Cgtku5aezJ
         S60KLI4bPgl/VhB7jh7NWyD8YSLURvK/Q6I14P2hFepVH6I2VvE9nc70B+07yW7WrbI7
         N2B8BInzYUkttY/HUFRKG5kq3hkCGDEXLzVtSII+jtZvZ5MUrsDWXOujPxHdCkwLUmse
         TSyQwqr40Yi3djafCeTKDcNfOJKD6Nm+csKh57EZ5UA7VyHIbPxk2MtkQtbB0y+aDrjX
         nJn6xgXUbUP8tIgT76gd2Liwy4RjL/4wosDPVO09fnTl29J9CqFHq1LLacx3Zq83rJis
         AbYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nFyRzQix4QobiDUrxXXBfBZHYGTgZYOo/nNtry0Wzuw=;
        b=Gph50ojvRXlLZB9xFD/D+SFNSFHh0o2gNtLHHT1cYhdTOWUqh3Iw9XG3D/DoEXR2wu
         AS55j4DB0scBJQi4C3oM6F3gilXjLIZWvyNT1D89Xc7lzM7VpFs5YbmVBL/eQjijNn9D
         vq3FQUGJyQKDaIznGR6K3LfNL3WK1pL5FBuKkGukQayreUthftwTHQf2DqMLoCkU1dh3
         OgL7vhneZ7T4tafl9DMx/GSYe0k/oqEHuGakZBQJJoMzty6Vro+RzvG2asSj+oYKqEgH
         fzXViD4bLJhksg9Wn0ueJ8nXMDOsYp4FVxHVML35GwGghuX8YAneqlipvT5G0DswCfJl
         ocVQ==
X-Gm-Message-State: APjAAAWJMPAONaNmjQ8czla9bqXVadstrY+idBxurfvSkBFAMoJ7vFMB
        5L5dDSb1/OBuckneGff31g8=
X-Google-Smtp-Source: APXvYqxpevMm88xA5S01/87cm7UBqbtYUTb9Fc6Libm1qhM/Zg6YGmW9TSAHRZuCPi1butXoHvK/uw==
X-Received: by 2002:a92:dd88:: with SMTP id g8mr23586605iln.221.1572801855683;
        Sun, 03 Nov 2019 09:24:15 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:b1d3:36cc:8df:d784])
        by smtp.googlemail.com with ESMTPSA id s5sm638294iol.66.2019.11.03.09.24.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2019 09:24:14 -0800 (PST)
Subject: Re: [PATCH net-next v4 0/6] sfc: Add XDP support
To:     Martin Habets <mhabets@solarflare.com>,
        Charles McLachlan <cmclachlan@solarflare.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-net-drivers@solarflare.com, brouer@redhat.com
References: <c0294a54-35d3-2001-a2b9-dd405d2b3501@solarflare.com>
 <b971b219-5aab-722d-72b7-545a7c2b609e@gmail.com>
 <e3f1c071-3609-d6e7-81d6-9ee73f9f4f6a@solarflare.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <236ff7c4-95da-da0e-8ba7-12bfb92c7d55@gmail.com>
Date:   Sun, 3 Nov 2019 10:24:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <e3f1c071-3609-d6e7-81d6-9ee73f9f4f6a@solarflare.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/19 4:07 AM, Martin Habets wrote:
> On 31/10/2019 22:18, David Ahern wrote:
>> On 10/31/19 4:21 AM, Charles McLachlan wrote:
>>> Supply the XDP callbacks in netdevice ops that enable lower level processing
>>> of XDP frames.
>>>
>>> Changes in v4:
>>> - Handle the failure to send some frames in efx_xdp_tx_buffers() properly.
>>>
>>> Changes in v3:
>>> - Fix a BUG_ON when trying to allocate piobufs to xdp queues.
>>> - Add a missed trace_xdp_exception.
>>>
>>> Changes in v2:
>>> - Use of xdp_return_frame_rx_napi() in tx.c
>>> - Addition of xdp_rxq_info_valid and xdp_rxq_info_failed to track when
>>>   xdp_rxq_info failures occur.
>>> - Renaming of rc to err and more use of unlikely().
>>> - Cut some duplicated code and fix an array overrun.
>>> - Actually increment n_rx_xdp_tx when packets are transmitted.
>>>
>>
>> Something is up with this version versus v2. I am seeing a huge
>> performance drop with my L2 forwarding program - something I was not
>> seeing with v2 and I do not see with the experimental version of XDP in
>> the out of tree sfc driver.
>>
>> Without XDP:
>>
>> $ netperf -H 10.39.16.7 -l 30 -t TCP_STREAM
>> MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to
>> 10.39.16.7 () port 0 AF_INET : demo
>> Recv   Send    Send
>> Socket Socket  Message  Elapsed
>> Size   Size    Size     Time     Throughput
>> bytes  bytes   bytes    secs.    10^6bits/sec
>>
>>  87380  16384  16384    30.00    9386.73
>>
>>
>> With XDP
>>
>> $ netperf -H 10.39.16.7 -l 30 -t TCP_STREAM
>> MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to
>> 10.39.16.7 () port 0 AF_INET : demo
>> Recv   Send    Send
>> Socket Socket  Message  Elapsed
>> Size   Size    Size     Time     Throughput
>> bytes  bytes   bytes    secs.    10^6bits/sec
>>
>>  87380  16384  16384    30.01     384.11
>>
>>
>> Prior versions was showing throughput of at least 4000 (depends on the
>> test and VM setup).
> 
> Thanks for testing this. And a good thing we have counters for this.
> Are the rx_xdp_drops or rx_xdp_bad_drops non-zero/increasing?
> 

Patches are now in the kernel. Tests Friday and yesterday were showing a
lot of variability, so may be an issue with the servers / lab setup I am
using. I need to follow up on that.
