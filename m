Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D38529E1A3
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbgJ1Vsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727323AbgJ1VlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:41:14 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF698C0613D1;
        Wed, 28 Oct 2020 14:41:13 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id a9so594229wrg.12;
        Wed, 28 Oct 2020 14:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=150B9TY9v6fV7KS+jxlyPSKb4srW4lcCjnHLKa1uLvo=;
        b=bWRA9CAagWShk3n4pjpvMARXxKNk02ECjHV3X5ODSIEVnLIJENmuVQauDRDgevRrQY
         /3ALFRSJKLiuexGDHPUR/4FYGRcNPOCdzy4Xism2WqbGxc01datBkC9LtVyGVxR1SaEA
         u+5IegqMUyK9QnIYQopdu67LBTQe9EAKisfqX/XYLJivmZccUHdSEcl6EdXaq65snVQ/
         yVXIdZvozvdpusCT3n+X7A1JuCq5GzTW7YV7gwlUlyges0H4WMo4b4G82thEp37RYUPR
         iWNYW+pZznfC5am8DQmPS+I5ko+iZk18BsQ+vJUScnPVJ/aTzJdou40Lbc1Aez/Phb6Q
         cxdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=150B9TY9v6fV7KS+jxlyPSKb4srW4lcCjnHLKa1uLvo=;
        b=dP3sJ5Yf2bxDibT6EoYyBsjlyyJ3T63Rdzsx9c/wxspLRNIGyjwPzb8hWgc28gKnwK
         jfmaa40al9ImU8yFWNjgpLKtczzCcyAm6gMuwL7xk4WCcMHj2pDRskvtCnKUL4YbDUaL
         IrBB4uehewjYGWiOSokZPWMaNp9x/13LecZx9O7OX960UzaJWw3l8dR3ZUJDC5w2Ol3q
         BlpUBBEvNPLB2diP14pHqJqWpu4yyq/OdxlMkEfIn5QK+JpxXjOhyCbkaQb5MkdymqLD
         Rf9H0dL1nC3eSn/MuxrpN02m4ycQXWYZRQECeB7DyDK7IisbEHt8jMhDx1Nhch8zeQmi
         /TiA==
X-Gm-Message-State: AOAM530OCZDzTYuBXxwGisKRf6+S8PcDNBp9XQ6My8jExQY+JJs3nTxA
        QgK6eZ62SOfk/nANO+WuhKClG9uh7qLW4l/l2bKv+aeq
X-Google-Smtp-Source: ABdhPJyXaf251l2zxK1mU6Ob1m4WfUi/fpjxTE2AHRPuKN9tn4RClWrnnxgQVywhnWfx1KxAIoh7JVkx5mhPW3rWFcg=
X-Received: by 2002:a17:906:8385:: with SMTP id p5mr872467ejx.538.1603917801870;
 Wed, 28 Oct 2020 13:43:21 -0700 (PDT)
MIME-Version: 1.0
References: <20201028182018.1780842-1-aleksandrnogikh@gmail.com> <20201028182018.1780842-3-aleksandrnogikh@gmail.com>
In-Reply-To: <20201028182018.1780842-3-aleksandrnogikh@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 28 Oct 2020 16:42:45 -0400
Message-ID: <CAF=yD-J7tJ0+UaMHUQbdChkcE9NQCTn9t7VY9ZJtddeDwoi=rA@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] net: add kcov handle to skb extensions
To:     Aleksandr Nogikh <aleksandrnogikh@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Eric Dumazet <edumazet@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Aleksandr Nogikh <nogikh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 2:21 PM Aleksandr Nogikh
<aleksandrnogikh@gmail.com> wrote:
>
> From: Aleksandr Nogikh <nogikh@google.com>
>
> Remote KCOV coverage collection enables coverage-guided fuzzing of the
> code that is not reachable during normal system call execution. It is
> especially helpful for fuzzing networking subsystems, where it is
> common to perform packet handling in separate work queues even for the
> packets that originated directly from the user space.
>
> Enable coverage-guided frame injection by adding kcov remote handle to
> skb extensions. Default initialization in __alloc_skb and
> __build_skb_around ensures that no socket buffer that was generated
> during a system call will be missed.
>
> Code that is of interest and that performs packet processing should be
> annotated with kcov_remote_start()/kcov_remote_stop().
>
> An alternative approach is to determine kcov_handle solely on the
> basis of the device/interface that received the specific socket
> buffer. However, in this case it would be impossible to distinguish
> between packets that originated during normal background network
> processes or were intentionally injected from the user space.
>
> Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

Acked-by: Willem de Bruijn <willemb@google.com>
