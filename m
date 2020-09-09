Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0042629CB
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 10:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730061AbgIIIMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 04:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729275AbgIIIMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 04:12:43 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7B4C061755
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 01:12:42 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id y15so1410471wmi.0
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 01:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y4mg3/crLg7i+YSHd//57w46nzas9VKoqhALJzI4hmw=;
        b=SPmrGq+R+6IS8rQk1qz+5m4gmYD+ClPV9BHLLx9ll+4Qu0kFKIglG2p5uaBEbRji9u
         KB10BXSOrdfMTPM70OdFWtQRNQDZbvsmjTTu8zbXcYgV309kTe9QHjipe3BNSZ3sLUdA
         ZxGXPzmNb+wqzaYA/v0CRjDgHXvfcC0zH5w5Tx1ar3HqUA4pk8Si6pY2bKUttsUWo/xc
         TAy/61JaQBBQHcg5T0o8z+GKVpZ3xvxBXIO8v7UBSKse/UGcoioTLPsrpcqpNy1bAcc4
         HugTt9l3L8ugFNLvd0jMRNzLq1ruSfrdphuyhcL31anVGszzX6KpImjYcbZHPmBmWsZG
         +YvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y4mg3/crLg7i+YSHd//57w46nzas9VKoqhALJzI4hmw=;
        b=uBPlhKkv7JOnTv1GuL5Ju23iOysVvfmcVj0nFWqzC+mgfkP1LmemDSLK03mIwfncjx
         4xTaO0Hku8WdFxR88ovhU5Q309a9iJuCYpegpABXqmjgV3HnqQ/kjjKrClebJS4ziI4P
         VCZMB5fciyDJfK0Z/dHhkt7k9wwMzUY6dqJQ26JIsn/RHLBMqKwg8piUeX+96jV0ybnx
         wVMX1JvtST7ufTaWUgZ/yZDSY9gO1QI3zMI6Kjepvv3qtaDJTBYbROtzMPThaVXecwLS
         GYQNo6qUzUnVm86r6Nw18l55e8kaaUe/s29SuVKh4QVwAkwQ21D+TnWrenI7LEseK7LM
         x91w==
X-Gm-Message-State: AOAM533yBpanEeYzhDkR8EWg8O9rI+PjFiNSoys3yi+DpVc5DdtyFUST
        KQ6Jc3SR5Y7GvhP1HrKcNQdAvGUeTzJEsdqRpO0=
X-Google-Smtp-Source: ABdhPJz386Vt9TTjl6o/8TnQOz9XYMOrLHbFAV1hHyyuId1dPk7YaVLl2eu9NlgcKWeci4v4Ohg0wQ==
X-Received: by 2002:a1c:1902:: with SMTP id 2mr2493727wmz.26.1599639161042;
        Wed, 09 Sep 2020 01:12:41 -0700 (PDT)
Received: from [192.168.1.12] ([194.35.119.237])
        by smtp.gmail.com with ESMTPSA id z19sm2679016wmi.3.2020.09.09.01.12.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 01:12:40 -0700 (PDT)
Subject: Re: [PATCH bpf-next 0/2] bpf: detect build errors for man pages for
 bpftool and eBPF helpers
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
References: <20200907164017.30644-1-quentin@isovalent.com>
 <CAEf4BzZNfsSyeJv7VXv-Z0p8EKV=pdDjfQVzNY3X8Y1=oWMwaQ@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <fb5efa4d-5f3d-adcb-a18c-14899c1651b0@isovalent.com>
Date:   Wed, 9 Sep 2020 09:12:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZNfsSyeJv7VXv-Z0p8EKV=pdDjfQVzNY3X8Y1=oWMwaQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/09/2020 04:48, Andrii Nakryiko wrote:
> On Mon, Sep 7, 2020 at 9:40 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> This set aims at improving the checks for building bpftool's documentation
>> (including the man page for eBPF helper functions). The first patch lowers
>> the log-level from rst2man and fix the reported informational messages. The
>> second one extends the script used to build bpftool in the eBPF selftests,
>> so that we also check a documentation build.
>>
>> This is after a suggestion from Andrii Nakryiko.
>>
>> Quentin Monnet (2):
>>   tools: bpftool: log info-level messages when building bpftool man
>>     pages
>>   selftests, bpftool: add bpftool (and eBPF helpers) documentation build
>>
>>  tools/bpf/bpftool/Documentation/Makefile      |  2 +-
>>  .../bpf/bpftool/Documentation/bpftool-btf.rst |  3 +++
>>  .../bpf/bpftool/Documentation/bpftool-gen.rst |  4 ++++
>>  .../bpf/bpftool/Documentation/bpftool-map.rst |  3 +++
>>  .../selftests/bpf/test_bpftool_build.sh       | 23 +++++++++++++++++++
>>  5 files changed, 34 insertions(+), 1 deletion(-)
>>
>> --
>> 2.25.1
>>
> 
> LGTM.
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
> But this still won't be run every time someone makes selftests. We do
> build bpftool during selftests build, so it would be good to run doc
> build there as well to ensure everyone is executing this. But this is
> a good first step for sure.
> 

I see, indeed with this patch we would only build the doc on "make
run_tests", not when building the selftests. I'll send another version
that builds the doc at the same time as we build bpftool then.

I also had another look at rst2man's options, and there's probably
cleaner a way to get rid of the stderr redirection/line counting that
I'm doing in this version. I'll fix that too.

Thanks for the feedback.
Quentin
