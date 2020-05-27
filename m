Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85531E36E2
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 06:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbgE0EJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 00:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbgE0EJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 00:09:16 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4700CC061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 21:09:16 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id c8so4114869iob.6
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 21:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HkB6qexNaxW4GxrzBaUMCsmfZ76FuB/7A69crkTWCz0=;
        b=WDlnjgo073sLSBajtUG5eBt5OxSzOUxWngQG2ksfy5OqaWrU73m1Pgr3BEjQiUdmil
         0xUmhgQwPL/uWbweHk7zv9HZfBgUfqm53frRA4Bue+GgyAjioR47FRc+nZ3xUPGVJe2O
         AoWvjtFPCY4BMB9TbA/qSXKoeymci649yuNJMa1QDRr+OPNogjTtJ/SoQuWkoCLGGXMq
         5OTACFCEbdey/F2wKob6BoP+RNaT0Mp9wvCq65ikVmjo8VwgZZSCiSwNfy/B4DV+Bux7
         WZ7OOipSOXF5z42/oy81Kmqv7uD/9GkBDuWWV4XgnddAkzUyjznpLYWhiD1ZqRFDEFgh
         pKvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HkB6qexNaxW4GxrzBaUMCsmfZ76FuB/7A69crkTWCz0=;
        b=TmgHGu3B42wbyW8iCiTwWaM/klQY9+MpLKirDUldwPJ8g169UBxoQH/4qLa3Cu7ow4
         oTJA9Dw5nFMLRhZUJbdnxsIJj/It9j6jy65EIcGCdwySe+qFgoKCxWK/Kh3pRuyie9og
         9VDOYM2DOju+yEg4j35jj22rE1bskD7n4wlrKDMsXQ71sXdqOIZ+JA7DTNNI992UCpUj
         yHBMtcPQFSliOyzsNfYywVECdW1BSJ61B9FwEsOtdRVeniJFR+aFqQgcjOlT5MuGLo1D
         NJzG7NhrDUf5yyelL2lUeKGH4AP6vO16P+5WQZWt178PXdvodGq5fWpHb03vq4jbUdQF
         bcHg==
X-Gm-Message-State: AOAM530kdJ/fuiBUuTij3JrV5OuZSPwBNovkr7j4MMfUUbpg0dGRqUF4
        ZsNBu9PT6PGAQF80uO7XCtTfLLQN2T+nJIoFJms=
X-Google-Smtp-Source: ABdhPJwpazDG9snqF/ye13KiLxEyZEupX88fTZIjQg6x3A0GgViqSWctIFhXG3ETA5+3wkhqq3kCSoKn9xo0w7bLR4w=
X-Received: by 2002:a5d:9242:: with SMTP id e2mr7896806iol.85.1590552555580;
 Tue, 26 May 2020 21:09:15 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1590512901.git.petrm@mellanox.com>
In-Reply-To: <cover.1590512901.git.petrm@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 26 May 2020 21:09:03 -0700
Message-ID: <CAM_iQpW8NcZy=ayJ49iY-pCix+HFusTfoOpoD_oMOR6+LeGy1g@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/3] TC: Introduce qevents
To:     Petr Machata <petrm@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 10:11 AM Petr Machata <petrm@mellanox.com> wrote:
>
> The Spectrum hardware allows execution of one of several actions as a
> result of queue management events: tail-dropping, early-dropping, marking a
> packet, or passing a configured latency threshold or buffer size. Such
> packets can be mirrored, trapped, or sampled.
>
> Modeling the action to be taken as simply a TC action is very attractive,
> but it is not obvious where to put these actions. At least with ECN marking
> one could imagine a tree of qdiscs and classifiers that effectively
> accomplishes this task, albeit in an impractically complex manner. But
> there is just no way to match on dropped-ness of a packet, let alone
> dropped-ness due to a particular reason.
>
> To allow configuring user-defined actions as a result of inner workings of
> a qdisc, this patch set introduces a concept of qevents. Those are attach
> points for TC blocks, where filters can be put that are executed as the
> packet hits well-defined points in the qdisc algorithms. The attached
> blocks can be shared, in a manner similar to clsact ingress and egress
> blocks, arbitrary classifiers with arbitrary actions can be put on them,
> etc.

This concept does not fit well into qdisc, essentially you still want to
install filters (and actions) somewhere on qdisc, but currently all filters
are executed at enqueue, basically you want to execute them at other
pre-defined locations too, for example early drop.

So, perhaps adding a "position" in tc filter is better? Something like:

tc qdisc add dev x root handle 1: ... # same as before
tc filter add dev x parent 1:0 position early_drop matchall action....

And obviously default position must be "enqueue". Makes sense?

(The word "position" may be not accurate, but hope you get my point
here.)

Thanks.
