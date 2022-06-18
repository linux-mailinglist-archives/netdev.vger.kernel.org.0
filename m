Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8615503FD
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 12:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbiFRKYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 06:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiFRKYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 06:24:53 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88011EC46
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 03:24:52 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id n4so6197793vsm.6
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 03:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k9YbzABl4hlZL3fcaWXFts77m7ITlSxM8r1dVX+fX3s=;
        b=UvgIodnjxm+pflvssFqwGhXIxLE3AVjhBYqckfrdAGxMAdj3cSkflRqUMgsiTTMC+C
         14OZXDjhevEruW4w/DNXXnhubnBQ3QUXxP4TKmzeAmdUVcCYS761IH9Kbf/eHo/KBEq3
         1n+1NvDhBVoNjHR4jFkMRP496lhZaHdxG20+zH0YRK3kLrN4fzqP3daAiBFzIFU8DQFR
         CDP4vf71hn20jh5618I+SmoqzSFTeXk6pi0AqYpDt7qvKV3Hdo8dtv4Nfip9GkNte3/6
         tjAg0t1S4O+jfJeUMD0fC7pWgaHjmqYbIXDHMOWyWNixx/J0iBosDIO9/GG3aOedlhQv
         COLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k9YbzABl4hlZL3fcaWXFts77m7ITlSxM8r1dVX+fX3s=;
        b=Z42Sm0lgvMxvTdEGlzl56oVcwT3JIRvT7Y3RKNPS7bKbRCHCYmhk3I+DsjDCMFcKl4
         HqOUGnpGoJsIbmxvnsP9sJaJf0XLK6bkoY4zgNg3YRVA/wS0/zLYnlTu5CSSOeP0pX1b
         /iz+lbAGu0uIMGg3N11113Sdi0zOZlO4+tkB0Imp9qTyWA0RfZmO1ziu1T2xrKJ2JVRJ
         rmZePVvu4ecgWtRgIjcDCNJSlPvitmVx/hcQx+86945/Jp0Io5S29zBY82qgPRLtS45E
         /tOtPmLGIb9e75MOZpM0Vazjl5rxxWFD+3y6OklcQuMRvuVD9oGW3kMSsUnQO5A83hh4
         1jpA==
X-Gm-Message-State: AJIora86/BFpvAa+D+4/9+IM6UfgsssW3DZW6HfsVAR3U/PrfY+wLaLl
        mMB51vjVxYIheIUmTwG7t3jV25u0M38qv11d+Ao=
X-Google-Smtp-Source: AGRyM1sMulgJ45+/skOSlICO+47W/gsiGNQMRPkrv2HZ8Gny5Zoq2aJGYJhBjKUPwdDa08HyXA4Mxk3UaW0bvv0FFZM=
X-Received: by 2002:a67:a444:0:b0:34c:51fa:f442 with SMTP id
 p4-20020a67a444000000b0034c51faf442mr6101058vsh.19.1655547891840; Sat, 18 Jun
 2022 03:24:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220609105725.2367426-1-wangyuweihx@gmail.com>
 <20220609105725.2367426-3-wangyuweihx@gmail.com> <101855d8-878b-2334-fd5a-85684fd78e12@blackwall.org>
 <CANmJ_FNXSxPtBbESV4Y4Zme6vabgTJFSw0hjZNndfstSvxAeLw@mail.gmail.com>
 <57228F24-81CD-49E9-BE4D-73FC6697872B@blackwall.org> <20220615163303.11c4e7ef@kernel.org>
In-Reply-To: <20220615163303.11c4e7ef@kernel.org>
From:   Yuwei Wang <wangyuweihx@gmail.com>
Date:   Sat, 18 Jun 2022 18:24:40 +0800
Message-ID: <CANmJ_FN-U7HOn8+meVYVpUaN9diEwH6aDduCw5t9zk31AoO-mA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/2] net, neigh: introduce interval_probe_time
 for periodic probe
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>, roopa@nvidia.com,
        dsahern@kernel.org, =?UTF-8?B?56em6L+q?= <qindi@staff.weibo.com>,
        netdev@vger.kernel.org, wangyuweihx <wangyuweihx@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jun 2022 at 07:33, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 15 Jun 2022 18:39:53 +0300 Nikolay Aleksandrov wrote:
> > >> Do we need the proc entry to be in jiffies when the netlink option is in ms?
> > >> Why not make it directly in ms (with _ms similar to other neigh _ms time options) ?
> > >>
> > >> IMO, it would be better to be consistent with the netlink option which sets it in ms.
> > >>
> > >> It seems the _ms options were added later and usually people want a more understandable
> > >> value, I haven't seen anyone wanting a jiffies version of a ms interval variable. :)
> > >>
> > >
> > >It was in jiffies because this entry was separated from `DELAY_PROBE_TIME`,
> > >it keeps nearly all the things the same as `DELAY_PROBE_TIME`,
> > >they are both configured by seconds and read to jiffies, was `ms` in
> > >netlink attribute,
> > >I think it's ok to keep this consistency, and is there a demand
> > >required to configure it by ms?
> > >If there is that demand, we can make it configured as ms.
> >
> > no, no demand, just out of user-friendliness :) but
> > I get it keeping it as jiffies is also fine
>
> +1 to using ms

If no one is against this, we can make configured as ms?

so, there will be updates as follow in the next version patch:
- make this option configured as ms, and rename it to `interval_probe_time`
- add documentation to Documentation/networking/ip-sysctl
- fix damaged whitespace
- fix missing `proc_*_jiffies_minmax` on `CONFIG_PROC_SYSCTL` is not defined
