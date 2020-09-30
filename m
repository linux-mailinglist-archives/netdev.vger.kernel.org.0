Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E6527EFDE
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 19:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgI3RCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 13:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3RCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 13:02:38 -0400
Received: from mail.buslov.dev (mail.buslov.dev [IPv6:2001:19f0:5001:2e3f:5400:1ff:feed:a259])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDBC4C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 10:02:37 -0700 (PDT)
Received: from vlad-x1g6.mellanox.com (unknown [IPv6:2a0b:2bc3:193f:1:a5fe:a7d6:6345:fe8d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id 2879020175;
        Wed, 30 Sep 2020 20:02:33 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=buslov.dev; s=2019;
        t=1601485353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I5kCNn8zVzN/jr9yYLKQGAXT5a1dLL9zH1aiGbVBBaw=;
        b=mfjaDQVJQDC+4GTRroLnqG+Vd5Tnmk/S5r5cjfC188RpZiSgyusXZqJWPGEOykRO2uUJva
        y8Kf/b7zNfzwOEt4S3Mjs2UjINUZHRlufORfNwzxSBoCOZt49+f9OUmamoC3wXhQCH+aRe
        L6NWMFn9RY5Ms9rZLPIHjcqEXxoFtVOKwJFFc2B6rzSGbACfkaOaXiHcWpfcF3erevhIPF
        TLrKoA+uTJvxs4lbZ95QEz+0737plNvKO/+W0HRVP6XyTUWTa1J1LOznk4dsCbHMYNpY6s
        IqQUdz3bDWOX3YD5+V6ivyEUx8Vr18ZCLErWbwxERoazb0nPLzjB+i2uGoeZkQ==
References: <20200930073651.31247-1-vladbu@nvidia.com> <20200930073651.31247-3-vladbu@nvidia.com> <0d4e9eb2-ab6b-432c-9185-c93bbf927d1f@gmail.com>
User-agent: mu4e 1.4.13; emacs 26.3
From:   Vlad Buslov <vlad@buslov.dev>
To:     David Ahern <dsahern@gmail.com>
Cc:     Vlad Buslov <vladbu@nvidia.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [RESEND PATCH iproute2-next 2/2] tc: implement support for terse dump
In-reply-to: <0d4e9eb2-ab6b-432c-9185-c93bbf927d1f@gmail.com>
Message-ID: <87tuvf6vvc.fsf@buslov.dev>
Date:   Wed, 30 Sep 2020 20:02:31 +0300
MIME-Version: 1.0
Content-Type: text/plain
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=vlad@buslov.dev smtp.mailfrom=vlad@buslov.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 30 Sep 2020 at 18:57, David Ahern <dsahern@gmail.com> wrote:
> On 9/30/20 12:36 AM, Vlad Buslov wrote:
>> From: Vlad Buslov <vladbu@mellanox.com>
>> 
>> Implement support for classifier/action terse dump using new TCA_DUMP_FLAGS
>> tlv with only available flag value TCA_DUMP_FLAGS_TERSE. Set the flag when
>> user requested it with following example CLI:
>> 
>>> tc -s filter show terse dev ens1f0 ingress
>
> this should be consistent with ip command which has -br for 'brief'
> output. so this should be
>
>    tc -s -br filter show dev ens1f0 ingress
>
> Other tc maintainers should weigh in on what data should be presented
> for this mode.

Thanks for the feedback, David! I've just sent V2 with -br option.

[...]

