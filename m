Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 078C554DBD8
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 09:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358576AbiFPHeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 03:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359400AbiFPHeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 03:34:18 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F330B2604
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 00:34:17 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id h18so379929ilj.7
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 00:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NvHuwwL/F6pMsG0Nc9FpP+u076JoaJtZoFmfOQuVsgo=;
        b=G5Swza7nAvxYIxG91GHxCoqN9VYTTk3sCQY6CEWUt8hBkhA58e2oKTFYY+90XN2m0g
         XwDh2Q8eQZhBDzqbOzSSta1XOg2+QcpPBU0aZJGqkG1T3cr+QdYXNLGTCQ5qEvvMB+dX
         Ptt6PTIrh41v1HQe7YqChFY1tS3aGyK7fRmqhaN0ugp6hM2lciIeovlbbNrAflKeZ1bS
         ZMSKWD5ayOBeDePaQSTknATZyeEjhm6kLsnvn24qdjb6SiOb9716E3ynuLHbmAKkNS9h
         wHjXKffq80JR+r0R4mccRhMLXF4vFwSFiktZ1UWQxvqEjPqlvBOmDTjKujRFsf5XIMQr
         Zsug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NvHuwwL/F6pMsG0Nc9FpP+u076JoaJtZoFmfOQuVsgo=;
        b=yn0H5Je4xGyj67HTsH1ZRaqG9uikhK+YxZWGRfpe36Rs3O+dKsSVxuCsTU1pRn4NOR
         quT6T0onWlMAK6mZuu9RC+2GpPhKywvKnlf8MnAoOUqmTvqVK6EgIuNMYlVvIhqGeIvh
         glKZJDjd6rjrIi7dTBpPxvzzH9bJCVyIpulmw6UUSfSpc/dlMJcRrdVN6WsF5MLpEH+g
         qwMxQc8jjRMcnInYKeJji3FfYNltnKClFXDQD8I5Y6gCBsvJ7ZfTL4i6/Rpolgev86DX
         9k70z/XIJK3LFDcycTkHqKTwHYqIHg8TRqAvS6wpMUsNslXJo81GFOa23zl936sE+VGZ
         6h2Q==
X-Gm-Message-State: AJIora9jH4wMCRgztvU7zwOX9yfVuPmf6+bDA1EKtN99E89NXDnKDCQ+
        VjaiFNvmyswwwbiNSM/zAAi0V9Y4bP3I8XIMRjTcFA==
X-Google-Smtp-Source: AGRyM1sVFw5s0O+ztvDdV/nEl+ruJskz6+CHPw575NteMZD8Lgqzw3Itmu0TIxj49OlTOivjYNeLaCin7L2L90E7fSY=
X-Received: by 2002:a05:6e02:1e08:b0:2d3:a866:2f0d with SMTP id
 g8-20020a056e021e0800b002d3a8662f0dmr1964465ila.277.1655364857096; Thu, 16
 Jun 2022 00:34:17 -0700 (PDT)
MIME-Version: 1.0
References: <1655182915-12897-1-git-send-email-quic_subashab@quicinc.com>
 <1655182915-12897-2-git-send-email-quic_subashab@quicinc.com>
 <20220615173516.29c80c96@kernel.org> <CANP3RGfGcr25cjnrUOdaH1rG9S9uY8uS80USXeycDBhbsX9CZw@mail.gmail.com>
 <132e514e-bad8-9f73-8f08-1bd5ac8aecd4@quicinc.com>
In-Reply-To: <132e514e-bad8-9f73-8f08-1bd5ac8aecd4@quicinc.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Thu, 16 Jun 2022 00:33:02 -0700
Message-ID: <CANP3RGdRD=U7OAwrcdp1XUXFcb5b1zTfoy1fxa8JZUcnxBdsKg@mail.gmail.com>
Subject: Re: [PATCH net v2 1/2] ipv6: Honor route mtu if it is within limit of
 dev mtu
To:     "Subash Abhinov Kasiviswanathan (KS)" <quic_subashab@quicinc.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Stefano Brivio <sbrivio@redhat.com>,
        Kaustubh Pandey <quic_kapandey@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 15, 2022 at 10:36 PM Subash Abhinov Kasiviswanathan (KS)
<quic_subashab@quicinc.com> wrote:
>
> >> CC maze, please add him if there is v3
> >>
> >> I feel like the problem is with the fact that link mtu resets protocol
> >> MTUs. Nothing we can do about that, so why not set link MTU to 9k (or
> >> whatever other quantification of infinity there is) so you don't have
> >> to touch it as you discover the MTU for v4 and v6?
>
> That's a good point.

Because link mtu affects rx mtu which affects nic buffer allocations.
Somewhere in the vicinity of mtu 1500..2048 your packets stop fitting
in 2kB of memory and need 4kB (or more)

> >> My worry is that the tweaking of the route MTU update heuristic will
> >> have no end.
> >>
> >> Stefano, does that makes sense or you think the change is good?
>
> The only concern is that current behavior causes the initial packets
> after interface MTU increase to get dropped as part of PMTUD if the IPv6
> PMTU itself didn't increase. I am not sure if that was the intended
> behavior as part of the original change. Stefano, could you please confirm?
>
> > I vaguely recall that if you don't want device mtu changes to affect
> > ipv6 route mtu, then you should set 'mtu lock' on the routes.
> > (this meaning of 'lock' for v6 is different than for ipv4, where
> > 'lock' means transmit IPv4/TCP with Don't Frag bit unset)
>
> I assume 'mtu lock' here refers to setting the PMTU on the IPv6 routes
> statically. The issue with that approach is that router advertisements
> can no longer update PMTU once a static route is configured.

yeah.   Hmm should RA generated routes use locked mtu too?
I think the only reason an RA generated route would have mtu information
is for it to stick...
