Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A87E23DE11
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 19:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729507AbgHFRVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 13:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729571AbgHFRVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 13:21:35 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76DD3C061575
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 10:21:35 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id t15so41467147iob.3
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 10:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sBHz45CBrjKzOMEFaYxLF+glZ59/D2TtW0F/VzvBEKc=;
        b=W1Q+XdwNbdaqRzo6JKtLewRkvUIOmfRzpZhv5HOS19U+Cwi7nHaV7mClKVnpX78LIS
         zDIdrqyhw4D387PINFKpg9px49dw8ITKypefT1ZxCIDPRlPcMkil6sGz8VO54qRDlZI2
         CdfLzAwWqmDDH0FmXfRkw9gRoN5dXo242m6QhoanxZHq+N1IadJbFIdH2tQBierJZ+rI
         G3a2EjzBs7ZtpDmD0frFGOZKVyF41eTmqPXqgRPRfsf1syTnilIH0qwnC7unqaHWxYbO
         R/fVQ2kp259h5R/R/C9g0N42y4f2mtKEhXKcFwk3mtKXp9eJA+Ii31Vm0CFzE7wAYewB
         wo8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sBHz45CBrjKzOMEFaYxLF+glZ59/D2TtW0F/VzvBEKc=;
        b=WK+UkYFnRe48pgBoxEsIralpvyZ0l15bcnbsc8N+P+HP8SrKASncBct5ugEbZu1br/
         DmVbF0pwrSuzGGrnri8go1+ciTeUXjWxZf+Lue4VL9KZMCIC/LoUFu6rqPuKfzILTPH8
         9ASL6oSLpqF935TtjsY2YbRNlwEelZ7hTcc9pltQSitqawbfRILhJfXrEH5BGGRuEl9M
         B8RATCfQc/R3dzfkgs8t802X0rC1gsWwys81tW7VrPt8ckynbxOop7H4L0rYdvVh1n6/
         jVdWGDnIcXnQeM9Fj7oqovhBBfDb9scfq3xTpEvk9mwVQTAc7ktNUOeQHVaoESl5MvGT
         9SDg==
X-Gm-Message-State: AOAM533Bi1IrrsgBAArVNdLHwb5zQG76ucikWFieTfyPjiPC7dPRyM9k
        IZ++iqCYX6YoeRpoTwjp15fcaXOEK0Ru9T5Fu/NtqkhcTl8=
X-Google-Smtp-Source: ABdhPJz0Xe+aFJcsxDAu1b1zI/7lHkXIur+gpvQRgL/HGSRW3SMo9ZV1OBWo8hUOGgMeYS7p4p6pcaW972W8tuOLvN4=
X-Received: by 2002:a05:6602:13d3:: with SMTP id o19mr10833134iov.32.1596734494183;
 Thu, 06 Aug 2020 10:21:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAFbJv-4yACz4Zzj50JxeU-ovnKMQP_Lo-1tk2jRuOJEs0Up6MQ@mail.gmail.com>
 <CAM_iQpWhwQc4yHvfFh-UWtEU2caMzXFXs4JM4gwQaRf=B0JG5g@mail.gmail.com>
In-Reply-To: <CAM_iQpWhwQc4yHvfFh-UWtEU2caMzXFXs4JM4gwQaRf=B0JG5g@mail.gmail.com>
From:   satish dhote <sdhote926@gmail.com>
Date:   Thu, 6 Aug 2020 22:51:23 +0530
Message-ID: <CAFbJv-5KYtxrXwiAJmyFuKx9zVn1NaOmt-EA7eM+_StS-+dbAA@mail.gmail.com>
Subject: Re: Question about TC filter
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Cong,

I tried adding below patch i.e. "return cl == 0 ? q->block : NULL;"
but after this I'm not able to see any output using "tc filter show... "
command. Looks like the filter is not getting configured.

If this is a bug, then do I need to file a new ticket for this?

Thanks
Satish

On Thu, Aug 6, 2020 at 5:36 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> Hello,
>
> On Tue, Aug 4, 2020 at 10:39 PM satish dhote <sdhote926@gmail.com> wrote:
> >
> > Hi Team,
> >
> > I have a question regarding tc filter behavior. I tried to look
> > for the answer over the web and netdev FAQ but didn't get the
> > answer. Hence I'm looking for your help.
> >
> > I added ingress qdisc for interface enp0s25 and then configured the
> > tc filter as shown below, but after adding filters I realize that
> > rule is reflected as a result of both ingress and egress filter
> > command?  Is this the expected behaviour? or a bug? Why should the
> > same filter be reflected in both ingress and egress path?
>
> I am not very sure but I am feeling this is a bug. Let's Cc Daniel who
> introduced this.
>
> With the introduction of clsact qdisc, the keywords "ingress" and
> "egress" were introduced too to match clsact qdisc. However, its
> major/minor handle is kinda confusing:
>
> TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_INGRESS);
> TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_EGRESS);
> #define TC_H_CLSACT TC_H_INGRESS
>
> They could match the ingress qdisc (ffff:) too.
>
>
> >
> > I understand that policy is always configured for ingress traffic,
> > so I believe that filters should not be reflected with egress.
> > Behaviour is same when I offloaded ovs flow to the tc software
> > datapath.
>
> I believe so too, otherwise it would be too confusing to users.
>
> If you are able to test kernel patch, does the following one-line
> change fix this problem? If not, I will try it on my side.
>
> diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
> index 84838128b9c5..4d9c1bb15545 100644
> --- a/net/sched/sch_ingress.c
> +++ b/net/sched/sch_ingress.c
> @@ -49,7 +49,7 @@ static struct tcf_block *ingress_tcf_block(struct
> Qdisc *sch, unsigned long cl,
>  {
>         struct ingress_sched_data *q = qdisc_priv(sch);
>
> -       return q->block;
> +       return cl == 0 ? q->block : NULL;
>  }
>
>  static void clsact_chain_head_change(struct tcf_proto *tp_head, void *priv)
>
>
> Thanks.
