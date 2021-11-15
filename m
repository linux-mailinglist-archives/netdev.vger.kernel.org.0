Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D474517BF
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 23:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242809AbhKOWqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 17:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348096AbhKOW14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 17:27:56 -0500
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA92C0A3BDB;
        Mon, 15 Nov 2021 13:40:42 -0800 (PST)
Received: by mail-ua1-x931.google.com with SMTP id y5so20019752ual.7;
        Mon, 15 Nov 2021 13:40:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A5J469ns3XG7OVxeYptfcPiuHXSrmzCSL7lcsf9OaQw=;
        b=B1RIvix8dh5HgGXRvFDIOm+oro/0IBnw20lxQztddbYySaAjwpwaJluTNf+d7hLTa3
         HLXY2zsyaN/wpPIye6RJnjYcTgX8QBKGHiEStqXXjR7u8GeTDyvCIOKxihUjEoaqcO6S
         Uf6Bt4SznAVTI7tFzhrj5aPJp8WQ43XTNc9QWHqze53+KDWKwiwAb3WfPFuZw9Zo6OoM
         YU0ihnDG8l1Csj3wMCg7g1kP8tU6/dHG2Z9OsQsBs8nb2ochiLRYWcerujmLXL1lOQLE
         xU7lm2dlQPZoEsrs8AFaeFHCls5IO8bFmNAQAo1XeXl01YmfM8P8j+Pd9fOEcaSlwMfd
         f4EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A5J469ns3XG7OVxeYptfcPiuHXSrmzCSL7lcsf9OaQw=;
        b=itsY06RepjezWsdUw5t1kgHYOhBPUT8DhfMoTdmrC0nYZ2YTpqClQPXPs/lqlQfcPH
         Oz25z9Cbx/13Z7flMJZg9I08bMB4LCg3rsazCkKXqrl7BCjiNS1vvu3wiQ+erEJjsT8u
         HPGD9Re8Mx3Qeaj2PzZkWsZ0Hr6I2FACDbHZGUzWvU+z9aBvGdqqVC51zrzb1jSHK0vu
         Cbz/i8+JaBN1WtPARwio3cfI4zxI4Esm9tiioxyZ82XhP8+BhtHnIp8P87R0qWNcH/g6
         jqPW8RDFjEa6JDomz9YiFjVWiBXDyAvw9k3Q6+wYsrz1Hb185vLsTrL7xplQFMRjUqy/
         Hpsw==
X-Gm-Message-State: AOAM531FogDWH6iKenHoPTNmDzcCjgaT7YXH0c/bwpHxsZphTr7IRkjD
        slDn4UQa6laALnesd0aaoFw20bCNxYwuJ+vA/Hs=
X-Google-Smtp-Source: ABdhPJwOejlN4PJ2DDBI7npw4cDbQmBCrA0aLmnL1zZgrVrrBYwz3boiGcioyN8r2cio4O9gpdXJYvkiKkJNhXvIjsk=
X-Received: by 2002:ab0:25da:: with SMTP id y26mr3108397uan.72.1637012441004;
 Mon, 15 Nov 2021 13:40:41 -0800 (PST)
MIME-Version: 1.0
References: <20211102213321.18680-1-luiz.dentz@gmail.com> <CABBYNZ+i4aR5OjMppG+3+EkaOyFh06p18u6FNr6pZA8wws-hpg@mail.gmail.com>
 <CABBYNZJPanQzSx=Nf9mgORvqixbgwd6ypx=irGiQ3CEr6xUT1A@mail.gmail.com> <20211115130938.49b97c8f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211115130938.49b97c8f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 15 Nov 2021 13:40:30 -0800
Message-ID: <CABBYNZ+fAVW1Go+UUirgFsbNjffEKdUv-9ArM6MiFxMYEGOM6w@mail.gmail.com>
Subject: Re: pull request: bluetooth 2021-11-02
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Mon, Nov 15, 2021 at 1:09 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 15 Nov 2021 11:53:15 -0800 Luiz Augusto von Dentz wrote:
> > > Any chance to get these changes in before the merge window closes?
> >
> > I guess these won't be able to be merged after all, is there a define
> > process on how/when pull-request shall be sent to net-next, Ive assume
> > next-next is freezed now the documentation says the the merge window
> > lasts for approximately two weeks but I guess that is for the Linus
> > tree not net-next?
>
> I'm not sure what the exact rules are for net-next.
>
> We had some glitches this time around, IMHO. Here is what I have in
> mind for the next merge window but note that I haven't had a chance
> to discuss it with Dave yet, so it's more of me blabbering at this
> point than a plan:
>  - net-next would not apply patches posted after Linus cuts final;
>  - make sure all trees feeding net-next submit their changes around
>    rc6 time so that we don't get a large code dump right as the merge
>    window opens;

So net-next has a merge window open during the rc phase, until rc6? I
assume if the rc goes further than rc7 it also would extend the merge
window of net-next as well?

>  - any last minute net-next PRs should be ready by Monday night PST;
>  - we'd give the tree one day to settle, have build issues reported etc
>    and submit PR on Wednesday.
>
> If we go with a more structured timeline along these lines I'll try
> to send reminders.

+1, that would be great to have reminders for the merge window
open/close that way if for some reason if you guys decide to change
your merge window that would be noticed by us.

-- 
Luiz Augusto von Dentz
