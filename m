Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 502794FBC2A
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 14:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243553AbiDKMhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 08:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346116AbiDKMhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 08:37:12 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7867A1ADBD
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 05:34:58 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-2ebebe631ccso78632647b3.4
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 05:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R9y1kk602xVe9VWgNIj5Zet7o/mgFMgJ/PHrZsXQqKY=;
        b=jg3ZpF/NWDTAbaq9QrEnXCvGMqEMAPC/i8QN3AtUwsJfpgNEY9QU+7G0PIA+3fBD8N
         osCCQido5jqE2bFDuLGr0q/RRSfyR2oNGyW/WZ46+QPXEDTZGhbuh12ABevl0Bs1osYD
         6HCqjBvxAQeq4Xmmc1etJCq+aXZP1XzJD7z4VdqcfRrjGAyD+KeJzjpj0V8C2ADrRRY1
         g9jY9WQSzdJ5w6B/nKxgi8p76amooqLtMiDukc8DMFiYD9eLSaV/ug9udKUXc+yR8LGB
         ZEFDg//yIS3WC7kwKdjG0lAnbjaXtg+Xy1N4n2Pn4n00yhokJ9ejVA17ealNiPA9KG/n
         sg0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R9y1kk602xVe9VWgNIj5Zet7o/mgFMgJ/PHrZsXQqKY=;
        b=QWYVn8WElOIrv4CACf+ZVwCJsHu1cBFK5x8tRX0emTbeLyaO/jb504J3n1fdLs/LJk
         uzTi9InIjF4OtcQKSsRaa+KkXM8pP5ApfpHtTp/9a0g2AKJa0cwsa0iLM0fW/iVK4VaS
         KRfqznDCG+9+szbP1hyvgkEtkVjA0huX37nqwyM6GP0aqh6GkvZeqnEIJIVa8IyGM8LK
         d4jgGi08hkWp5s57n0KBCfED3Yx5qerpoSsaj6W5EAZKtgPjJ573Yjq7u3W0k8dgrOnP
         cNuy02abAYHbZbu/73FNujBwDTQ6lNVYRrfhyA0fsmHFWJV2nqWytTYh2fkLddmzVvkm
         J0Qg==
X-Gm-Message-State: AOAM533c3Hw5gQAhCNHlkU3T5IMUWsD/KaeloYm6dYHlvM/kc/jeAGGW
        XxG2OTbIexFu2vKWQw6gGbbLux68y0/3qHb2BEKUWg==
X-Google-Smtp-Source: ABdhPJw7mL5DK/85t4seNBQ//oyr1Ue4YW/C8vfJYey+JgYw8q2mBESHYu71mJhYsZUK5galN6sdupUsT8Mp2jwq/SY=
X-Received: by 2002:a81:98c2:0:b0:2ea:4f2d:185e with SMTP id
 p185-20020a8198c2000000b002ea4f2d185emr26983651ywg.4.1649680497559; Mon, 11
 Apr 2022 05:34:57 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1649528984.git.lorenzo@kernel.org> <628c0a6d9bdbc547c93fcd4ae2e84d08af7bc8e1.1649528984.git.lorenzo@kernel.org>
 <CAC_iWj+wGjx4uAmtkvP=kJsD1uBKsxUXPfy8YS8Abhz=ooLmkg@mail.gmail.com> <YlQe8QysuyGRtxAx@lore-desk>
In-Reply-To: <YlQe8QysuyGRtxAx@lore-desk>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Mon, 11 Apr 2022 15:34:21 +0300
Message-ID: <CAC_iWj+fk4hkpBQE6SnusVHFJMoq3u40Hn2VK7uCmUADXM2MPQ@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 1/2] net: page_pool: introduce ethtool stats
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        thomas.petazzoni@bootlin.com, linux@armlinux.org.uk,
        jbrouer@redhat.com, jdamato@fastly.com, andrew@lunn.ch
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Apr 2022 at 15:28, Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> > Hi Lorenzo,
>
> Hi Ilias,
>
> >
> > [...]
> >
> > >
> > >         for_each_possible_cpu(cpu) {
> > >                 const struct page_pool_recycle_stats *pcpu =
> > > @@ -66,6 +87,47 @@ bool page_pool_get_stats(struct page_pool *pool,
> > >         return true;
> > >  }
> > >  EXPORT_SYMBOL(page_pool_get_stats);
> > > +
> > > +u8 *page_pool_ethtool_stats_get_strings(u8 *data)
> > > +{
> > > +       int i;
> > > +
> > > +       for (i = 0; i < ARRAY_SIZE(pp_stats); i++) {
> > > +               memcpy(data, pp_stats[i], ETH_GSTRING_LEN);
> > > +               data += ETH_GSTRING_LEN;
> > > +       }
> > > +
> > > +       return data;
> >
> > Is there a point returning data here or can we make this a void?
>
> it is to add the capability to add more strings in the driver code after
> running page_pool_ethtool_stats_get_strings.

But the current driver isn't using it.  I don't have too much
experience with how drivers consume ethtool stats, but would it make
more sense to return a length instead of a pointer? Maybe Andrew has
an idea.

Thanks
/Ilias
>
> >
> > > +}
> > > +EXPORT_SYMBOL(page_pool_ethtool_stats_get_strings);
> > > +
> > > +int page_pool_ethtool_stats_get_count(void)
> > > +{
> > > +       return ARRAY_SIZE(pp_stats);
> > > +}
> > > +EXPORT_SYMBOL(page_pool_ethtool_stats_get_count);
> > > +
> > > +u64 *page_pool_ethtool_stats_get(u64 *data, struct page_pool_stats *stats)
> > > +{
> > > +       int i;
> > > +
> > > +       for (i = 0; i < ARRAY_SIZE(pp_stats); i++) {
> > > +               *data++ = stats->alloc_stats.fast;
> > > +               *data++ = stats->alloc_stats.slow;
> > > +               *data++ = stats->alloc_stats.slow_high_order;
> > > +               *data++ = stats->alloc_stats.empty;
> > > +               *data++ = stats->alloc_stats.refill;
> > > +               *data++ = stats->alloc_stats.waive;
> > > +               *data++ = stats->recycle_stats.cached;
> > > +               *data++ = stats->recycle_stats.cache_full;
> > > +               *data++ = stats->recycle_stats.ring;
> > > +               *data++ = stats->recycle_stats.ring_full;
> > > +               *data++ = stats->recycle_stats.released_refcnt;
> > > +       }
> > > +
> > > +       return data;
> >
> > Ditto
>
> same here.
>
> Regards,
> Lorenzo
>
> >
> > > +}
> > > +EXPORT_SYMBOL(page_pool_ethtool_stats_get);
> > >  #else
> > >  #define alloc_stat_inc(pool, __stat)
> > >  #define recycle_stat_inc(pool, __stat)
> > > --
> > > 2.35.1
> > >
> >
> > Thanks
> > /Ilias
