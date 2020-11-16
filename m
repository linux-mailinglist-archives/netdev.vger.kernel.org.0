Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B422B3F36
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 09:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbgKPI44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 03:56:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbgKPI4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 03:56:55 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D967EC0613CF;
        Mon, 16 Nov 2020 00:56:55 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id s2so8064094plr.9;
        Mon, 16 Nov 2020 00:56:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/7exOec2rlf5TgxMLPx1G26Xq13i61v9xsjCSraZp34=;
        b=YPT+9zMnL9qaT+lauWL+oi7XSV9xk9TzzcIcB9sgCu9TZJkjohtFSwa71VilaPNiNq
         naHFrNuAvSk7ra9eSYY/LqmIbAUh6dEfTTw9uuyW61mrotbPy2t6pa6zXXHwHzs7+BQT
         jGkbHdire17liAz3QpPiAB/Ymdu1K8H3Yz09bdx3Iy1IUNTcwRRhvFgnA7JhFXbwtHuP
         PdLgDQZctrZNhRoDl8cJUTdD8Xa85IoOa7hiWFjMbydQpT3JJ/hn9nQCBz2wHT6aLlVw
         6DGmJ0uzJWkYPdcAjVaYOikuPXK1C4R+bZPFqpuIh7poKICHuPuZrRao9/7a+5ivA+Hf
         KnGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/7exOec2rlf5TgxMLPx1G26Xq13i61v9xsjCSraZp34=;
        b=OStGY/lDX/hvXRx0eSqupoYCxQtcFq/Fr/qrQGvKYIUAPmftRELRiTHt4Gj/CdoQhU
         ehoO3JRu0ZraHTDxM0h1IWD55mXPr/mDaHb0Dz2mAx2lANkMm24BF520GZOWJuXZ3wn7
         SVnBqHYsO621y01BqLLeGPDB9ku3yc5lp5yT/ff6SvRDxFPbLn6tNfzWgcRJzvqL5Y8J
         Yt5+Z62M35nCzPd7bSk/QtDopjYqERTiDQBqsH8UnA8KF/uUw5v+nIBUwI7aaP7YldEM
         dqMfMjAc/1ctOhUKVreL55n/Onj68sYCQpU/WioQmorto0WNjukhhR3n/7h+avxLnf+I
         9Ccw==
X-Gm-Message-State: AOAM531TGlSbx/kIPYTnwCKoJzL7tCFOZOTLED/HDXTLmJso9cDciJKG
        RDlXaTKgLYIx5rwZYZndY/TXQ4ipGn2BPKwq1To=
X-Google-Smtp-Source: ABdhPJzLSeRkCv50CphOH4iBJx4+4pX26oI0R4McwYYNZFKOkLbKC12iLMuSWbP+YFRzqRyBOLyPCQheM+vAm4XCTXg=
X-Received: by 2002:a17:902:9890:b029:d8:e265:57ae with SMTP id
 s16-20020a1709029890b02900d8e26557aemr7796896plp.78.1605517015460; Mon, 16
 Nov 2020 00:56:55 -0800 (PST)
MIME-Version: 1.0
References: <20201114111029.326972-1-xie.he.0141@gmail.com>
In-Reply-To: <20201114111029.326972-1-xie.he.0141@gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 16 Nov 2020 00:56:44 -0800
Message-ID: <CAJht_ENA4EGX5BzuBrhJzDTs_a0WRxNh-aLu=U-EHWTA-BvoFg@mail.gmail.com>
Subject: Re: [PATCH net-next] MAINTAINERS: Add Martin Schiller as a maintainer
 for the X.25 stack
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 14, 2020 at 3:10 AM Xie He <xie.he.0141@gmail.com> wrote:
>
> Martin Schiller is an active developer and reviewer for the X.25 code.
> His company is providing products based on the Linux X.25 stack.
> So he is a good candidate for maintainers of the X.25 code.

Hi Martin,

Could you ack to indicate your willingness. Thanks!
