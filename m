Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F89A6D4BD
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 21:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391168AbfGRT00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 15:26:26 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:44721 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727687AbfGRT00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 15:26:26 -0400
Received: by mail-ot1-f68.google.com with SMTP id b7so30198206otl.11;
        Thu, 18 Jul 2019 12:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jS2O2TnKQegeZWDkB+hyC28+mdRfDO0dwLNv8/KsAYU=;
        b=tELURjUDlkz33UjaO8n/YfWtrYM4s0mxFA4hV+51XiVtgmw4Ciy7VHrwQjpEJZC1jx
         6cB9JnKzdO1b67Qb64tS0c8IKetXh04RjI72SAqNkP5diONZEMm+rMkmKRrVsiDlTf4X
         nqpts2VMQ2cXA1weXh63twDvtO/fWyQQFoijzFdfOyTObJ5l6IRFS7b7UBv9RHfg6VuU
         IqAgebdIiKZUgu4Z8IsuljnAOJKa3v6f3SqH+H8aY3k3+c/dDz2+VmT5hWijqmQ1rjQT
         wwBAxwTopyId6Ik0oeE6v2YfanPC+1pl5+MU57Xf59+jv0SF5sctaK3fYSJwN6nqhLRM
         wgKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jS2O2TnKQegeZWDkB+hyC28+mdRfDO0dwLNv8/KsAYU=;
        b=UZY6fc7CRGUOF6zPjHyYcWdHMYVLQky46nltNNrMl8P50xmrClm0ounRI+XBf3mgwS
         f7373WW9chRreMRogFP/7al+ATQdGEErJA1EM8QDbOvH4LB+oRZWawUO1H/3CpLI53Mq
         U+apl8qY98JllhWsmwnH7hxjYaredtATV8aFSYfK+SUiorUV2th4xeK0lp6WUa6q8LI0
         PMMi6DZpjQeopIi3x3KRVhdtHR3RlFcYoihH5OUdrcy72T0ofWRAUt242LpC+6lKtOn8
         DFlKjlBEpUKPe5OUz66SLL81y2VJCpvcSTuIR4r3DTxB7ijdJSgKIaBYaBw41mRbrsBL
         2VYA==
X-Gm-Message-State: APjAAAXK7ugqRrGTjEzh1LvTZADbsc2akzen87l1W3EM8V7Thwj+dXY5
        uUeB2jR8ZV6osIO9UmjumI+UpNnqgcrV81a3azQ=
X-Google-Smtp-Source: APXvYqyi5UpW61izWXuIW6qPszX2nnCoBz5uFsKhFBZekpliaB58is4zjB9HwuubHLBES0jaYfg7S7KrQtwN4z+VAbk=
X-Received: by 2002:a05:6830:1319:: with SMTP id p25mr6463699otq.224.1563477984856;
 Thu, 18 Jul 2019 12:26:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190718143428.2392-1-TheSven73@gmail.com> <20190718.120600.607199310950720839.davem@davemloft.net>
In-Reply-To: <20190718.120600.607199310950720839.davem@davemloft.net>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Thu, 18 Jul 2019 15:26:13 -0400
Message-ID: <CAGngYiWTUN7WfJc2mORzEbTNyQV-t_rngkZw2B3Edrd_42d-yA@mail.gmail.com>
Subject: Re: [PATCH] net: fec: generate warning when using deprecated phy reset
To:     David Miller <davem@davemloft.net>
Cc:     Fugang Duan <fugang.duan@nxp.com>, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 18, 2019 at 3:06 PM David Miller <davem@davemloft.net> wrote:
>
> The device tree documentation in the kernel tree is where information
> like this belongs.  Yelling at the user in the kernel logs is not.

Good point, thank you. I'll post a patch which will do exactly that.
