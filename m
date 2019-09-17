Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6379B4D21
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 13:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfIQLpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 07:45:39 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:34698 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbfIQLpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 07:45:39 -0400
Received: by mail-io1-f65.google.com with SMTP id q1so6879280ion.1
        for <netdev@vger.kernel.org>; Tue, 17 Sep 2019 04:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I8zI7qhOq721x2msbZwKNbqsXGV4rHGFyA4/znvpOwU=;
        b=lw47oWfmX859ky8ieWEMx1ECPJlegr4xNnPaB+1Dhh9Kax2lMnsDkqoN0omoVJeMDe
         q3/jjNrHzAywr36GxTlIkfkgq8zHBt1bzBWPusQ6iho+KkvFCM33DuhcjWdPcLVpojT8
         zAKC/vky2D71LV/jfqOh4lY1fOnoPaEp/pWqLOIT526TRm5lDYsQB8gJmFYPzhrBhSJN
         xPuwulCGbO0QR0ToeYtVk08+7ELcvqL/4roKxaCcAliuEW7uDOOm0rCB/XvHooBxc7Qy
         6aUjctEpMmWjaOil4gNkXRUwHfFTFcOT0qz5+Bt91VhTanz2zigjF7oWzBUChqiL8XQW
         QN/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I8zI7qhOq721x2msbZwKNbqsXGV4rHGFyA4/znvpOwU=;
        b=r+0oFb7skTgCptA6VELXjPaq4OTYK0xWZiFMZSKQdSm1v9hmkCvIZzgQYoxE4rh0M/
         lLDIxCblQ/On9kub+LbJUinSM8w/QjGjVna1lfqd6cWYidznElC/VtEGt8tqEg5TLbbS
         oB/Igz8HreZYoIKN91WblU2ixJ68KBTrWfGG1b/5PfOCi1S4m0K1VEUyJ4vKWJx4qGG4
         9guEsHo3TIas3upxTODctg+jBY2k3WlCJ5+liReHZIYrT5qeOezEFTBYI7kj1E+rReF5
         /CAM4lYxea7FRAzsJxpQt5pTocRvVYVynxtlZuOoIC5wIOyZVxnzOETu4edh80oKZmG0
         nZFA==
X-Gm-Message-State: APjAAAUwvv1A3MzgxtrCQPp75WaZh6QQ/sgcLnSyJJ5GIum41y5jfrZe
        MeKQML7En/74/tVpuOfZx9h0ZSANVYqChCyfy9Y=
X-Google-Smtp-Source: APXvYqw2ZpvJHWt7OSKNWmV/hJdUXqiz4Z41j1KL2om2H0FdC3xXpwpAfdcPDdgbxDQAp2zCWdIWHMqu8GnbyjmAz8E=
X-Received: by 2002:a05:6638:1f5:: with SMTP id t21mr3383875jaq.119.1568720738495;
 Tue, 17 Sep 2019 04:45:38 -0700 (PDT)
MIME-Version: 1.0
References: <c359067b4a84342ff24c6a3d089171de68489fcd.1568709449.git.dcaratti@redhat.com>
In-Reply-To: <c359067b4a84342ff24c6a3d089171de68489fcd.1568709449.git.dcaratti@redhat.com>
From:   yotam gigi <yotam.gi@gmail.com>
Date:   Tue, 17 Sep 2019 14:45:27 +0300
Message-ID: <CANnrxJjndjiBaJgqbxkO9Uomkj0VbF08OHsYTKUJK8q3hG9MKw@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: act_sample: don't push mac header on
 ip6gre ingress
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Yotam Gigi <yotamg@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 17, 2019 at 1:02 PM Davide Caratti <dcaratti@redhat.com> wrote:
>
> current 'sample' action doesn't push the mac header of ingress packets if
> they are received by a layer 3 tunnel (like gre or sit); but it forgot to
> check for gre over ipv6, so the following script:
>
>  # tc q a dev $d clsact
>  # tc f a dev $d ingress protocol ip flower ip_proto icmp action sample \
>  > group 100 rate 1
>  # psample -v -g 100
>
> dumps everything, including outer header and mac, when $d is a gre tunnel
> over ipv6. Fix this adding a missing label for ARPHRD_IP6GRE devices.
>
> Fixes: 5c5670fae430 ("net/sched: Introduce sample tc action")

Reviewed-by: Yotam Gigi <yotam.gi@gmail.com>

> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  net/sched/act_sample.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
> index 10229124a992..86344fd2ff1f 100644
> --- a/net/sched/act_sample.c
> +++ b/net/sched/act_sample.c
> @@ -146,6 +146,7 @@ static bool tcf_sample_dev_ok_push(struct net_device *dev)
>         case ARPHRD_TUNNEL6:
>         case ARPHRD_SIT:
>         case ARPHRD_IPGRE:
> +       case ARPHRD_IP6GRE:
>         case ARPHRD_VOID:
>         case ARPHRD_NONE:
>                 return false;
> --
> 2.21.0
>
