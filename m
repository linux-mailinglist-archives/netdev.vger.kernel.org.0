Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4173531C14B
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 19:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbhBOSP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 13:15:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbhBOSPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 13:15:55 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD068C061574;
        Mon, 15 Feb 2021 10:15:14 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id w1so3569564ejk.6;
        Mon, 15 Feb 2021 10:15:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2OD7Oc4ulM3X8ouS1/vJUS6vCduQdV8B7cQgskKhcDc=;
        b=inrkHH3bnH/oh8dpYhSj7C7mkInLB2gqXT9VzUwWY8N/Q/MEsWYnjTWcScvQmeNk+C
         xuGbFq8g2XtnbOYSUuC93EUEfuo4xAOX/wS64UWE0Ew1kJVJGKCYldhpRaodRYXt6UwG
         0gXRpzueGUIGufDhrmFne8uwiptbs82Kgo0tuq0GsRfGM/Dm9pl6HrTGl9jH3Kq44hEH
         gtFOPEmK6j0egOa9MMz6Mi1GtN0hZzi9KQLauKpAhcDzljZDVqW1fGID+rr+frS3iqqg
         15Y8XPvW/t2cIBTmGTBxqzCNGqdNY2TfMeHsGpZQqSzMhpggENt/m7qCXaBD8PcvXlhT
         6fYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2OD7Oc4ulM3X8ouS1/vJUS6vCduQdV8B7cQgskKhcDc=;
        b=MvderKbaJYdpu/v+zRdaXnX+ytXh0uVPS9LPMQ8q0l2akWwOvEtPG/077iJu5IaaoB
         x6ek2jL1nkLIzM/T664WKGJ7VdeHmm6YiJWH/1+wAAQdrSRZnOuD5ZKZ6hf4vvs/40mR
         SkuOzH/neNj4D04uPGFbE9mJOe3k3E6eoSMxCvMUr3xQg2NJVStvk0lruCLxpQ3k6elO
         dqMAuk/vu1nWY4AoKme0iMcA2FmJTUxhub6BNq2I4s3wSkOHsQJCiB82AKG9X7oAaPPq
         ZRPMJB1DUzj/7J9D9dFnGuRCb9KUzfz+AQLfOtkFyTBL432eIqNc+oUDzUuY10HvDgBi
         iljw==
X-Gm-Message-State: AOAM533+xQ9yXInY5HMWvo/dwqUHEOFveuWWptLbE7ey28bvQ6RTFnIH
        /+maJaz3AAfj9sg7NER4p7XnRCCg/dBuuJ/fWLA=
X-Google-Smtp-Source: ABdhPJxEA+Mq4DrMcvXfk2Rn30RtAx8eLOFCtu1ZgYxPTL+5HaaRvMwLSO/IhyyAfYPF+lciX5yMEz73+0RlSAzuW+Q=
X-Received: by 2002:a17:906:33c5:: with SMTP id w5mr16980889eja.319.1613412913669;
 Mon, 15 Feb 2021 10:15:13 -0800 (PST)
MIME-Version: 1.0
References: <20210215175400.13126-1-gakula@marvell.com>
In-Reply-To: <20210215175400.13126-1-gakula@marvell.com>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Mon, 15 Feb 2021 23:45:02 +0530
Message-ID: <CA+sq2Cc5d4oJUNA96wMgEf3jgf4500Yu2G9TKA=cHuG8oyHtZw@mail.gmail.com>
Subject: Re: [net-next PATCH] octeontx2-af: cn10k: Fixes CN10K RPM reference issue
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 11:27 PM Geetha sowjanya <gakula@marvell.com> wrote:
>
> This patch fixes references to uninitialized variables and
> debugfs entry name for CN10K platform and HW_TSO flag check.
>
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
>
> This patch fixes the bug introduced by the commit
> 3ad3f8f93c81 ("octeontx2-af: cn10k: MAC internal loopback support".
> These changes are not yet merged into net branch, hence submitting
> to net-next.
>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c   |  2 ++
>  .../net/ethernet/marvell/octeontx2/af/rvu_debugfs.c   |  2 +-
>  .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c    | 11 ++++++-----
>  3 files changed, 9 insertions(+), 6 deletions(-)
>

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> index 3f778fc054b5..22ec03a618b1 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> @@ -816,22 +816,23 @@ static bool is_hw_tso_supported(struct otx2_nic *pfvf,
>  {
>         int payload_len, last_seg_size;
>
> +       if (test_bit(HW_TSO, &pfvf->hw.cap_flag))
> +               return true;
> +
> +       /* On 96xx A0, HW TSO not supported */
> +       if (!is_96xx_B0(pfvf->pdev))
> +               return false;
>
>         /* HW has an issue due to which when the payload of the last LSO
>          * segment is shorter than 16 bytes, some header fields may not
>          * be correctly modified, hence don't offload such TSO segments.
>          */
> -       if (!is_96xx_B0(pfvf->pdev))
> -               return true;
>
>         payload_len = skb->len - (skb_transport_offset(skb) + tcp_hdrlen(skb));
>         last_seg_size = payload_len % skb_shinfo(skb)->gso_size;
>         if (last_seg_size && last_seg_size < 16)
>                 return false;
>
> -       if (!test_bit(HW_TSO, &pfvf->hw.cap_flag))
> -               return false;
> -
>         return true;
>  }

The HW_TSO flag should not be set for B0 silicon as well, otherwise
the checks related to
HW issue mentioned above will not come into effect.

Thanks,
Sunil.
