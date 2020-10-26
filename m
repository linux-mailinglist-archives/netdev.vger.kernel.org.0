Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBAE298AA2
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 11:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1770798AbgJZKpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 06:45:22 -0400
Received: from mail-ej1-f68.google.com ([209.85.218.68]:40692 "EHLO
        mail-ej1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1769734AbgJZKpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 06:45:21 -0400
Received: by mail-ej1-f68.google.com with SMTP id z5so12655260ejw.7;
        Mon, 26 Oct 2020 03:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HM6/Sr3nJXxqrX16N2s/rIrfSLdc6tUrdbmvk/TPFvQ=;
        b=L5GdUxWyN3n3LYR4ib2QpkhpqhqH3fGjRj9YoZcS8CZ6fn1qY2V8tKBpRWFYQrd7jI
         YMdJ36rs6r9282dtxuHX4C5O49rq7GH7OTlyxq/aoiQqqpxtJB6sl85WkfaffwoIKe6J
         pmw/dGrg6968KNdjmhR7BASo0zJG5SIp0ea6eitaaxUOwoL6cwhVbMwYagHXAmSv4aFV
         ufoPKEqsMR2CvOwn/VHmuq7GgqYN3WG60kRdI3sSE+p2XYzFxsRkzeyI0c+nj4EAw3hK
         AAAwQzdPrQE6+wAArr+8OUPbP7gskxvmVRdIVP1pYiBBb1RTM0mGRQnWaBVuNTd8PJlW
         n2sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HM6/Sr3nJXxqrX16N2s/rIrfSLdc6tUrdbmvk/TPFvQ=;
        b=NV98qGYVti2kpTF8L2RhSb/ksRmt1lz0mF34y5getc7y1P0LGuvwtIJPXb4bkgVFsX
         GEUIVS9dxm5JajMgStFAt6BM/8JlwHuBMjM1XcZsfnBMcoM1cHNoHZgER5mSfzVHq30K
         IpRSwSn/Zhw2Vsi4d15PcmdV1GChhhxNo715RZfukxD8TunQJJ3kNx9/T8F+xHakhRfA
         zXzD79SCjgzlGjDTBnjVityNbFUUiLNpJcjOQbiWl1w2/e3si64JlT3xJTXaW6WNuaZM
         kSqT09qp/NheaXu2ltfvqiqt52vgT4RaCIpzWEwsSY6jsM6MSEw7Y8/YSb5RXl+kBd/T
         W8bA==
X-Gm-Message-State: AOAM5320M+9hIW66qCqKCViHyDP7af3kBoZ8Lv94CYMvGPxYNhIWeMvF
        O8VELRq7TWhi9QQes8NHolls/XQ9M+ReSgQy/Lg=
X-Google-Smtp-Source: ABdhPJysxKW6w6JyF/+y1D07vrNwGBstdSXvostZSkHaLNE9u+Y8Md21aBHsBBDmuMuz3OqjhB5/csyOvFbgpoW0OtE=
X-Received: by 2002:a17:906:c095:: with SMTP id f21mr15734577ejz.108.1603709119684;
 Mon, 26 Oct 2020 03:45:19 -0700 (PDT)
MIME-Version: 1.0
References: <20201026094442.16587-1-yegorslists@googlemail.com> <374efe56-58f2-22f2-f9e3-77d394719d51@pengutronix.de>
In-Reply-To: <374efe56-58f2-22f2-f9e3-77d394719d51@pengutronix.de>
From:   Yegor Yefremov <yegorslists@googlemail.com>
Date:   Mon, 26 Oct 2020 11:45:08 +0100
Message-ID: <CAGm1_ksnw4O6u8Q3OFFPTkemuh7s_NZC-WXM1NS6Ok6YpWLczA@mail.gmail.com>
Subject: Re: [PATCH] can: j1939: use backquotes for code samples
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On Mon, Oct 26, 2020 at 11:23 AM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 10/26/20 10:44 AM, yegorslists@googlemail.com wrote:
> > From: Yegor Yefremov <yegorslists@googlemail.com>
> >
> > Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
>
> Please add a patch description for upcoming patches.
> Please don't re-wrap lines in the same patch as changing documentation.

Will do.

> I've fixed both while applying the patches to linux-can/testing.

So my next step is to send a patch that re-wraps the lines?

Regards,
Yegor
