Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8050E351C33
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237673AbhDASOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236947AbhDASLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 14:11:41 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFDCC02FE98
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 09:04:18 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id j198so2270184ybj.11
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 09:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sUBBxIsh5MoadReGP/VqLbxohML6QjbcEagpy6zr2XU=;
        b=kgGoI1mi73jJD6vU65ZjfSW989i3YggKxTExgsujUPG2obK52+EqLs3uOVTYfZIwvS
         zIpdGcgqASulxt+rZ5WjRLODKT93fo5mJAsIYXfg7bKukY4PJNYKVVCG7WgoFiU+mwtj
         hcoIxKw8pdNBbIvX7rerUuJEa5a0V20aWrMKo/IMqB5QW2n1+TRXL/6ClTWQabbYsytE
         2s0MGIGrkq5F9P8qW40p/EKzwRoXNCh1+nYnSvM6YgvmJnM7s536PwfhYAPXmX+BEtiR
         beJ66gKeaeuXmHOwilFjAUIN26vIU106ceWCK1wWhmUY0bdzn42lqhUkxnOZ1QJO//1R
         mSCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sUBBxIsh5MoadReGP/VqLbxohML6QjbcEagpy6zr2XU=;
        b=sl71mcWM4ZfClResVR2UFrFz7PsiqgZeyDqw5sBlvcUWvLKdT7mBraXY+e1jx8LxjX
         SvaK1NoU2ll4ehz3m0nYIUrSOibt102v5Vjhm/vacMctoLXLwR1nJl4uFwMT+9AVXpp9
         fL2uWoTaXRxLaJssqhfhdepOfuJxT13/zc+wYd9w06Zbs598THKzu028qbfS1+GTlNpn
         CGSSgUiNDJSpUlv/BmUdHlGPHjH5TsShAnbySROoNd/kP/ubIUYmimcnZ6fdLSAxgMjg
         mGuwbSmQovoHWPQsmTi73haH1XgfyboZ8fNsfrqIrkQxmgWrPTEo7uDQeDe+591L8wUU
         8H8Q==
X-Gm-Message-State: AOAM532s81UdELZQytJtZl6gb10RF0krcuNZsfbJPqv2+UPG7/6dMOGe
        OkJ1vijxS8AEyxKNca3zB0lWqyN5zenm+9bXPTbx+r9/oLA=
X-Google-Smtp-Source: ABdhPJy9LhPezyvzgsg7ZroTaiT8wXFSCxJWKBWR93Vq5xwa7AbGV2rFFaql2dzdLKzB4TEZ2VQm4+2+1V7LIj71wDE=
X-Received: by 2002:a25:3614:: with SMTP id d20mr12775432yba.452.1617293057194;
 Thu, 01 Apr 2021 09:04:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210401155704.35341-1-otto.hollmann@suse.com>
In-Reply-To: <20210401155704.35341-1-otto.hollmann@suse.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 1 Apr 2021 18:04:05 +0200
Message-ID: <CANn89iJvtuT4q-djaCzoGJTY68vE8wT+LVDkYGm=8_XzC9gchg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: document a side effect of ip_local_reserved_ports
To:     Otto Hollmann <otto.hollmann@suse.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        David Ahern <dsahern@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 1, 2021 at 5:58 PM Otto Hollmann <otto.hollmann@suse.com> wrote=
:
>
>     If there is overlapp between ip_local_port_range and ip_local_reserve=
d_ports with a huge reserved block, it will affect probability of selecting=
 ephemeral ports, see file net/ipv4/inet_hashtables.c:723
>
>     int __inet_hash_connect(
>     ...
>             for (i =3D 0; i < remaining; i +=3D 2, port +=3D 2) {
>                     if (unlikely(port >=3D high))
>                             port -=3D remaining;
>                     if (inet_is_local_reserved_port(net, port))
>                             continue;
>
>     E.g. if there is reserved block of 10000 ports, two ports right after=
 this block will be 5000 more likely selected than others.
>     If this was intended, we can/should add note into documentation as pr=
oposed in this commit, otherwise we should think about different solution. =
One option could be mapping table of continuous port ranges. Second option =
could be letting user to modify step (port+=3D2) in above loop, e.g. using =
new sysctl parameter.
>
> Signed-off-by: Otto Hollmann <otto.hollmann@suse.com>

I think we can view this as a security bug that needs a fix.
