Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33107101AA5
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 08:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfKSH7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 02:59:01 -0500
Received: from mail-ua1-f67.google.com ([209.85.222.67]:36257 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726921AbfKSH7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 02:59:01 -0500
Received: by mail-ua1-f67.google.com with SMTP id z9so6221330uan.3;
        Mon, 18 Nov 2019 23:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PRw07XCFW2nbwWC0OIMMG5Z5kRG46gKFzow6yKd7+cM=;
        b=DQPxQDsPkoQRnm8IWQ46ldblk9QmcMp9+sn9ByC8jhBb5xfOIATvCq9Yz1sM/4yfVf
         yBnni68M3IYaZr5gjy4aPi/VyGPczD2kwbXntPj71CfKm6YwSVOMMeY3eDkl6EjzcUj8
         L+ghd6Ad+NaB+hfqlu+z8f+cQhntWGm+LaCBfWJWQF0dNafqfDyswqspB0joLQ3cPGq9
         fy6KUZS3/57R42MDchiverlSVM66h/TRs1IYCilQKOdMjde8QypXDkBBynu30djXZ7BR
         8QOWPrYqGl35ITne1FG3Z+loFaeX0fb5VCeiFu/EPRtRFXf4v66QDI3T60Tf8aBOE3ey
         V/Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PRw07XCFW2nbwWC0OIMMG5Z5kRG46gKFzow6yKd7+cM=;
        b=jbiA6odQOEuLYlH34vgyLiwZjc7lB4VoSYvTzuHHbyomW5/lbps/Xlc+ChEc+t/l/V
         bux+OKOcKj7x6nA1tO6aKQ4I4h3ql3wxKGCflGRMuORkKNMtiU06O/yrKPrz4w1Uusfq
         AX3gFK2rUfIIrrsiT/DfEnvAmXA/rSFyCr28OO2IFzyBkavqfB8aT8VyU3etSqFOndoU
         paVqYu63WaBXm06x+TeB9EpBb34PIEUZ6yiVmtaBFTeqxCaiW11afQtrkDdMx433ssv2
         t4b66ayFwZvvV1RUCYwLFmd6sCC0vyiFAJjwSqAlIl5WFDXaPDx9dNkf+n5iypebIRio
         Jk8A==
X-Gm-Message-State: APjAAAVJdI9fLrFZT6WDOipT6GaiG+5XYnbdYmauGcpYYgpbS0MQ+zDQ
        EEcL30Scjq7lid97lyAMKH+vX3v6l4J8z//VNtM=
X-Google-Smtp-Source: APXvYqysC8+XpmOyo7+68+S1jc5tlaMecLlA8Jnp5FRUKcdJ1vdUQU8Xazb6fNRshj5v/ELhOn7AC90iG05upSknKaE=
X-Received: by 2002:a9f:3772:: with SMTP id a47mr8648367uae.53.1574150340611;
 Mon, 18 Nov 2019 23:59:00 -0800 (PST)
MIME-Version: 1.0
References: <1574150628-3905-1-git-send-email-yanjun.zhu@oracle.com>
In-Reply-To: <1574150628-3905-1-git-send-email-yanjun.zhu@oracle.com>
From:   Rain River <rain.1986.08.12@gmail.com>
Date:   Tue, 19 Nov 2019 16:06:09 +0800
Message-ID: <CAJr_XRBBy121cVKhUQohyt-DxTLVWUHpMEURu3gnjr9nHtMxRw@mail.gmail.com>
Subject: Re: [PATCH 1/1] MAINTAINERS: forcedeth: Change Zhu Yanjun's email address
To:     Zhu Yanjun <yanjun.zhu@oracle.com>
Cc:     mchehab+samsung@kernel.org, David Miller <davem@davemloft.net>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        robh@kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 3:54 PM Zhu Yanjun <yanjun.zhu@oracle.com> wrote:
>
> I prefer to use my personal email address for kernel related work.
>
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>

Thanks

Acked-by: Rain River <rain.1986.08.12@gmail.com>

> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e4f170d..8165658 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -643,7 +643,7 @@ F:  drivers/net/ethernet/alacritech/*
>
>  FORCEDETH GIGABIT ETHERNET DRIVER
>  M:     Rain River <rain.1986.08.12@gmail.com>
> -M:     Zhu Yanjun <yanjun.zhu@oracle.com>
> +M:     Zhu Yanjun <zyjzyj2000@gmail.com>
>  L:     netdev@vger.kernel.org
>  S:     Maintained
>  F:     drivers/net/ethernet/nvidia/*
> --
> 2.7.4
>
