Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50EC91148B1
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 22:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730206AbfLEVal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 16:30:41 -0500
Received: from mail-lf1-f52.google.com ([209.85.167.52]:40003 "EHLO
        mail-lf1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbfLEVal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 16:30:41 -0500
Received: by mail-lf1-f52.google.com with SMTP id y5so3620180lfy.7
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 13:30:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dev-mellanox-co-il.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1sSGB3BokYfq4U4Y44YwKEXD8ScM4ZmN9h2uBGm5v6k=;
        b=sZM7CadPieZxnFSOoePtK2HQ3mve39aAcrI70Qis9s8uam8hrLUkWukjh1AWAYfWPn
         AcAtVRR8hrDHynsx6w4YNWc6yMtkxZdTIge6V+tkUfYrK2XXmUkrMVJIVlL9mOSWCk5y
         fTS6MDT62Eg4u/Xtjld+ucMhH2dFa3uVyU/qkQiFpnEZ9B4uYhdJ54D+ivqfTQuJhLvd
         DW69pwqrIBrlSz1Pwk9fNJ5GAhJfydldJScWGTjA3/ZXTTbWGjLxW1hcInq1jpPIJfJJ
         TCW00LOuonh4rt/iZYC5GUA1jOtZYRZ5HUPIZDoOJjRKDS3J0K3RvSzVm2UNxp1S0Dr3
         gHiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1sSGB3BokYfq4U4Y44YwKEXD8ScM4ZmN9h2uBGm5v6k=;
        b=Ahen7Kwz1C6fAItTCQ9FxMwk5pLMiNDwm4DJWoJ3IRQklskEts2k6ifTvMRLwCCOhM
         h5YgWo+gWrlVXguPZQib1XM1OjlYE4C9+8Ys7pBoDSEcBSjlZp97MJAr7WKlrw0jxUyB
         +tb7j+RbgasunEHyEmGxe+45IIQKZXmk7ZBgS5wwK64y/yKe6exYCOcegzeLfKqGYz4/
         zqO9VQCdP7obKvwNZoJbX7loh0Ak6egW7HlXAfbGTEByEgOqeGSSS/7cTJaeQtRe8c5r
         msbNhxKRjiWuC8lJkGor6ZOqLwhDpFv8ytfxbJj9HhcAZMboPDgze/h57CbU4MHm2sd1
         2A+Q==
X-Gm-Message-State: APjAAAWCX7apRdxZAWBc02F2M0pZ8JdvHFhOPA+JjlyIIxZZolbZSqSv
        vmHKytEaiFU4nH5bCDwa+ES3PJbvDBVYf0Yc378OGg==
X-Google-Smtp-Source: APXvYqz75N9cSfNovMnb5Gjt4c3CIhuirUXTTbN6MaBRdlS7q12D7dyidxhIvLeWYKfttuSrZdjK69Ny8CdjMekvPWk=
X-Received: by 2002:ac2:4c82:: with SMTP id d2mr6550952lfl.62.1575581439582;
 Thu, 05 Dec 2019 13:30:39 -0800 (PST)
MIME-Version: 1.0
References: <CAMDZJNXcya=6VsXitukS5MmZ36oPCUVNMncBJKrWmzwK62LeUg@mail.gmail.com>
In-Reply-To: <CAMDZJNXcya=6VsXitukS5MmZ36oPCUVNMncBJKrWmzwK62LeUg@mail.gmail.com>
From:   Saeed Mahameed <saeedm@dev.mellanox.co.il>
Date:   Thu, 5 Dec 2019 13:30:28 -0800
Message-ID: <CALzJLG-z18R+uPi2W3Wam7GKkxzayJDfyDyTmO+_W7Z1V0CaQg@mail.gmail.com>
Subject: Re: mlx5 support tc accept action
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Mark Bloch <markb@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>
Cc:     Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 4, 2019 at 10:41 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> Hi Roi, Saeed
> In one cause, we want the "accept" action: the IP of VF will be
> "accept", and others
> packets will be done with other actions(e.g. hairpin rule to other VF).
>
> For example:
>
> PF0=enp130s0f0
> VF0_REP=enp130s0f0_0
> VF0=p4p1_0
> VF1=p4p2_0 # belong to PF1
> VF0_IP=3.3.3.200
>
> ethtool -K $PF0 hw-tc-offload on
> ethtool -K $VF0 hw-tc-offload on
> tc qdisc add dev $PF0 ingress
> tc qdisc add dev $VF0 ingress
> tc filter add dev $PF0 protocol all parent ffff: prio 10 handle 1
> flower skip_sw action mirred egress redirect dev $VF0_REP
> tc filter add dev $VF0 protocol ip parent ffff: prio 1 handle 3 flower
> skip_sw dst_ip $VF0_IP action pass
> tc filter add dev $VF0 protocol all parent ffff: prio 10 handle 2
> flower skip_sw action mirred egress redirect dev $VF1
>
> When I change the driver, the rule which action "action pass", can be
> offloaded, but it didn't work.
> +               case FLOW_ACTION_ACCEPT:
> +                   action |= MLX5_FLOW_CONTEXT_ACTION_ALLOW;
> +                   break;
>
>
> How can we support it, this function is import for us.

Hi Tonghao,
where did you add the above code to ?
parse_tc_fdb_actions() ? or parse_tc_nic_actions() ?
in your use case you need to add it to parse_tc_nic_actions(),

currently in mlx5 we don't support ALLOW/pass actions.
it might be a little more complicated than what you did in order to
support this,
as a work around you can use action: FLOW_ACTION_MARK in the tc
command line rule without any change in the driver.
or change your code to do MLX5_FLOW_CONTEXT_ACTION_FWD_DEST instead of
MLX5_FLOW_CONTEXT_ACTION_ALLOW

Adding Mark and Ariel, they might have better feedback than mine

Thanks,
Saeed/
