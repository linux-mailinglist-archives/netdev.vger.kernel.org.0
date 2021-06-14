Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7FBB3A6CFB
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 19:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235445AbhFNRUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 13:20:14 -0400
Received: from mail-il1-f171.google.com ([209.85.166.171]:38416 "EHLO
        mail-il1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235509AbhFNRUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 13:20:12 -0400
Received: by mail-il1-f171.google.com with SMTP id d1so12832983ils.5;
        Mon, 14 Jun 2021 10:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qQkiC2Boq1enDbw0Bq2sZY++jJ/micvga8E5sa5r6h8=;
        b=oaHRSDkeNHn3y88GUfUSl+LoUEKIRn0UkitkMvrlsd0qga4MoiaA592YqccF4da9+R
         QKW1b+YJSLQCJVdiYSQCpiWWYwf+WVMgl9iOhVL/cgl5wX4hncn7eyNFcYb3+2ZZdsou
         QSP41fxW6jivabswvcq/rzmls56ys2MZ4CWfNdXRhZwqW2Od9Q30bHZpqwX1Oze65Ww3
         FidiC8bJBtYrqPNETHTfwtkIMqgNv6LBF7Mo2ijyO+W1VT35nq2Oe6vb8/7Blr/3NeP7
         bjKnTQh13taBxcswZg5RvHo8Att1FPHoonSYx4GoulUkj4GNUwDZ+EKmo62FY0NlAKGW
         VhMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qQkiC2Boq1enDbw0Bq2sZY++jJ/micvga8E5sa5r6h8=;
        b=kClqWH+ENVbFTSHldYRG8lkQaGCdC0a1sgI2iHUOs68nZwZ2JWMLOYUUFb+e5n5w0K
         KwyL70qa3Ex658lTcbXTzD+/acbgL/y0coem9JBkgTEnA5EoE2Ek/E79cmaYX+z+DpYr
         WXYkb94udtqGxcpJKXClmbnhdHzJuMngcF1lrg0hEY68EvvJ6bgC0/RDrFdEKuqMqzOf
         AuQfr1/mBnrxrcrEZS1zUYfUzjIdZGJReqerFMSIyksJ+JtnBICTUJWb8uRBKlCCanZu
         WfqWVt+EH8L4HCAixTjMizYh9HLss5oX6QB4ifLbQmL1hUs1od5uPS2MJ3T8J24+h6XG
         4rRQ==
X-Gm-Message-State: AOAM5305FEEz/SedTyh9bhr6pugzaXoISbmD4u6gtaKMcCme9zx5F0Qb
        BUnLeq9Qq8NBqhKjXhlxHDQirQHZomQmtN7zY34=
X-Google-Smtp-Source: ABdhPJwnFA+kS2s8Pa5xN5D5dTnI6Fj1l6zO+N6DVsd7aS+/13vpCxr6vmcTpiFdlRMsnD1ubpNYc7CmKGkDRdqEZD8=
X-Received: by 2002:a05:6e02:1a03:: with SMTP id s3mr14899111ild.220.1623691029568;
 Mon, 14 Jun 2021 10:17:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210610094505.1341-1-zuoqilin1@163.com>
In-Reply-To: <20210610094505.1341-1-zuoqilin1@163.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 14 Jun 2021 19:17:03 +0200
Message-ID: <CAOi1vP89H+D_FDoFEjzqC1ff7ryjBhAYEwtH6NC8YhmXWpyQhQ@mail.gmail.com>
Subject: Re: [PATCH] net/ceph: Remove unnecessary variables
To:     zuoqilin1@163.com
Cc:     Jeff Layton <jlayton@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        zuoqilin <zuoqilin@yulong.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 12:02 PM <zuoqilin1@163.com> wrote:
>
> From: zuoqilin <zuoqilin@yulong.com>
>
> There is no necessary to define variable assignment,
> just return directly to simplify the steps.
>
> Signed-off-by: zuoqilin <zuoqilin@yulong.com>
> ---
>  net/ceph/auth.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/net/ceph/auth.c b/net/ceph/auth.c
> index de407e8..b824a48 100644
> --- a/net/ceph/auth.c
> +++ b/net/ceph/auth.c
> @@ -58,12 +58,10 @@ struct ceph_auth_client *ceph_auth_init(const char *name,
>                                         const int *con_modes)
>  {
>         struct ceph_auth_client *ac;
> -       int ret;
>
> -       ret = -ENOMEM;
>         ac = kzalloc(sizeof(*ac), GFP_NOFS);
>         if (!ac)
> -               goto out;
> +               return ERR_PTR(-ENOMEM);
>
>         mutex_init(&ac->mutex);
>         ac->negotiating = true;
> @@ -78,9 +76,6 @@ struct ceph_auth_client *ceph_auth_init(const char *name,
>         dout("%s name '%s' preferred_mode %d fallback_mode %d\n", __func__,
>              ac->name, ac->preferred_mode, ac->fallback_mode);
>         return ac;
> -
> -out:
> -       return ERR_PTR(ret);
>  }
>
>  void ceph_auth_destroy(struct ceph_auth_client *ac)

Applied.

Thanks,

                Ilya
