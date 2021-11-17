Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5974547E2
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 14:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236523AbhKQN7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 08:59:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhKQN7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 08:59:39 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141E8C061570;
        Wed, 17 Nov 2021 05:56:41 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id m20so11620333edc.5;
        Wed, 17 Nov 2021 05:56:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=barpn6HXlNEJZCIDoLRAiQeoqQVNhfDbTQPuPxYCEgE=;
        b=pbUx2/mB0J0Or1fLsMpTkQes7REpjHCo+bSdAP8/JyNylZqPYYYtHfC4yYnuh6Et9e
         s1sLYspfEe5eHYAohHQK2xvdUkcKisZo1qpJhdk4dlosawjPmbCQGWPd0nVGh0IgUoji
         JbGFS8wGGgZrdU7+qObW75iK+5bvMYbe5RKHWgy6R6DBmUbN4wv+N6zLgXNZgtPvorKA
         iwC99r0igDysKJflgZX8TtGgV1y9fUCsWl7IpCDgnimzV8ZFw7kwclfr9YrTJeJi7zcm
         l/HAOoiPJjCgOGRTXr0dXn/Docx9PheRJLnbOzr+MgffAGnn6PN6RpW5mHyYIz/ljICp
         AoCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=barpn6HXlNEJZCIDoLRAiQeoqQVNhfDbTQPuPxYCEgE=;
        b=tNiOLnr6hhAvvEmn5VmPRlRUVstFaRa9QYUkkDpc2hnkx1NdjPphWbunt7FaroEDeb
         j21MtF0aiJ++2L4ns7n0VsMqn7Vu7RTAx56M/OMCJjfSMxR/S+KmDAfzvvt+fhvbRzcB
         iP0k/4gNNjp0vq3b+HnVuSSxquk0AHts4BQbQCc8ny967rse9pOlxJUwbK17jilCELHE
         zVimc+yW8dPp5wxqzBT3oC9NwGX2/1vT8dcUNR3HSxDOc5XCTWRU8Caj1I+jNkTY11s3
         ghBPVqNC5chTQKnzyAemQoIcSrY/c98x0o0ipvS+D0/NsdpoD6Awqwb+/d9E9X53Hmiu
         VAcw==
X-Gm-Message-State: AOAM532s2dOLWilJVo5+l0M699L6Vf7CTMqyQH42DTpEIygZqFcB/OVf
        TdNZl6xrh91kYtnweX0bbV4xHjh1tycSpjFcCo75CZtwtyY=
X-Google-Smtp-Source: ABdhPJwtZM5VA43xVKmj3kz4yBntpNkXzEFK5+D+KH1XnDlwVHdF50w+ggVjBrr8JJSeOm1Knyj0kN7uYmNDpVc2CJQ=
X-Received: by 2002:a50:da48:: with SMTP id a8mr22163831edk.146.1637157399729;
 Wed, 17 Nov 2021 05:56:39 -0800 (PST)
MIME-Version: 1.0
References: <20211111133530.2156478-1-imagedong@tencent.com>
 <20211111133530.2156478-2-imagedong@tencent.com> <20211116163407.7e0c6129@gandalf.local.home>
In-Reply-To: <20211116163407.7e0c6129@gandalf.local.home>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 17 Nov 2021 21:55:20 +0800
Message-ID: <CADxym3bHJZ+3HX3V=JjHfk7ZiUQAwwwdXL07e-JBSp9-wjdVXQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: snmp: add tracepoint support for snmp
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, mingo@redhat.com,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, Menglong Dong <imagedong@tencent.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 5:34 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 11 Nov 2021 21:35:29 +0800
> menglong8.dong@gmail.com wrote:
>
> > +#define DEFINE_SNMP_EVENT(proto)                             \
> > +DEFINE_EVENT(snmp_template, snmp_##proto,                    \
> > +     TP_PROTO(struct sk_buff *skb, int field, int val),      \
> > +     TP_ARGS(skb, field, val)                                \
> > +)
> > +
> > +#define TRACE_SNMP(skb, proto, field, val) \
> > +     trace_snmp_##proto(skb, field, val)
> > +
> > +#endif
>
> Why make a separate trace event for each protocol, and not just create an
> enum that gets passed to the trace event? Then you could just filter on
> what you want.

enn....I'm not sure, just feel comfortable to create a separate trace event for
each protocol. Maybe it is easier to use? However, making them together
seems more fridently to users who want to do statistics for all protocols. I'll
think over it~~~

Thanks!
Menglong Dong

>
> -- Steve
