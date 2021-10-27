Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA1F43BE4D
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 02:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237333AbhJ0AFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 20:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236379AbhJ0AFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 20:05:03 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D77C061570
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 17:02:39 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id g8so163080iob.10
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 17:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4twnWZaz/uCnsUp6yfoaHYStTI/UK/5pB+90myxvwMY=;
        b=McGYTg8EWlwdYu4NP87nhhrmGSR61hXJ5OYQ8OkGOrk7OMTerkySezVKbw6NB6lXX9
         V9mGDV/jQFXRdWhP5n5ukJxhXardWMokHErGiZTwKRsYbk6hqy4y2thQbIqYxm9qkXns
         9EAMr3DAHJ6gPE2b+FtDf9v4hcAWJLQ4I0yJrEs2WI24f6yNF3z47oXlLwA4QIAy6i5A
         tbX6YFJ4uIPec3Qz275WTkL0LqoyUtQ3Fr4YXN8Ry7nSRLwoqaA1pZkEnivZNxjkAqit
         yig8OsE9uFG5h6KAbgpIUslEugJWp70UJIep+y3iqMt0briWYHsVMCu5Mk2pJodydhpX
         Vz7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4twnWZaz/uCnsUp6yfoaHYStTI/UK/5pB+90myxvwMY=;
        b=Gub6dVTLLiECkjhBhmCunvDxxsINk70KwAI0Eoea7Aj4SK9kBzBuDfJT7WX/4W0+3r
         Mx2DYEfKQ7ukRML/U8AJbT6i8CkIHywOyinfHlyl17SnIr9Ptqvnn6a2mym0nFJlRf8+
         wD+MtpWF6dxC+ROD7PKaeWFDyqF9Qu4DK9iheL5wZ7esSNkGf2wnsEyd1jalHBMgU/sv
         3ZBSiltvxiNlVWhBp40Ztq+eIwUH8Bq0SpgPKOVsIjDUhQ51f6ZoiF4ot18E5LpuRiV/
         0UFzdZ1vmhQNeQmNzdC0dU0XYrId8SrDqx8AaSsSpd1XzYuGomXjHYEkjSIas9vS0blu
         dcqw==
X-Gm-Message-State: AOAM532okLcokxAWSzFEEsTq3ASI7YFfD4zmHFtcK0Q05o0i5wYb0RAi
        UKxoR5EkUkw0MS7AQQYz753VYhXgykXjY5MmRpZcAA==
X-Google-Smtp-Source: ABdhPJxP6jHFGZWuyB1s4DXm7xha6KVLCdtpM5c9ip48DGNXWfx/P0lsyJ2IyXXN/PUzPJwYsp0zTllz2xTKRMpx/So=
X-Received: by 2002:a05:6602:148b:: with SMTP id a11mr17937967iow.85.1635292958699;
 Tue, 26 Oct 2021 17:02:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAOhMmr7bWv_UgdkFZz89O4=WRfUFhXHH5hHEOBBfBaAR8f4Ygw@mail.gmail.com>
 <YXcGPLau1zvfTIot@unknown>
In-Reply-To: <YXcGPLau1zvfTIot@unknown>
From:   Slade Watkins <slade@sladewatkins.com>
Date:   Tue, 26 Oct 2021 20:02:27 -0400
Message-ID: <CA+pv=HPK+7JVM2d=C2B6iBY+joW7T9RWrPGDd-VXm09yaWsQYg@mail.gmail.com>
Subject: Re: Unsubscription Incident
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Lijun Pan <lijunp213@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
On Mon, Oct 25, 2021 at 4:10 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Fri, Oct 22, 2021 at 10:53:28AM -0500, Lijun Pan wrote:
> > Hi,
> >
> > From Oct 11, I did not receive any emails from both linux-kernel and
> > netdev mailing list. Did anyone encounter the same issue? I subscribed
> > again and I can receive incoming emails now. However, I figured out
> > that anyone can unsubscribe your email without authentication. Maybe
> > it is just a one-time issue that someone accidentally unsubscribed my
> > email. But I would recommend that our admin can add one more
> > authentication step before unsubscription to make the process more
> > secure.
> >
>
> Same here.
>
> Fortunately I just switched to lei:
> https://josefbacik.github.io/kernel/2021/10/18/lei-and-b4.html
> so I can unsubscribe all kernel mailing lists now.

Not a bad workaround! I may consider trying this out. Thanks for
sending this along.

I'd still love to figure out why the whole "randomly unsubscribing
people who want to be subscribed" thing is happening in the first
place, though.

>
> Thanks.

Cheers,
             -slade
