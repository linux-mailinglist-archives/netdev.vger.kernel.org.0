Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7311C3EBC8C
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 21:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbhHMTcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 15:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233819AbhHMTbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 15:31:55 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33513C0617AD;
        Fri, 13 Aug 2021 12:31:28 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso3151159pjh.5;
        Fri, 13 Aug 2021 12:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a+GmmgQMKyKL/dZvxG77oan3Yn+drH1Q9i6epzU+uNk=;
        b=MCFwyL7wafM5hyhVNQGizvhjP5SyNCsFqVFb4MGrZYf2tpqzxWLr0VQ8tTajcaHJmb
         GM8ZXtvhR1ycIEGLZxEpBh/CbZ5XGZwZ4tHi/iU/+O0/zgHJL1pNnjNATlFTYiD7gMpH
         hZwvorVlWvSGqoFpEKU75UBpzq2wdk8xe8NSZ+vqpKYbm8fAmG8g8vmmZGYtl/KyKUzI
         XSxSE5lSqDpJdF0xA1Nr094wMGKmZcBd/FqMFUWSZ4Msvr0RMWQb8W0NEUcekZ1N+5oa
         7ug2zc2KBFDCrwmeiP096zlpengxNhBxgMeryWOxnw3s8WLEpmPiEVtcHiN3njFZ/CC2
         NoAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a+GmmgQMKyKL/dZvxG77oan3Yn+drH1Q9i6epzU+uNk=;
        b=O9+S9DOr6u2Qfmg/b23zEuogUNAEkamsQtvq74LaJYWBJsimz/E1SNmYTeOrrr6fy2
         DRx4j/7P7vscezJ+YNrTpnftjkGoo2MYM81W+P8o1vUKSVG2S2UH0EkfnxRH89Bkfm+/
         jOkwwE27KbkwvNVML/1CsGdUBfLqN0Zw0X7A3lKH2RSpbZ8uewffCnOoDUOMHpZJMueg
         kxM7QDpjcpcMtDEWbZczxzh7HLcGROUFVgb2NG4SgvOiuie+YmsabHAz82v2mIhggz/9
         RtDniC8Bsl7K1uyzJcMSZVDdn007kkKqvFV6djOspfNWffZ4KkglG+YQMnuVh24/nmD6
         R9Dw==
X-Gm-Message-State: AOAM533dBHZrEsPqN7BybJWrbER+q9xD4jV2bTBpCE9fSyo434ggg6Ty
        VHFZA6FjEebhKgBFcVmRqVYqALbNuPbrPegtGAQ=
X-Google-Smtp-Source: ABdhPJz18f28FOPMFGtTv8rubCb8fsqWjm/ZquJ2jDh6VbI+WMIfTtpX5rc6Z0Uy3LhaLI4s5EUEDgf1AZzWDjdTlPo=
X-Received: by 2002:a17:90a:cf18:: with SMTP id h24mr4049241pju.228.1628883087750;
 Fri, 13 Aug 2021 12:31:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210813122737.45860-1-andriy.shevchenko@linux.intel.com> <20210813111407.0c2288f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210813111407.0c2288f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 13 Aug 2021 22:30:51 +0300
Message-ID: <CAHp75VeEO+givZ_SvUc2Wu7=iKvoqJEWYnMD=RHZCxKhqsV-9Q@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 1/3] ptp_ocp: Switch to use
 module_pci_driver() macro
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 9:15 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 13 Aug 2021 15:27:35 +0300 Andy Shevchenko wrote:
> > Eliminate some boilerplate code by using module_pci_driver() instead of
> > init/exit, and, if needed, moving the salient bits from init into probe.
> >
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>
> Jonathan has a series in flight which is fixing some of the same issues:
> https://patchwork.kernel.org/project/netdevbpf/list/?series=530079&state=*
>
> Please hold off for a day or two so it can get merged, and if you don't
> mind double check at that point which of your patches are still needed.

Actually it may be the other way around. Since patch 2 in his series
is definitely an unneeded churn here, because my devm conversion will
have to effectively revert it.


> According to patchwork your series does not apply to net-next as of
> last night so it'll need a respin anyway.

I hope he will chime in and see what we can do the best.


-- 
With Best Regards,
Andy Shevchenko
