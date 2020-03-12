Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92216182702
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 03:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387670AbgCLCUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 22:20:53 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:38657 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387655AbgCLCUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 22:20:53 -0400
Received: by mail-yw1-f67.google.com with SMTP id 10so4155040ywv.5
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 19:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=mJO0gPfRVjyzJQO11qElbN2uFcbtpT5CCTcTA+OdWrc=;
        b=v+L1Ey1UIF2qf1wfmJGouGAxO0c+m/+IRNtwaRuhOqpH/+XE2y2KnPN08BMNowt2R1
         OHKo+l0c8vsYNP6JuudJJ3nTiesfk3vwealGP+tERZhuSEX+es4sIiGSG0qTvvlfjm37
         x96exZaEbDRZ86lK58tLVDHWjmd1vOGMnIDXupM19t/GD0CHb63eGBJb4GCDn+ZudrbJ
         rqIh2CAE4fEux6eiechwHBkR8QzXGYYkOPbwLejblkS92RGzmfnP16kZH+7kmoGhpc2q
         l5yyn21QCgOq59WWunlRnWLP7SX5tG/2wJkZ+5Np2BrpAn4D3Pcy3eGAlpL3gLlUob5P
         irIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=mJO0gPfRVjyzJQO11qElbN2uFcbtpT5CCTcTA+OdWrc=;
        b=Or2YMCV5bp009TFxjhIhlOjwd73sh+5Zim9KqldlI/tcfMCWyj++bruHg99w+t1yry
         jW5Z2hLqw+BMm9g2ZNo14B4ARSehc8O+4tnaidqSKcn9TQ5ZHjiBQG1u44k0XuX/5M21
         drZVFUO7qM2Z/RrtKE5NJl2XqStcsfMcsBtaw/zdb+imGaII0s8kjucGDy7hudlTITAU
         fAgd2Vl8e3hwWnAhtPkz2Wl9MvROvhj+cNBTXyrAIws39FeL/5lDjqjXtZHEEWc15bpJ
         JaPGRk1SAccHwUpehRFmV52dOa6VH6FDayTcxZ26B68zFCGbtgnj83ZLvyL3j3qJlDd7
         GhzA==
X-Gm-Message-State: ANhLgQ0UHWM1rQwGMSUSFD7pcQcYqlUHFZ1krHSZCMDYr/hw+2Z+/dKW
        KXde2pMUsVMw1A+L9sQoKjiq3sAbS2E=
X-Google-Smtp-Source: ADFU+vt74rE93qfiMYpjNBt9FIN1E8IWbr2Xj5ifKWR/FhjC0cK6pW2OwYjxqea/I68KdT2PK88+kA==
X-Received: by 2002:a25:ad1c:: with SMTP id y28mr6142005ybi.291.1583979651722;
        Wed, 11 Mar 2020 19:20:51 -0700 (PDT)
Received: from sevai ([74.127.202.122])
        by smtp.gmail.com with ESMTPSA id q2sm19929479ywh.71.2020.03.11.19.20.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Mar 2020 19:20:51 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     Petr Machata <petrm@mellanox.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, davem@davemloft.net,
        jiri@mellanox.com, mlxsw@mellanox.com
Subject: Re: [PATCH net-next v2 1/6] selftests: qdiscs: Add TDC test for RED
References: <20200311173356.38181-1-petrm@mellanox.com>
        <20200311173356.38181-2-petrm@mellanox.com>
Date:   Wed, 11 Mar 2020 22:20:34 -0400
In-Reply-To: <20200311173356.38181-2-petrm@mellanox.com> (Petr Machata's
        message of "Wed, 11 Mar 2020 19:33:51 +0200")
Message-ID: <85ftee5n65.fsf@mojatatu.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Petr Machata <petrm@mellanox.com> writes:

> Add a handful of tests for creating RED with different flags.
>
> Signed-off-by: Petr Machata <petrm@mellanox.com>
> ---
>
> Notes:
>     v2:
>     - Require nsPlugin in each RED test
>     - Match end-of-line to catch cases of more flags reported than
>       requested
>
>  .../tc-testing/tc-tests/qdiscs/red.json       | 117 ++++++++++++++++++
>  1 file changed, 117 insertions(+)
>  create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json
>
> diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json
> new file mode 100644
> index 000000000000..b70a54464897
> --- /dev/null
> +++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json
> @@ -0,0 +1,117 @@
> +[
> +    {
> +        "id": "8b6e",
> +        "name": "Create RED with no flags",
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
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root red limit 1M avpkt 1500 min 100K max 300K",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc red 1: root .* limit 1Mb min 100Kb max 300Kb $",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "342e",
> +        "name": "Create RED with adaptive flag",
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
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root red adaptive limit 1M avpkt 1500 min 100K max 300K",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc red 1: root .* limit 1Mb min 100Kb max 300Kb adaptive $",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "2d4b",
> +        "name": "Create RED with ECN flag",
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
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root red ecn limit 1M avpkt 1500 min 100K max 300K",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc red 1: root .* limit 1Mb min 100Kb max 300Kb ecn $",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "650f",
> +        "name": "Create RED with flags ECN, adaptive",
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
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root red ecn adaptive limit 1M avpkt 1500 min 100K max 300K",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc red 1: root .* limit 1Mb min 100Kb max 300Kb ecn adaptive $",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },
> +    {
> +        "id": "5f15",
> +        "name": "Create RED with flags ECN, harddrop",
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
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root red ecn harddrop limit 1M avpkt 1500 min 100K max 300K",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc red 1: root .* limit 1Mb min 100Kb max 300Kb ecn harddrop $",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    }
> +]

Reviewed-by: Roman Mashak <mrv@mojatatu.com>
