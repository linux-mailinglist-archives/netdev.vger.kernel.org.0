Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFC630EDD6
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 08:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234771AbhBDHy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 02:54:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234769AbhBDHy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 02:54:56 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78853C061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 23:54:16 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id b9so3614941ejy.12
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 23:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=reYmZlyHNIgipKF7ucvdToHvccizSip31uqGD3uwkxk=;
        b=d+GVk3zTrCySrIcsGAwfItEwjF3yULCaQDHn5fQyarQww1L4ylamoWkLmVhWQAYCcL
         DkmI+QC3650nehLu5isWckOC/Na+da6dHDxHtbfb0jkZJglhpGd+8GJRXxY/CMTHRbOJ
         Mh9ttxJpJTbRW671l1JuXX/X95hg3jXwz6qf495BgijyfkcA2o+ez8BZZrLFz0lgsK6E
         oil41O+M6I0wz3Ruxx3ed8BCtTp7OwMMhDE0POAUdc2B56Y+wAIVuo/izbZAHTw2fzWD
         /MelPd14/1uA0nGzFG77DJi4eKtTyOfntMM+8szly97yaCdZNEoIqoi4Kwo9Kusum6Y8
         XfHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=reYmZlyHNIgipKF7ucvdToHvccizSip31uqGD3uwkxk=;
        b=tEGnMlHmsJzqFP22XeoPRI194kam0WDsRkPZWbJglagYEl6Enen18+NgPZ1V9sNJyp
         scMhAPe/al5YKFEP/QbsCzNZUUUAtgK779NXHNterIS4lEbCjdsgRmo81m7c2NpSY60a
         op7NTHh0mvBYgaDHXug2JyqkLy6pvJ7bnHvMEifMec9KLTdMx2DP0vfyECEc1lUtd99K
         VpiwlzUVzKIGfJXP901BDLtjp7P/ljHxh9So24uufNUetUt+Y/n13szrZSrbq/KfIw4f
         xGrQfNa6RGDfIO+gL99Vu4F1In+TVwSezAgi5ylNo5bgt6iB4KQW52VdLknKE8teQ5wO
         IDmA==
X-Gm-Message-State: AOAM5326d3he/PiLMfGR0iutDaXjEDbw0iqUwr46knMwPZnnP/00cWCP
        AercKdC32RJL0Crc3s5WVj1rQVbjEIkt91Yygfpa6g==
X-Google-Smtp-Source: ABdhPJzMe1TNaCxNpLZG8gDzQJGL+A4Eh6kuj/N+2NdX+by1l+jCZ7swnp8cqZmAeCP8H8ZjYu9qvVHFufirMU1Q2yo=
X-Received: by 2002:a17:907:a06f:: with SMTP id ia15mr6893342ejc.328.1612425255089;
 Wed, 03 Feb 2021 23:54:15 -0800 (PST)
MIME-Version: 1.0
References: <1612365335-14117-1-git-send-email-loic.poulain@linaro.org> <20210203151559.00007e94@intel.com>
In-Reply-To: <20210203151559.00007e94@intel.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Thu, 4 Feb 2021 09:01:23 +0100
Message-ID: <CAMZdPi9bL_pe0QmrHj=7PFN4bJAdtw-FOiSHHpoGw=ZZyyzYSQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4 1/2] net: mhi-net: Add de-aggeration support
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jesse,

On Thu, 4 Feb 2021 at 00:16, Jesse Brandeburg
<jesse.brandeburg@intel.com> wrote:
>
> Loic Poulain wrote:
>
> > When device side MTU is larger than host side MTU, the packets
> > (typically rmnet packets) are split over multiple MHI transfers.
> > In that case, fragments must be re-aggregated to recover the packet
> > before forwarding to upper layer.
> >
> > A fragmented packet result in -EOVERFLOW MHI transaction status for
> > each of its fragments, except the final one. Such transfer was
> > previously considered as error and fragments were simply dropped.
> >
> > This change adds re-aggregation mechanism using skb chaining, via
> > skb frag_list.
> >
> > A warning (once) is printed since this behavior usually comes from
> > a misconfiguration of the device (e.g. modem MTU).
> >
> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > ---
> >  v2: use zero-copy skb chaining instead of skb_copy_expand.
> >  v3: Fix nit in commit msg + remove misleading inline comment for frag_list
> >  v4: no change
>
> apologies for the nit, can you please fix the spelling of aggregation in
> the subject?

I will, anyway I need to change that since it is not de-aggregation
but re-aggregation of fragmented packets.

Thanks
Loic
