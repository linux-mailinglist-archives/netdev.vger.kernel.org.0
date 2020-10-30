Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D8E2A112D
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 23:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbgJ3WwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 18:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgJ3WwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 18:52:21 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F555C0613D5;
        Fri, 30 Oct 2020 15:52:21 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id gi3so17410pjb.3;
        Fri, 30 Oct 2020 15:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=91c9EpN35NammVPGZ4fZAQ5G050YxyvJ3BZUiRrkUMs=;
        b=CCQG+ezN81ySThA+qBB5QkNFAEhBb6/sj04wP5mk154Md4ZDuvf5jxLl4wqou5M9UZ
         dDpnas2WuL+iILzIo4jq+hPA1YXSg1JHOnUpTmuAFUrVS0We3TUI7yrvCbPbz3YmVHXA
         z8WeT3pfUo8jIcq8HV6FzRrhp8XDvES63C/M1PyJgGa0cVUe7XOEiBtQ1dYVj4zWGZ+Z
         3pmKtlQjWT0A5QMt/pt/6cRMfvfH+ev/y/IYMFAB389b+HNiJZYaTSPp9zh3cjc/AYB0
         QPvt707IYWaFN0EXaATlJnVj07f1NdvSnGtZd27mRnBvgXKI4MxGWiSk9m4FRGZyGDGZ
         DHkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=91c9EpN35NammVPGZ4fZAQ5G050YxyvJ3BZUiRrkUMs=;
        b=kG76QQJ97mb7tH4HumG1ksJF1JSdxONkk0eAwyKJF1oKUZd/6vyKg2RtteVTu9FDVf
         HoxqLImI6qZkt+ro7oOJJceUxPfN6gnht32njl2R92wWUoLMMhKtEJQNWbFtMBYtAso5
         QtMM4lc9IfkigLCQz0BD4pi9VRxIfq2xms0YtglaZPk6Epar2tV+3u6VNdfxVJbt56s2
         BrQacxzKkHzoR9KfU13pixjLhgGt3y9XdEFLmQZeFnBIuTzJTP7Zk7KuRFlu9V1CneDR
         Ym56Q1J5FOk2BKK4Q839JVQe5zwEQbA5jgwqZ0HmwIK1jsLp+XU4z50p3hF3GkAj1EXI
         FFPA==
X-Gm-Message-State: AOAM532l+3xr7ywwPWCZ205lvSX+bY/wmK/mI1IugQob2Jt3IVtUT1pW
        ymTU+ZWmeUStS+1AAauLBWF4gM3nzGVrMyr4QBLoh1vYNuc=
X-Google-Smtp-Source: ABdhPJw34ayAF4nQFq7OJ5Mv48RULe+Tvk+O092gR/L7tzH8LdGtjI56M4bAjwO6ky2pSJsyeLTNt0Wqw0H3T+SbCuQ=
X-Received: by 2002:a17:902:82c8:b029:d6:b42f:ce7a with SMTP id
 u8-20020a17090282c8b02900d6b42fce7amr999714plz.23.1604098340678; Fri, 30 Oct
 2020 15:52:20 -0700 (PDT)
MIME-Version: 1.0
References: <20201030022839.438135-1-xie.he.0141@gmail.com>
 <20201030022839.438135-5-xie.he.0141@gmail.com> <CA+FuTSczR03KGNdksH2KyAyzoR9jc6avWNrD+UWyc7sXd44J4w@mail.gmail.com>
 <CAJht_ENORPqd+GQPPzNfmCapQ6fwL_YGW8=1h20fqGe4_wDe9Q@mail.gmail.com>
 <CAF=yD-J8PvkR5xTgv8bb6MHJatWtq5Y_mPjx4+tpWvweMPFFHA@mail.gmail.com>
 <CAJht_EPscUkmcgidk5sGAO4K1iVeqDpBRDy75RQ+s0OKK3mB8Q@mail.gmail.com> <CA+FuTSefJk9xkPQU8K5Ew6ZmnSbMo0S4izAoc=h7-cDrN98jUQ@mail.gmail.com>
In-Reply-To: <CA+FuTSefJk9xkPQU8K5Ew6ZmnSbMo0S4izAoc=h7-cDrN98jUQ@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 30 Oct 2020 15:52:09 -0700
Message-ID: <CAJht_EOMJNENgE7bvy6Nc5xqoH9aKUhufWNvwhT-m3X0OreS3g@mail.gmail.com>
Subject: Re: [PATCH net-next v4 4/5] net: hdlc_fr: Do skb_reset_mac_header for
 skbs received on normal PVC devices
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 3:22 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> It's indirect:
>
>         skb_reset_network_header(skb);
>         if (!skb_transport_header_was_set(skb))
>                 skb_reset_transport_header(skb);
>         skb_reset_mac_len(skb);

Oh. I see. skb_reset_mac_len would set skb->mac_len. Not sure where
skb->mac_len would be used though.

> > I thought only AF_PACKET/RAW sockets would need this information
> > because other upper layers would not care about what happened in L2.
>
> I think that's a reasonable assumption. I don't have a good
> counterexample ready. Specific to this case, it seems to have been
> working with no one complaining so far ;)

Yeah. It seems to me that a lot of drivers (without header_ops) have
this problem. The comment in af_packet.c before my commit b79a80bd6dd8
also indicated this problem was widespread. It seemed to not cause any
issues.
