Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE4A4983E1
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 16:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234596AbiAXPz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 10:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234236AbiAXPz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 10:55:26 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C657FC06173B
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 07:55:25 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id d188so5707897iof.7
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 07:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PAk46n1MPi9gPpAjJNci/8kPlMhpslWLN7yEsIjhWq4=;
        b=GewqqABG6/7V/ms2Yxh7ww0Nktw+O/cM64/81V2i9uPU+eqLQGhPIxs51HP/nA4dY3
         NBwP5hsYz/pkFblWVNpzZWr2f1OLQNhVUcqIZaiWJK0qbBeZ/mhUzr5oUmVvgxDGxLdS
         Yc2pEbNFbzn8HwdF0zHkzo0nTuUQqmtK9e0zY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PAk46n1MPi9gPpAjJNci/8kPlMhpslWLN7yEsIjhWq4=;
        b=6XwgV8VVGT/Mw8KXL5b8BBeZdmvckIBV8/NvJx6ES06EBI66FdSTom+4HUFAL9t5LM
         7gX3qZSMRrXFu1/6sb8b/vAWVn6Y8aasQzkk0KI1CqM4LyjrC2OEgNg/AoDke1GIuQvb
         gdor8t8CLeBOMmr+KwHJXp1C+/6CqfUX/JFAu6rKGr3R6mMOIHMGgtGhazQ+NDsWYDGF
         tEPywgZCqaTcUHFTEf1BGQ8eWJL+OtB4Z6OgRjEeDKi/NCufFUs2eP27Ees+DXDm3yvh
         j3JrDkBdY3YYKkWiwxsnmwxABkIANLRFhHg+OKFuq7cMxz+btabUrHNyK/lL2NBhCs+A
         /Fng==
X-Gm-Message-State: AOAM531ls5uyPX6Ay41qn4jXKmoOGECPCtl0l4Cef06BOYnya5NxTLKU
        D0O3wkw6IZwm62XRjeYjOGD96LMPFJUaKaAHQOmcFQ==
X-Google-Smtp-Source: ABdhPJyxBqzCdPqA56UWB4jv/1dn8GxVWqJQuoJalf6pMaCqUpsM+VCbcLeIjIQvF+SRKk4FjmW02qOpqmaS1PtY8Pg=
X-Received: by 2002:a02:6d04:: with SMTP id m4mr6392976jac.80.1643039725076;
 Mon, 24 Jan 2022 07:55:25 -0800 (PST)
MIME-Version: 1.0
References: <20220123001258.2460594-1-sashal@kernel.org> <20220123001258.2460594-3-sashal@kernel.org>
 <20220124075041.13c015a6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220124075041.13c015a6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Mon, 24 Jan 2022 15:55:14 +0000
Message-ID: <CALrw=nFwuo=OWzDimGK0MyqLs4LBu9_WkKxXLpw+e2oTJAD8Lw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.10 3/9] sit: allow encapsulated IPv6 traffic to
 be delivered locally
To:     Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>,
        stable@vger.kernel.org, netdev <netdev@vger.kernel.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Amir Razmjou <arazmjou@cloudflare.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 3:50 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 22 Jan 2022 19:12:52 -0500 Sasha Levin wrote:
> > From: Ignat Korchagin <ignat@cloudflare.com>
> >
> > [ Upstream commit ed6ae5ca437d9d238117d90e95f7f2cc27da1b31 ]
> >
> > While experimenting with FOU encapsulation Amir noticed that encapsulated IPv6
> > traffic fails to be delivered, if the peer IP address is configured locally.
>
> Unless Ignat and Amir need it I'd vote for not backporting this to LTS.
> This patch is firmly in the "this configuration was never supported"
> category. 5.15 and 5.16 are probably fine.

We planned to use it on 5.15 and onwards. Not backporting to 5.10 is
fine for us.
