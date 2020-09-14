Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAD42688BE
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 11:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgINJs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 05:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgINJs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 05:48:56 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F6CAC06174A;
        Mon, 14 Sep 2020 02:48:56 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id j11so22368652ejk.0;
        Mon, 14 Sep 2020 02:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ygOoarixSm6MKpzS3gULS1k3GqoRnquHOnJWOJBo7jg=;
        b=cQndfL2saukadmPqDWiK7ztBdK3V4Z83M0/wWorBy5MHnfXzc/7BBE6QO6T99ZZBH+
         MOIS4I2IhXlk0NiX0p0qjBgEL3TLW6wmhHNrQZCBgf1Q9YNgBG6X4EsCPXkC1Ee+YsWW
         T+PPMhUghmvk7bBDUH1uSyJ1C8Nnsk+cDzDwLhWhvNwsVgbbE57pgA/85x/qkFUW/XX0
         fNDEm8qsJcvpBh/UJzSN6+3aO9fn2NzDigZY6omyQn/S9t1Y64D5H7X1z9OlcRPKuVlz
         2Dm+xo6/TsUnQgOEK3Y7doAIF8+byTGOBDYMalLNTcVrT0mjnL9E/iQ5NeiSergz7jup
         kclA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ygOoarixSm6MKpzS3gULS1k3GqoRnquHOnJWOJBo7jg=;
        b=i34NL37lTO4hJ5emRtP/kJmV2tqgyQRomwJvGv1daWvIOHtaRvTH1aCXoAUQjKW3aF
         Q68RKmphtUYFGuFD4nZUYRb5SpZ3ei4MKyoaBNhnRv1v5LWFKhABe3222vEirqfLRYkp
         noNgIQ0xIA5j6OE/n88aH6Wr0Br4YTmS9OtRjPSmomB9CUd7fyM7VVgdNaIp9grOoli9
         hY7X5bb2Wr3zJoXdxiyIq7o2FduYwbb0Z6u0yY3txcbmQxb2Y6PEdW2baw6N6zE/+cA0
         fuh3GgKZim+n91H2hSLb9NmIi8Hodq47qZTccS/5yAxPp/9Gw0fsnkFESpKKY3UqS1zt
         vJpw==
X-Gm-Message-State: AOAM530BsjADet3avl4bOyJzLKXLjL55WgtVeEXkBeCfhOgAZ++81WRq
        kVdhMveTYgIvhKwOIhmFHrZoeqkjjeuQ3s1+IyY=
X-Google-Smtp-Source: ABdhPJxL1f/SkFqHBP0W358GOCN/8NfzF7R6KphDmWOIVmUfOj5VjSc+t36/EiRNI1xihMVLfxE8wcdgEkN0/+dUF+0=
X-Received: by 2002:a17:906:386:: with SMTP id b6mr13732009eja.538.1600076935085;
 Mon, 14 Sep 2020 02:48:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200914074154.1255716-1-xie.he.0141@gmail.com>
In-Reply-To: <20200914074154.1255716-1-xie.he.0141@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 14 Sep 2020 11:48:17 +0200
Message-ID: <CAF=yD-Kq4fgNtYae0s9Z4KhYgyCYZo6Ws8Syf+zp0bh-sNArjQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net/packet: Fix a comment about
 hard_header_len and headroom allocation
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 9:42 AM Xie He <xie.he.0141@gmail.com> wrote:
>
> This comment is outdated and no longer reflects the actual implementation
> of af_packet.c.
>
> Reasons for the new comment:
>
> 1.
>
> In af_packet.c, the function packet_snd first reserves a headroom of
> length (dev->hard_header_len + dev->needed_headroom).
> Then if the socket is a SOCK_DGRAM socket, it calls dev_hard_header,
> which calls dev->header_ops->create, to create the link layer header.
> If the socket is a SOCK_RAW socket, it "un-reserves" a headroom of
> length (dev->hard_header_len), and checks if the user has provided a
> header sized between (dev->min_header_len) and (dev->hard_header_len)
> (in dev_validate_header).
> This shows the developers of af_packet.c expect hard_header_len to
> be consistent with header_ops.
>
> 2.
>
> In af_packet.c, the function packet_sendmsg_spkt has a FIXME comment.
> That comment states that prepending an LL header internally in a driver
> is considered a bug. I believe this bug can be fixed by setting
> hard_header_len to 0, making the internal header completely invisible
> to af_packet.c (and requesting the headroom in needed_headroom instead).
>
> 3.
>
> There is a commit for a WiFi driver:
> commit 9454f7a895b8 ("mwifiex: set needed_headroom, not hard_header_len")
> According to the discussion about it at:
>   https://patchwork.kernel.org/patch/11407493/
> The author tried to set the WiFi driver's hard_header_len to the Ethernet
> header length, and request additional header space internally needed by
> setting needed_headroom.
> This means this usage is already adopted by driver developers.
>
> Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Brian Norris <briannorris@chromium.org>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Acked-by: Willem de Bruijn <willemb@google.com>
