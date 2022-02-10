Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5424B0F18
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 14:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242392AbiBJNrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 08:47:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242384AbiBJNrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 08:47:12 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6D2D73;
        Thu, 10 Feb 2022 05:47:13 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id fy20so15431505ejc.0;
        Thu, 10 Feb 2022 05:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3O5dxW8Yi3OGBQsUph2cEFwlLeho+NaqEkL3/CgaS64=;
        b=UKZG9UDkHLOigLdNLKeZ0FMk/1dFBQae/6nrOMlCiK4oKFBaClwv655PPDg/cf7/Cn
         x6QIyIowFHjt1tVUIhBnVGU0/QTY0GsbNysAdzdo9nioSB35CA74mDKDxwCanMaKgzZa
         QQ0QrC3oD7yE1GSkJAwi/6CJoSooxTPiqEWzO+eP+P4cY0RXxCRId1dhG5Tl6B2LbXfC
         3kSJeyqj6PpHNcoS+2Qf9j264sHgYzxbMXzGPY4nqmMYDPdIwunS4IM+OXlJsWPYWkfs
         EtIYLpndqbz+NdSMUTrsozOYMfz3qnioawWsMTa5xiDMGgtuK4YPtvVdA2IGSkGpR6S5
         I56Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3O5dxW8Yi3OGBQsUph2cEFwlLeho+NaqEkL3/CgaS64=;
        b=of/pj6Nm2MxdYLglRcjOAQNJ7Ij2f+oXi51FxZaGAHT6d/J7VF8SCCTlKgOPV7GLs0
         ap8mBe6dfSe6pXPkLM8qm21uWxPS6v91HW+Wp+vaFd4XXaXMkcXck+XPZcuP5HBfBitU
         ndBz3/9IioSjTr+8b9uaDiFcwGuXGSO2B72ub206BycXmnjBmoeKnIbUx1QzSk/oOrr3
         rHpWlpRmKucnItUH0lhSgtP7IYjTZnmzD3OUeVUyb2phGn4goyBch03cJt0JFJxz5YlK
         iwrFopkzy3T8Dx5Z/ykaPB1aXh8Ej8259n3zXUG1XdM9O0mCO3PtA13RZM9o9g0L/QnG
         e7cw==
X-Gm-Message-State: AOAM532rMBwG+dEE7wc0OoPpkjsPGOAOeto6uX0ecTNT1rR8sZtAWqDT
        eIISOCs2wcPV5y3XO873Ds1Yov6lYJXhms+Dm1U=
X-Google-Smtp-Source: ABdhPJyWMp7m4+apEwVy+wWt18FsYjZ2B+C1emhDUEB7/gfu8NcXsUiOi8gdQjmNxvt9Gj9xNCMK4dBf4z0+vyyc7Uw=
X-Received: by 2002:a17:906:b819:: with SMTP id dv25mr6409626ejb.689.1644500829972;
 Thu, 10 Feb 2022 05:47:09 -0800 (PST)
MIME-Version: 1.0
References: <20220128073319.1017084-1-imagedong@tencent.com>
 <20220128073319.1017084-2-imagedong@tencent.com> <0029e650-3f38-989b-74a3-58c512d63f6b@gmail.com>
 <CADxym3akuxC_Cr07Vzvv+BD55XgMEx7nqU4qW8WHowGR0jeoOQ@mail.gmail.com> <20220209211202.7cddd337@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220209211202.7cddd337@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Thu, 10 Feb 2022 21:42:14 +0800
Message-ID: <CADxym3ZajjCV2EHF6+2xa5ewZuVqxwk6bSqF0KuA+J6sGnShbQ@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 1/7] net: skb_drop_reason: add document for
 drop reasons
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        pablo@netfilter.org, kadlec@netfilter.org,
        Florian Westphal <fw@strlen.de>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, alobakin@pm.me,
        paulb@nvidia.com, Kees Cook <keescook@chromium.org>,
        talalahmad@google.com, haokexin@gmail.com, memxor@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Cong Wang <cong.wang@bytedance.com>
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

On Thu, Feb 10, 2022 at 1:12 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 10 Feb 2022 11:19:49 +0800 Menglong Dong wrote:
> > I'm doing the job of using kfree_skb_reason() for the TCP layer,
> > and I have some puzzles.
> >
> > When collecting drop reason for tcp_v4_inbound_md5_hash() in
> > tcp_v4_rcv(), I come up with 2 ways:
> >
> > First way: pass the address of reason to tcp_v4_inbound_md5_hash()
> > like this:
> >
> >  static bool tcp_v4_inbound_md5_hash(const struct sock *sk,
> >                       const struct sk_buff *skb,
> > -                    int dif, int sdif)
> > +                    int dif, int sdif,
> > +                    enum skb_drop_reason *reason)
> >
> > This can work, but many functions like tcp_v4_inbound_md5_hash()
> > need to do such a change.
> >
> > Second way: introduce a 'drop_reason' field to 'struct sk_buff'. Therefore,
> > drop reason can be set by 'skb->drop_reason = SKB_DROP_REASON_XXX'
> > anywhere.
> >
> > For TCP, there are many cases where you can't get a drop reason in
> > the place where skb is freed, so I think there needs to be a way to
> > deeply collect drop reasons. The second can resolve this problem
> > easily, but extra fields may have performance problems.
> >
> > Do you have some better ideas?
>
> On a quick look tcp_v4_inbound_md5_hash() returns a drop / no drop
> decision, so you could just change the return type to enum
> skb_drop_reason. SKB_DROP_REASON_NOT_SPECIFIED is 0 is false,
> so if (reason) goto drop; logic will hold up.

Yeah, that's an idea. But some functions are more complex, such as
tcp_rcv_state_process() and tcp_rcv_state_process()->tcp_v4_conn_request().
The return value of tcp_rcv_state_process() can't be reused, and it's hard
to add a function param of type 'enum skb_drop_reason *' to
tcp_v4_conn_request().

There are some nice drop reasons in tcp_v4_conn_request(), it's a pity to
give up them.

How about introducing a field to 'struct sock' for drop reasons? As sk is
locked during the packet process in tcp_v4_do_rcv(), this seems to work.

Thanks!
Menglong Dong
