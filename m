Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3542CDDA5
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 19:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731641AbgLCS2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 13:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728893AbgLCS2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 13:28:50 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6663C061A4E;
        Thu,  3 Dec 2020 10:28:04 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id s21so1835767pfu.13;
        Thu, 03 Dec 2020 10:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SePawBc92qjZrhhuqEGXpjzYBRM23iXEFSpAUGOVHFw=;
        b=THpnI2SehSyLp53MHiiUv28kK7Xk+w4pwJZKYx1XceULvW/bVtAMRRpOPj/ltqv+CW
         YriEUMakGBcLB/E7B6abZM0ckKlprIqm1FPJHiPBN64DK4kwnO8FVY3rByhEvpF20Euz
         Osf87po7s/ui13IvKl6TV/dyUOJfVYNjFF+CBLmRis2Ii/UyoaGDVK0lxnsHMp8luk42
         I9Eey69rWYlfyk4rYdfguESF3zDfZGvYhL4rkr4wM3jxbUWVY733foCMqrBcQMEpmwVr
         5FtLwu55tWFlDzhmCfrDRN3abjlwDwTRDUpLkTg5jy3Ur2VHSIuujRupc2+Mf/4neY7g
         nwAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SePawBc92qjZrhhuqEGXpjzYBRM23iXEFSpAUGOVHFw=;
        b=lvqpw5uzXDB8mdqK/Zvjj+V3vmQ1rmZMfHBA0gf+KJn0Ig3Su8OmwKqMp+6WFoOTKq
         O7mEEv29kGTUHoyK6GDJFETbXI93rkm4FiFJcYKhY+DHYwyPinDZAVNswM3xK/V3lhQu
         cDbSN8+oKug3knw7ZTeBoGXqqpPOL6z1FoG+3J5cuh/No4Iuxu/aJI5i46Voq6OylE6e
         VuNELZTguk4lr8vKmJF2r5kItllNvbRwYyvC3g80lX5iZ5wck5eVjFfqCy8KgKv3k9Ec
         541Yb9H3RJa7oEXV+31GcQyc7p7v7DaNRgfWAgJ1kzcgT35GULbNVEMbuNGhRZFe59Aj
         dR+g==
X-Gm-Message-State: AOAM533fu+zxDMMnYbFQpf30mMfxPozykM6428AuQPruy+/NMq3pPPid
        frkx9KSCVleHNuL87jTQnKWWQrrsipmsvhzOPJMy5nFJIzA7ng==
X-Google-Smtp-Source: ABdhPJzmQ/gQ9leIvSLr4xXLgDINcplXNAFS21D559/T2GLR6mUab0sTLuc+f3BrAey4fdVknkUEQRTdX/wt8sCBJMg=
X-Received: by 2002:a63:2d86:: with SMTP id t128mr4205743pgt.5.1607020084137;
 Thu, 03 Dec 2020 10:28:04 -0800 (PST)
MIME-Version: 1.0
References: <20201201194438.37402-1-xiyou.wangcong@gmail.com>
 <20201202171032.029b1cd8@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CAM_iQpWfv59MoEJES1O=FhA4YsrB2nNGGaKzDmqcmXQXzc8gow@mail.gmail.com>
 <CAADnVQK74XFuK6ybYeqdw1qNt2ZDi-HbrgMxeem46Uh-76sX7Q@mail.gmail.com> <CAADnVQ+tRAKn4KR_k9eU-fG3iQhivzwn6d2BDGnX_44MTBrkJg@mail.gmail.com>
In-Reply-To: <CAADnVQ+tRAKn4KR_k9eU-fG3iQhivzwn6d2BDGnX_44MTBrkJg@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 3 Dec 2020 10:27:53 -0800
Message-ID: <CAM_iQpUUnsRuFs=uRA2uc8RZVakBXCA7efbs702Pj54p8Q==ig@mail.gmail.com>
Subject: Re: [Patch net] lwt: disable BH too in run_lwt_bpf()
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Dongdong Wang <wangdongdong@bytedance.com>,
        Thomas Graf <tgraf@suug.ch>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 3, 2020 at 10:22 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> I guess my previous comment could be misinterpreted.
> Cong,
> please respin with changing preempt_disable to migrate_disable
> and adding local_bh_disable.

I have no objection, just want to point out migrate_disable() may
not exist if we backport this further to -stable, this helper was
introduced in Feb 2020.

Thanks.
