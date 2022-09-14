Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F165B899E
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 16:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiINN7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 09:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiINN7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 09:59:42 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B2510B4
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 06:59:30 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-1274ec87ad5so41270022fac.0
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 06:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=ecbcgh2XCDEUm+/ZfRl2Y++otYHA08IMV0flQG/03d0=;
        b=5Jq5xTvsbatkEnvLYlO8cJCA6nnkbYsZRKMR4rC5ok5aOzmad+yCdJcxNtKR2hI1/7
         dky3w9E3OyZ0SpWi0TL+Yv0qYQ9p/qljlCf8hK2WAWO3dHdg0uplU5DrSWiHbJIf5oWs
         q+jZ5lf68Qz0CurUButJscXGCDR29OyE1TunaVjyiG91C81PsHHuKIdz4QwNMA8+oduB
         +DSeLTh/CwdiAhIKgptyZ6DAVry2zYPmOzxYPSLBkse6wQojfo8W8UJXLbYEi/06BJur
         TzfymoIdG+jq8TcynA0dLw2J+CG0qfPdAiU52RkBYjTSXXTfeayxArpV0v9LEoeOHkcT
         ebfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ecbcgh2XCDEUm+/ZfRl2Y++otYHA08IMV0flQG/03d0=;
        b=pePEnIvNM8xtKT4Gm26wiMthgHRM/JKceBU/AMOkGGKoW9DKYLgQeCMASRK3EHk8JI
         jxu7tOfgYjUxMV+AJqbRmIObM9iSXndbi55cv5mcQAkO9He8RYv8XM9uKhO9rRVcjSky
         arzsTxZ5/55IiS1KrinGVC2RplQb3DYH6gToe3M8O2Gl6rX/soJyF29ZDIHrOZkxWE+6
         9CXJyTfq8tqvtpXEfZ39qLy8RuwbL+8bkW/xk671yXZVwM5gw/qvBZbhBDQDiT2pNaNx
         DcCAPxwX3XUG4r0RGVBvaX7j5b3PJYrx/4jCLQ2pl0Sr7bMcmU/DC21brItD0M6I/NXg
         L9Qw==
X-Gm-Message-State: ACgBeo2BwpZBqQPVLdx7R59Y/oshnRjMPHO94r1feXLGybKIIb1e9+cU
        IwyrpCsM02As7DITIgGiLRsAmw==
X-Google-Smtp-Source: AA6agR7uD9WqW+dsmzFhRQ2MR92bHGsF973mlKH8DU0aiXXyzuHoSC5wjKJuYsnSaycraul8nJ93Tw==
X-Received: by 2002:a05:6808:1985:b0:34f:c592:b8c2 with SMTP id bj5-20020a056808198500b0034fc592b8c2mr2056535oib.3.1663163969556;
        Wed, 14 Sep 2022 06:59:29 -0700 (PDT)
Received: from ?IPV6:2804:1b3:7000:d095:41f2:210c:b643:8576? ([2804:1b3:7000:d095:41f2:210c:b643:8576])
        by smtp.gmail.com with ESMTPSA id c8-20020a056870b28800b001275f056133sm8487765oao.51.2022.09.14.06.59.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Sep 2022 06:59:29 -0700 (PDT)
Message-ID: <cf1bb615-09b9-a252-01fe-4192461307a9@mojatatu.com>
Date:   Wed, 14 Sep 2022 10:59:23 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net-next 3/9] selftests/tc-testings: add selftests for bpf
 filter
Content-Language: en-US
To:     Zhengchao Shao <shaozhengchao@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        jhs@mojatatu.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        shuah@kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
References: <20220913042135.58342-1-shaozhengchao@huawei.com>
 <20220913042135.58342-4-shaozhengchao@huawei.com>
From:   Victor Nogueira <victor@mojatatu.com>
In-Reply-To: <20220913042135.58342-4-shaozhengchao@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/09/2022 01:21, Zhengchao Shao wrote:
> Test 23c3: Add cBPF filter with valid bytecode
> Test 1563: Add cBPF filter with invalid bytecode
> Test 2334: Add eBPF filter with valid object-file
> Test 2373: Add eBPF filter with invalid object-file
> Test 4423: Replace cBPF bytecode
> Test 5122: Delete cBPF filter
> Test e0a9: List cBPF filters
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>   .../tc-testing/tc-tests/filters/bpf.json      | 171 ++++++++++++++++++
>   1 file changed, 171 insertions(+)
>   create mode 100644 tools/testing/selftests/tc-testing/tc-tests/filters/bpf.json
> 
> diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/bpf.json b/tools/testing/selftests/tc-testing/tc-tests/filters/bpf.json
> new file mode 100644
> index 000000000000..c679588f65fd
> --- /dev/null
> +++ b/tools/testing/selftests/tc-testing/tc-tests/filters/bpf.json
> @@ -0,0 +1,171 @@
> +[
> +    {
> +        "id": "23c3",
> +        "name": "Add cBPF filter with valid bytecode",
> +        "category": [
> +            "filter",
> +            "bpf"
> +        ],
> +	"plugins": {

Just a nit-pick, there are some places where you are using tabs instead 
of spaces. Mostly when specifying the plugins, like in the line above.

This goes for the other test patches in this set as well.

> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$TC qdisc add dev $DEV1 ingress"
> +        ],
> +        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf bytecode '4,40 0 0 12,21 0 1 2048,6 0 0 262144,6 0 0 0'",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf",
> +        "matchPattern": "filter parent ffff: protocol ip pref 100 bpf chain [0-9]+ handle 0x1.*bytecode '4,40 0 0 12,21 0 1 2048,6 0 0 262144,6 0 0 0'",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DEV1 ingress"
> +        ]
> +    },
> +    {
> +        "id": "1563",
> +        "name": "Add cBPF filter with invalid bytecode",
> +        "category": [
> +            "filter",
> +            "bpf"
> +        ],
> +	"plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$TC qdisc add dev $DEV1 ingress"
> +	]
> +        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf bytecode '4,40 0 0 12,31 0 1 2048,6 0 0 262144,6 0 0 0'",
> +        "expExitCode": "2",
> +        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf",
> +        "matchPattern": "filter parent ffff: protocol ip pref 100 bpf chain [0-9]+ handle 0x1.*bytecode '4,40 0 0 12,21 0 1 2048,6 0 0 262144,6 0 0 0'",
> +        "matchCount": "0",
> +        "teardown": [
> +            "$TC qdisc del dev $DEV1 ingress"
> +        ]
> +    },
> +    {
> +        "id": "2334",
> +        "name": "Add eBPF filter with valid object-file",
> +        "category": [
> +            "filter",
> +            "bpf"
> +        ],
> +        "plugins": {
> +                "requires": "buildebpfPlugin"
> +        },
> +        "setup": [
> +            "$TC qdisc add dev $DEV1 ingress"
> +	],
> +        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf object-file $EBPFDIR/action.o section action-ok",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf",
> +        "matchPattern": "filter parent ffff: protocol ip pref 100 bpf chain [0-9]+ handle 0x1 action.o:\\[action-ok\\].*tag [0-9a-f]{16}( jited)?",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DEV1 ingress"
> +        ]
> +    },
> +    {
> +        "id": "2373",
> +        "name": "Add eBPF filter with invalid object-file",
> +        "category": [
> +            "filter",
> +            "bpf"
> +        ],
> +        "plugins": {
> +                "requires": "buildebpfPlugin"
> +        },
> +        "setup": [
> +            "$TC qdisc add dev $DEV1 ingress"
> +	],
> +        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf object-file $EBPFDIR/action.o section action-ko",
> +        "expExitCode": "1",
> +        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf",
> +        "matchPattern": "filter parent ffff: protocol ip pref 100 bpf chain [0-9]+ handle 0x1 action.o:\\[action-ko\\].*tag [0-9a-f]{16}( jited)?",
> +        "matchCount": "0",
> +        "teardown": [
> +            "$TC qdisc del dev $DEV1 ingress"
> +	]
> +    },
> +    {
> +        "id": "4423",
> +        "name": "Replace cBPF bytecode",
> +        "category": [
> +            "filter",
> +            "bpf"
> +        ],
> +	"plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$TC qdisc add dev $DEV1 ingress",
> +            [
> +                "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf bytecode '4,40 0 0 12,21 0 1 2048,6 0 0 262144,6 0 0 0'",
> +                0,
> +                1,
> +                255
> +            ]
> +        ],
> +        "cmdUnderTest": "$TC filter replace dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf bytecode '4,40 0 0 12,21 0 1 2054,6 0 0 262144,6 0 0 0'",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf",
> +        "matchPattern": "filter parent ffff: protocol ip pref 100 bpf chain [0-9]+ handle 0x1.*bytecode '4,40 0 0 12,21 0 1 2054,6 0 0 262144,6 0 0 0'",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DEV1 ingress"
> +	]
> +    },
> +    {
> +        "id": "5122",
> +        "name": "Delete cBPF filter",
> +        "category": [
> +            "filter",
> +            "bpf"
> +        ],
> +	"plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$TC qdisc add dev $DEV1 ingress",
> +	    [
> +                "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf bytecode '4,40 0 0 12,21 0 1 2048,6 0 0 262144,6 0 0 0'",
> +                0,
> +                1,
> +                255
> +            ]
> +        ],
> +        "cmdUnderTest": "$TC filter del dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf",
> +        "matchPattern": "filter parent ffff: protocol ip pref 100 bpf chain [0-9]+ handle 0x1.*bytecode '4,40 0 0 12,21 0 1 2048,6 0 0 262144,6 0 0 0'",
> +        "matchCount": "0",
> +        "teardown": [
> +            "$TC qdisc del dev $DEV1 ingress"
> +	]
> +    },
> +    {
> +        "id": "e0a9",
> +        "name": "List cBPF filters",
> +        "category": [
> +            "filter",
> +            "bpf"
> +        ],
> +	"plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$TC qdisc add dev $DEV1 ingress",
> +	    "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf bytecode '4,40 0 0 12,21 0 1 2048,6 0 0 262144,6 0 0 0'",
> +            "$TC filter add dev $DEV1 parent ffff: handle 2 protocol ip prio 100 bpf bytecode '4,40 0 0 12,21 0 1 2054,6 0 0 262144,6 0 0 0'",
> +            "$TC filter add dev $DEV1 parent ffff: handle 100 protocol ip prio 100 bpf bytecode '4,40 0 0 12,21 0 1 33024,6 0 0 262144,6 0 0 0'"
> +        ],
> +        "cmdUnderTest": "$TC filter show dev $DEV1 parent ffff:",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
> +	"matchPattern": "filter protocol ip pref 100 bpf chain [0-9]+ handle",
> +        "matchCount": "3",
> +        "teardown": [
> +            "$TC qdisc del dev $DEV1 ingress"
> +        ]
> +    }
> +]
