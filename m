Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D5F34E8E8
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 15:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbhC3NW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 09:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbhC3NWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 09:22:20 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39047C061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 06:22:20 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id g20so8368053wmk.3
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 06:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JsP35BirHCdgsezypIrQJ0waxDBG5JUsFgZjJoWO1Ow=;
        b=PlYmaCgdtfvlCZW7YbbVS8QGeQB7CUASe9yWevMyT15MsJty1/mgq5HnPb3sf+xZnx
         hSQSjivBsOQRziRfUaQ5g3bAUR+1PY9aqyYbyHZUqfkx8t6lNTehQxzqqlBkLeunyOmg
         PLpRJCOArsPoWx8iRTb8GP5JesRqiu6G9tYNcEQ/zd4aBWiwbRrO3vxydJJ9/H5ZWHDS
         Gu0OW9xNFDxbWUJyFjia898CfexksosUjsa0yCV9ga+ADjGRzjAgsV1CH5QQOuxISRLp
         3KrpmuGzL+Rsz90GOLs0QEMBv5BeiG5PKPykeF1Vduk95M6xewkF8x51p4JkxPvca3iU
         9v+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JsP35BirHCdgsezypIrQJ0waxDBG5JUsFgZjJoWO1Ow=;
        b=kthNC2hTSMDaNYMKzOK8d92HZck/p9iiPa48w8TwYZDNUHtqxUCT78W9QQE1OmdpK+
         edbweyufE5UvkSpNEjRZRvj6W2jNsZkE+OzNKQ2Q25HhWDuYFtJt8ORDCgW3yHkHvygm
         P/e9nfWY5uxyZooqeI7h56i/lAcPOjKPJ3gPH80TeOnrlXcxNkTKXLj5Rm9i56AcprSw
         TgX8EcsEbp0Qb5jYUaTzodldzLAFmyLLXVDMEKBub/xBa7c7pkOwZNRrS9s0GjcL7+3s
         qiAZuQPWO+d+x5v+bFXLUYzygz6g/iZ0t1ExDjUEhJTYojkmtBqrqHdPJE87CqjUJJHT
         cjeg==
X-Gm-Message-State: AOAM532P5n2dWBol3kiT9c3v36fS7YflfCEZeK7emlF8c1uMDaacNSjP
        iiarkcyRGW4lXIvOlYvMyTA=
X-Google-Smtp-Source: ABdhPJxZqH+P5eg09kQqJDq+yj/jsS++880YqTJxuVEVRmKJUCl7ZKJrYGHqts5D8FIKwHQIoEy72g==
X-Received: by 2002:a1c:bd55:: with SMTP id n82mr4024373wmf.3.1617110539050;
        Tue, 30 Mar 2021 06:22:19 -0700 (PDT)
Received: from [192.168.1.101] ([37.167.251.74])
        by smtp.gmail.com with ESMTPSA id m10sm3561741wmh.13.2021.03.30.06.22.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Mar 2021 06:22:18 -0700 (PDT)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8c_FAIL=3a_Test_report_for_kernel_5=2e10=2e0?=
 =?UTF-8?Q?-rc6_=28mainline=2ekernel=2eorg=29?=
To:     Vlad Buslov <vladbu@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jianlin Shi <jishi@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        netdev <netdev@vger.kernel.org>, skt-results-master@redhat.com,
        Yi Zhang <yi.zhang@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        Jianwen Ji <jiji@redhat.com>, Hangbin Liu <haliu@redhat.com>,
        Ondrej Moris <omoris@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Changhui Zhong <czhong@redhat.com>,
        Xiong Zhou <xzhou@redhat.com>,
        Rachel Sibley <rasibley@redhat.com>,
        David Arcari <darcari@redhat.com>
References: <cki.4066A31294.UNMQ21P718@redhat.com>
 <CABE0yyi9gS8nao0n1Dts_Og80R71h8PUkizy4rM9E9E3QbJwvA@mail.gmail.com>
 <CABE0yyj997uCwzHoob8q2Ckd2i5Pv1k+JDRbF3fnn11_R2XN1Q@mail.gmail.com>
 <20201209092052.19a39676@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CANn89iL8akG+u6sq4r7gxpWKMoDSKuCbgFvDPrrG+J85zC1KNg@mail.gmail.com>
 <CANn89iKcKATT902n6C1-Hi0ey0Ep20dD88nTTLLH9NNF6Pex5w@mail.gmail.com>
 <838391ff7ffa5dbfb79f30c6d31292c80415af18.camel@kernel.org>
 <CANn89iK+fU7LGH--JXx_FLxawr7rs1t-crLGtkbPAXsoiZMi8A@mail.gmail.com>
 <ygnhsg8ek8dr.fsf@nvidia.com>
 <20201209142256.3e4a08fb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <ygnhpn3ijbyb.fsf@nvidia.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a6eac222-bd0f-df08-a6a9-0605288b1f2d@gmail.com>
Date:   Tue, 30 Mar 2021 15:22:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <ygnhpn3ijbyb.fsf@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/10/20 9:35 AM, Vlad Buslov wrote:
> On Thu 10 Dec 2020 at 00:22, Jakub Kicinski <kuba@kernel.org> wrote:
>> On Wed, 9 Dec 2020 22:54:40 +0200 Vlad Buslov wrote:
>>>> Yes, I think the patch I sent should fix this, ETH_P_ARP should not be
>>>> dropped ;)
>>>>
>>>> I am testing this before offical patch submission.
>>>
>>> Your patch fixed TC geneve tests for me, but some of more complex OVS
>>> tests are still failing. I'll try to provide details tomorrow.
>>
>> Does a revert of Eric's patch fix it? For OvS is could also well be:
>> 9c2e14b48119 ("ip_tunnels: Set tunnel option flag when tunnel metadata is present")
> 
> The tests pass with Eric's commit reverted.
> 

I will release today the syzbot report, I am lacking time to fix the issue.

