Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16AA6431768
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 13:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhJRLfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 07:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbhJRLfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 07:35:16 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A6FC06161C;
        Mon, 18 Oct 2021 04:33:05 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id b188so10893696iof.8;
        Mon, 18 Oct 2021 04:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E7ifO5BVPgOaaNdJsY38xuA6JsGENgZFJ6DdNp9B7wI=;
        b=ENJ2zN3PxW0z7Kh5XQhf9ew/rE6C/uB8Go5bnJl+x8nGzFLQdfrHYS7cUGSTueUSEG
         f2KJDYcc/fDrxUEU00wkp5KV8HlMi68pJHLSam9/+iclrMZFvrxwfDCMtR7qmZjVzHOw
         Nr3tNUtLy1lJHcIFnrdtfZlEPpYk34LtIFrMrwxkQnmFs/EdwejchZ/AcgNzspH3JwY8
         YOCExRgN5CgIvKA5GQ7FR3Je0JcRtqKMBHwRxfN6WMy0NRssPRrUwgpdgGhCIKkoXk3o
         psUieB91kllLiLkrq+HfyP91iPYwZ73L04WxKhg63ZldQVaV7vY6y8g9hSkOXCFYY440
         LrVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E7ifO5BVPgOaaNdJsY38xuA6JsGENgZFJ6DdNp9B7wI=;
        b=O6SfxsDE3O6dqzEPosmANVZMkl46aECSTIEuoxcNZf6GzM6giMmR5k11VVa9DBAFAP
         MF3jEVXAFFmQFNrMGvFzj6ONMN7jyS/Rj15sQASwD1pxjVsgaFzBcZyKpkLdm/yDA5M6
         4rs6R2WxXP1RKYHd90+czZn5J37mKRJoECdwDycmsv6qD+JApg1yRJja36WSnZsPdbUK
         MKuWI+R2MRcJ01nlSVrYQE4Xb1jTfg/pAfTfU1ldJdXREf4wmuY1F5AWhoTLDg+Ygldz
         orgKkNUkAqMY4pDlDlcBrN1kU84nLK2mf6o32+DPSm/Aq2vF0Gp01VTPsUr42vgfUrez
         RKOQ==
X-Gm-Message-State: AOAM531WqGI5DguYaBwNoloZFNmJpi0utanpCmbvlxHxrk2OBhb9CDBa
        WwN8IOsrDiD3337nddtj5FcXHpUyKmMGSRVhAU0=
X-Google-Smtp-Source: ABdhPJxFgtvgU3knHtiUQXMNalkS0mgyH/u1KxHLmjWwMqIDNUSuvJzt2siSzEozgXUzHwELOXILvCfbq0791S+CgJ8=
X-Received: by 2002:a05:6602:2d4e:: with SMTP id d14mr14339267iow.172.1634556785457;
 Mon, 18 Oct 2021 04:33:05 -0700 (PDT)
MIME-Version: 1.0
References: <20211018155113.1303fa5e@canb.auug.org.au>
In-Reply-To: <20211018155113.1303fa5e@canb.auug.org.au>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Mon, 18 Oct 2021 13:32:54 +0200
Message-ID: <CANiq72mOMtY+jC7hU92cpdRDuQSYSs3vOaJ_+9wx7NOVifmGFg@mail.gmail.com>
Subject: Re: linux-next: manual merge of the rust tree with the bpf-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Adam Bratschi-Kaye <ark.email@gmail.com>,
        Alex Gaynor <alex.gaynor@gmail.com>,
        Ayaan Zaidi <zaidi.ayaan@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Boris-Chengbiao Zhou <bobo1239@web.de>,
        Douglas Su <d0u9.su@outlook.com>, Finn Behrens <me@kloenk.de>,
        Fox Chen <foxhlchen@gmail.com>, Gary Guo <gary@garyguo.net>,
        Geoffrey Thomas <geofft@ldpreload.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Miguel Ojeda <ojeda@kernel.org>,
        Sumera Priyadarsini <sylphrenadin@gmail.com>,
        Sven Van Asbroeck <thesven73@gmail.com>,
        Wedson Almeida Filho <wedsonaf@google.com>,
        Yuki Okushi <jtitor@2k36.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 6:51 AM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

Looks correct, thanks Stephen!

I am glad you didn't have more conflicts after the rebase to v5.15-rc5.

Cheers,
Miguel
