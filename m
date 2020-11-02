Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE7B2A309A
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 17:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbgKBQzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 11:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbgKBQzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 11:55:45 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B39FC061A04;
        Mon,  2 Nov 2020 08:55:44 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id m9so1945802iox.10;
        Mon, 02 Nov 2020 08:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2H9EsI2c7+OiPZfg2pvjS7KuZTJIt0qfXr5+p6cJnkQ=;
        b=egMapO/6e+ncr5505ArghJnNHTjdRItNq+eqEtIo4ad3zKHLRnr8MetXRv1ltQg86J
         j/3lPxg6DuILRx5akKprwgA63qZSlWb1htU7VRcNWRZzb2I0ZnM9531k8vQQPeHekDiT
         zXUFoQ4Y+WECZSZ5eL3KxEAGCr20vC9rzUnXr3/44quZt1LjcEyODZUtzgEJD7s4Lui/
         sn1P49OTJ9DXDLIrE42kXG2NU7Yiufq+UnUdNdHRMQHcI6r84pepXtoyzgkJP+oyk3+5
         8abtabiw7NgUPXdBXthqKmPPJs98LLtnJW74mHf8FcmpiAVBDIPNYB1NDd5fhaTlakOH
         9BYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2H9EsI2c7+OiPZfg2pvjS7KuZTJIt0qfXr5+p6cJnkQ=;
        b=Y1YKspVFRyeJOUehKsA619tUJARYkAHu++ivT1rkVI06YpVwLbCM1c4jxevUa7VNcY
         LAdWXAxyfb4nAGGhHTyQIGQVGjtOnp9YV7h2Vai2hUoyHe0Nu9VMFSPSRzoyUsFfrtV6
         LrUVzt+qIfw3XItlIuVXak5wtnGX8oVHLuL1LvZgupoi+YNw5kmppzndR5p0lM4J+w2m
         PHxsb5J1cUpgwFVjln3G9GR/zYNJTC7tL55G+my4fJ39+r7jCwoueOKr1TKGpfYolOuC
         UPWXaxIJoKa02gcV7hkwzyGDN89HNqxVVvZxREcYdbmwAHFtnKgp83N5SDfNkfCXMhv2
         RAqw==
X-Gm-Message-State: AOAM5303JKwf7dIsi0QgOi2AZUpbN/RDKp+TcXUzjBZs9dwOchtgLh7t
        Glf6E9Sd0tOt8N6cxaTq97qxpfCrSAOixe8bNRk=
X-Google-Smtp-Source: ABdhPJwO1YBK8c1j69XdlVp8QkGr4z5Nz7Ea5+01MAhoO0b9ypWqoW/V6z2qDIaJarjRlcOzjI5nzEDiXgKjtKCC1Ik=
X-Received: by 2002:a02:c64f:: with SMTP id k15mr7607073jan.75.1604336143354;
 Mon, 02 Nov 2020 08:55:43 -0800 (PST)
MIME-Version: 1.0
References: <1599562954-87257-1-git-send-email-linyunsheng@huawei.com>
 <CAM_iQpX0_mz+McZdzZ7HFTjBihOKz5E6i4qJQSoFbZ=SZkVh=Q@mail.gmail.com>
 <830f85b5-ef29-c68e-c982-de20ac880bd9@huawei.com> <CAM_iQpU_tbRNO=Lznz_d6YjXmenYhowEfBoOiJgEmo9x8bEevw@mail.gmail.com>
 <1f8ebcde-f5ff-43df-960e-3661706e8d04@huawei.com> <CAM_iQpUm91x8Q0G=CXE7S43DKryABkyMTa4mz_oEfEOTFS7BgQ@mail.gmail.com>
 <db770012-f22c-dff4-5311-bf4d17cd08e3@huawei.com>
In-Reply-To: <db770012-f22c-dff4-5311-bf4d17cd08e3@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 2 Nov 2020 08:55:32 -0800
Message-ID: <CAM_iQpUBytX3qim3rXLkwjdX3DSKeF8YhyX6o=Jwr-R9Onb-HA@mail.gmail.com>
Subject: Re: [PATCH v2 net] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@huawei.com,
        John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 12:38 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2020/10/30 3:05, Cong Wang wrote:
> >
> > I do not see how and why it should. synchronize_net() is merely an optimized
> > version of synchronize_rcu(), it should wait for RCU readers, softirqs are not
> > necessarily RCU readers, net_tx_action() does not take RCU read lock either.
>
> Ok, make sense.
>
> Taking RCU read lock in net_tx_action() does not seems to solve the problem,
> what about the time window between __netif_reschedule() and net_tx_action()?
>
> It seems we need to re-dereference the qdisc whenever RCU read lock is released
> and qdisc is still in sd->output_queue or wait for the sd->output_queue to drain?

Not suggesting you to take RCU read lock. We already wait for TX action with
a loop of sleep. To me, the only thing missing is just moving the
reset after that
wait.


> >>>> If we do any additional reset that is not related to qdisc in dev_reset_queue(), we
> >>>> can move it after some_qdisc_is_busy() checking.
> >>>
> >>> I am not suggesting to do an additional reset, I am suggesting to move
> >>> your reset after the busy waiting.
> >>
> >> There maybe a deadlock here if we reset the qdisc after the some_qdisc_is_busy() checking,
> >> because some_qdisc_is_busy() may require the qdisc reset to clear the skb, so that
> >
> > some_qdisc_is_busy() checks the status of qdisc, not the skb queue.
>
> Is there any reason why we do not check the skb queue in the dqisc?
> It seems there may be skb left when netdev is deactivated, maybe at least warn
> about that when there is still skb left when netdev is deactivated?
> Is that why we call qdisc_reset() to clear the leftover skb in qdisc_destroy()?
>
> >
> >
> >> some_qdisc_is_busy() can return false. I am not sure this is really a problem, but
> >> sch_direct_xmit() may requeue the skb when dev_hard_start_xmit return TX_BUSY.
> >
> > Sounds like another reason we should move the reset as late as possible?
>
> Why?

You said "sch_direct_xmit() may requeue the skb", I agree. I assume you mean
net_tx_action() calls sch_direct_xmit() which does the requeue then races with
reset. No?


>
> There current netdev down order is mainly below:
>
> netif_tx_stop_all_queues()
>
> dev_deactivate_queue()
>
> synchronize_net()
>
> dev_reset_queue()
>
> some_qdisc_is_busy()
>
>
> You suggest to change it to below order, right?
>
> netif_tx_stop_all_queues()
>
> dev_deactivate_queue()
>
> synchronize_net()
>
> some_qdisc_is_busy()
>
> dev_reset_queue()

Yes.

>
>
> What is the semantics of some_qdisc_is_busy()?

Waiting for flying TX action.

> From my understanding, we can do anything about the old qdisc (including
> destorying the old qdisc) after some_qdisc_is_busy() return false.

But the current code does the reset _before_ some_qdisc_is_busy(). ;)

Thanks.
