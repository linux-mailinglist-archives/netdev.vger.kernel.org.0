Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22E5F6E842
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 17:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730484AbfGSPyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 11:54:06 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:39129 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727927AbfGSPyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 11:54:05 -0400
Received: by mail-ot1-f66.google.com with SMTP id r21so27191038otq.6;
        Fri, 19 Jul 2019 08:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uBio4QtwZFLBKAtqqjIaRKNNdRczJ0fbb/kd94CXTnE=;
        b=sUFZIvKDXwMF4dXrfuCryv23nVkvavLZO465yay/AfVkUNN3Y9ndNwDxQ+CHInYmWa
         B8WRd2Gczc3/3SC8yM4T7efI2rN6uKzJCMAhwlJiNtS4jx/Iu1GhgpLoxxGT74d5b06D
         bmXDFweFOSU8ReLuCuPH+lCX/MI4IWNQDjEKUrrrQyvPOKO75xnTEI8WHYDAYyymtIHg
         nKktDMGN/P7tV4wghb5vEWW3GpvmVq/w5CGlUUkVfI8CeTsO8meD2xqp3EjYbZqECvFA
         0rXNpijAed3a5Qz8tz7cSdr7ryE827mwVagLlqHSFWWjejzC4YwYcIag7gyhzQM0gmF7
         31Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uBio4QtwZFLBKAtqqjIaRKNNdRczJ0fbb/kd94CXTnE=;
        b=ngK3YS/icBPDNyw1NBAsZzcsNShmzPUQ96xAYVT5lkqtGvxdZXaqrlXGa6EYxBhrHg
         pMeU/qDWNx/lTOF2/V8s0XHdBNO3hK9PEXMxltvk/gz9vrU4snVvxgv291ve133KrW8R
         /BYX3zpfBEjA+n4ApKTY3yH0W0mTHcUxF/JoIS5mG2Cc2yg7/jVOb8PlIOVWfViPVHUB
         ZQc+ntg73DCQdBaFgNBHuebh8ZbC1GlNOaragna3ZcPxDcQJFvUm8E0ENkoUMhWcH/IE
         y03MRPWnkLQi5jnlOx2h32djmSOEEVHl9humglqt3sK5uWNYsIEeP9Oxro/ZCdcgYQE1
         M+ow==
X-Gm-Message-State: APjAAAVzizLqSW8dcVlEp7Sq4zZ4cQ9vTws5Ivg7XyGhFScVtr6bPYym
        pLG32OEyvwpO3rSYVTCLIkHan+xAJIlrRJPKTHA=
X-Google-Smtp-Source: APXvYqyLmBWzw4SwWARwiJj058j2d5oagvoYn7wEnMicS1aiPXVaIDMDy0N7bbW9/192znhYMnUx1vRswBPvStlAY0Y=
X-Received: by 2002:a9d:6c46:: with SMTP id g6mr38493961otq.104.1563551644864;
 Fri, 19 Jul 2019 08:54:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190717201925.fur57qfs2x3ha6aq@debian> <alpine.DEB.2.21.1907172238490.1778@nanos.tec.linutronix.de>
 <CADVatmO_m-NYotb9Htd7gS0d2-o0DeEWeDJ1uYKE+oj_HjoN0Q@mail.gmail.com>
 <alpine.DEB.2.21.1907172345360.1778@nanos.tec.linutronix.de>
 <052e43b6-26f8-3e46-784e-dc3c6a82bdf0@gmail.com> <CADVatmN6xNO1iMQ4ihsT5OqV2cuj2ajq+v00NrtUyOHkiKPo-Q@mail.gmail.com>
 <8124bbe5-eaa8-2106-2695-4788ec0f6544@gmail.com> <CADVatmPQRf9A9z1LbHe5cd+bFLrPGG12YxPh2-yXAj_C9s8ZeA@mail.gmail.com>
 <870de0d9-5c08-9431-a46a-33ee4d3a6617@gmail.com>
In-Reply-To: <870de0d9-5c08-9431-a46a-33ee4d3a6617@gmail.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Fri, 19 Jul 2019 16:53:28 +0100
Message-ID: <CADVatmMMOV-VV4-Hpp9=qvy4HXOO9aShQeczJFEMCPxS+PJsRw@mail.gmail.com>
Subject: Re: regression with napi/softirq ?
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 18, 2019 at 4:08 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 7/18/19 2:55 PM, Sudip Mukherjee wrote:
>
> > Thanks Eric. But there is no improvement in delay between
> > softirq_raise and softirq_entry with this change.
> > But moving to a later kernel (linus master branch? ) like Thomas has
> > said in the other mail might be difficult atm. I can definitely
> > move to v4.14.133 if that helps. Thomas ?
>
> If you are tracking max latency then I guess you have to tweak SOFTIRQ_NOW_MASK
> to include NET_RX_SOFTIRQ
>
> The patch I gave earlier would only lower the probability of events, not completely get rid of them.
>
>
>
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index 0427a86743a46b7e1891f7b6c1ff585a8a1695f5..302046dd8d7e6740e466c422954f22565fe19e69 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -81,7 +81,7 @@ static void wakeup_softirqd(void)
>   * right now. Let ksoftirqd handle this at its own rate, to get fairness,
>   * unless we're doing some of the synchronous softirqs.
>   */
> -#define SOFTIRQ_NOW_MASK ((1 << HI_SOFTIRQ) | (1 << TASKLET_SOFTIRQ))
> +#define SOFTIRQ_NOW_MASK ((1 << HI_SOFTIRQ) | (1 << TASKLET_SOFTIRQ) | (1 << NET_RX_SOFTIRQ))
>  static bool ksoftirqd_running(unsigned long pending)
>  {
>         struct task_struct *tsk = __this_cpu_read(ksoftirqd);

Thanks Eric, this looks better than the hack that tglx gave. :)
Though the hack was good for testing.

But my original problem was a drop is network packets and till now I
was thinking
that the delay in processing the softirq is causing that. But with the
hack tglx has given
the latency has decreased but my problem is still there.
So, I am looking into it again now.

Thanks again for the patch.


-- 
Regards
Sudip
