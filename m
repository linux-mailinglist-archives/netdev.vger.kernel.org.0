Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98149288F0F
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 18:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389837AbgJIQjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 12:39:00 -0400
Received: from mail.buslov.dev ([199.247.26.29]:47425 "EHLO mail.buslov.dev"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388719AbgJIQjA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 12:39:00 -0400
Received: from vlad-x1g6 (unknown [IPv6:2a0b:2bc3:193f:1:a5fe:a7d6:6345:fe8d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id BA26320BB3;
        Fri,  9 Oct 2020 19:38:56 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=buslov.dev; s=2019;
        t=1602261537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tFzy1cNToggHZdfoRqbmO4gPSaZYG40s1447YY6p97E=;
        b=hfPV+1qwemkxy5C0odsYC1YVbPlvCIF61aoMwlosFLbGMdxVmM1LQP5TQfgZQ715MLZx16
        q/0oi1MebGaFd6x+VCgRHj0rR1iVRSJZh+rkmequ1aaQ+OYFBYygWKQPsqqPRfYGYQ8p+w
        alKN3sOkiTQIr2U9o3/7gPx7wXmLb4XiSF5eHu/s/71bQ0cV6HhnXewvE/L8aUmEyBhhZI
        dC+iCXuVrIRWP9qBiEAskfYB7AMsd/DoKEy6niRSDx8aNYkb3ZnPsrrakJ3sxAgHYKDfqd
        m51ZhslcoUxQvJPoxDfLjjdXIs/IqmANJyB5J/3XTfg17uD4A34go32GZg63jQ==
References: <20200930165924.16404-1-vladbu@nvidia.com> <20200930165924.16404-3-vladbu@nvidia.com> <9961ad12-dc8f-55fc-3f9d-8e1aaca82327@gmail.com> <ff969d59-53e0-aca3-2de8-9be41d6d7804@mojatatu.com> <87imbk20li.fsf@buslov.dev> <81cf5868-be3d-f3b0-9090-01ec38f035e4@mojatatu.com> <87ft6n1tp8.fsf@buslov.dev> <5d4231c5-94d2-4d14-292f-e68d015ea260@mojatatu.com>
User-agent: mu4e 1.4.13; emacs 26.3
From:   Vlad Buslov <vlad@buslov.dev>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     David Ahern <dsahern@gmail.com>, Vlad Buslov <vladbu@nvidia.com>,
        stephen@networkplumber.org, xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, davem@davemloft.net, jiri@resnulli.us,
        ivecera@redhat.com, Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH iproute2-next v2 2/2] tc: implement support for terse dump
In-reply-to: <5d4231c5-94d2-4d14-292f-e68d015ea260@mojatatu.com>
Date:   Fri, 09 Oct 2020 19:38:55 +0300
Message-ID: <87d01r1hi8.fsf@buslov.dev>
MIME-Version: 1.0
Content-Type: text/plain
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=vlad@buslov.dev smtp.mailfrom=vlad@buslov.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 09 Oct 2020 at 15:45, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2020-10-09 8:15 a.m., Vlad Buslov wrote:
>>
>> On Fri 09 Oct 2020 at 15:03, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
>>> Which test(s)?
>>> I see for example d45e mentioning terse but i dont see corresponding
>>> code in the iproute2 tree i just pulled.
>>
>> Yes. The tests d45e and 7c65 were added as a part of kernel series, but
>> corresponding iproute2 patches were never merged. Tests expect original
>> "terse flag" syntax of V1 iproute2 series and will have to be changed to
>> use -brief option instead.
>
> Then i dont see a problem in changing the tests.
> If you are going to send a v3 please include my acked-by.
> Would have been nice to see what terse output would have looked like.
>
> cheers,
> jamal

Sure. Just waiting for everyone to voice their opinion regarding the
output format before proceeding with any changes.

