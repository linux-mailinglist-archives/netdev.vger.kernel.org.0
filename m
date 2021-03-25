Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91BC934970C
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 17:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhCYQl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 12:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbhCYQlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 12:41:25 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FECC06174A;
        Thu, 25 Mar 2021 09:41:25 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id v26so2515485iox.11;
        Thu, 25 Mar 2021 09:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OdbHY0RnzXW9ln9u58UHELCJWkEnS2LU09uY7jHKHhU=;
        b=lt3Hqv6lHrHwGZtQRrQ38hRcDah6BT3R+RyYwSI+RZP0u9c/rC6oVratLljSq2SigX
         H2UxOLfe7Woo6m5o982ut9cTCFvthqQMvwXclLOuqSHaOGyOFM2zLxTNnbBmhM5TYk8D
         x616ICnc69sZ1QMlbwlZhz+B8JsnbDM/a1vYkg6R2GjUOWWeLKmdFLJ2uVJlYD+iPVhw
         AeDBQjlYUVKZvnZbODqbTLAZnl3lCd8gaFjdg2HJYxV3FUumtAKMiudPRrqB434EF1pm
         q47nf8xQPVnhPk6DKzRlK/N04bcmCTWOC22OUZGoMmpBEaS92bznVdEIwKWgWC0xSG+e
         1Eqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OdbHY0RnzXW9ln9u58UHELCJWkEnS2LU09uY7jHKHhU=;
        b=EFyP5zy4DIFedsVa3vqPLI7SG3CiPgNIg8akWfwS5ttr58hOorR6Fei4YAnkcya9L1
         6aRr61NEeWqEUFHMEDSYMZFqyfof4yGYqXsEAbrqYladbMxGYQ21d579mmfY7SjkLtW7
         aBOw7mXvCidH/ZbcXg5WjXMkZz07RZWkz1t0XjJFQjs5OrR6Ldn44COBqt4OgR48GlZV
         vioEGhkwLsSn84YckkhqaydV/9Uu9BCl2N1ea2PtPB6esef6HbL0XHQsTOmPJgoqKmIa
         YR1PC4MZr/DDMsp6tCkThKdhGuMTKO9SM9/vXR/GAeLmiz/K5qoFS9/W8kCbOYZkCF9A
         j/oA==
X-Gm-Message-State: AOAM5315bl5Nsj1QENAeynp8cMUvrORlWXKRnb28JqMWlRAEXgQlQCVq
        pmrDQUWm7MrTmekN5bf7+Tr9w7zZqiYf0q6w4a0=
X-Google-Smtp-Source: ABdhPJxbrlydndu7n5u97K0HgoGx9Fx7r5H7yg7JN5zcWAYel05Svrjq2W6LDfFYaZts37+Sii4p9iLuRyVB+S8mVS4=
X-Received: by 2002:a02:8801:: with SMTP id r1mr8496177jai.51.1616690485097;
 Thu, 25 Mar 2021 09:41:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210325063825.228167-1-luwei32@huawei.com> <20210325063825.228167-2-luwei32@huawei.com>
In-Reply-To: <20210325063825.228167-2-luwei32@huawei.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 25 Mar 2021 17:41:16 +0100
Message-ID: <CAOi1vP9uuaY9OMmW0Xni5iUztyAviFH3N11ohWbb2zqXsGYMiQ@mail.gmail.com>
Subject: Re: [PATCH -next 1/5] net: ceph: Fix a typo in osdmap.c
To:     Lu Wei <luwei32@huawei.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, xiyou.wangcong@gmail.com,
        ap420073@gmail.com, linux-decnet-user@lists.sourceforge.net,
        Andrew Lunn <andrew@lunn.ch>, vivien.didelot@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>, olteanv@gmail.com,
        steffen.klassert@secunet.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 7:37 AM Lu Wei <luwei32@huawei.com> wrote:
>
> Modify "inital" to "initial" in net/ceph/osdmap.c.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Lu Wei <luwei32@huawei.com>
> ---
>  net/ceph/osdmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
> index 2b1dd252f231..c959320c4775 100644
> --- a/net/ceph/osdmap.c
> +++ b/net/ceph/osdmap.c
> @@ -1069,7 +1069,7 @@ static struct crush_work *get_workspace(struct workspace_manager *wsm,
>
>                 /*
>                  * Do not return the error but go back to waiting.  We
> -                * have the inital workspace and the CRUSH computation
> +                * have the initial workspace and the CRUSH computation
>                  * time is bounded so we will get it eventually.
>                  */
>                 WARN_ON(atomic_read(&wsm->total_ws) < 1);
> --
> 2.17.1
>

Hi Lu,

There is at least one other legit typo in that file: "ambigous".
I'd rather fix all typos at once, so curious why Hulk Robot didn't
catch it.

Thanks,

                Ilya
