Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70BB29D3D1
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgJ1VnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgJ1VnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:43:22 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C231C0613CF;
        Wed, 28 Oct 2020 14:43:22 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id x7so991876ili.5;
        Wed, 28 Oct 2020 14:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ozYCZRgZqvrBNZwSGWpcjHZ/UebLYVQ2msLNU5VY5Mo=;
        b=uoRMTe+GToyjDoY9/GaktCa1BeSuPzVAR3/boLPppUGl2qn34CK74mw2rIzAvM3ugD
         SQ2p3aZO5PqkKhiOBdyBW8DBlPIF/Tcc6+83P3KSglxaTdhTl9wHL0mu6LpQJ/aNPYGk
         /aDeRn5tXPMYv6ZrqEqshKEqAMefYDA42I2NAyiczmdob/fE6/C17lTpYjIm3i2nHFub
         K7djTFNomWxGyjgJgYaExtWgiUrXfPoe1d3WFjoYg76WLdF5US+sBtUNs/orjJRmkjIT
         oyE1avb6xQqwp/xtMx5iZ1T0D8ckNdMumCO27aucVma7HiOGSBhpTihnODBRV/SORZ9K
         jh4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ozYCZRgZqvrBNZwSGWpcjHZ/UebLYVQ2msLNU5VY5Mo=;
        b=JxiQeAP6dvKB85JUPFPrcNEDA2w0x8x3+OoV1zVhk3OFgiN+igbqgPCM6VO5rMJ2pY
         5cMiamFbi0oxjAGWfd75bfGxVHPREYxK1XYZQzosiuyvZa4bRDFhqtfKsuABTuGXEXKq
         9WaVFjP3YYPHPKG16GALTn1NYr8sM4zlPSaYsnVTQKmKjNl31gPnhyEZa/8QrwGqiYUm
         kdnx7dxsdr50YWGgHza0XfWAnEYkog/8st5SyxXdUh3TRTPZwx1Ri+Gydlu7fKHQ6H9/
         7brvmOtfGEJi7kTWB/I2rBN6iJleGg4nKNLf5Pwo1AhMbg56Jt885BeFkZtRy6IzI9e5
         mK3g==
X-Gm-Message-State: AOAM531odQqRjfVAq2JbSpUTAK7bU3Q1aoJobGsLdWzcg/X1lX1jM2kb
        w14L/WrETjLK8IZ65tH/ONhVCS8SVAbm7hIW6cwfcVK0zUwiFA==
X-Google-Smtp-Source: ABdhPJwBVHlD8D4vAAXos2Nzvs1/eRlOYVtS1b+L4Ik0PIOGENFpsUsLpxj2nAxw9y6dHLnM6j3+R7WB5l0ZfZPRLMc=
X-Received: by 2002:a92:c04c:: with SMTP id o12mr171588ilf.22.1603906736261;
 Wed, 28 Oct 2020 10:38:56 -0700 (PDT)
MIME-Version: 1.0
References: <20201028113533.26160-1-lukas.bulwahn@gmail.com> <d956a5a5-c064-3fd4-5e78-809638ba14ef@redhat.com>
In-Reply-To: <d956a5a5-c064-3fd4-5e78-809638ba14ef@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 28 Oct 2020 10:38:45 -0700
Message-ID: <CAM_iQpUfE2f3QBFY6r0_D2mzFK_SsmFXdA-1p3h7yquM8912fg@mail.gmail.com>
Subject: Re: [PATCH] net: cls_api: remove unneeded local variable in tc_dump_chain()
To:     Tom Rix <trix@redhat.com>
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, linux-safety@lists.elisa.tech
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 6:59 AM Tom Rix <trix@redhat.com> wrote:
>
>
> On 10/28/20 4:35 AM, Lukas Bulwahn wrote:
> > @@ -2971,13 +2963,11 @@ static int tc_dump_chain(struct sk_buff *skb, struct netlink_callback *cb)
> >               if (!dev)
> >                       return skb->len;
> >
> > -             parent = tcm->tcm_parent;
> > -             if (!parent) {
> > +             if (!tcm->tcm_parent)
> >                       q = dev->qdisc;
> > -                     parent = q->handle;
>
> This looks like a an unused error handler.
>
> and the later call to
>
> if (TC_H_MIN(tcm->tcm_parent)
>
> maybe should be
>
> if (TC_H_MIN(parent))

When tcm->tcm_parent is 0, TC_H_MIN(tcm->tcm_parent) is also 0,
so we will not hit that if branch.

So, I think Lukas' patch is correct.

Thanks.
