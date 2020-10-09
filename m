Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B61A28887A
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 14:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388500AbgJIMPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 08:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388479AbgJIMPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 08:15:39 -0400
Received: from mail.buslov.dev (mail.buslov.dev [IPv6:2001:19f0:5001:2e3f:5400:1ff:feed:a259])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75398C0613D2
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 05:15:36 -0700 (PDT)
Received: from vlad-x1g6 (unknown [IPv6:2a0b:2bc3:193f:1:a5fe:a7d6:6345:fe8d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id BC9351F899;
        Fri,  9 Oct 2020 15:15:31 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=buslov.dev; s=2019;
        t=1602245732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=65e1hdl7VmpfAd1gwqzD6uPu3E/PjVR8GpKfKl/WHoM=;
        b=A4ScWzpRkRJbe+gwsKHef3GEAp2Y4PiqTv8iUIGVqGIeWOSDZn4yZ5gtZzGX2vvwBfyY5Z
        pCkbTXxC6hkbfrkCVCXHyDsH1c/S7XZNKgQDuaTeiUrU02GMUaDlkK9mq+mCTj5lU3dFy4
        YnGk7Nw9FMikL34rLuSqWxAiM74zUfG2wsqAFELJsK448UWBbiur48KDu85feMPinHncNV
        ONWl92Fhd6qT3xsmW0yctCy5AJwoZFaMMMTzJaG0l6abAYDgMCShrdKc5ehNWKTz17PSVt
        pVX6zAMAudSdxNE6Rs4/x6DJre1f34M8xHbjaONO6t2wLelIyYOTMgGujbwQyw==
References: <20200930165924.16404-1-vladbu@nvidia.com> <20200930165924.16404-3-vladbu@nvidia.com> <9961ad12-dc8f-55fc-3f9d-8e1aaca82327@gmail.com> <ff969d59-53e0-aca3-2de8-9be41d6d7804@mojatatu.com> <87imbk20li.fsf@buslov.dev> <81cf5868-be3d-f3b0-9090-01ec38f035e4@mojatatu.com>
User-agent: mu4e 1.4.13; emacs 26.3
From:   Vlad Buslov <vlad@buslov.dev>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     David Ahern <dsahern@gmail.com>, Vlad Buslov <vladbu@nvidia.com>,
        stephen@networkplumber.org, xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, davem@davemloft.net, jiri@resnulli.us,
        ivecera@redhat.com, Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH iproute2-next v2 2/2] tc: implement support for terse dump
In-reply-to: <81cf5868-be3d-f3b0-9090-01ec38f035e4@mojatatu.com>
Date:   Fri, 09 Oct 2020 15:15:31 +0300
Message-ID: <87ft6n1tp8.fsf@buslov.dev>
MIME-Version: 1.0
Content-Type: text/plain
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=vlad@buslov.dev smtp.mailfrom=vlad@buslov.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 09 Oct 2020 at 15:03, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2020-10-08 11:34 a.m., Vlad Buslov wrote:
>>
>> On Thu 08 Oct 2020 at 15:58, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>
>>
>> Hi Jamal,
>>
>> The existing terse dump tdc tests will have to be changed according with
>> new iproute2 tc syntax for brief(terse) output.
>>
>
> Which test(s)?
> I see for example d45e mentioning terse but i dont see corresponding
> code in the iproute2 tree i just pulled.

Yes. The tests d45e and 7c65 were added as a part of kernel series, but
corresponding iproute2 patches were never merged. Tests expect original
"terse flag" syntax of V1 iproute2 series and will have to be changed to
use -brief option instead.

>
> I feel like changing the tests this early may not be a big issue
> if they havent propagated in the wild.
>
> cheers,
> jamal

