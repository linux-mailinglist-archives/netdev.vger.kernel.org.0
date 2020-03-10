Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0E3D18020F
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 16:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgCJPkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 11:40:04 -0400
Received: from mail-qv1-f65.google.com ([209.85.219.65]:34112 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgCJPkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 11:40:04 -0400
Received: by mail-qv1-f65.google.com with SMTP id o18so6308333qvf.1
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 08:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=zt2Mb0x4NfkJXwv4nmSJ1xYOR2BfFcegw+aNZXjspnU=;
        b=JS3sPgZ0oWQXz0TftbB4Do3j9yu05dmE5TS4z1wXlv0fuwtf8pq0X68DEKLZDJSwIc
         AF5LnC4LfTPyjcRDtUrjrv9JuIA+rCbASz4Ot28D4SjipDUt1p4nig6CVGwtD+MYaqDB
         J84h7QjuFbIMhOR5suiMoPYK4Kq94bMoq15I6awRwaGYS6X17qlv1hrUG1eyA5buljuh
         Pajl/benPZWM3g4Cpn3vuHx88+CeOh4wWHAl3oWKtAb5AfppL7IssrMSkw6rRzyQucw6
         Sg/dI0c3UzMFJiV+cUcYGI1DBJEtxKPCn6bQyoNXZyappuCRmUeyWsGqJMMbmqm/trWJ
         /Mig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=zt2Mb0x4NfkJXwv4nmSJ1xYOR2BfFcegw+aNZXjspnU=;
        b=twKXHV91fid7gKGWANf/9P9kwluGCcefa+bB61t250qGCgfZbWgIh1K63Z/paOXuW2
         hPcFhwljWSrZk2z+E1SKqjFpEwlK3FVU+mPZ6m5lAqYbldqlDZzpwjRaWFUa49KQ9DHI
         t0F9AiEoFiKnO7OWaAMHTWA171mCce/Ai2M7fWAeX+IGRqNXYct+uUlm4rUvRSmZagY9
         5qY1NA35Hdu9H8RRt/jero4IKagehKtAzYM3UEX6QBawXC9JjcQUeYJj8PO/zYCa+/wR
         qdQ/e2AMAq1LA62Sr6OiaK6lcg4ubH/39Tk+p7dMCAJAoQSr/Tv1HrT7lbozOy83L3Q8
         +p+A==
X-Gm-Message-State: ANhLgQ2pHLsw4zDkkGE56d88O5Wzb1O5dAkkNeVuoyN5T54SUT3avjaj
        Iery1NAWMRjk2gDFvVmIOEtqEQ==
X-Google-Smtp-Source: ADFU+vt6o8MOJacxbnYA5BjH2EYIAvyOgrYN2d7DLVHPWdubgq9jrUKAuRLhYDDo1XI9422sbXVlsQ==
X-Received: by 2002:a0c:ea50:: with SMTP id u16mr19545372qvp.30.1583854802923;
        Tue, 10 Mar 2020 08:40:02 -0700 (PDT)
Received: from sevai (69-196-152-194.dsl.teksavvy.com. [69.196.152.194])
        by smtp.gmail.com with ESMTPSA id r10sm23604904qkm.23.2020.03.10.08.40.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Mar 2020 08:40:02 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        petrm@mellanox.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kuba@kernel.org, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 1/6] selftests: qdiscs: Add TDC test for RED
References: <20200309183503.173802-1-idosch@idosch.org>
        <20200309183503.173802-2-idosch@idosch.org>
Date:   Tue, 10 Mar 2020 11:40:00 -0400
In-Reply-To: <20200309183503.173802-2-idosch@idosch.org> (Ido Schimmel's
        message of "Mon, 9 Mar 2020 20:34:58 +0200")
Message-ID: <85a74o5icv.fsf@mojatatu.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ido Schimmel <idosch@idosch.org> writes:

> From: Petr Machata <petrm@mellanox.com>
>
> Add a handful of tests for creating RED with different flags.
>

Thanks for adding new tests in TDC.

Could you give more descriptive names for tests? (Look at
tc-tests/qdiscs/fifo.json or tc-tests/qdiscs/ets.json as examples)

Did you try running this with nsPlugin enabled? I think you would need
to add the following for every test:

"plugins": {
        "requires": "nsPlugin"
}

> Signed-off-by: Petr Machata <petrm@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> ---
>  .../tc-testing/tc-tests/qdiscs/red.json       | 102 ++++++++++++++++++
>  1 file changed, 102 insertions(+)
>  create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json
>
> diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json
> new file mode 100644
> index 000000000000..6c5a4c4e0a45
> --- /dev/null
> +++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json
> @@ -0,0 +1,102 @@
> +[
> +    {
> +        "id": "8b6e",
> +        "name": "RED",
> +        "category": [
> +            "qdisc",
> +            "red"
> +        ],
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true"
> +        ],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root red limit 1M avpkt 1500 min 100K max 300K",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc red 1: root .* limit 1Mb min 100Kb max 300Kb",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY handle 1: root",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    },

[...]

