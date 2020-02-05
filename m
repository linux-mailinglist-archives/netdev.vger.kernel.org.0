Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9C0153A69
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 22:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbgBEVoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 16:44:32 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:43282 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727116AbgBEVob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 16:44:31 -0500
Received: by mail-yw1-f66.google.com with SMTP id f204so3886064ywc.10
        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 13:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IZY6u5H0nI9sLLrpUPCUXkL7QEKENAxLaurk3sMVGfw=;
        b=iYC3MNCYUe/meVHEvPY6FGn0IUtDGqWFkg+IxKypIDs864456FmBpHy5HR/oB4qKqR
         njG6YZxK44jvaFDN9HQMx4cIohzNEmsmclQBjAlcn7And+o+BR2bKeXzA0RufvUpEBkA
         EvLkKNblCRoZET7B8R8F4Tb5eqz406tXy8lPTv9kxDnbEnRaXqFWbukBZIFsyy3FQ/fO
         lWaMKptlX/H6Ov5ZfBv//dSUlT3PUYan2dga4rveWfOF7DPdfJWFekCTyeuX/DGeZpR9
         Malz83isBddxURJo0vZM2Qg4Nodpi04Xn9/co7lj9I1aFsGBAaFJ59NTht4Cpdi76Mou
         7npw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IZY6u5H0nI9sLLrpUPCUXkL7QEKENAxLaurk3sMVGfw=;
        b=Cs/JZ7tkgolC3EBRwvMRlkKtBrMz7vL1cksCb/6iXdLaAXT7p+eG1GoP/5NTR0PM49
         4ryKKNxPVv3IiRSfzrJOwqvnwneo+qT2UM43j/TF+YuCMpyJwn/mVacxP6IVZwmvT5Gl
         yTs+KKsPPaBptjg/+V5Ry2IKrCTCnAsjQ9NITuY3uql+ak1gnzrJaSQDaznWUAlnfdD0
         dPuHIsajqpm4Y3wPC5tcNlipniThtYFS3na0rHodHqJix2XaqvDo8yEfq1JeSVusC1M9
         m7YjmpXLbxNE4AdcTV1T36yOZ0VIEeI5T5cXmXNXjofyEDnQVnmItiK5iXapCF+ZsPnO
         83og==
X-Gm-Message-State: APjAAAUjwMUSIfdiQrq2rEjuSdB4I8rVlJuJPYkzfXHuHF7VMD6pZoYG
        daw1aYTFa6sXjBSJxjTPG29svuDD
X-Google-Smtp-Source: APXvYqwURxHsOaD4KmjMYHgD+AaXGAjHEOz8/n5M/AtBuKYiSo3qpCG/gpZdtqDOGsX/sukSGMyQyg==
X-Received: by 2002:a81:4f0d:: with SMTP id d13mr191258ywb.128.1580939070351;
        Wed, 05 Feb 2020 13:44:30 -0800 (PST)
Received: from mail-yw1-f41.google.com (mail-yw1-f41.google.com. [209.85.161.41])
        by smtp.gmail.com with ESMTPSA id x184sm471817ywg.4.2020.02.05.13.44.29
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 13:44:29 -0800 (PST)
Received: by mail-yw1-f41.google.com with SMTP id i126so3910168ywe.7
        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 13:44:29 -0800 (PST)
X-Received: by 2002:a25:68c9:: with SMTP id d192mr105687ybc.165.1580939068143;
 Wed, 05 Feb 2020 13:44:28 -0800 (PST)
MIME-Version: 1.0
References: <CABGOaVTY6BrzJTYEtVXwawzP7-D8sb1KASDWFk15v0QFaJVbUg@mail.gmail.com>
In-Reply-To: <CABGOaVTY6BrzJTYEtVXwawzP7-D8sb1KASDWFk15v0QFaJVbUg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 5 Feb 2020 16:43:51 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeYGYr3Umij+Mezk9CUcaxYwqEe5sPSuXF8jPE2yMFJAw@mail.gmail.com>
Message-ID: <CA+FuTSeYGYr3Umij+Mezk9CUcaxYwqEe5sPSuXF8jPE2yMFJAw@mail.gmail.com>
Subject: Re: TCP checksum not offloaded during GSO
To:     Yadu Kishore <kyk.segfault@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 4, 2020 at 12:55 AM Yadu Kishore <kyk.segfault@gmail.com> wrote:
>
> Hi,
>
> I'm working on enhancing a driver for a Network Controller that
> supports "Checksum Offloads".
> So I'm offloading TCP/UDP checksum computation in the network driver
> using NETIF_F_HW_CSUM on
> linux kernel version 4.19.23 aarch64 for hikey android platform. The
> Network Controller does not support scatter-gather (SG) DMA.
> Hence I'm not enabling the NETIF_IF_SG feature.
> I see that GSO for TCP is enabled by default in the kernel 4.19.23
> When running iperf TCP traffic I observed that the TCP checksum is not
> offloaded for the majority
> of the TCP packets. Most of the skbs received in the output path in
> the driver have skb->ip_summed
> set to CHECKSUM_NONE.
> The csum is offloaded only for the initial TCP connection establishment packets.
> For UDP I do not observe this problem.
> It appears that a decision was taken not to offload TCP csum (during GSO)
> if the network driver does not support SG :
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 02c638a643ea..9c065ac72e87 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3098,8 +3098,9 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
>   if (nskb->len == len + doffset)
>   goto perform_csum_check;
>
> - if (!sg && !nskb->remcsum_offload) {
> - nskb->ip_summed = CHECKSUM_NONE;
> + if (!sg) {
> + if (!nskb->remcsum_offload)
> + nskb->ip_summed = CHECKSUM_NONE;
>   SKB_GSO_CB(nskb)->csum =
>   skb_copy_and_csum_bits(head_skb, offset,
>         skb_put(nskb, len),
>
> The above is a code snippet from the actual commit :
>
> commit 7fbeffed77c130ecf64e8a2f7f9d6d63a9d60a19

This behavior goes back to the original introduction of gso and
skb_segment, commit f4c50d990dcf ("[NET]: Add software TSOv4").

Without scatter-gather, the data has to be copied from skb linear to
nskb linear. This code is probably the way that it is because if it
has to copy anyway, it might as well perform the copy-and-checksum
optimization.
