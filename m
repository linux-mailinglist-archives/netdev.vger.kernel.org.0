Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 619DC391745
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 14:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233304AbhEZMXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 08:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233168AbhEZMXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 08:23:50 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B919C061574;
        Wed, 26 May 2021 05:22:15 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id f12so1379284ljp.2;
        Wed, 26 May 2021 05:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zhDNs1OvrLLRHp01VJsRDHjv3DfbHGL4iLUwl466cC0=;
        b=rHZZ3w3PlqpSbLALcERtloPxfgr52ZeAz39H4XufVjhhBR7VnmNmMbt5pAlOZPn+B8
         jvBNG1pDTLG0A1b82u/0gZzSvy7o9MBie11WLmWImJ290NUcdWiJfVO1hMD2g67b2e4P
         DWNTpMfy42TFLtFWjKeKOTBHNEYNCgV/4qXtO9k6oJC3GVWczmxxDMYNBXL8ieCY7iRy
         O1PSfmCVBdkQrAcAtRNumkSyP/KAafWYGWVRyXY9AR6OGTALVtqIjKnaaJUlnsTua/hC
         cPe0gg9Hcr1HZVsQwavlhYtAtm4KKOdldO/NC4AEleDsePXNIifUzWOk4yyy41vJyKSW
         uHzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zhDNs1OvrLLRHp01VJsRDHjv3DfbHGL4iLUwl466cC0=;
        b=dNtKjGz61pqPAuEW2FiPCUZtb8zB/wY5HlbRbVX0QO6ZbfQXi9gsKJD24wpMn+bNE6
         Yg0uBGj9r8/YrOExo4wyNjm3pgOV73nkDrLqW5zSnTmjKGLdeIpMWRwmJUzVCwXGyNYX
         UH6yUzOWNA2Ef/1Oh+Kep0eaYeJgzSNvh8cCdkKeCSnAIty950A0ucY9SRJjknZj0oZT
         snrmYgRMV2bSZuxWcoIg9EagrI4NYUXPvMUO81LyY+0cPW8l+Z6xODWw0i17Fk4/mB+7
         a7xn4t4wd/JyI0n2+DUUKK5YbiNVB1Odz7YgCS2ztCYvvMcnvUOS64iNfnD/wyA5W13o
         w2/w==
X-Gm-Message-State: AOAM5326geFrR+aj2Lxg+ubJdbgLByy6TldKUriB1M04D3s422i1HGN8
        DwB76xhqvkbuqL9/fV49rVu0PgcoeqPGsd10Vx8=
X-Google-Smtp-Source: ABdhPJz+UwFaB+HIhfZwYF/YvCY0Fi2m8Tsoyq2FE1GmkwajoauUMxc5/eG5xLmWDagdy1BsVAieXaQwTiR6ivWyG78=
X-Received: by 2002:a2e:240e:: with SMTP id k14mr2032686ljk.423.1622031733666;
 Wed, 26 May 2021 05:22:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210309151834.58675-1-dong.menglong@zte.com.cn> <6d59bf25-2e1e-5bd7-07f1-dff2e73c7a7e@linaro.org>
In-Reply-To: <6d59bf25-2e1e-5bd7-07f1-dff2e73c7a7e@linaro.org>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 26 May 2021 20:22:02 +0800
Message-ID: <CADxym3Ycq=H74N7MLak-kub_qWeFCJLhZFgnjKKPPARXktJO2w@mail.gmail.com>
Subject: Re: [PATCH net-next] net: netlink: remove netlink_broadcast_filtered
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, mkubecek@suse.cz,
        dsahern@kernel.org, zhudi21@huawei.com, johannes.berg@intel.com,
        marcelo.leitner@gmail.com,
        Menglong Dong <dong.menglong@zte.com.cn>, ast@kernel.org,
        yhs@fb.com, rdunlap@infradead.org, yangyingliang@huawei.com,
        0x7f454c46@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 5:28 PM Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
>
[...]
>
> I was trying to figure out if the function could be useful to filter out
> some netlink messages when sending them to userspace.
>
> Still looking for examples :/
>
> On the other side, this function was put there as part of the network
> namespace infrastructure. Even there is no user, it may be needed.
>

I noticed that the function has not been used since it was added over
ten years ago, and thought that it may not be used in the future.

If you think it may be needed, let's just keep it!

Thanks!
Menglong Dong
