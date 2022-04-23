Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D861B50CC2F
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 18:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233378AbiDWQLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 12:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiDWQLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 12:11:10 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B711613018F
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 09:08:13 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-2eba37104a2so113083537b3.0
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 09:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7ya74eRat9eGj9VpDr1M1ckTJtJkRtfzBLWmWW8GVMk=;
        b=kx9e+lLT2LvuKV99Ei4Ytihk+YeYPaT9sRo2NdfVl4r7FmLdgw3Sdad+ZfeC3eVDaD
         l+A20VnqmuojZtOdlg+PLLE4+896mrUvct+A1c5S1yvwdNGQtXDjxsuQXaMjan5L2FpI
         lxEPUXlSi/1qdZiY+ZOZMaUgP0ahyof4zAyNoDMXQrS7CgQrVcXlGdAbKfBMUIeNdmli
         6PaobtgaJb24vNU4o5qRSJfjv8Gl/d+PoLM41viPqryfN0V0R22CzcC/kOHmmKbwE7pq
         Fgxg9TX3CrnzvGlJCtOr2HmB4QFMjiqDU+TqraKFw6nOQj7Y4qju5gojcwdv+p50/TwW
         cu7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7ya74eRat9eGj9VpDr1M1ckTJtJkRtfzBLWmWW8GVMk=;
        b=2xaNzOr6/+iAejWvNPzJwYt41kz+R8rjZYEJezii0pJhG5oc7sgWjUbs9ikNi/A5Kt
         m0weQ0vhY3in33at08k1Blgk6buHxp56/MVL+EaMaDXvKi7UmMutYlCBK44I5pmW06DE
         wZcXIJA6WR0gCqw/qQmwmoJtFZN7km/6EMHI58fG+y22V5fQjfRK0JfU5YKIJHySaduV
         lS+s6Noounll1LlO8Rvy1eR0gsTyZgLNrwJInR4/cMWcOVm4a9tZ688lHzMyVNE4jhYG
         4ls+CoeuKTaoeYk1dVMh/WqQGZ1VaWGQ2w6tT3+AxNVm4JQlK8XOtyMq8/qnQmQrMa48
         zd/g==
X-Gm-Message-State: AOAM5313QoA4PF9c3jRUW8aQqFvthcHk7mZoOttSWek9DjdpXM8wrbk+
        YtRDmsoRmhSiFLSrF2KPjpzxTMcABufVHpCukXgXWclTKgWglneg
X-Google-Smtp-Source: ABdhPJyCexgTZnYE2oIqV8jpKPyewC/zwS4eqJvjWe7zvA+bfICAYRAu/QqRAC0CFjUv4kh6eo8eoEce+4ETbAMPJCw=
X-Received: by 2002:a81:203:0:b0:2f7:d70f:1b2 with SMTP id 3-20020a810203000000b002f7d70f01b2mr117375ywc.463.1650730092819;
 Sat, 23 Apr 2022 09:08:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210809070455.21051-1-liuhangbin@gmail.com> <162850320655.31628.17692584840907169170.git-patchwork-notify@kernel.org>
 <CAHsH6GuZciVLrn7J-DR4S+QU7Xrv422t1kfMyA7r=jADssNw+A@mail.gmail.com>
 <CALnP8ZackbaUGJ_31LXyZpk3_AVi2Z-cDhexH8WKYZjjKTLGfw@mail.gmail.com>
 <CAHsH6GvoDr5qOKsvvuShfHFi4CsCfaC-pUbxTE6OfYWhgTf9bg@mail.gmail.com>
 <YmE5N0aNisKVLAyt@Laptop-X1> <CALnP8ZY9hkiWyxjrVTdq=NFA0PYjt7f9YbSEJrbt-EQoRAk6gw@mail.gmail.com>
In-Reply-To: <CALnP8ZY9hkiWyxjrVTdq=NFA0PYjt7f9YbSEJrbt-EQoRAk6gw@mail.gmail.com>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Sat, 23 Apr 2022 19:08:01 +0300
Message-ID: <CAHsH6GtYXEVE_dbSyQ81_X7UOdd8U5a5QLUAsRx9+-nG3uZXmQ@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: act_mirred: Reset ct info when
 mirror/redirect skb
To:     Marcelo Ricardo Leitner <mleitner@redhat.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, ahleihel@redhat.com,
        dcaratti@redhat.com, aconole@redhat.com, roid@nvidia.com,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 4:41 PM Marcelo Ricardo Leitner
<mleitner@redhat.com> wrote:
>
> On Thu, Apr 21, 2022 at 07:00:07PM +0800, Hangbin Liu wrote:
> > Hi Eyal,
> > On Tue, Apr 19, 2022 at 09:14:38PM +0300, Eyal Birger wrote:
> > > > > > On Mon,  9 Aug 2021 15:04:55 +0800 you wrote:
> > > > > > > When mirror/redirect a skb to a different port, the ct info should be reset
> > > > > > > for reclassification. Or the pkts will match unexpected rules. For example,
> > > > > > > with following topology and commands:
> > > > > > >
> > > > > > >     -----------
> > > > > > >               |
> > > > > > >        veth0 -+-------
> > > > > > >               |
> > > > > > >        veth1 -+-------
> > > > > > >               |
> > > > > > >
> > > > > > > [...]
> > > > > >
> > > > > > Here is the summary with links:
> > > > > >   - [net] net: sched: act_mirred: Reset ct info when mirror/redirect skb
> > > > > >     https://git.kernel.org/netdev/net/c/d09c548dbf3b
> > > > >
> > > > > Unfortunately this commit breaks DNAT when performed before going via mirred
> > > > > egress->ingress.
> > > > >
> > > > > The reason is that connection tracking is lost and therefore a new state
> > > > > is created on ingress.
> > > > >
> > > > > This breaks existing setups.
> > > > >
> > > > > See below a simplified script reproducing this issue.
> >
> > I think we come in to a paradox state. Some user don't want to have previous
> > ct info after mirror, while others would like to keep. In my understanding,
> > when we receive a pkt from a interface, the skb should be clean and no ct info
> > at first. But I may wrong.
>
> Makes sense to me. Moreover, there were a couple of fixes on this on
> mirred around that time frame/area (like f799ada6bf23 ("net: sched:
> act_mirred: drop dst for the direction from egress to ingress")). That's
> because we are seeing that mirred xmit action when switching to
> ingress direction should be as close skb_scrub_packet. OVS needs this
> scrubbing as well, btw. This ct information could be easily stale if
> there were other packet changes after it.

Makes sense to me too. The main reason for bringing this up was that it's a
subtle change and wasn't trivial to figure out.

>
> Point being, if we really need the knob for backwards compatibility
> here, it may have to be a broader one.

FWIW the dst change was ok in our setups.

>
> >
> > Jamal, Wang Cong, Jiri, do you have any comments?
> >
> > > >
> > > > I guess I can understand why the reproducer triggers it, but I fail to
> > > > see the actual use case you have behind it. Can you please elaborate
> > > > on it?
> > >
> > > One use case we use mirred egress->ingress redirect for is when we want to
> > > reroute a packet after applying some change to the packet which would affect
> > > its routing. for example consider a bpf program running on tc ingress (after
> > > mirred) setting the skb->mark based on some criteria.
> > >
> > > So you have something like:
> > >
> > > packet routed to dummy device based on some criteria ->
> > >   mirred redirect to ingress ->
> > >     classification by ebpf logic at tc ingress ->
> > >        packet routed again
> > >
> > > We have a setup where DNAT is performed before this flow in that case the
> > > ebpf logic needs to see the packet after the NAT.
> >
> > Is it possible to check whether it's need to set the skb->mark before DNAT?
> > So we can update it before egress and no need to re-route.

For future reference, we worked around this issue by moving some of the
relevant ebpf functionality to the lwt output hook which allows classification
and rerouting.

Eyal.
