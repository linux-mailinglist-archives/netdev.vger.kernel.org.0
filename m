Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0A42A1081
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 22:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgJ3VtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 17:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgJ3VtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 17:49:15 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712D8C0613CF;
        Fri, 30 Oct 2020 14:49:15 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id w21so6455269pfc.7;
        Fri, 30 Oct 2020 14:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QMAAS0p4jKFE9qps1JnEBoN58ABu2M0kNCMhmGgt+hs=;
        b=TvRXlpOytiEDQ40UohV35i39LxvuKG9Seb6lphF3K0GrEkqTzTmrYA1rQhRvOdikAW
         WJoaXShW3Ra/8Ooj5nuRMOwVV0KutJJIy/T/H0BNjFUQ0+28PKa3BbpYSN44fvGTTezx
         aY9LqG0ebaLYLAkRnL7oc422uctNAusDy9r7UoHtUdjDDbKVRTC8Dh71mGTE2FSk9zwe
         hmwvWZKI055PR15g+yB9n+G/E1I/Dr96F1WrMgdPHA2t1Xiw/owlR3lUrEGDdTBFwl39
         TqLFEONPeE57VqfQv8U7c5+tUPhMtndoOwFmk21ykwJqRJTP3GuByIBsR8RRD/JyGCV9
         hLtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QMAAS0p4jKFE9qps1JnEBoN58ABu2M0kNCMhmGgt+hs=;
        b=LeMo+foOuid5M0pYHfLXE0Hoa3gQvSdNjOSVAjC6D/r7Cmpop+zvqXFZSEVaxJU00e
         mAl3q0k9tLEDSiSHfx73xenh3GQuSGq8lLn/Lq7GRZbBalbEVXd/MKB2K22R+KoiBqr4
         2mFKkSk5SbTlBciN0hXTIXWyEwQ4cngJCvFkwtyR0vvYo6jjdsrhdiKq+qHsnPF9xwcc
         nT1ucAT8/it4r3UgNWEgBwODOHsHfUe3NbD5mhHTi5DB2kQQiTIE8hTUxwAP88pnSBJY
         +sWsIS3o/qgoXP/oBlVUpjjtU4wJsaQXuhhTRITFb6aKsUdv6GBNQB6BDfbL9sfSNq13
         Q8tQ==
X-Gm-Message-State: AOAM532DE+JshA9IdhKCsdo/3vDeaSspWwuMvVOhtB21dpoqf6aY0Oko
        9DsYzWuytTd7TKV234bXLWJp6gP2wPQKP3Zdlq+y9G5d0SE=
X-Google-Smtp-Source: ABdhPJxwN2zh7wVq6PqBMCHN4uYi87x5Si8xX0kx+wAak6R3qDltA7rQuQ6enR5P1ucrMw6PpFjGbHlMeaJjZ5SFnB4=
X-Received: by 2002:a63:3581:: with SMTP id c123mr3826426pga.233.1604094555109;
 Fri, 30 Oct 2020 14:49:15 -0700 (PDT)
MIME-Version: 1.0
References: <20201030022839.438135-1-xie.he.0141@gmail.com>
 <20201030022839.438135-5-xie.he.0141@gmail.com> <CA+FuTSczR03KGNdksH2KyAyzoR9jc6avWNrD+UWyc7sXd44J4w@mail.gmail.com>
 <CAJht_ENORPqd+GQPPzNfmCapQ6fwL_YGW8=1h20fqGe4_wDe9Q@mail.gmail.com> <CAF=yD-J8PvkR5xTgv8bb6MHJatWtq5Y_mPjx4+tpWvweMPFFHA@mail.gmail.com>
In-Reply-To: <CAF=yD-J8PvkR5xTgv8bb6MHJatWtq5Y_mPjx4+tpWvweMPFFHA@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 30 Oct 2020 14:49:05 -0700
Message-ID: <CAJht_EPscUkmcgidk5sGAO4K1iVeqDpBRDy75RQ+s0OKK3mB8Q@mail.gmail.com>
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

On Fri, Oct 30, 2020 at 2:28 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> Yes, it might require holding off the other patches until net is
> merged into net-next.
>
> Packet sockets are likely not the only way these packets are received?
> It changes mac_len as computed in __netif_receive_skb_core.

I looked at __netif_receive_skb_core. I didn't see it computing mac_len?

I thought only AF_PACKET/RAW sockets would need this information
because other upper layers would not care about what happened in L2.

I see mac_len is computed in netif_receive_generic_xdp. I'm not clear
about the reason why it calculates it. But it seems that it considers
the L2 header as an Ethernet header, which is incorrect for this
driver.

> If there is no real bug that is fixed, net-next is fine.
