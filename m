Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C07320817
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 03:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhBUCVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 21:21:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhBUCVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Feb 2021 21:21:37 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE16C061574;
        Sat, 20 Feb 2021 18:20:57 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id f17so6928095qth.7;
        Sat, 20 Feb 2021 18:20:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lXiKXFfeWt9fU0aynhUPV7n3Y0YFPh1zzQ5w7OiN4mM=;
        b=cFC7u7NHHyBOp5k9mW7/pxbztiaxUnpSNt86azW9EwDKnp1kqiZcL/F490A7RSbyxx
         Uxt1J2ROaMu1VWPU16BjHUP+jQed6PJXCIaUHn78f0uzWG2NMgbBz+zfLlksUKNsvzAS
         f8utfn3OCGiTwSaU8XgbtAPPYZiuHTIpMOXq4htmY8ivzB1LIq/u48w/n2rWFWACTxCl
         59pcRZYjGouQ4ejcxxpeUurqwsmB0VBgjesuiiBfK9ViN9GRuVey511MYZLaKVIjO9EM
         oPzTVURyuLPmWlXav416O9K4ZCs+Rmh81xwc1uzpgVTfw2ek+/ETxwHHyYapABFD6jNb
         sZnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lXiKXFfeWt9fU0aynhUPV7n3Y0YFPh1zzQ5w7OiN4mM=;
        b=agkHC1IUL4P9lvunhbatu/2un9vgjFy+EL0OnyMOQSrZyx1v+MU/WG2PZFvO/wwhIZ
         Fl96683DxBDYE8C5FXVH95lOrkQ3Z3vxwLk2TW3484fCh6SmH7ODHERJFJzP8Py4V1f7
         8R1LRPijwQD+6xV3YuLw937X0Xw9DBVDS3AuZwFTn+u/z6iD8+2aLurY+qt2+eBvQmUt
         2eRTRFn2SUzNrUHc2itN7tm4cybzZ4IexKDX6riE4DZubGEEa5Pj9jIZAGoQ5R0pN7Yr
         9gYnjSyaeOE/m/bKJk35n/Y1SItTBI09JsTr0r+ago+sRw6kEY0kJo9Bc1jfeKfEwL5Z
         5I9w==
X-Gm-Message-State: AOAM533EIOchmK9Be96c4hWf3GnDAeDK+CRPGml/e6DyQrs1GfwBvDI/
        bZMm5V7Dsjm+Sa8juz+IDCzq2/HZsuZLh2W0P+o=
X-Google-Smtp-Source: ABdhPJzS83AOa3X+3olu8OpFyXENV/vMJO86vMNACCxwO9i5S9I3K5QYQNtqjh52tnrrn7yZuewuP1QvuAfGOLCifJY=
X-Received: by 2002:a05:622a:18c:: with SMTP id s12mr15604599qtw.131.1613874055734;
 Sat, 20 Feb 2021 18:20:55 -0800 (PST)
MIME-Version: 1.0
References: <20210220043203.11754-1-yejune.deng@gmail.com> <3b69191b-9bd5-9050-9126-17b4905a67e9@gmail.com>
In-Reply-To: <3b69191b-9bd5-9050-9126-17b4905a67e9@gmail.com>
From:   Yejune Deng <yejune.deng@gmail.com>
Date:   Sun, 21 Feb 2021 10:20:44 +0800
Message-ID: <CABWKuGW5bvPDvNv5=Fj_=f9=gk--=_w28jsCJ8MK5t7ysK+s8g@mail.gmail.com>
Subject: Re: [PATCH] arp: Remove the arp_hh_ops structure
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry,it was my fault, I will resubmit.

On Sun, Feb 21, 2021 at 9:54 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 2/19/21 9:32 PM, Yejune Deng wrote:
> >  static const struct neigh_ops arp_direct_ops = {
> >       .family =               AF_INET,
> >       .output =               neigh_direct_output,
> > @@ -277,15 +269,10 @@ static int arp_constructor(struct neighbour *neigh)
> >                       memcpy(neigh->ha, dev->broadcast, dev->addr_len);
> >               }
> >
> > -             if (dev->header_ops->cache)
> > -                     neigh->ops = &arp_hh_ops;
> > -             else
> > -                     neigh->ops = &arp_generic_ops;
>
> How did you test this?
>
> you took out the neigh->ops assignment, so all of the neigh->ops in
> net/core/neighbour.c are going to cause a NULL dereference.
>
>
> > -
> > -             if (neigh->nud_state & NUD_VALID)
> > -                     neigh->output = neigh->ops->connected_output;
> > +             if (!dev->header_ops->cache && (neigh->nud_state & NUD_VALID))
> > +                     neigh->output = arp_generic_ops.connected_output;
> >               else
> > -                     neigh->output = neigh->ops->output;
> > +                     neigh->output = arp_generic_ops.output;
> >       }
> >       return 0;
> >  }
> >
>
