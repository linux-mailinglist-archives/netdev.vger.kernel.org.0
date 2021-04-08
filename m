Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBAE357AEA
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 05:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbhDHDu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 23:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhDHDu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 23:50:56 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB34C061760
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 20:50:45 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id r193so738247ior.9
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 20:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QSQwh6FEfQXgkuwm6nqm6CMdCCSMi5maBHIb9ncUYxw=;
        b=zMXiEZz6V4TELas2KtY6Aaj/g/mcC4L/oN3+6ft9h7yJQCVInuundESFeMpTI6VrJ9
         dmLo468jWhWxfySioaql1JGlhvk82bfjSGVH0eA13M/k4fuutw+FuNfjVBkz76rlk/wc
         lSEh+JMHsxkbxcZM3g55ZC9HZPCeV2DnyPEcaGRaThRqfVsHFdJ7LAg5OpRkckMZNtFE
         DE8EREciU0+ZuU5eSombKU0c5IT7q14J58deHK/E9ucOvni2b39gM3QqCHbejmOOSk4H
         YbAvrbauqqZ+3UU1uU2b/K5DyNHVbzlOAMrCIt9O5NjC6VSjPHJcMKHJ4o1kHmbLOGVs
         4S/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QSQwh6FEfQXgkuwm6nqm6CMdCCSMi5maBHIb9ncUYxw=;
        b=bQ9osAPs11nJZpO5Z8xbcNgbzs/5xqiR2f9dzEUMGymVdABNy1QUW+7oCHmZu888/m
         JKTIaQ/oUlIl5lsD1fb7Y3Qf1Sp9yEKamfTcK9eD/jmfwmY8x6yojtIDRb10fy80eRFU
         6ixmuYVLv8RArOLuXVsk5EPIssqbPuG/mxjveWC+2oBW8dLDn+BukxJcA+K+PE7MWBVI
         8LV08m47lpPneQxQauJUVAC6QYk6CIpWDY8zqAFsJ2gGL8ION8F8YrpnY58wcwstDPVC
         rXt/nhV3UK7Eg3rRVd9iw7etMzzoObK9mBaox67twyo9soMDcAHbrxZ1eDX54hMo0OFI
         rHnw==
X-Gm-Message-State: AOAM530jCWT77CjabD1Rfa3Amiok5YcLntlsFdcelIKiwcOXEpQPBmVW
        zDVaizadX+B9lDIbjkXR8g0I6RX++myGMEo3vE46PA==
X-Google-Smtp-Source: ABdhPJwTZQsVjIvnv/Fy62zB6KFa6XbHe8bhrSuSeJAmHilUDdo/fWDu3XEqO0YNif2WKp/p5fSwwANNOBfEBZdTg3c=
X-Received: by 2002:a02:230d:: with SMTP id u13mr6929339jau.53.1617853844692;
 Wed, 07 Apr 2021 20:50:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210408130200.32ec9d1e@canb.auug.org.au>
In-Reply-To: <20210408130200.32ec9d1e@canb.auug.org.au>
From:   "Cong Wang ." <cong.wang@bytedance.com>
Date:   Wed, 7 Apr 2021 20:50:33 -0700
Message-ID: <CAA68J_ZYfJdVQS4_sWB2RVowXO1UVPQVzoNmdFN4P96kKV3KEA@mail.gmail.com>
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

On Wed, Apr 7, 2021 at 8:02 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> Today's linux-next merge of the net-next tree got a conflict in:
>
>   include/linux/skmsg.h
>
> between commit:
>
>   1c84b33101c8 ("bpf, sockmap: Fix sk->prot unhash op reset")
>
> from the bpf tree and commit:
>
>   8a59f9d1e3d4 ("sock: Introduce sk->sk_prot->psock_update_sk_prot()")
>
> from the net-next tree.
>
> I didn't know how to fixed it up so I just used the latter version or
> today - a better solution would be appreciated. This is now fixed as
> far as linux-next is concerned, but any non trivial conflicts should be
> mentioned to your upstream maintainer when your tree is submitted for
> merging.  You may also want to consider cooperating with the maintainer
> of the conflicting tree to minimise any particularly complex conflicts.

The right way to resolve this is to move the lines added in commit
1c84b33101c8 to the similar place in tcp_bpf_update_proto().

Thanks.
