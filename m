Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF123182704
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 03:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387676AbgCLCVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 22:21:25 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:35626 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387655AbgCLCVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 22:21:25 -0400
Received: by mail-yw1-f68.google.com with SMTP id d79so4168036ywd.2
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 19:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=kpSjTuoEcpBoVHNBONzuuwZ+a7vUHSa7EY8tH7DFXd0=;
        b=2GZ1ig4MYiXXvqaHQxSi6S3QfalBDuJ46vlKR2sNOKauWR37AhZgjJxJ+TFeEVudf2
         N/FZVyuOy+Xqa+40O1MwudCJxGlpMpMOtmYIpQ3gFZyTQAW4TpGY8Y1cMUfXX7+tdNzg
         evVClhnxtdYhm+TlnG4Url2GL66jXpkgGUB8jMrgxFqipD9ZA6YjLQ2Dib0lz5eDA/5p
         iDSYcdYlbuMHgOPU2QnIY98uYDiGJjziagM0SqkoXmupyZKs6rakHg1mVd3g1vyHBRmx
         qZqRs5+0a3wpFc2ST6yfzG6jI6xZiD5cZFUZvUXZ6Wme8CJLeliJLR2MChWfFdDUv+nK
         /49w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=kpSjTuoEcpBoVHNBONzuuwZ+a7vUHSa7EY8tH7DFXd0=;
        b=Q5sm00vkN07mn7w6eObr7Z1p99wS+9hj/Bu8bOlh9PhiDg92IOeb/yZVz5V/6WQC5C
         6t8U4XbgBvu4cC7ASzpe7cGx7iwZQYOJSb4K6tqSIgLjkaRAUZVPK9V0n3as84Aml2GH
         WrGFnxRN+T6kJDWLoEcJYRl8f88vX7gthO9cpL7P2NViqtwCt4MxgAMPwE6AzXBUoLly
         tOtnjnD0RhSHNGKE9FsLJXaK0ViMhI/pcidZKSlU6DM6mBPtideAN4dagZy1bKrWLMlf
         erRObU/011RqqaABQU8v7RM0xlFUefy6yLAM7+TuRTm2b1e1sZccZHc1bK3AJYeLNZsX
         Z2TQ==
X-Gm-Message-State: ANhLgQ2FBIV0B9cRt68AM5/Gig6KxOufp75pl+auXr7SxBUd9j7jy68/
        mZtY2nVhl2wpve9onlZ2xZNQ6Q==
X-Google-Smtp-Source: ADFU+vth5B404ZkT8SR77oAnB35TtBVKqSIcv/Foami4jeWW69UzMvHo+s+hNCTxAk75d0aQIC5qjg==
X-Received: by 2002:a0d:d654:: with SMTP id y81mr6391078ywd.23.1583979684214;
        Wed, 11 Mar 2020 19:21:24 -0700 (PDT)
Received: from sevai ([74.127.202.122])
        by smtp.gmail.com with ESMTPSA id c196sm9485038ywc.65.2020.03.11.19.21.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Mar 2020 19:21:23 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     Petr Machata <petrm@mellanox.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, davem@davemloft.net,
        jiri@mellanox.com, mlxsw@mellanox.com
Subject: Re: [PATCH net-next v2 5/6] selftests: qdiscs: RED: Add taildrop tests
References: <20200311173356.38181-1-petrm@mellanox.com>
        <20200311173356.38181-6-petrm@mellanox.com>
Date:   Wed, 11 Mar 2020 22:21:11 -0400
In-Reply-To: <20200311173356.38181-6-petrm@mellanox.com> (Petr Machata's
        message of "Wed, 11 Mar 2020 19:33:55 +0200")
Message-ID: <85blp25n54.fsf@mojatatu.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Petr Machata <petrm@mellanox.com> writes:

> Add tests for the new "taildrop" flag.
>
> Signed-off-by: Petr Machata <petrm@mellanox.com>
> ---
>
> Notes:
>     v2:
>     - Require nsPlugin in each RED test
>     - Match end-of-line to catch cases of more flags reported than
>       requested
>     - Add a test for creation of non-ECN taildrop, which should fail
>
>  .../tc-testing/tc-tests/qdiscs/red.json       | 68 +++++++++++++++++++
>  1 file changed, 68 insertions(+)
>
> diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json
> index b70a54464897..72676073c658 100644
> --- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json
> +++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json
> @@ -113,5 +113,73 @@
>              "$TC qdisc del dev $DUMMY handle 1: root",
>              "$IP link del dev $DUMMY type dummy"
>          ]
> +    },
> +    {
> +        "id": "53e8",
> +        "name": "Create RED with flags ECN, taildrop",
> +        "category": [
> +            "qdisc",
> +            "red"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root red ecn taildrop limit 1M avpkt 1500 min 100K max 300K",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc red 1: root .* limit 1Mb min 100Kb max 300Kb ecn taildrop $",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "d091",
> +        "name": "Fail to create RED with only taildrop flag",
> +        "category": [
> +            "qdisc",
> +            "red"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root red taildrop limit 1M avpkt 1500 min 100K max 300K",
> +        "expExitCode": "2",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc red",
> +        "matchCount": "0",
> +        "teardown": [
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "af8e",
> +        "name": "Create RED with flags ECN, taildrop, harddrop",
> +        "category": [
> +            "qdisc",
> +            "red"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root red ecn harddrop taildrop limit 1M avpkt 1500 min 100K max 300K",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc red 1: root .* limit 1Mb min 100Kb max 300Kb ecn harddrop taildrop $",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
>      }
>  ]

Reviewed-by: Roman Mashak <mrv@mojatatu.com>
