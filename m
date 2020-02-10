Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1BEA157BEA
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 14:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731599AbgBJNd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 08:33:27 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:53143 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731540AbgBJNdY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Feb 2020 08:33:24 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 2c20193e;
        Mon, 10 Feb 2020 13:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=u84pNJcIW9O86SIUAGq7iDSgVSk=; b=IJnksc
        0VKA9RArxPoApx9Lxyk0SKimGJxzpzS698pu3dX9EHGFfbm+F4STKyTHBjm2C8H0
        hAjsj7qOpOuawE+56TRIF/rbltyKR54cRIileQisZyd5gnSgt9azyuGWoKahiTf2
        FKHMYAbZPNYKotnyGeR/mO1vnPqXhfpqfqoqEfZ5RXMdB/1wtSemlixqvs2kyufX
        hVZ6g+m/AKh48FiHeBgQMCXBlBQJXuFLeVKHM5IURbD5CG/UsrNktW8VNVsZu4X9
        oFyZU41W5xLn5PB5oT7ae2VnPeSXcwL8hODwjIxW8g70h92a73yzwZHFV0qqmX5X
        KdLi4T3Jm1A9Iejw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a6d371e8 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 10 Feb 2020 13:31:47 +0000 (UTC)
Received: by mail-ot1-f44.google.com with SMTP id j20so6308883otq.3;
        Mon, 10 Feb 2020 05:33:22 -0800 (PST)
X-Gm-Message-State: APjAAAWAsu/PYQMgfRknngl31ZYj/MXmawNsaSiggLyB+Z9g0mMRmui+
        BChYO5pXegPD0XQR002Hc78Mn5CxS7QWFFmwwKk=
X-Google-Smtp-Source: APXvYqwUCHe7DeQYHFCMtOOyPrDw3tIrn9mTG6F0o7Cu4tnktN1L9m3k900n0lKACKgP7Cf1YSDO0Y7+wgLKHj31Q/w=
X-Received: by 2002:a9d:24c8:: with SMTP id z66mr1114632ota.52.1581341602248;
 Mon, 10 Feb 2020 05:33:22 -0800 (PST)
MIME-Version: 1.0
References: <20200209143143.151632-1-Jason@zx2c4.com> <20200210115041.GF2991@breakpoint.cc>
In-Reply-To: <20200210115041.GF2991@breakpoint.cc>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 10 Feb 2020 14:33:11 +0100
X-Gmail-Original-Message-ID: <CAHmME9pGJ787etz43zaWq_C0i0tefSej_450tu9VA7p5-PWWEg@mail.gmail.com>
Message-ID: <CAHmME9pGJ787etz43zaWq_C0i0tefSej_450tu9VA7p5-PWWEg@mail.gmail.com>
Subject: Re: [PATCH net 1/5] icmp: introduce helper for NAT'd source address
 in ndo context
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 10, 2020 at 12:50 PM Florian Westphal <fw@strlen.de> wrote:
>
> Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > +#if IS_ENABLED(CONFIG_NF_CONNTRACK)
>
> CONFIG_NF_NAT would be preferrable even though it makes little
> difference in practice I guess.

Sure, will do for v2, thanks.
