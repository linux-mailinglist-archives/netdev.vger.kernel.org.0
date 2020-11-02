Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1663B2A34C6
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 21:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgKBUAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 15:00:34 -0500
Received: from mail.buslov.dev ([199.247.26.29]:60241 "EHLO mail.buslov.dev"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbgKBUAV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 15:00:21 -0500
Received: from vlad-x1g6 (unknown [IPv6:2a0b:2bc3:193f:1:a5fe:a7d6:6345:fe8d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id 9B24B1FC70;
        Mon,  2 Nov 2020 22:00:19 +0200 (EET)
References: <20201031201644.247605-1-vlad@buslov.dev> <96c51cbb-1a72-d89d-5746-2930786f8afb@mojatatu.com>
User-agent: mu4e 1.4.13; emacs 26.3
From:   Vlad Buslov <vlad@buslov.dev>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next] net: sched: implement action-specific terse dump
In-reply-to: <96c51cbb-1a72-d89d-5746-2930786f8afb@mojatatu.com>
Date:   Mon, 02 Nov 2020 22:00:18 +0200
Message-ID: <87zh3z5y25.fsf@buslov.dev>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 02 Nov 2020 at 14:26, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> Thanks Vlad. Ive run the basic test and it looks good.
> One thing i discovered while testing is that if the
> cookie is set, we also want it in the dump. Your earlier
> comment that it only costs if it was set is on point.
>
> So please remove that check below:

Okay. Will send V2 shortly.

>
>
>> +	if (cookie && !from_act) {
>> +		if (nla_put(skb, TCA_ACT_COOKIE, cookie->len, cookie->data)) {
>> +			rcu_read_unlock();
>> +			goto nla_put_failure;
>> +		}
>
>
> cheers,
> jamal

