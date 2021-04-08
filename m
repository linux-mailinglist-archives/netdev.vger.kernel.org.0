Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C4F357AEE
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 05:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbhDHDyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 23:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhDHDyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 23:54:05 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6C8C061760
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 20:53:55 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id d10so615589ils.5
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 20:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2W7012bsIfpRy+MP9eZql6DB7ScoxohiHSmP5niLDlE=;
        b=ciN+HMG0IjEpS0j9JpuVYLetEtRmmzUYWqlcPKsKvlQSwwOZKulO6xvWMgmkBdKKHR
         dQZOSQC99RJxUGh+qCCFFvF42MQb95PWYbYrOs/Ql8pNYJBDIjbU0LODxO8o0sM070Qk
         tsv8Ypabqkz+j9zB3BqRiLAnfOmOYkU07v6zmUkYo2f8YOTgDh/CBjMFO7Y7zeymY2sN
         0XwCOx5FuGjpmQbU+mql4LlrQ+mcFA/mc41H2wD7MimNm8rr290VgDczN216c60AcC1U
         T9RNH2pFOG7UuRpfgbLX9t6DPS3D8hoKJ5rMVNp426pxCkbZqHwuvKksUc5X9zaY0Jli
         CfuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2W7012bsIfpRy+MP9eZql6DB7ScoxohiHSmP5niLDlE=;
        b=DFkhamHhHTMBXxhLeU766DJL2ZV0Cfqxmpf2AzamIMrz08kJgRa87+E5P8m5wNN6Hy
         e3MCxc0G3M7ujHtD4VMtCYztR7imTdokyXkOu6odzsSmLMQ6qdG4XDwXFxJRIgq0EQN+
         DDUfeRvq7/FGzcW1SycnUJRP7KpY6e2I1KSUkuW22ijg6hvn100o1EayAn0IAwgJc8AD
         UD4Dsj7lCa9GasU6KxGvSX0SSmpLjmZnkqUvutRqGKZL8h94fw+5TQxNxJO3o/huTkQ/
         XUYs0TzYYcJ+Rr5V7R8JQynu321kX+0/OvjzPCZXLb7Adv7WiH+Kg5gdpdqp6LbKcMI+
         3t0A==
X-Gm-Message-State: AOAM531d/Dc4MR+CGa5YEI/bJtjn5gGW0C9UzbghGo7LUJUziybeY1yr
        ypJNDloSUGB9rM01rDQFu6iF0hEoCfpny62eQ9bG4A==
X-Google-Smtp-Source: ABdhPJx//CkLH61Xww8j3pQhhGFZ0Z/pvJq9S3j4VGvVBlyYQOY64PQR0KUIq7YPJnKRcK4hQjw+ZlacPbmdLQlap9Y=
X-Received: by 2002:a05:6e02:1546:: with SMTP id j6mr4969555ilu.299.1617854034862;
 Wed, 07 Apr 2021 20:53:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210408131117.7f2f3a29@canb.auug.org.au>
In-Reply-To: <20210408131117.7f2f3a29@canb.auug.org.au>
From:   "Cong Wang ." <cong.wang@bytedance.com>
Date:   Wed, 7 Apr 2021 20:53:44 -0700
Message-ID: <CAA68J_ahKn3eD+QxYDUkJvLCbOzY13isBgLtwwSUwBw=S8YusA@mail.gmail.com>
Subject: Re: [External] linux-next: manual merge of the net-next tree with the
 bpf tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 7, 2021 at 8:11 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> Today's linux-next merge of the net-next tree got a conflict in:
>
>   net/core/skmsg.c
>
> between commit:
>
>   144748eb0c44 ("bpf, sockmap: Fix incorrect fwd_alloc accounting")
>
> from the bpf tree and commit:
>
>   e3526bb92a20 ("skmsg: Move sk_redir from TCP_SKB_CB to skb")
>
> from the net-next tree.
>
> I fixed it up (I think - see below) and can carry the fix as
> necessary. This is now fixed as far as linux-next is concerned, but any
> non trivial conflicts should be mentioned to your upstream maintainer
> when your tree is submitted for merging.  You may also want to consider
> cooperating with the maintainer of the conflicting tree to minimise any
> particularly complex conflicts.

Looks good from my quick glance.

Thanks!
