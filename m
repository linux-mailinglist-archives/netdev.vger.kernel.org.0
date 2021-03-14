Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61DC33A581
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 16:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234046AbhCNPmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 11:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbhCNPmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 11:42:22 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA42C061574
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 08:42:21 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id r24so5884161otp.12
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 08:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=S1WLotiTpKzMumuPPyrYds01OPLOrCqxxWlKJeMg6E8=;
        b=lb404ztdIs2UzXyJUuJ1+eHdzGNrqOEgFUp4ZbsAiic7tEAY//Ctqnr6MrYEYb23+g
         Hcw+kyKmBFwJktWZR+kGD4XZag9MJChFJQK45bOwITvMG4ajUULQ49E1AB4jFo/HjAtk
         2sLI8HtP+6dTm1FA6Gw/RmhTawlwhq1l4dxSQ4Vo5Jwa7DKyvaWqldF1aiU3lNSf9ZrM
         3A/IBIQGaDU7iRLcl+2i+nkC47qFe7xAKrY74AkpfGtJeFgsKkfXfKTxmSmU2V6+bvzM
         y11a/xYtYbu1REhfIhqvsvBuFWJ3RWIjysM1+TuZDV8SiAxmgkJhIC1Va4v26geKaWz9
         Ju2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S1WLotiTpKzMumuPPyrYds01OPLOrCqxxWlKJeMg6E8=;
        b=h8O9Yze+yrOFQ+aM/xTNN8U/KtFLAtTNwqxxxFffBttFMzR9KmVQQ33iHmTD1Vc5Nb
         BI4g+T4xmc4NjZik/HJbsWhDnOWwHTeG5GQ+kbSqEkKWRCKXNgGS6zpLvyjksrqf//1Z
         3A2o36URBcEUvwDr0NBB8ZA375U6dJh0RmlL2znn4WItXTB6Y68I8LkErFp2Hj/a+SKY
         77s1M6H4b8oelMAPvAg78dr1EogEFE7JMKUqjrTs7Je0DZgOs5utEunloJOvDh6m4RQx
         fagZhwHfKFTMig57bzjEeWVwtzV5HjBsuLQzdX8ldFoT8V1VYlYKTV9tDcpdaKcnvjKF
         /XUA==
X-Gm-Message-State: AOAM531zsRrsHHZC8r0+k8Ma55dQn/K/AUiXGQB3+xlJv54rriPjcEcC
        X6G1E7Kqz8PVMWEW1BlJnd4=
X-Google-Smtp-Source: ABdhPJwR4UKoh/DJ5bqa1albUPssaou1cwImwnm8dpD9EsyinOrpz1rL9bDca7BJuSoT5CCT0fstUA==
X-Received: by 2002:a9d:354:: with SMTP id 78mr11066718otv.123.1615736541014;
        Sun, 14 Mar 2021 08:42:21 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id i6sm5818142oto.47.2021.03.14.08.42.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Mar 2021 08:42:20 -0700 (PDT)
Subject: Re: [PATCH net-next 07/10] selftests: fib_nexthops: Test resilient
 nexthop groups
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <cover.1615563035.git.petrm@nvidia.com>
 <30b674759710d76063caafaaa249c6beb309a278.1615563035.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fd42f0ce-baf4-8771-e57e-4a7995d1c1c6@gmail.com>
Date:   Sun, 14 Mar 2021 09:42:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <30b674759710d76063caafaaa249c6beb309a278.1615563035.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/12/21 9:50 AM, Petr Machata wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Add test cases for resilient nexthop groups. Exhaustive forwarding tests
> are added separately under net/forwarding/.
> 
...
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Co-developed-by: Petr Machata <petrm@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
>  tools/testing/selftests/net/fib_nexthops.sh | 517 ++++++++++++++++++++
>  1 file changed, 517 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


