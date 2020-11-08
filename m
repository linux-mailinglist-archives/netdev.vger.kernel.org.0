Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617E92AA977
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 06:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgKHF1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 00:27:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgKHF1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 00:27:44 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349EFC0613CF;
        Sat,  7 Nov 2020 21:27:44 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id n15so5444710otl.8;
        Sat, 07 Nov 2020 21:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=XE6DDqq8PzLKVEch12IMRl0UYe/3AExuvFUQzYKpLi4=;
        b=rO4JvHvjG1z98sfUyqjZnyyyW5v5uJhtLYJfPk/bepN2kdth/pRGCI2nHbZ+QvaLJV
         oYpVF6cSr5arJfh2Ejl06cewlNXviRHzycqte/VKaQo+3cVAVxRo/Pl9a1i9khDqswiB
         LF1uZVom/COgjeOL+cPLTsFpRdmmCEnnEv4/DsqE7nmB1R4mCUAQhEMNJlF/bq1O1EXK
         KtbtnCjn3CzZAf+zRa1KtZ4tSKhdqFiYc/0WBwY4iDdVkCpdJFYTLvPYyT5M5rl5+Knp
         T8x9O4MAbwTBiePfAZUsxn0Wk+DmbeGLtlza2rbqcUzCJrvRv3g1Gqh1/qnItPpjn25D
         Iv/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=XE6DDqq8PzLKVEch12IMRl0UYe/3AExuvFUQzYKpLi4=;
        b=nh45UXaUVU1XxjPQ9HeBgcFzy4wdYxCbOv55szvbQNt3Z4IG0ycABEdZrJZDKcRmoX
         f63ZEO1dIebtoVZbB9nZDl1BT9wJttTER9HKhii4NT+8zqp3d67yKleyFWY0mln1xRJL
         GL0g52QXha821bAewnOHow/d8P5NrjhCY6XQ9qitJRVqmA8MSy/6ryBPR31Kn3ZA5KTk
         fsHvprv7PYql6fu48FA+gBAss1IVxulbICI+l9vWUKVnyqFYxt8sDZd4KavwjshW6utL
         GTeOUWMo38cusHIbayZHUkVsMPjHq6Pvh2H/fbbE9hPW9PbSQ2zuYuY/4ycDOgb4M0pj
         hnCg==
X-Gm-Message-State: AOAM5329rGdiQNu4NbFDMX7jqyceyQJxbdrq1/2g0IMt03on2XElgv8x
        C0N4HqB9+F0tWUg53pYMGMnZdrWw7+m6ylV8/ts=
X-Google-Smtp-Source: ABdhPJztcNOzPPZtWecyVrFoVBcPQ7OBV38hbvs50i68GTku5OjdMCjgbOWyXcEI90sNyXbqMqRLTOzj/YQk+20XeIY=
X-Received: by 2002:a9d:731a:: with SMTP id e26mr6034762otk.53.1604813263494;
 Sat, 07 Nov 2020 21:27:43 -0800 (PST)
MIME-Version: 1.0
References: <20201107122617.55d0909c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <222b9c1b-9d60-22f3-6097-8abd651cc192@gmail.com>
In-Reply-To: <222b9c1b-9d60-22f3-6097-8abd651cc192@gmail.com>
From:   Zhu Yanjun <zyjzyj2000@gmail.com>
Date:   Sun, 8 Nov 2020 13:27:32 +0800
Message-ID: <CAD=hENdP8sJrBZ7uDEWtatZ3D6bKQY=wBKdM5NQ79xveohAnhQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] RDMA/rxe: Fetch skb packets from ethernet layer
To:     "zyjzyj2000@gmail.com" <zyjzyj2000@gmail.com>, kuba@kernel.org,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 8, 2020 at 1:24 PM Zhu Yanjun <zyjzyj2000@gmail.com> wrote:
>
>
>
>
> -------- Forwarded Message --------
> Subject: Re: [PATCH 1/1] RDMA/rxe: Fetch skb packets from ethernet layer
> Date: Sat, 7 Nov 2020 12:26:17 -0800
> From: Jakub Kicinski <kuba@kernel.org>
> To: Zhu Yanjun <yanjunz@nvidia.com>
> CC: dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, netdev@vger.kernel.org
>
>
> On Thu, 5 Nov 2020 19:12:01 +0800 Zhu Yanjun wrote:
>
> In the original design, in rx, skb packet would pass ethernet
> layer and IP layer, eventually reach udp tunnel.
>
> Now rxe fetches the skb packets from the ethernet layer directly.
> So this bypasses the IP and UDP layer. As such, the skb packets
> are sent to the upper protocals directly from the ethernet layer.
>
> This increases bandwidth and decreases latency.
>
> Signed-off-by: Zhu Yanjun <yanjunz@nvidia.com>
>
>
> Nope, no stealing UDP packets with some random rx handlers.

Why? Is there any risks?

Zhu Yanjun
>
> The tunnel socket is a correct approach.
