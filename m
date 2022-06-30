Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCC456214B
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 19:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236190AbiF3Rbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 13:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235422AbiF3Rbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 13:31:37 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B332D1F63D
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 10:31:36 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id c130-20020a1c3588000000b0039c6fd897b4so2157616wma.4
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 10:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5liJTY0rhHtYnwTJ5DBaS9oTl6h0HQV6t08ouhBj/kA=;
        b=KtXf629MTWCdni/mC3gNiXK1U/Jbq9057JkblUk9nWvUtid0d2DM4K2Jh4MPDTrXlc
         +kG0JQn7j1trXWbQu90DcPzE0gK2QBOZtwoTU49Qlr918JY+WVwHkUzK01flZ95mZZbS
         0KhhAK5/9IRhqQDK0smWOIeX+F6dlrRf3W+S/KDM/dTB8tI6M+lZUpa53nSaJ9Z+TZb/
         eYqOqZ88cje+PV9ej+J7YHjfbUFWj60+gIheMEeSICeFQ8gIlo9yyUQ2HNyj+lJrH2My
         3KWyAMzY9GVvEBQGQtzB/j2kzqVelP2nAwuVJWbUed4jbN4oS8DaNAW/EslrMQn5akdH
         684Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5liJTY0rhHtYnwTJ5DBaS9oTl6h0HQV6t08ouhBj/kA=;
        b=sE3m6gyG/GZPJ6pQOaUJVmlnULGLF63aS+18JzxMcGCWrzD2DMRIHP7vRjaZZILPLP
         5VZ5Jkp6KYmST4NfQLfjCmFqjxsiabwTVr7Y6xTv08kEtHENPQYJ9t0BtEViwX6p9K54
         NziB93Lu9rAjfLND5eh3oNLXamJS08Rs1lkS5mV7pJ+bXhYfxLbM27HZm8KveEehyOrX
         5Hl8f04uB2jva7HDiWXoTQ8u4P0yatWI/mh+5HUUt/Y3oM/EfeGtXhXATPDDKoLd6feC
         G4EXF0lp0JQfasWYQYRrWXmpep7CW7+QZcqMcDc0mfzDylWWt4WmshMxz1/OpSN8KrJQ
         Y80g==
X-Gm-Message-State: AJIora89rGOCjlutgH0wm3VriFtjr/8Ao4ed8WNCwCqGKKPlNfa/Rl4e
        aCAXVfF7zuIgipRLoyAzGkuZQA==
X-Google-Smtp-Source: AGRyM1snKPBg6O3PdlvZTRwmrzAzP7J8puievqaDhqEWhwLoeo4UQ98ZIga7J37iYZiqb3YKKeEbuQ==
X-Received: by 2002:a05:600c:4ed2:b0:397:7493:53e6 with SMTP id g18-20020a05600c4ed200b00397749353e6mr13180452wmq.61.1656610295235;
        Thu, 30 Jun 2022 10:31:35 -0700 (PDT)
Received: from [192.168.178.21] ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id i8-20020a1c3b08000000b00397402ae674sm3506047wma.11.2022.06.30.10.31.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 10:31:34 -0700 (PDT)
Message-ID: <825c69ce-11ac-0675-b310-7c0abab17205@isovalent.com>
Date:   Thu, 30 Jun 2022 18:31:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [PATCH bpf-next] bpftool: Allow disabling features at compile
 time
Content-Language: en-GB
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220629143951.74851-1-quentin@isovalent.com>
 <9ffd4b6b-0073-cfef-5889-cb4d0b838f8e@iogearbox.net>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <9ffd4b6b-0073-cfef-5889-cb4d0b838f8e@iogearbox.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/06/2022 16:16, Daniel Borkmann wrote:
> On 6/29/22 4:39 PM, Quentin Monnet wrote:
>> Some dependencies for bpftool are optional, and the associated features
>> may be left aside at compilation time depending on the available
>> components on the system (libraries, BTF, clang version, etc.).
>> Sometimes, it is useful to explicitly leave some of those features aside
>> when compiling, even though the system would support them. For example,
>> this can be useful:
>>
>>      - for testing bpftool's behaviour when the feature is not present,
>>      - for copmiling for a different system, where some libraries are
>>        missing,
>>      - for producing a lighter binary,
>>      - for disabling features that do not compile correctly on older
>>        systems - although this is not supposed to happen, this is
>>        currently the case for skeletons support on Linux < 5.15, where
>>        struct bpf_perf_link is not defined in kernel BTF.
>>
>> For such cases, we introduce, in the Makefile, some environment
>> variables that can be used to disable those features: namely,
>> BPFTOOL_FEATURE_NO_LIBBFD, BPFTOOL_FEATURE_NO_LIBCAP, and
>> BPFTOOL_FEATURE_NO_SKELETONS.
>>
>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
>> ---
>>   tools/bpf/bpftool/Makefile | 20 ++++++++++++++++++--
>>   1 file changed, 18 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
>> index c19e0e4c41bd..b3dd6a1482f6 100644
>> --- a/tools/bpf/bpftool/Makefile
>> +++ b/tools/bpf/bpftool/Makefile
>> @@ -93,8 +93,24 @@ INSTALL ?= install
>>   RM ?= rm -f
>>     FEATURE_USER = .bpftool
>> -FEATURE_TESTS = libbfd disassembler-four-args zlib libcap \
>> -    clang-bpf-co-re
>> +FEATURE_TESTS := disassembler-four-args zlib
>> +
>> +# Disable libbfd (for disassembling JIT-compiled programs) by setting
>> +# BPFTOOL_FEATURE_NO_LIBBFD
>> +ifeq ($(BPFTOOL_FEATURE_NO_LIBBFD),)
>> +  FEATURE_TESTS += libbfd
>> +endif
>> +# Disable libcap (for probing features available to unprivileged
>> users) by
>> +# setting BPFTOOL_FEATURE_NO_LIBCAP
>> +ifeq ($(BPFTOOL_FEATURE_NO_LIBCAP),)
>> +  FEATURE_TESTS += libcap
>> +endif
> 
> The libcap one I think is not really crucial, so that lgtm. The other
> ones I would
> keep as requirement so we don't encourage distros to strip away needed
> functionality
> for odd reasons. At min, I think the libbfd is a must, imho.

Thanks Daniel, that's a legitimate concern. Probably best to avoid
offering an easy option to disable the features in that case - I can
live with Makefile edits if I need to test a different feature set.
Please drop this patch.

Thanks,
Quentin

