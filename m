Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3601869B62F
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 00:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjBQXIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 18:08:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjBQXIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 18:08:39 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C0AC67D;
        Fri, 17 Feb 2023 15:08:38 -0800 (PST)
Message-ID: <12ea2782-5215-46ba-3687-575e91287309@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676675316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0c1sASh6r0c4ZcdECXd0VwSvQd9qA6WNt9795mNIsXE=;
        b=AZdcM0vUmO7Gq0ESPwmhIVEZ4EvFTodgCKZPUATUMLftkZEKjCEgSR11Wvde79tCOHPXdE
        OjsfNsu5L2ZPpI8MyiW0WIwkpx7q2VUNSuhKgj8Ry2MOoF+fFz+jjNdtTu7CdvJEtXfS9n
        ovKnoMoQ8aIs4rEAdyNC8eAwWchp97c=
Date:   Fri, 17 Feb 2023 15:08:33 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next 4/4] selftests/bpf: Add bpf_fib_lookup test
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        kernel-team@meta.com
References: <20230217004150.2980689-1-martin.lau@linux.dev>
 <20230217004150.2980689-5-martin.lau@linux.dev>
 <CAEf4BzYL_K5Z3K-M394FeaQp87YozmqyUR8i=PaSfU7aCM=P+g@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CAEf4BzYL_K5Z3K-M394FeaQp87YozmqyUR8i=PaSfU7aCM=P+g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/17/23 3:02 PM, Andrii Nakryiko wrote:
>> +#define SYS(fmt, ...)                                          \
>> +       ({                                                      \
>> +               char cmd[1024];                                 \
>> +               snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__); \
>> +               if (!ASSERT_OK(system(cmd), cmd))               \
>> +                       goto fail;                              \
>> +       })
> 
> it's probably a high time to move this SYS() macro into test_progs.h
> and stop copy/pasting it across many test?

Make sense. will follow up.

