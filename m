Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6862B76A8
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 08:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgKRHBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 02:01:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgKRHBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 02:01:04 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09517C0613D4
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 23:01:04 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id r1so864272iob.13
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 23:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XK9Xa2Jw481sQ6TLm0TXN98EcJZUN3SUOYz/838ylbU=;
        b=JRbcgWAfnkPR3FQXJVZ5GDqiAYYY73Ud0osBom0UklQVG6OIJ9c9xXhW0hqN4IFe/2
         jNKIwWC5lWMhc9wz+uFeDrLm35pM6y7PyacR3BGWQ3VfaxGHZWMi7j7gT1wTjMkpfg0p
         YRHK5kQ0h46bTGhOekXwqOlLImzIpj1ZbgGAqb1NJP0k9H1ocTPNFyAC+3LF50pH12v1
         1EE17HYPR6+CTLU+pNXGmMF09JqV/VnYZ/53JNtej8jdZpTIWhPhNA7dUtPkeuSIxb5i
         iqPU2SZSuYmpz61Z1PNHgy2aQawjvtzdY5JGnamj4csRZjB7ljtXHjvVklIjI6/wYA8Q
         SoIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XK9Xa2Jw481sQ6TLm0TXN98EcJZUN3SUOYz/838ylbU=;
        b=rAHtJMiI8C/gmN1hp/WzER7kF5hLaKtFq+nH5RblEDd4uMxIWkPN59I04uCRJyE4E6
         egdJHcNIYM14FPQD2nPJ39+cN4LuFc/SqsE/hO5L1xG4W1Yg++2VgmZEpWegbLB9Z239
         LNGxa/pga9PusQdC4VvBHgAVCJV/DlPj7O9+MXGdiDenkdZll/3fuNLgEKpUxL6ByH1I
         R2FUfiRwcspDms6fHDhkkqGdu7a6fstw1/QVpcDhVcAje0nAngxbiIREpw7jpPGr/vFj
         gX+GNAYcqQtT3xnGQfxWSzQlthZ3iw2OTV1LYSAcHD+eO6GiwreMgtGXvXIoISPVLznO
         KhPg==
X-Gm-Message-State: AOAM532oLw6qx9hCLrN7uQNw9MtZ655APkw+029sPrhPyLfz+8TofSBX
        vI8R46jRWXbMCQ4r0uPQN42JW8GCif3i8szFSYM=
X-Google-Smtp-Source: ABdhPJxtpE/FqYB/Vtexl3JqjMLEnKFUlU/GbLiBA6/JW6rxiq1eh8TONlcIN7diU/YtWbxcxIqN9fiAEcamIvKYEwo=
X-Received: by 2002:a05:6638:d46:: with SMTP id d6mr6870829jak.124.1605682863350;
 Tue, 17 Nov 2020 23:01:03 -0800 (PST)
MIME-Version: 1.0
References: <1605663468-14275-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1605663468-14275-1-git-send-email-wenxu@ucloud.cn>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 17 Nov 2020 23:00:52 -0800
Message-ID: <CAM_iQpVoFrZ9gFNFUsqtt=12OS_Cs+vpokgNCB0eQiBf=hD4dA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 3/3] net/sched: sch_frag: add generic packet
 fragment support.
To:     wenxu <wenxu@ucloud.cn>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 5:37 PM <wenxu@ucloud.cn> wrote:
>
> From: wenxu <wenxu@ucloud.cn>
>
> Currently kernel tc subsystem can do conntrack in cat_ct. But when several
> fragment packets go through the act_ct, function tcf_ct_handle_fragments
> will defrag the packets to a big one. But the last action will redirect
> mirred to a device which maybe lead the reassembly big packet over the mtu
> of target device.
>
> This patch add support for a xmit hook to mirred, that gets executed before
> xmiting the packet. Then, when act_ct gets loaded, it configs that hook.
> The frag xmit hook maybe reused by other modules.
>
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
> v2: make act_frag just buildin for tc core but not a module
>     return an error code from tcf_fragment
>     depends on INET for ip_do_fragment

Much better now.


> +#ifdef CONFIG_INET
> +               ret = ip_do_fragment(net, skb->sk, skb, sch_frag_xmit);
> +#endif


Doesn't the whole sch_frag need to be put under CONFIG_INET?
I don't think fragmentation could work without CONFIG_INET.

Thanks.
