Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE35749D91F
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 04:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235523AbiA0DVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 22:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbiA0DVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 22:21:03 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CFAC06161C;
        Wed, 26 Jan 2022 19:21:03 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id l5so1793386edv.3;
        Wed, 26 Jan 2022 19:21:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O5EXL+KCI3XHdyFnsikvunYb7cTowezqWaEb+c/SuL0=;
        b=d8N2K/LJLwqY+C2zjTs/R6C7yI7IQBhhmXmx/NAXVUIjndMXPE+0pfGsXOH9HFF/hc
         L5wKLZOV4GUR7L4W7unpnRI1gy4vbs71IulYvrDZyZePBbAaEoqiJOmjyd7wexbxaye8
         T9fdFzmiFBHYkWmQoTG6pkx9ORLOHE/M9oBdkGnWzeQVNTzDDmXI7KWjfNj66C35P1El
         w7uvBC8NVtP0eNuxdJXEjjULrQIn5ApBCHjfnYENGWq+QGqbVkVuOYLvsEfJQRuHbwJc
         Xs/xg2FDET7Vmg0a7BIBuGJm2V0/Xr2z+cXSPAGtIyoMec3zdb/SREWiglmwo3KKzG3y
         VlXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O5EXL+KCI3XHdyFnsikvunYb7cTowezqWaEb+c/SuL0=;
        b=Cf6FbxT7vEmzstqXHTwG7GyRcn+vQi3hiLhSyEeMOuQLLJj/ENYH1Exmr2hRgwa3hV
         wqwT7wWxXIjyElx1vEs9xx3m8yudkvuQRJQJD9H65hS+ohgTPgQMBVmczdRUtYh4mR4C
         PBQw3bEgMyu1ykiOVSAmIRnHiioHr9TiiwBSaanwCz1icMuv/PWaVsLv6MSJfZ/4ZcUw
         aa2jURm+DhHIjLrQJaeowrwxhPtiKMaGfmx/n9oc04eQMEOB9nQ1dK4SoCVXpGcH8di1
         SrHhlfZTRXbyj8fFFL+2Wf9FJaJvY0OznrKO/JXs9rl5togUtlJ/Ca9fJNSo3BxmOtPl
         46Ew==
X-Gm-Message-State: AOAM531AK1zVOcL2LZV7vVA1a2Sf9DIjW+ZFHQGRO3VxU0BLbxmK+IFJ
        YCWEAjp0TRkAdvZh+vjJlQFMuaiXMz3YuRCXUsM=
X-Google-Smtp-Source: ABdhPJzCJfIP8APfgXtAF/HrK1KeBX/GaOn46vgOdHi5yPrmCS87Uq/OLIq8Hoeocu6d8Rei02yT0d2EQ6DJQA9M73I=
X-Received: by 2002:a05:6402:448c:: with SMTP id er12mr1813831edb.137.1643253661540;
 Wed, 26 Jan 2022 19:21:01 -0800 (PST)
MIME-Version: 1.0
References: <20220126072306.3218272-1-imagedong@tencent.com> <20220126184812.32510ab4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220126184812.32510ab4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Thu, 27 Jan 2022 11:16:32 +0800
Message-ID: <CADxym3YmFhg4eKmQBYQhu+WQTT3KgJmpq_9u0-odKwKpv3DTGw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] net: drop_monitor: support drop reason
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Menglong Dong <imagedong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 10:48 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 26 Jan 2022 15:23:06 +0800 menglong8.dong@gmail.com wrote:
> > @@ -606,12 +610,17 @@ static int net_dm_packet_report_in_port_put(struct sk_buff *msg, int ifindex,
> >  static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
> >                                    size_t payload_len)
> >  {
> > -     u64 pc = (u64)(uintptr_t) NET_DM_SKB_CB(skb)->pc;
> > +     struct net_dm_skb_cb *cb = NET_DM_SKB_CB(skb);
> >       char buf[NET_DM_MAX_SYMBOL_LEN];
> > +     enum skb_drop_reason reason;
> >       struct nlattr *attr;
> >       void *hdr;
> > +     u64 pc;
> >       int rc;
> >
> > +     pc = (u64)(uintptr_t)cb->pc;
> > +     reason = cb->reason;
> > +
> >       hdr = genlmsg_put(msg, 0, 0, &net_drop_monitor_family, 0,
> >                         NET_DM_CMD_PACKET_ALERT);
> >       if (!hdr)
> > @@ -623,6 +632,9 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
> >       if (nla_put_u64_64bit(msg, NET_DM_ATTR_PC, pc, NET_DM_ATTR_PAD))
> >               goto nla_put_failure;
> >
> > +     if (nla_put_u32(msg, NET_DM_ATTR_REASON, reason))
>
> Why the temporary variable instead of referring to cb->reason directly?

Good question......v3 is coming

>
> > +             goto nla_put_failure;
