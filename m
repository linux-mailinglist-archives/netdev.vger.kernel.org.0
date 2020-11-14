Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22432B2F77
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 19:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgKNSFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 13:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbgKNSFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 13:05:51 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43982C0613D1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 10:05:51 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id s24so13076929ioj.13
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 10:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kmIJcD83/9AU8/f5ZJJnIrgPnXpaM5oBCos4uPCM2ng=;
        b=kyGtjwA9Zr7KIWYDomyZf0Px0n9gytDgRVmRdjEMxSENbJbkR/2t0vLcg0fbeRFb2a
         KnNRVvsl4Bi13K9uvty6vVpoG7eVFNRItwv30SrGNpWoXS1S1EdAFCJE/sUEHrddQoOm
         SHQJ1U8wTYC9fZEfFTM1Nf3Mewho2lahzOX9P5ipq9HhRXlMaXr0CL+yc8voJkBvPgZM
         Iy2kio7Engy/uDb0pt8+CaBKPJTRfmpaOMiZKe3KgYmksv8DsT2CDzcRgq9GyK4ial0X
         OHo4IJO8MUYxSMaNabT1TGRwLQLJpyeuVmxUOCm+cOR4bkoC0q1adAPX5/izYcog7OBB
         hIVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kmIJcD83/9AU8/f5ZJJnIrgPnXpaM5oBCos4uPCM2ng=;
        b=lpOF2ZiygpHmBaK5RRI9J//8UWAFpdN9LBqMI7nF9uurB7y7xZodW4n/cyn0oa3Fdp
         vfl9zRBZfVOKn8WLGH3jOFHjppv5QF2HQjl6rwpa1IdljxodLwyJRcxW7/rBbPES0+9F
         ObWoHy8i7CWobUcITOvmk1j+ui3YCNhObFptQAmnhAaJ++nlxpCQdAgLc+a66tRGB32i
         d4nnypcihcgIIaLpD2wAs+LuRXBkVnDuXX/3OQA7q7CcDDRflIzKZkSyc3gPNHbzmrui
         ydE7gP/5EvnWXiWm/pjGUV19BhTzzjQJlbygCQ7W0/dUDLrLVQ57MCpUchQh5JqVyE7j
         oXkA==
X-Gm-Message-State: AOAM533JXB+e4lvPYyQEzq/WZ1bMXkFL+/UuA/e3aIFux1TIgAawHqKQ
        M/zcETFpXUARl5+w3g70OPqfcYnkKv8eXesUfXzSLq3QG6D8zQ==
X-Google-Smtp-Source: ABdhPJw1noMKKv5Z/HqqCfbr1hJqzpMTEejmyiRaWpztatGhYEw52A5nbtUaPO831ar/pTQaJS/TRTbduTDx65NikHI=
X-Received: by 2002:a05:6638:d46:: with SMTP id d6mr5815964jak.124.1605377150498;
 Sat, 14 Nov 2020 10:05:50 -0800 (PST)
MIME-Version: 1.0
References: <1605151497-29986-1-git-send-email-wenxu@ucloud.cn> <1605151497-29986-4-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1605151497-29986-4-git-send-email-wenxu@ucloud.cn>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 14 Nov 2020 10:05:39 -0800
Message-ID: <CAM_iQpUu7feBGrunNPqn8FhEhgvfB_c854uEEuo5MQYcEvP_bg@mail.gmail.com>
Subject: Re: [PATCH v10 net-next 3/3] net/sched: act_frag: add implict packet
 fragment support.
To:     wenxu <wenxu@ucloud.cn>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 9:44 PM <wenxu@ucloud.cn> wrote:
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index 9c79fb9..dff3c40 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -1541,8 +1541,14 @@ static int __init ct_init_module(void)
>         if (err)
>                 goto err_register;
>
> +       err = tcf_set_xmit_hook(tcf_frag_xmit_hook);

Yeah, this approach is certainly much better than extending act_mirred.
Just one comment below.


> diff --git a/net/sched/act_frag.c b/net/sched/act_frag.c
> new file mode 100644
> index 0000000..3a7ab92
> --- /dev/null
> +++ b/net/sched/act_frag.c

It is kinda confusing to see this is a module. It provides some
wrappers and hooks the dev_xmit_queue(), it belongs more to
the core tc code than any modularized code. How about putting
this into net/sched/sch_generic.c?

Thanks.
