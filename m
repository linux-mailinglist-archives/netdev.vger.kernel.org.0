Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F0D250A4A
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 22:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgHXUtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 16:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHXUtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 16:49:17 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501A4C061574
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 13:49:17 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id f193so5546302pfa.12
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 13:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Uv9gG7ktC/ackhaGqtPHs34kPN0x3rmU+zhvd3e95ak=;
        b=XAjxQ/wy+UpyPYzlMz93w3SUo53RK7zMkAa/g3Q+wN0+SXG/SMO7xa2EZcyF4q0up6
         +gsh0R5HHCKV0hV2XIhxnMs1WUnkh2n4SFLEcJ+me7qAeDoeThpRtUKtWGiPdjDYH9jt
         1EM3lm6sAYxa0O4DjaM4jVMre6jZ33xWWqbqc4sYirmZ9S2Geon4BnZF6GZB7/SGESt1
         OsVOV/WeJYeUNR1troS3bx3PvFb2oqjp6bt0gSZ649I/f7BqK5W0LlDWxCZ7k4DSI+a9
         qESH1iK++M2H1td1J+zgNNxPFF/vq/wk2GJAkFIAhnXiVKqljMJm16+19pmRfoEksl5g
         Ezjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Uv9gG7ktC/ackhaGqtPHs34kPN0x3rmU+zhvd3e95ak=;
        b=FrZWTZO1D0IZqI7uHMGWmvhMa6CN7fTJj5JfhbH9qZqOo+NnBCcpa5O25v0XySDIK8
         +vrMqZvqyWxXG+OGO5zsF15LUTVtO4iwzE9n05iXIShXq7jfBItn6DSCHI077NdsXDBR
         AMol+nGOygbbSOVuo/SDp8GLqTOG8avG6jwqFttznJvuXp0Rc626tY2Y2yGwefEIO5+j
         phVHsOvwe1cpyctoM9xawaeMUm0xSCcJzulTO/hP7XOOKk9zGIdUDpAmqANXtmlxt8Xd
         nP86HnujmpOcqUAUntLpIXIMGpNjd3xnExVQmS2MmwQ5hL/nx6MXGpxzA2UoVqv4djaF
         i1qA==
X-Gm-Message-State: AOAM533YOMB566o15nvnJUiBpgf1rlRFMmr1v6ufg2Ccoyq5HCg0WaE/
        hsN9BCdDeQlAdZZMXUnZv0jr0AI5D4yjDeAmKEc=
X-Google-Smtp-Source: ABdhPJxqEF7ku+7/JtZQ0AQE9Uh+P2NIRgLbYDULW7JUikfvvlZ3pQMJAWVHLkeGNVpLT10LlIsrlW/lr+xcI6gmOtM=
X-Received: by 2002:a63:b24b:: with SMTP id t11mr4501787pgo.233.1598302156023;
 Mon, 24 Aug 2020 13:49:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAD=jOEY=8T3-USi63hy47BZKfTYcsUw-s-jAc3xi9ksk-je+XA@mail.gmail.com>
 <CAJht_EPrOuk3uweCNy06s0UQTBwkwCzjoS9fMfP8DMRAt8UV8w@mail.gmail.com> <20200824141315.GA21579@madhuparna-HP-Notebook>
In-Reply-To: <20200824141315.GA21579@madhuparna-HP-Notebook>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 24 Aug 2020 13:49:04 -0700
Message-ID: <CAJht_ENNhvOO=V+bABBC3nL6G7Gkw6H-UVQPWxO4_vyYXcVNhA@mail.gmail.com>
Subject: Re: Regarding possible bug in net/wan/x25_asy.c
To:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        andrianov <andrianov@ispras.ru>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 7:13 AM Madhuparna Bhowmik
<madhuparnabhowmik10@gmail.com> wrote:
>
> Sure, I had a look at it and since you are already working on fixing
> this driver, don't think there is a need for a patch to fix the
> particular race condition bug. This bug was found by the Linux driver
> verification project and my work was to report it to the maintainers.

OK. Thank you for reporting!

I think the Linux driver verification project works very well because
it can help to find data races.

This driver might take a long time to fix because it has many issues,
and developers who are interested in it and are able to review patches
to it are rare.

Xie He
