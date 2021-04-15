Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B187F36086D
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 13:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbhDOLnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 07:43:12 -0400
Received: from mail-yb1-f178.google.com ([209.85.219.178]:45663 "EHLO
        mail-yb1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbhDOLnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 07:43:11 -0400
Received: by mail-yb1-f178.google.com with SMTP id g38so25775677ybi.12;
        Thu, 15 Apr 2021 04:42:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I5b6XAHxeefLRvPDk8t3YKHG/hquBKc6aBz1bhGKFzg=;
        b=HDwNv+UsyBKuYBAROKWqE7WKK5QX3sKN7aGINdI124v5zZRroHhRT4BcAoRjtr0eBH
         Y107LfR/dd8YGjT8YWxTYE0648+SejKFstANP5aU/EfVZn8/FicecAvp4GPr9luXEKHA
         nBGOzw96GB/b+Rl0jvaHlxUbc2m9+ML8DBbm26CbA8aSQjCAIX2V2jLchHC4D9+XJQ/u
         aL/hVEpxLYmgbafUQlj82G1BDWjWBEbXuBCwVTwYAB1RrJXhXxLLeDYRBA01yrkabQaw
         80H1wZ8+Cno7Ylj9UCn2j2afFC8OhSemnLbyKlQrQJqoWJ3iqZS0vdONywzIK7kaZ8mJ
         D1HA==
X-Gm-Message-State: AOAM5308js4AS3FgYfjehQr+jZngcZdJIt4kHSzsYCLFXUu5AyQsKKrc
        u0RjgzvpGxuE25Yqd9YoLyLTbK8czpnfIfeEaSQ=
X-Google-Smtp-Source: ABdhPJyZEHl9axgrvEnSDsaxgaykdNnNbKsYZXPrDOqdS8lyvUA/qa5E116myALM5bNLzof1l/pq4QQB3I5Q9/FuDZg=
X-Received: by 2002:a25:be09:: with SMTP id h9mr3884853ybk.239.1618486967845;
 Thu, 15 Apr 2021 04:42:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210415084723.1807935-1-colin.king@canonical.com> <20210415090412.q3k4tmsp3rdfj54t@pengutronix.de>
In-Reply-To: <20210415090412.q3k4tmsp3rdfj54t@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Thu, 15 Apr 2021 20:42:36 +0900
Message-ID: <CAMZ6RqJvN10Qf7rg-Z1aD82kJGPqueqgr+t88=yoJH93m+OuGw@mail.gmail.com>
Subject: Re: [PATCH][next] can: etas_es58x: Fix missing null check on netdev pointer
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Colin King <colin.king@canonical.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu. 15 Apr 2021 at 18:04, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 15.04.2021 09:47:23, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> >
> > There is an assignment to *netdev that is can potentially be null but the
                                           ^^
Typo: that is can -> that can

> > null check is checking netdev and not *netdev as intended. Fix this by
> > adding in the missing * operator.
> >
> > Addresses-Coverity: ("Dereference before null check")
> > Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X CAN USB interfaces")
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Thanks Colin!
