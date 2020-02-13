Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC37E15CB97
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 21:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387397AbgBMUAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 15:00:25 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:51547 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727910AbgBMUAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 15:00:24 -0500
Received: by mail-pj1-f66.google.com with SMTP id fa20so2845891pjb.1;
        Thu, 13 Feb 2020 12:00:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7zNWtKUJHoek7tX6KN5yHzkwTD50SXdtF49klgds63w=;
        b=Ge5DB+gxR4EOP+lTDQ3adyNCo1HDVCkNwHphQnRwHHDD0wylg0usLBGFpUWtcVW8Ee
         98bVBeqTN7ygFyAutPvD7/LOQ8A5uooRuUig3lvoVm+SI6nMRiyAxve6n/2JEQ3jvwai
         s/7PQE8D+tZvDE80ZQYWmwzn+SGbqyHiK+w1qOo2RwSz4JRiJDTKr0fpess2GX6978u1
         bNfOvOa+/gDi++23dku389FH8YsqWeMF3EMIsWae0/xRR7Agy9fafajAAIkBxQ5MnEDV
         WQmFcgS751Cyg1Zic+ieNOycvG4clAFsA8OTrPuz7vIOgTKgpb5c/+dH+2coTXIiSsMf
         Hh5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7zNWtKUJHoek7tX6KN5yHzkwTD50SXdtF49klgds63w=;
        b=VoXJBtDwq1kiQTSxozlegHeqI0qfB/b6u32uTNJCvafDuwbJ7SEh/deda8THzSWOse
         d3n+BapWMALry+U2GfNToZHfl7+k5K5146wz1o84dF6Nfoehs5kQ/IGZvAVKrUt2AFJM
         SYnymzsw0wDXhCXoJD1LntswyzW7UHc85juX8dXiiu12ss7f7ntfz4hjsYVFHg0RBMwa
         ScNA8vc9gnLtmnUfc5+UziUTSQIN4YAJZEbrYtxd03fVOLFEaWLYrVSnjX3/3U/uHkVg
         6hoUWxeXpzyjZr4SgfKdDjiQm6w9oRKOUR8Rr1V2nNswfbY/kfrYSiGwFbaWbESkGXJj
         MbMA==
X-Gm-Message-State: APjAAAUy4gN+x3SkbvWGVIgDUiyaJrlZMJfL//C2YW+JbrT8r033ksw4
        XV6H8NHjfn1uMtu6QUviYoc=
X-Google-Smtp-Source: APXvYqxrbb7grYzIdTdSfic9sPeYzOOlTp0B0yWzUqe5aLDoN7IoykLfytqJ3FVK6jUh17KuriOfVQ==
X-Received: by 2002:a17:902:a588:: with SMTP id az8mr15533441plb.123.1581624023960;
        Thu, 13 Feb 2020 12:00:23 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id z29sm4378794pgc.21.2020.02.13.12.00.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2020 12:00:23 -0800 (PST)
Subject: Re: WARNING in dev_change_net_namespace
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        syzbot <syzbot+830c6dbfc71edc4f0b8f@syzkaller.appspotmail.com>
Cc:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, dsahern@gmail.com,
        hawk@kernel.org, jiri@mellanox.com, johannes.berg@intel.com,
        john.fastabend@gmail.com, kafai@fb.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mkubecek@suse.cz,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
References: <000000000000c54420059e4f08ff@google.com>
 <878sl6fh2a.fsf@x220.int.ebiederm.org>
 <4802635e-0ef1-b96c-e596-fa83cd597e20@gmail.com>
Message-ID: <a116fc12-92ea-7609-1d60-4fd90939141a@gmail.com>
Date:   Thu, 13 Feb 2020 12:00:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <4802635e-0ef1-b96c-e596-fa83cd597e20@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/13/20 11:57 AM, Eric Dumazet wrote:
> 
> 
> On 2/13/20 11:00 AM, Eric W. Biederman wrote:
>> syzbot <syzbot+830c6dbfc71edc4f0b8f@syzkaller.appspotmail.com> writes:
>>
>>> Hello,
>>
>> Has someone messed up the network device kobject support.
>> I don't have the exact same code as listed here so I may
>> be misreading things.  But the only WARN_ON I see in
>> dev_change_net_namespaces is from kobject_rename.
>>
>> It is not supposed to be possible for that to fail.
> 
> Well, this code is attempting kmalloc() calls, so can definitely fail.
> 
> syzbot is using fault injection to force few kmalloc() to return NULL

[  533.360275][T24839] FAULT_INJECTION: forcing a failure.
[  533.360275][T24839] name failslab, interval 1, probability 0, space 0, times 0
[  533.418952][T24839] CPU: 0 PID: 24839 Comm: syz-executor.4 Not tainted 5.6.0-rc1-syzkaller #0
[  533.427669][T24839] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
[  533.437873][T24839] Call Trace:
[  533.441188][T24839]  dump_stack+0x1fb/0x318
[  533.445677][T24839]  should_fail+0x4b8/0x660
[  533.450125][T24839]  __should_failslab+0xb9/0xe0
[  533.454913][T24839]  ? kzalloc+0x21/0x40
[  533.459000][T24839]  should_failslab+0x9/0x20
[  533.463524][T24839]  __kmalloc+0x7a/0x340
[  533.467698][T24839]  kzalloc+0x21/0x40
[  533.471604][T24839]  kobject_rename+0x12f/0x4d0
[  533.476399][T24839]  ? sysfs_rename_link_ns+0x179/0x1b0
[  533.481782][T24839]  device_rename+0x16d/0x190
[  533.486380][T24839]  dev_change_net_namespace+0x1375/0x16b0
[  533.492550][T24839]  ? ns_capable+0x91/0xf0
[  533.496900][T24839]  ? netlink_ns_capable+0xcf/0x100
[  533.502038][T24839]  ? rtnl_link_get_net_capable+0x136/0x280
[  533.508470][T24839]  do_setlink+0x196/0x3880
[  533.512943][T24839]  ? __kasan_check_read+0x11/0x20
[  533.517992][T24839]  rtnl_newlink+0x1509/0x1c00

