Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105914467AD
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 18:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbhKERWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 13:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbhKERWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 13:22:06 -0400
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2125AC061205
        for <netdev@vger.kernel.org>; Fri,  5 Nov 2021 10:19:27 -0700 (PDT)
Received: by mail-ua1-x92c.google.com with SMTP id b3so18417057uam.1
        for <netdev@vger.kernel.org>; Fri, 05 Nov 2021 10:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j7e054TQxRkKePZRHPZZz/iNSezx3VyhNaeHe3JFl2M=;
        b=LdK8LxByQTOLWBVrkBe6u7dVyQCQ45IhS5R06gyrw8ohKlumFT1O4JgjJdLS6WtVPx
         k4VzKboyYmn1Ew9F2iYDddW4XzQninlCBniPW37bYHSqCFU74VzyjJ0P0d753EfbReyL
         mLkh8z+7I3IHGd5ZCbQCc3NsJJ3Ali8DZpRxBqa1skLdSgrZfYKr+dqNK+NcTsEV6s2S
         yLQVM0FL2XLaF+BVX6u+M0kmmZop042dJ7kq5LRrXkzBkTROvtV+Tn2cJUc6Sm6V6uA3
         xbRXxwse9lCNAyh0UV0wS+BBMGf7OIdC+9m4/f+CyVNshAxOwuovjVb/JvWcEByaiGdu
         9OlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j7e054TQxRkKePZRHPZZz/iNSezx3VyhNaeHe3JFl2M=;
        b=DWcmcxkMTQNykCltyM86IQFFVuQD9Vm8p5rY2P9bOAHrawoq8lUweLzljKur3qcB6j
         qSv8tY9dQ8GZVpGzfXnKi2TwBJTpSIxUQw1dupHvPIB7h1QiGHAiUxyLoHGstfV7OJA8
         12rinzd5S7ZfPlacPfQkNTYs6IzX3yE4ymxLKfh6lg4fFqN83Beo+pu+tDHI6djPqvvw
         BlpciG0LxkjWySx6nc5/SfVai9yS74Z3mgKykqr9vtImeYc21kLK/cddpIdPLfN69pDs
         nIH38NARK90MkNiyLzQoSk2ghmLcvJtVFhRXTEotguuAg2CMR92eTqBDVu/PBzAOvMht
         ompQ==
X-Gm-Message-State: AOAM530VQozqmgOGGgIvtuqO/y/EtYxKVkDSeP/PkIw6GC2hLFXTzfkt
        1Bu5uuw99zOqy1EGN822a156TCSfb9UhusssRgjxWg==
X-Google-Smtp-Source: ABdhPJyArVudCy9jJYcQJcDgH+JsX3zXk19/yUY1WztfAAeJ03CP9bpPgiHmL4gCP3Zf9Rxio93f+L2xs1ntUZ3FogY=
X-Received: by 2002:a05:6102:481:: with SMTP id n1mr41880101vsa.18.1636132766138;
 Fri, 05 Nov 2021 10:19:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210924235456.2413081-1-weiwan@google.com> <CAEA6p_CSbFFiEUQKy_n5dBd-oBWLq1L0CZYjECqBfjjkeQoSdg@mail.gmail.com>
 <6c5ac9d3-9e9a-12aa-7dc8-d89553790e7b@gmail.com>
In-Reply-To: <6c5ac9d3-9e9a-12aa-7dc8-d89553790e7b@gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Fri, 5 Nov 2021 10:19:15 -0700
Message-ID: <CAEA6p_CXGaboJaO+LCM=c_tnf2P5oZZyXwJn1ybQDakWp+b=8g@mail.gmail.com>
Subject: Re: [patch v3] tcp.7: Add description for TCP_FASTOPEN and
 TCP_FASTOPEN_CONNECT options
To:     "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Cc:     Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-man@vger.kernel.org, netdev@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 3:12 PM Alejandro Colomar (man-pages)
<alx.manpages@gmail.com> wrote:
>
> Hi Wei,
>
> On 10/15/21 6:08 PM, Wei Wang wrote:
> > On Fri, Sep 24, 2021 at 4:54 PM Wei Wang <weiwan@google.com> wrote:
> >>
> >> TCP_FASTOPEN socket option was added by:
> >> commit 8336886f786fdacbc19b719c1f7ea91eb70706d4
> >> TCP_FASTOPEN_CONNECT socket option was added by the following patch
> >> series:
> >> commit 065263f40f0972d5f1cd294bb0242bd5aa5f06b2
> >> commit 25776aa943401662617437841b3d3ea4693ee98a
> >> commit 19f6d3f3c8422d65b5e3d2162e30ef07c6e21ea2
> >> commit 3979ad7e82dfe3fb94a51c3915e64ec64afa45c3
> >> Add detailed description for these 2 options.
> >> Also add descriptions for /proc entry tcp_fastopen and tcp_fastopen_key.
> >>
> >> Signed-off-by: Wei Wang <weiwan@google.com>
> >> ---
> >
> > Hi Alex,
> >
> > Does this version look OK to you to apply?
> > Let me know.
>
> Sorry, I missed that patch.
> Thanks for the ping!  I'll try to have a look at it ASAP.
>

Hi Alex,

I am not sure if this patch has been applied yet?
If not, could you help take a look? Let me know if you'd like me to resend it.

Thanks.
Wei

> Thanks,
>
> Alex
>
>
> >
> > Thanks.
> > Wei
>
>
> --
> Alejandro Colomar
> Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
> http://www.alejandro-colomar.es/
