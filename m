Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC911D6C26
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 21:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgEQTN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 15:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgEQTN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 15:13:26 -0400
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5973AC061A0C
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 12:13:26 -0700 (PDT)
Received: by mail-oo1-xc41.google.com with SMTP id q6so1596302oot.0
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 12:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iJlwxTep1GzUnZyRQGZ2FCEqht1K7smuquQzoyw/yYw=;
        b=uZJDHV0ZCCUhMJ0nuiY+WOaVx3ygnT1YEEeRw5XXkvgx3CiNIqAzxL3LwKeaOrNvph
         x0PzXbJiYOkSjbc6nkjG6BRer6A6tg88QqGY+YYoEOucKiKoA6tCJ0EytKqocWhjMJL7
         WoviHmmaCbZ6nQGOA1rW1cjVb3d4YX3zwrYhyEq+Snyeskf9gqRX9Q9ag8tggLHemGb+
         x5brZsNz/nc1dzbEna8N9ObtGHLH4HDOivO22IrFcCLAxXtwdWcPoLoEaAKRMvZ9bPUO
         IZ4zI9d/kAbVYL8bjRgoqK2P9T3KK0RF10rSwtzgPAPiTF11xvocj+YxhXc3HZWLvGoP
         b0SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iJlwxTep1GzUnZyRQGZ2FCEqht1K7smuquQzoyw/yYw=;
        b=fNxzOQ1HaJxVLyeUBhxLfSN6HBuAe9jFtAPnZbjy+2avCVC2WZoiImyOwJNdz+OzKL
         mHrvON+LClKC+eJbZ0YVvZNTRMwwES0S3ll1cL061qcpnz3WRaUCEkVgBP0Z7tWY03Eu
         b+98qUHizq2sTx0ka4Bqz3UAcOO3BMGhIIrP+jA6ldbzSzZBc+0jSX6ewavRNJMhl19+
         M+DBInynBWchX/rKymxVs9mmN1Y10pG5qjAfwjbh/Qv5IbwQeyVZsDYHkgB6a6pmfbOY
         /qvUa6FvmP7mJITa1BjgdQlJUPnaW6jIZIW6PSNa2pv3LJPR0xLKVDDNCon0/dMnagLh
         4JEg==
X-Gm-Message-State: AOAM532GErmG6ksyUJfskEaNwzJDnjHiH3CtXLAhKE79m2d+ldJcQYyo
        W5sf+eQTfKoO6Vk4SCzr00leeIJwVpTw+3cQug0=
X-Google-Smtp-Source: ABdhPJzJv5uqsv6gVg69lXrUyT21wgiThelCs23I4O+W4cycDPJ+uCBh5t4VHGZWVh6Gx2qK/eDhbfj3qanZR33/FLw=
X-Received: by 2002:a4a:5147:: with SMTP id s68mr10350690ooa.86.1589742805589;
 Sun, 17 May 2020 12:13:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200515114014.3135-1-vladbu@mellanox.com>
In-Reply-To: <20200515114014.3135-1-vladbu@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 17 May 2020 12:13:14 -0700
Message-ID: <CAM_iQpXtqZ-Uy=x_UzTh0N0_LRYGp-bFKyOwTUMNLaiVs=7XKQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/4] Implement classifier-action terse dump mode
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 4:40 AM Vlad Buslov <vladbu@mellanox.com> wrote:
>
> Output rate of current upstream kernel TC filter dump implementation if
> relatively low (~100k rules/sec depending on configuration). This
> constraint impacts performance of software switch implementation that
> rely on TC for their datapath implementation and periodically call TC
> filter dump to update rules stats. Moreover, TC filter dump output a lot
> of static data that don't change during the filter lifecycle (filter
> key, specific action details, etc.) which constitutes significant
> portion of payload on resulting netlink packets and increases amount of
> syscalls necessary to dump all filters on particular Qdisc. In order to
> significantly improve filter dump rate this patch sets implement new
> mode of TC filter dump operation named "terse dump" mode. In this mode
> only parameters necessary to identify the filter (handle, action cookie,
> etc.) and data that can change during filter lifecycle (filter flags,
> action stats, etc.) are preserved in dump output while everything else
> is omitted.
>
> Userspace API is implemented using new TCA_DUMP_FLAGS tlv with only
> available flag value TCA_DUMP_FLAGS_TERSE. Internally, new API requires
> individual classifier support (new tcf_proto_ops->terse_dump()
> callback). Support for action terse dump is implemented in act API and
> don't require changing individual action implementations.

Sorry for being late.

Why terse dump needs a new ops if it only dumps a subset of the
regular dump? That is, why not just pass a boolean flag to regular
->dump() implementation?

I guess that might break user-space ABI? At least some netlink
attributes are not always dumped anyway, so it does not look like
a problem?

Thanks.
