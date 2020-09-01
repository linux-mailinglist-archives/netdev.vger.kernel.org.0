Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F40258EEF
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 15:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgIANOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 09:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728067AbgIANKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 09:10:44 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8C5C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 06:10:25 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id b123so561258vsd.10
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 06:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nhxA47PPAUoW9K3p7YN0tZxp7z8XK1tFao3IrG0oM3Y=;
        b=dWqkpRrSUi9hXsz/qwj1jPeD0Krp5iOj60FphxM0X8BlmeM3FI27Y/5gCphi4BMOUJ
         YHF9x4ASnQcG/y0MzWHwqRd/erHeW4FZL2UJ69c0KTpYvs437HTORcnIjOgUSaLBXDBm
         COuteYXMP910hMm9uEs6scL5R71eEHTrArI6oYJOMPW7tBoA97iasT5Ijj4o+10I5vH2
         GX8gh6jRBDNssr00jnDkYU7g/ygnMLET+W8dgkhKzhjeFUzF/fJ0yYzjYsSHTzxP8vGN
         hggogzajfWfKkfokDm/2stXtYFCmS1xh2jEWdx8Ra3zTyHdx05f9ef3MuuSPgk0rMbgB
         ZBMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nhxA47PPAUoW9K3p7YN0tZxp7z8XK1tFao3IrG0oM3Y=;
        b=DjENtiQJXXwp14a/46APnfvune0UNcM/MfLUH94dVE10H8xfLYNTdmLHb6Sk1k39Mk
         5nXo01HF8yb6eA9j0Tm1es/RzUwE5OZezjTvoe3uFMl2ZAJSwsDPlyNeL1sv5r+P9baT
         SoTjhX8Pe+EIywxsJWZXM5jJnc2929uiE0yLaxl2snwB/kyWWL26nbxXsqaCXcGCujqB
         Ld7fZ8k7ils6QwQZ/wXBwsPfkoQT6YRDrVDnN7SveasjcOut/2uhRML/ICLOKdWSEOMH
         rZ6RjzotKrotqUKEh/ehSHbpRUhx6/YoAVVsqT6b0Jl5mMYCNmPRvZqNVLxQ3BNDTGww
         k6ag==
X-Gm-Message-State: AOAM530kiH/N0kCtqqbsviUnv4+Xz5YCQzIXg86ZoEHBaXyJeTkcUHqp
        FicWc9OjpZHF5afbkR1saoJkUB0HaIpye2pXEvc=
X-Google-Smtp-Source: ABdhPJyDmKYk1JefDZ6yyLHsdZcW2wz2ELi7tqW9YkIPj0RYFI3UIIcBFQhFQHT5e7sYzL3JtVPGOeYhmeAvbpZ8TX4=
X-Received: by 2002:a67:1702:: with SMTP id 2mr1254272vsx.6.1598965821002;
 Tue, 01 Sep 2020 06:10:21 -0700 (PDT)
MIME-Version: 1.0
References: <159886787741.29248.5272329110875821435.stgit@ebuild>
In-Reply-To: <159886787741.29248.5272329110875821435.stgit@ebuild>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 1 Sep 2020 21:07:12 +0800
Message-ID: <CAMDZJNWgxfux2nR=Y7CAxJ4uJOcc702gVFSP=zEboa=zS+J+yw@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net-next] net: openvswitch: fixes crash if
 nf_conncount_init() fails
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 31, 2020 at 5:58 PM Eelco Chaudron <echaudro@redhat.com> wrote:
>
> If nf_conncount_init fails currently the dispatched work is not canceled,
> causing problems when the timer fires. This change fixes this by not
> scheduling the work until all initialization is successful.
>
> Fixes: a65878d6f00b ("net: openvswitch: fixes potential deadlock in dp cleanup code")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
Reviewed-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  net/openvswitch/datapath.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index 6e47ef7ef036..78941822119f 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -2476,13 +2476,19 @@ static int __init dp_register_genl(void)
>  static int __net_init ovs_init_net(struct net *net)
>  {
>         struct ovs_net *ovs_net = net_generic(net, ovs_net_id);
> +       int err;
>
>         INIT_LIST_HEAD(&ovs_net->dps);
>         INIT_WORK(&ovs_net->dp_notify_work, ovs_dp_notify_wq);
>         INIT_DELAYED_WORK(&ovs_net->masks_rebalance, ovs_dp_masks_rebalance);
> +
> +       err = ovs_ct_init(net);
> +       if (err)
> +               return err;
> +
>         schedule_delayed_work(&ovs_net->masks_rebalance,
>                               msecs_to_jiffies(DP_MASKS_REBALANCE_INTERVAL));
> -       return ovs_ct_init(net);
> +       return 0;
>  }
>
>  static void __net_exit list_vports_from_net(struct net *net, struct net *dnet,
>
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev



-- 
Best regards, Tonghao
