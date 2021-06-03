Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D0739ABE9
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 22:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhFCUoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 16:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFCUoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 16:44:20 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCAC4C06174A;
        Thu,  3 Jun 2021 13:42:24 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id e17so7752834iol.7;
        Thu, 03 Jun 2021 13:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U5j3+XmrYWYH5LDVYd/lbOK1tf7tlgcYQD0pA5KQF/E=;
        b=pyxX77wS5anKffcbbBNjJBOqbSWW2vwirO5pdECjHy+WTdl+EdkabpGp1SRiJgljiz
         wyKzYkHU/BOW52/iaXGjQXw1Z2CMB7TZWw/CxwSPFR5xTySoZsqXO5713A+bYqkYtayI
         eFpVY6zZF84U66/OADkKtTo9knRUviBIcnj+5CFUA3qQUbQEVXvYdC2jK82x0c04yPR/
         BvlIy001XjJ81ZkrlvmPwHWNk+tk3/ieXYtC4a6hwAkGkayBxgpqoHRzwz7W3ZhohNce
         QkuQ0HP2O5B3dkkFXsZCv/61uanUmW26/TU2YvK58pIc2wccODVMY90o1CWxME0OLv6w
         EBoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U5j3+XmrYWYH5LDVYd/lbOK1tf7tlgcYQD0pA5KQF/E=;
        b=QJBtWgzGJ5LuEnwaVvkm0EOoQNFIZQ7LAYzzYpYVszuS7uQX64PYM8vF3wESefKGg4
         jsmVHZB3OdnK7hKBDr0Vd3JKZXNqu9BWmy8u/NpmeGdNUtP079rqciaGqIyZ0fBQ2INW
         aSrE+bpDKDjtEE8/G0W6PkEr0QMGil8MyuI1yqfmZMTYEDVaamtShe0bNP8DxVdjNhWG
         lPEK82UPrBQ8A03n8dhEyefMXJLXOVOyZHuENwfv7FZUAf6QTP9STs0u3wCOqUoJwaDN
         hjgReKnqzL8iwMpzYtHXOzqtE/1XOczcivCvitcLDS+o9J44UNQFJLplJJ0vsWBIOCy2
         9c9w==
X-Gm-Message-State: AOAM531reXx2Kilqmc/U9ZTy/bCazLTEjJv8szBe28aT6K4uVDl/pXSQ
        tRSN1TIJdF9ysMjwAcBkIJu6RwyJHFTABXnvjoiu1o8zh5f3RQ==
X-Google-Smtp-Source: ABdhPJxxW+tYeSDoYo46Jkehjk8yMBdPxcY5yzp7TTW4ufpz8X3uP/EQ8ttGE2pldcWiBMxbuzdwbH8VHArK/WEIX1E=
X-Received: by 2002:a02:9a17:: with SMTP id b23mr817562jal.10.1622752944215;
 Thu, 03 Jun 2021 13:42:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210602065635.106561-1-zhengyongjun3@huawei.com> <162275220464.19203.17231827580306620053.git-patchwork-notify@kernel.org>
In-Reply-To: <162275220464.19203.17231827580306620053.git-patchwork-notify@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 3 Jun 2021 22:42:26 +0200
Message-ID: <CAOi1vP-wwcjS+W1o_5hA8CCgYykg=V7g3zU3yNvjSVO3wsxx5w@mail.gmail.com>
Subject: Re: [PATCH net-next] libceph: Fix spelling mistakes
To:     patchwork-bot+netdevbpf@kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 3, 2021 at 10:30 PM <patchwork-bot+netdevbpf@kernel.org> wrote:
>
> Hello:
>
> This patch was applied to netdev/net-next.git (refs/heads/master):
>
> On Wed, 2 Jun 2021 14:56:35 +0800 you wrote:
> > Fix some spelling mistakes in comments:
> > enconding  ==> encoding
> > ambigous  ==> ambiguous
> > orignal  ==> original
> > encyption  ==> encryption
> >
> > Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> >
> > [...]
>
> Here is the summary with links:
>   - [net-next] libceph: Fix spelling mistakes
>     https://git.kernel.org/netdev/net-next/c/dd0d91b91398

Not sure who is in charge of the bot.  Jakub, perhaps you?

This patch was picked up into ceph tree yesterday and is already in
linux-next:

https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?h=next-20210603&id=f9f9eb473076d7d1e40bfb42e626c6ae19720647

Thanks,

                Ilya
