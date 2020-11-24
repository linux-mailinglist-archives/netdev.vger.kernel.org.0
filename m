Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA2D2C31EB
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 21:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730971AbgKXU1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 15:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgKXU1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 15:27:06 -0500
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897BBC0613D6;
        Tue, 24 Nov 2020 12:27:06 -0800 (PST)
Received: by mail-oo1-xc41.google.com with SMTP id i30so2885571ooh.9;
        Tue, 24 Nov 2020 12:27:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1p3MphIVZg58IrRlJbbZQsq/DayH0/k53DA6gJWI+tY=;
        b=kESjEbsMyt0C9kEtlQN/GPGWWzPPTR94l4yhLYCrPcckKsSp7OjFKkGhvtm0n/sa8k
         /VwWhL0m8LuALUMHCb0Ks3s/QrNoOioGLD2LKZ4Ck8itg8Kfj7n8xMqoKF4v08x22YYV
         FmLEXkMhEXq6R/Ou2POkCl0yS83EBEB/PwYmtw8NOvF8ICy4I1ZEh+fL7Go/M+4QIuSO
         e9MWj/bzc3tQWrhiXGAMdnPSF0MA8sX8bNELO14j2LxXnjba/rQbVn4lyKijceuN99MA
         PKxa6Dm6ldTt0foRq0TAQhUhgzREclEiPT22aTTm2IYXL2cFo8+1Jn2LxaIMOHtx0XRG
         of5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1p3MphIVZg58IrRlJbbZQsq/DayH0/k53DA6gJWI+tY=;
        b=ttTb3/V2fycBsaFFQw3R5FV7sex0gpR6rC1JhVH1RbnBnd4Lk2hGzqf7Q8EyjgR+eI
         vw0cRLOSR/+sGWNTcUn77AS7nn5FA91ZT9417UnH8TyCebEH6DYH+8zR7OYQFU1dI4DY
         pXmWIyxpifQwXBoP6CKcgdVXUpPqSSRsevtB0FpmdsUgSv58edmCvWR/6SOtjx7hzKU0
         7GIU0ax8q9NX3n5FB+xxN25vSycCqXiAuy0t1u0hrz04vr8D8/lc0SQ/CV+MVs5Q8YYZ
         BkImX3af61dpbrLvhEcmbTqZ7Ub3iNFLgEV9RyfbMDco5zsoD2IomxnCnjXfo9WamHTE
         a+3g==
X-Gm-Message-State: AOAM531XV/Qk+MwZ/lOXGFWIesnojp0VR7Zm0ekFG79if4rhlJk9NPYo
        TNenLWsNul1Ti6hgKb4cclJz/TRemOCESmu4rg==
X-Google-Smtp-Source: ABdhPJzgirUetLwmKsEwRsYdOGsTrSFqmH+CMkWHtP8fG2GQbOqglTAc3jLGPdw2Lr4nYTP25FFhtFJphpd/Ea0V5pw=
X-Received: by 2002:a05:6820:351:: with SMTP id m17mr113548ooe.36.1606249625819;
 Tue, 24 Nov 2020 12:27:05 -0800 (PST)
MIME-Version: 1.0
References: <20201120181627.21382-1-george.mccollister@gmail.com>
 <20201120181627.21382-2-george.mccollister@gmail.com> <919273d3-6aa6-33b3-a8fe-d59ace9b1342@gmail.com>
In-Reply-To: <919273d3-6aa6-33b3-a8fe-d59ace9b1342@gmail.com>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Tue, 24 Nov 2020 14:26:53 -0600
Message-ID: <CAFSKS=NujO_LXWjMFhXwiHGjB0RDEVXqSOUKooSywSLPKHw5sw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] dsa: add support for Arrow XRS700x tag trailer
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 4:18 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 11/20/2020 10:16 AM, George McCollister wrote:
> > Add support for Arrow SpeedChips XRS700x single byte tag trailer. This
> > is modeled on tag_trailer.c which works in a similar way.
> >
> > Signed-off-by: George McCollister <george.mccollister@gmail.com>
>
> One question below:
>
> [snip]
>
> > +     if (pskb_trim_rcsum(skb, skb->len - 1))
> > +             return NULL;
> > +
> > +     /* Frame is forwarded by hardware, don't forward in software. */
> > +     skb->offload_fwd_mark = 1;
>
> Given the switch does not give you a forwarding reason, I suppose this
> is fine, but do you possibly have to qualify this against different
> source MAC addresses?

I don't see any reason why I'd need to do that but maybe I'm missing something.

> --
> Florian
