Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7E23171F1
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 22:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbhBJVG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 16:06:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbhBJVGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 16:06:23 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827AFC061756
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 13:05:43 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id z21so2086400iob.7
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 13:05:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0FgD1PFQsuSujnf2F1L1dl6JiMRhMnUyjoUYKNm3iks=;
        b=XvIryJIaUQXzqFDaHJl7gM6/xKHnvm75MXs3+waP5hvDT9bMOqp63ZH80Kdb/guhJ8
         zyPZMsXzYAAXzPWcJnlIrHH011T7w5AqpzPz+zs2aR2TkQYeRHVCiVfLi+osAZtnKPs/
         t+xLKv8uwwtwVYDtpMj7YakWPuEl8hQOAJ4LOo9N6iuVF3Y41yAmEjHUXlAjzFGdLPLr
         VWG1eKex5LNVA8RC49NUAoC05oM/O0zFaYAn3e+QVZixKHs/zUJdlFicGRBo5Elivdvp
         PGP4v9CX+4uAaRIbDHWVhUmgSRTI5/mxhz9EDNnEeHSo4QiqRmANq/3ySc0Afgb90/7B
         wzwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0FgD1PFQsuSujnf2F1L1dl6JiMRhMnUyjoUYKNm3iks=;
        b=pjZIPYOxsu9O1OKa5OeRT6r5mPzQjjSwARhjIeaMdgsfuZrU2JA7Svxm37tPU8bDQO
         4x0KGC8VDi7XykwbQAeT2+IHOpvcohaGtQisUiJQFjxYHkY7ZigaXBYx6b5Mo8VKl2H3
         V1TIRlcAFpPVxN+HhxO6K6+pUZHc9zYK2DP/4/wVp9uPwCTisefs86/9PfGFV45J1t94
         mzIG+fktqMBFxJF4RXM2a2CePl0mwD03wScFo78RiqZTUt5crgfsi3ghg6P1/HosYXKu
         JZaBMVlxPINkvsky9hqUFTMp2I6BiZ/FPjSqcFxuAFOOv1gJRvw0nCxk2imZX+3e34+R
         p/Kw==
X-Gm-Message-State: AOAM532gQNK+uRYNQP9g2fNnOwK/Q0+T7RGK5Ce0grZhTKHJNK96bQFn
        ov2nD/315xoylcNhPYPKoVH/FTd1v1q4oMD/48c=
X-Google-Smtp-Source: ABdhPJyF1eTLEvzelq4NdHWSoYVMXF3saS72lc0Ee4vfBkBkf+AJuSExgyQpMUeotwYo6geAVzXepER7epIoPHatOO8=
X-Received: by 2002:a6b:d007:: with SMTP id x7mr2581412ioa.88.1612991142941;
 Wed, 10 Feb 2021 13:05:42 -0800 (PST)
MIME-Version: 1.0
References: <20210210204333.729603-1-razor@blackwall.org>
In-Reply-To: <20210210204333.729603-1-razor@blackwall.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 10 Feb 2021 13:05:32 -0800
Message-ID: <CAKgT0UecsEG8C=U8A8iFQNBMsKU_ZLESz+4p6xQXc4+w=Bcp2Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/3] bonding: 3ad: support for 200G/400G ports
 and more verbose warning
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     Netdev <netdev@vger.kernel.org>, roopa@nvidia.com,
        Andy Gospodarek <andy@greyhouse.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, idosch@nvidia.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 12:43 PM Nikolay Aleksandrov
<razor@blackwall.org> wrote:
>
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
>
> Hi,
> We'd like to have proper 200G and 400G support with 3ad bond mode, so we
> need to add new definitions for them in order to have separate oper keys,
> aggregated bandwidth and proper operation (patches 01 and 02). In
> patch 03 Ido changes the code to use pr_err_once instead of
> pr_warn_once which would help future detection of unsupported speeds.
>
> v2: patch 03: use pr_err_once instead of WARN_ONCE
>
> Thanks,
>  Nik
>
> Ido Schimmel (1):
>   bonding: 3ad: Print an error for unknown speeds
>
> Nikolay Aleksandrov (2):
>   bonding: 3ad: add support for 200G speed
>   bonding: 3ad: add support for 400G speed
>
>  drivers/net/bonding/bond_3ad.c | 26 ++++++++++++++++++++++----
>  1 file changed, 22 insertions(+), 4 deletions(-)
>

With this update the series looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
