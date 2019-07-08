Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB01F61CA0
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 11:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730015AbfGHJ53 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 8 Jul 2019 05:57:29 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:46305 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729185AbfGHJ53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 05:57:29 -0400
Received: by mail-ed1-f66.google.com with SMTP id d4so13967950edr.13
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 02:57:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=9MAGqQmzjLDN+1MxtG+/WK6dk3U8014eI3HfqI8NgWI=;
        b=IeJCzfal+qI+sWAgc4ttm7OISmHkS3IGaXkYZKSqGYod7zRtsYy0DTRg6hdYZPQXlu
         cZPUObTRQAejBxzKc1XfKDdtPzBfrJRjFnfPoVpsMwXYuDTfh2zWLWoFz6qIwUnFXV+0
         Zr0WSyt6FLszPhKQQ2hOXciis7k7Iu1lymcFlD05NazCFbiAUF970Rm/tutSaPGjpYYo
         mhC9h6AGgGs4OyvZUzWuJWFxo7ZPaxffdulmPK5LLGbS/iRMIFLb67A+iRaBH3NQQRfs
         GTtqmQmvZm5BPkfxj4f7un1zjaIGjkoKnrcE+jHmvEHeMTYtBqZzTJS0hrd6ORUWtH97
         tFYw==
X-Gm-Message-State: APjAAAU1+l4gtCMGgbsp/yx9QWwR+TWTV88GzIdQABYfks4hufCe/zet
        km9yyqqsFdaUhu1bukLSd5D3cA==
X-Google-Smtp-Source: APXvYqwpyC70Qrrsyc8lZf/HQb2fCRoNLquCJ7cfSu071ApXrObrvHcvlPW/LSqb6quFLv5eBME7jw==
X-Received: by 2002:a17:906:85d7:: with SMTP id i23mr15527699ejy.119.1562579847781;
        Mon, 08 Jul 2019 02:57:27 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id 9sm3396949ejf.50.2019.07.08.02.57.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 02:57:27 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DAF96181CE6; Mon,  8 Jul 2019 11:57:26 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Quentin Monnet <quentin.monnet@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBl?= =?utf-8?B?bA==?= 
        <bjorn.topel@gmail.com>
Subject: Re: [PATCH bpf-next v2 6/6] tools: Add definitions for devmap_hash map type
In-Reply-To: <767cade7-4cc4-b47d-a8ca-a30c01e0ba47@netronome.com>
References: <156240283550.10171.1727292671613975908.stgit@alrua-x1> <156240283611.10171.18010849007723279211.stgit@alrua-x1> <767cade7-4cc4-b47d-a8ca-a30c01e0ba47@netronome.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 08 Jul 2019 11:57:26 +0200
Message-ID: <87y318zw55.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quentin Monnet <quentin.monnet@netronome.com> writes:

> 2019-07-06 10:47 UTC+0200 ~ Toke Høiland-Jørgensen <toke@redhat.com>
>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>> 
>> This adds a selftest, syncs the tools/ uapi header and adds the
>> devmap_hash name to bpftool for the new devmap_hash map type.
>> 
>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> ---
>>  tools/bpf/bpftool/map.c                 |    1 +
>>  tools/include/uapi/linux/bpf.h          |    1 +
>>  tools/testing/selftests/bpf/test_maps.c |   16 ++++++++++++++++
>>  3 files changed, 18 insertions(+)
>> 
>> diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
>> index 5da5a7311f13..c345f819b840 100644
>> --- a/tools/bpf/bpftool/map.c
>> +++ b/tools/bpf/bpftool/map.c
>> @@ -37,6 +37,7 @@ const char * const map_type_name[] = {
>>  	[BPF_MAP_TYPE_ARRAY_OF_MAPS]		= "array_of_maps",
>>  	[BPF_MAP_TYPE_HASH_OF_MAPS]		= "hash_of_maps",
>>  	[BPF_MAP_TYPE_DEVMAP]			= "devmap",
>> +	[BPF_MAP_TYPE_DEVMAP_HASH]		= "devmap_hash",
>>  	[BPF_MAP_TYPE_SOCKMAP]			= "sockmap",
>>  	[BPF_MAP_TYPE_CPUMAP]			= "cpumap",
>>  	[BPF_MAP_TYPE_XSKMAP]			= "xskmap",
>> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
>> index cecf42c871d4..8afaa0a19c67 100644
>> --- a/tools/include/uapi/linux/bpf.h
>> +++ b/tools/include/uapi/linux/bpf.h
>> @@ -134,6 +134,7 @@ enum bpf_map_type {
>>  	BPF_MAP_TYPE_QUEUE,
>>  	BPF_MAP_TYPE_STACK,
>>  	BPF_MAP_TYPE_SK_STORAGE,
>> +	BPF_MAP_TYPE_DEVMAP_HASH,
>>  };
>>  
>>  /* Note that tracing related programs such as
>
> Hi Toke, thanks for the bpftool update!
>
> Could you please also complete the documentation and bash completion for
> the map type? We probably want to add the new name to the "bpftool map
> help" message [0], to the manual page [1], and to the bash completion
> file [2].

Sure, can do :)

-Toke
