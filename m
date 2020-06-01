Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51A51EAFD1
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 21:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbgFATuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 15:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbgFATuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 15:50:35 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49962C061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 12:50:35 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id h3so10573892ilh.13
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 12:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9GqEwOViARBEcZXVGO4M5VP1pr/t94sDXh/Iu76+DIg=;
        b=u+zFwk/7FmN2UJbLpfB45Cs5uxG/5cdMdKxYCiC6QFVWmor7pjCL2LNdXgbuwPqzdp
         QcPkZ/dR6ThpaWBYMxqo2o3/p0JRma58FsHnfGetRg2RmDSEk/WGBhM8D8yEUzm8KiPz
         giY3kRA++e2jJjUbngW6sYQKPyDIBlDezKqVCxfDIFaXn2GG6Dd+c/TRKjU+C2nl4shW
         1CpSkRjr5yInKLdj62Cf5jZY2DXM2nL9X4jIY+rqw7Meb4Q+uW//m6bFF3L3e6JcmRhU
         RUBwbMo6sW4pk6ZS/d1nIJ3r8EGmImlKjj9UYTFhlHoc/TeraINa0xkb5zv9Ush6QJaU
         Hv8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9GqEwOViARBEcZXVGO4M5VP1pr/t94sDXh/Iu76+DIg=;
        b=dnXgdKtXPp+KmkX2Q5LjijM6vcxCtmZzRLhqQqHlYiqIEoKfE3EzmHarMuJ8TyKEL0
         uo7A/iVKP3TXB54SfQK4qQU4/6m7WcGilGCghS6YPfVuRseo+vSugFUj64GewRU1VLGH
         2IjBG9kG27ox7YAnT8Z/xvqMRCDEplgb11La6G1M6mppPsq01jfeSJiaKTfzv8eD0uk2
         4dQ8TS1SHc8kGKPGouStyND3VlX/P4/3m1ys7bZQZh48AjtWRZl6lL0+JBXfV1oA8KdM
         nRxZeqTsM6Lx1scFv7w7YvVUyhy0ojUbjJmpyWLWcwygK/x2mqnWY55nSV71baIFom+2
         sNzA==
X-Gm-Message-State: AOAM53204DRmmEIZl3yV6Z1MKB50kW6tRsr0CdGuBHEueNDeJOwJnRj1
        ioF9V6BSDJWjPRrhsvSfRwx2pHgWQza3TKGeOZ4=
X-Google-Smtp-Source: ABdhPJxF3j1DoT4ubwrwwAbbMmo/P+7DXFkomDFIKjQAvDRG1vz6YXUDd/VEII2B4kgTUwGETOZX6UiBfWln2NkgghI=
X-Received: by 2002:a92:cb91:: with SMTP id z17mr22078494ilo.305.1591041034333;
 Mon, 01 Jun 2020 12:50:34 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1590512901.git.petrm@mellanox.com> <CAM_iQpW8NcZy=ayJ49iY-pCix+HFusTfoOpoD_oMOR6+LeGy1g@mail.gmail.com>
 <20200601134023.GQ2282@nanopsycho>
In-Reply-To: <20200601134023.GQ2282@nanopsycho>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 1 Jun 2020 12:50:23 -0700
Message-ID: <CAM_iQpXTWK+-_42CsVsL==XOSZO1tGeSDCz=BkgAaRsJvZL6TQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/3] TC: Introduce qevents
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Petr Machata <petrm@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
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

On Mon, Jun 1, 2020 at 6:40 AM Jiri Pirko <jiri@resnulli.us> wrote:
> The first command just says "early drop position should be processed by
> block 10"
>
> The second command just adds a filter to the block 10.

This is exactly why it looks odd to me, because it _reads_ like
'tc qdisc' creates the block to hold tc filters... I think tc filters should
create whatever placeholder for themselves.

I know in memory block (or chain or filters) are stored in qdisc, but
it is still different to me who initiates the creation.

Thanks.
