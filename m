Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4B7173C97
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 17:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgB1QLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 11:11:36 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:34020 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgB1QLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 11:11:36 -0500
Received: by mail-yw1-f68.google.com with SMTP id b186so3811583ywc.1
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 08:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jwoj9BQOLJS3MEsoQc1zDfo1HZksZEv1KxnRAg4XdU4=;
        b=t1F7wCOidRuOZOIOcu6MxruVOxJjBrS+c7haLY/0vWS9MeiRas9oi01IsGGgxQ73CH
         WAMJy0a4H7UtHtuh90QmPoTvAfFcrJnDvH+7sjG3nw/I0JJTl1C1uaT+W96q/jqG49y5
         FP/my6E9ZDlKQicUbajyaAhoSYeOqAJtwLDEh1QvZEtxwTcdlZaBVZtgR/2OlaGsFL1t
         CvSkc2q7iUrmd09wvIZ/m0D7PHDDE50L/WmWBCIWH4RF5t1l0Ge+4FCzQPa0nNW+SUoD
         CuBgoOGi5RL/sVc+8aNj/0p7R+8bKyayeVun5WwLEYAEKLWEVHFvh96PvGhXqjNNkumU
         m0Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jwoj9BQOLJS3MEsoQc1zDfo1HZksZEv1KxnRAg4XdU4=;
        b=sdiPnxvfe8+dJJu+XSJLLcYO9HKSUfTRHhbey1QNkVIenNhYGcJIOb7bN00VnynC88
         +DVdHEvdbkGOwXsK4Sx4wv2VEF2LrnZsY4krM8503vXLG9F90+yPgo/qyhY3Irido8VR
         8NISgJXgsub5IJu/6FhUxvj4Ken50xKKQvHNVT80kYuxBNYLy1/sHYJ7Z4ING5+6oku2
         J81RLpWzdujSCAEz7UUFs8U8cVarztZkghTRf46LLVMGaAOO0D5mTj3oPADObbj+2LPO
         2J24vdpVuXzc0PFnl0QjfGpXLQFOaeJ993bvHMbNNz1PE7rMrOj2UaDtN5rU5a+s2Obm
         CWpQ==
X-Gm-Message-State: APjAAAVC1slgv5LPwKLOgP7G85VN4r5GEsTvvsXdDce8UrvszDmYIGRN
        6fh7WY1ts3AG+ryqYKiDyvi4h6gG
X-Google-Smtp-Source: APXvYqzlRpASXKykgrmUvcqdyDyWwojeL43sfsi3KzRltGqTexPKTtqrHUPei9xQSS4t1gFkqr4Y2Q==
X-Received: by 2002:a25:5041:: with SMTP id e62mr4102270ybb.179.1582906294345;
        Fri, 28 Feb 2020 08:11:34 -0800 (PST)
Received: from mail-yw1-f49.google.com (mail-yw1-f49.google.com. [209.85.161.49])
        by smtp.gmail.com with ESMTPSA id y9sm4019590ywc.19.2020.02.28.08.11.33
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 08:11:33 -0800 (PST)
Received: by mail-yw1-f49.google.com with SMTP id n127so3750129ywd.9
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 08:11:33 -0800 (PST)
X-Received: by 2002:a81:168e:: with SMTP id 136mr1024757yww.172.1582906292751;
 Fri, 28 Feb 2020 08:11:32 -0800 (PST)
MIME-Version: 1.0
References: <cover.1582897428.git.pabeni@redhat.com> <0f2bbdfbcd497e5f22d32049ebb34e168ed8fecc.1582897428.git.pabeni@redhat.com>
 <f4494fd4-323e-cc1a-cc53-284a0de03eb2@virtuozzo.com>
In-Reply-To: <f4494fd4-323e-cc1a-cc53-284a0de03eb2@virtuozzo.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 28 Feb 2020 11:10:56 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfD157LSzfswU5ssVwc-kbTSVooKFmCo1pjJC+cO+crzA@mail.gmail.com>
Message-ID: <CA+FuTSfD157LSzfswU5ssVwc-kbTSVooKFmCo1pjJC+cO+crzA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/2] net: datagram: drop 'destructor' argument
 from several helpers
To:     Kirill Tkhai <ktkhai@virtuozzo.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 28, 2020 at 9:50 AM Kirill Tkhai <ktkhai@virtuozzo.com> wrote:
>
> On 28.02.2020 16:45, Paolo Abeni wrote:
> > The only users for such argument are the UDP protocol and the UNIX
> > socket family. We can safely reclaim the accounted memory directly
> > from the UDP code and, after the previous patch, we can do scm
> > stats accounting outside the datagram helpers.
> >
> > Overall this cleans up a bit some datagram-related helpers, and
> > avoids an indirect call per packet in the UDP receive path.
> >
> > v1 -> v2:
> >  - call scm_stat_del() only when not peeking - Kirill
> >  - fix build issue with CONFIG_INET_ESPINTCP
> >
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
>
> Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>

Nice cleanup, thanks!
