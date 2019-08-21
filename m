Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A152297A1D
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 14:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbfHUM6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 08:58:33 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38078 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728556AbfHUM6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 08:58:30 -0400
Received: by mail-wr1-f65.google.com with SMTP id g17so1950271wrr.5
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 05:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:openpgp:autocrypt:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bO+vfaZtlAaiMfBYUy9u7bZwcwjqEWTUIEDMwqosQL0=;
        b=v0hxOWeWM+JZneL0ed0Bk+EzZsECgxn/A+tZykSkd28Y435KFehstGD2NsmRN4T+Ns
         kWkTqe+iuBJUhORNNn/x4zuOO3c1tu9O1WzFjuh7h+gtUcLgK001TtBjTT40HaqUPDZL
         5xMLmKJkMOI575JJb2ZwWM7bK+m+zenqVxTTQMzKZ6mhnGTW3FPpZkihd65xTzTienwR
         nQsxlkj5fIEkg+Jo3hTmNnlCtF24dNE5rsEnPIzQmGyg+1ifNb4u5g2T8hx9laQIUdLZ
         ESv/8VS5bzUgQhX/LxX4g93m+htzwny4us8yuVjeebSFkYXSNc/MAHQjGtiM87ozBqZd
         R2qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:openpgp:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=bO+vfaZtlAaiMfBYUy9u7bZwcwjqEWTUIEDMwqosQL0=;
        b=I2+Q0tpPY0/XZq9FLY1VFPJbHdh5iQlWvIpoHPnX4qJxdw1EjNY2lXjz6zSv/EKXuy
         A7zWftg3Nw9b1PssdxYnWA45Md299Hn/qY1lDCQpr7RD+0xV/5ERZFaaJbxhTo7Oy+cA
         jsr13v24CPx+7tag7eJMswTp2Bo9dErIVghDsh2nwVaNkP0A6iVVzF7XK1nC07SsRhCM
         e3WUA6SEXybwGjVAn8/5TBSoS+JLJEZowaOQuwARQKtstfSgZovhqC0iN+V1YLO4pweA
         Z3BxtdPMpEi6EJamIuU2QkwpI4ZBamoVBeUqkkPuJBNytgfkVjFafuwoyx6aS+/I2wVn
         eDcw==
X-Gm-Message-State: APjAAAUnHKSomAk/LsV/bEw2gzpeB4ZLeO2btDPRdVY9pPk+3m1KdtiH
        pqmSxG/xOiC6FHfJgDfckZAMpg==
X-Google-Smtp-Source: APXvYqzThIEh6tsTtbLt2y/SOycgaxAZOPVCAk8PVMyFv4TOq5BvvRNTzUyno3nYqYMalhFTE1pKLg==
X-Received: by 2002:a5d:6b84:: with SMTP id n4mr15715599wrx.118.1566392307480;
        Wed, 21 Aug 2019 05:58:27 -0700 (PDT)
Received: from [172.20.1.254] ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id w13sm49776194wre.44.2019.08.21.05.58.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 05:58:26 -0700 (PDT)
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com
References: <20190821085219.30387-1-quentin.monnet@netronome.com>
 <20190821085219.30387-3-quentin.monnet@netronome.com>
 <b44cf34c-b6d5-a3f5-f386-e70791e47229@iogearbox.net>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quentin.monnet@netronome.com; prefer-encrypt=mutual; keydata=
 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
 RHhSHGnKaQ6MfrTge5Q0h5A=
Subject: Re: [PATCH bpf-next 2/2] tools: bpftool: add "bpftool map freeze"
 subcommand
Message-ID: <2b6d7326-fc74-288b-fa52-b79752222123@netronome.com>
Date:   Wed, 21 Aug 2019 13:58:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <b44cf34c-b6d5-a3f5-f386-e70791e47229@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-08-21 13:40 UTC+0200 ~ Daniel Borkmann <daniel@iogearbox.net>
> On 8/21/19 10:52 AM, Quentin Monnet wrote:
>> Add a new subcommand to freeze maps from user space.
>>
>> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
>> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>> ---
>>   .../bpf/bpftool/Documentation/bpftool-map.rst |  9 +++++
>>   tools/bpf/bpftool/bash-completion/bpftool     |  4 +--
>>   tools/bpf/bpftool/map.c                       | 34 ++++++++++++++++++-
>>   3 files changed, 44 insertions(+), 3 deletions(-)
>>
>> diff --git a/tools/bpf/bpftool/Documentation/bpftool-map.rst
>> b/tools/bpf/bpftool/Documentation/bpftool-map.rst
>> index 61d1d270eb5e..1c0f7146aab0 100644
>> --- a/tools/bpf/bpftool/Documentation/bpftool-map.rst
>> +++ b/tools/bpf/bpftool/Documentation/bpftool-map.rst
>> @@ -36,6 +36,7 @@ MAP COMMANDS
>>   |    **bpftool** **map pop**        *MAP*
>>   |    **bpftool** **map enqueue**    *MAP* **value** *VALUE*
>>   |    **bpftool** **map dequeue**    *MAP*
>> +|    **bpftool** **map freeze**     *MAP*
>>   |    **bpftool** **map help**
>>   |
>>   |    *MAP* := { **id** *MAP_ID* | **pinned** *FILE* }
>> @@ -127,6 +128,14 @@ DESCRIPTION
>>       **bpftool map dequeue**  *MAP*
>>             Dequeue and print **value** from the queue.
>>   +    **bpftool map freeze**  *MAP*
>> +          Freeze the map as read-only from user space. Entries from a
>> +          frozen map can not longer be updated or deleted with the
>> +          **bpf\ ()** system call. This operation is not reversible,
>> +          and the map remains immutable from user space until its
>> +          destruction. However, read and write permissions for BPF
>> +          programs to the map remain unchanged.
> 
> That is not correct, programs that are loaded into the system /after/
> the map
> has been frozen cannot modify values either, thus read-only from both
> sides.
> 
> Thanks,
> Daniel

Hi Daniel,

Are you entirely sure about it? I could not find the relevant
restriction in the code, the checks seem to be on map flags
(BPF_F_RDONLY) which do not seem to be modified by the "frozen" status
in map_freeze()? And tests I ran on my side seem to indicate the map can
still be updated by new programs. Did I miss something?

Tested on 5.3.0-rc1:

1. Create hash map
2. Load BPF program foo, using map
3. Test-run program foo - map is updated
4. Freeze map - update effectively becomes impossible from user space
5. Load BPF program bar, using same map
6. Test-run program bar - map is still updated

Best regards,
Quentin
