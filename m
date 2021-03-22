Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A2D344783
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 15:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhCVOik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 10:38:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229972AbhCVOiR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 10:38:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EE326197F;
        Mon, 22 Mar 2021 14:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616423897;
        bh=zLCBqyxs8ZnqWYtBIbw1rx4A/T40oK8uTCij+mkv4zA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BWwGML3g/r4wcFVLMnpxLiNGNnQwMHk+IIV00sW2aO0GR3LuD+L8x9obCgAa1TzsG
         9NbEl1n4B+zxUwsBg+UDROqe7Bw420BtVIwCcMyzd6YzqJDR8VMIek4dBxLqA4SM3i
         Sll2xiquNlYT8am3gvyXKosTdAs16M0p/3hoCwyUURQjx+H81BohfcmrLUFEKtjIO8
         8BOwxcImz1T+gGHo6BudvM9fPVLy5FuCC03bQKYSsVLW7jlRaD+/+WxPfvT55R8+7e
         SXpYuB1OzYPw+UTRmEwd3PFworcfaX4M7LO3M6/WJNQgDTN5cci9xxA6DiYhogENZn
         wiGRxdthiJ5Qw==
Received: by mail-ot1-f42.google.com with SMTP id o19-20020a9d22130000b02901bfa5b79e18so16148957ota.0;
        Mon, 22 Mar 2021 07:38:17 -0700 (PDT)
X-Gm-Message-State: AOAM532emE5Vj9dvr2hhc0JnxNIvB7RiWp/IQrQh37biQxXV9jwIQ99b
        DkjqrMQ3h2SLW8btSFaDIoUtf0DTzdLRL0/INy4=
X-Google-Smtp-Source: ABdhPJyD2TKuKk6FRxgPFeFRM5z/aHMnocQOgJEpVO8jyolW16oFTYSTTc6QNuxZg6X8/RTWR7AM9q63bBX27fdLH6M=
X-Received: by 2002:a05:6830:148c:: with SMTP id s12mr205798otq.251.1616423896385;
 Mon, 22 Mar 2021 07:38:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210322121453.653228-1-arnd@kernel.org> <YFiihvb1TLFaAZdH@unreal>
In-Reply-To: <YFiihvb1TLFaAZdH@unreal>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 22 Mar 2021 15:37:58 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2HyDPF9-=wo=Yk0k8GWqOY94obFSwpeZFCwViJzRw_8g@mail.gmail.com>
Message-ID: <CAK8P3a2HyDPF9-=wo=Yk0k8GWqOY94obFSwpeZFCwViJzRw_8g@mail.gmail.com>
Subject: Re: [PATCH net-next] [v2] misdn: avoid -Wempty-body warning
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 2:58 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> Thanks, interesting when we will delete whole drivers/isdn :)
>
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

Not any time soon I think, Harald Welte mentioned that Osmocom
still relies on mISDN.

The CAPI stuff only remains because of net/bluetooth/cmtp/ though.
I don't think there are any users, but Marcel wanted to keep cmtp
since it is not really hardware specific. We could probably move
drivers/isdn/capi/* to net/bluetooth/cmtp/ if there was a good reason.

         Arnd
