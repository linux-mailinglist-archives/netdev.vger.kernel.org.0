Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D24258DBD
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 13:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgIAL5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 07:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727963AbgIAL53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 07:57:29 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2582C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 04:57:24 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id d26so1246541ejr.1
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 04:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dHfbkHKqlJNasfLkXcpOnTeNlwRUoLyY5hJuqtCUfFc=;
        b=otSMpZbaoETFEo2TAx1vrB9dOgzWa3vAwj/3aPR3zxGQPGyWGnY2ZJoyI9gQVkN3Ag
         tJy8S4ommUvlmj4DBgMVz6jgvM3RO+zaUs6CC5ZEcrYg/LZ/bbWjO1so2mZhtB+m2HPh
         yrWmZ180rjT/fS/hiPh4E8UoSWp5DJ4YNzgu0zXAHewlEUgELzAk5SjIFehd5uANbn2R
         argMki2zw6uTsfiIgV+eEM5/iq6uEOEDut0Fg882WT3R9yBHLJ3o5iQh2ULjmqm1U1db
         c1M8++jehsmskPuW3xJA4/9SdvU9jc0HGUuR/p2W5t7SoVFvFOuEGkbfYm4Phbxe/IkH
         8nJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dHfbkHKqlJNasfLkXcpOnTeNlwRUoLyY5hJuqtCUfFc=;
        b=rr0M7CRL9uJAzuuSlevYeWjGs92QRv0PI8xz3oqIxPYedqJOsjIPHZPo6e+Q8V6Rih
         PS2qC1e5YDEAn699gnhibZNurpLRwOeAn1jn9Z3Bs+XTtG5rsA7z1PnjOJBefNmk/5Tl
         +48k2HDd7slbdsYhdnphke9v4BqyCPNiTHnE9/snQfBeMs3Wp0Vhzumyn4SExeSjb5q7
         B3hh9d9T0jgt2bDQmn5f0BqZSs/fLPcqN913zPfjG9bxN3ZlYuBjQKCFP6DqRp0JzY71
         9f3EcgYxG1nVUE+0X/O5pMpmB5h5cu1CJmLauQidojY5ir2GBYIintaZ5chwKynxFHdJ
         8Vdg==
X-Gm-Message-State: AOAM532LBFaC3SlH4t8m3/O2o13YLYKWN1T9gU7dgshdUmqBme70Rhb3
        ovDtJpElO42SceMu99SW7ZsRmGzIP8kg15U4Vaw=
X-Google-Smtp-Source: ABdhPJyh1TcUDbPtVSDqmijz44rzJSAyahwAkkQrzEDC1FTo2HZ/E5Wb6ccxjqqe/QmXUi407KEFcmRoMfUQazZ6mz0=
X-Received: by 2002:a17:906:2a49:: with SMTP id k9mr1177509eje.117.1598961443492;
 Tue, 01 Sep 2020 04:57:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200825050636.14153-1-xiangxia.m.yue@gmail.com>
 <20200825050636.14153-2-xiangxia.m.yue@gmail.com> <20200825235121.0d8bd3d0@elisabeth>
In-Reply-To: <20200825235121.0d8bd3d0@elisabeth>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 1 Sep 2020 19:54:14 +0800
Message-ID: <CAMDZJNWW96=XsLrV1GvOg_dRKhUr62473ftXdXc1BKWPMk2gUg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/3] net: openvswitch: improve coding style
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Pravin Shelar <pshelar@ovn.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        ovs dev <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 26, 2020 at 5:51 AM Stefano Brivio <sbrivio@redhat.com> wrote:
>
> On Tue, 25 Aug 2020 13:06:34 +0800
> xiangxia.m.yue@gmail.com wrote:
>
> > +++ b/net/openvswitch/datapath.c
> >
> > [...]
> >
> > @@ -2095,7 +2099,7 @@ static void ovs_update_headroom(struct datapath *dp, unsigned int new_headroom)
> >       dp->max_headroom = new_headroom;
> >       for (i = 0; i < DP_VPORT_HASH_BUCKETS; i++)
>
> While at it, you could also add curly brackets here.
>
> > +++ b/net/openvswitch/flow_table.c
> >
> > [...]
> >
> > @@ -111,9 +111,11 @@ static void flow_free(struct sw_flow *flow)
> >       if (ovs_identifier_is_key(&flow->id))
> >               kfree(flow->id.unmasked_key);
> >       if (flow->sf_acts)
> > -             ovs_nla_free_flow_actions((struct sw_flow_actions __force *)flow->sf_acts);
> > +             ovs_nla_free_flow_actions((struct sw_flow_actions __force *)
> > +                                       flow->sf_acts);
> >       /* We open code this to make sure cpu 0 is always considered */
> > -     for (cpu = 0; cpu < nr_cpu_ids; cpu = cpumask_next(cpu, &flow->cpu_used_mask))
> > +     for (cpu = 0; cpu < nr_cpu_ids;
> > +          cpu = cpumask_next(cpu, &flow->cpu_used_mask))
>
> ...and here.
>
> > @@ -273,7 +275,7 @@ static int tbl_mask_array_add_mask(struct flow_table *tbl,
> >
> >       if (ma_count >= ma->max) {
> >               err = tbl_mask_array_realloc(tbl, ma->max +
> > -                                           MASK_ARRAY_SIZE_MIN);
> > +                                          MASK_ARRAY_SIZE_MIN);
>
> This is not aligned properly either, MASK_ARRAY_SIZE_MIN is added to
> ma->max and should be aligned to it.
>
> > @@ -448,16 +450,17 @@ int ovs_flow_tbl_init(struct flow_table *table)
> >
> >  static void flow_tbl_destroy_rcu_cb(struct rcu_head *rcu)
> >  {
> > -     struct table_instance *ti = container_of(rcu, struct table_instance, rcu);
> > +     struct table_instance *ti =
> > +             container_of(rcu, struct table_instance, rcu);
>
> The assignment could very well go on a separate line.
Hi Stefano
Sorry for missing the comment. I update the patch in v4. Thanks.

> --
> Stefano
>


-- 
Best regards, Tonghao
