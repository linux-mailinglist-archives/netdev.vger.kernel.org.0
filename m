Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A25267691
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 01:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgIKXao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 19:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgIKXak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 19:30:40 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7952C061573;
        Fri, 11 Sep 2020 16:30:40 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id j7so1601257plk.11;
        Fri, 11 Sep 2020 16:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bWPqtreNNvGR50JNC9uAvA3aDmdeHpNeB2iU9FqChh8=;
        b=VldpTsvsVb0yxA+TZ858ZA74K9SkObObuhPjXREJB+ose1FtXtaDD1Eq0AcvL9NUOl
         Ln/JXysaICHMMBESWpsJR3YtHTL7m7eRd8qh1RaKqcqcnZIAhNOOOnhOENlqQoBcD3Eo
         Wtmt/bjwxtv1totFfE/HTSgtejCMT3mN53SXVhv8rym1RdsUfDFVP8iIePFbvlhpwME7
         J/1cdo6JzMteoQvLddtzZswQocyDRVrccuBh25N7ZpTUIAc/aZLfF8cYNZ/GinQMaWj5
         gBCWPF40KlsZkLPK6F0/LEOkLf0cm0Knmrz/GamMv4AQSwQqeJPKSUL3WXr19D2KKouM
         XEmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bWPqtreNNvGR50JNC9uAvA3aDmdeHpNeB2iU9FqChh8=;
        b=eaTNnP477tPXr6uaRCeTMA3UhbLZFfxk2CzF58trNDa6YxeJaTG7R7sktsd+P+DHRA
         kmMI+tk0hA66Kl/7FtIOizblTBrog2JwKaeOnz0BeLHiBQTNhdcz2ofEdTFOqjh+NvkE
         CAn+McBAtiOcVwmIve8wYijpUaYokwcBVdvHX6I67d6EIc5qJgMwVTqv7L6gPPX4aC4/
         7/eK07SZUOxhfSt+xKAga37sY1M313LGo+CmkrEiQDWTIJ4+CH8O+Mz/BTiJcjd4o9MA
         tV5ucGKB5O9M2muQRNq5nFQkFGsGJ8TrxrNFqg1eQRrr0u3IU6hEALtxsvJgfldsCHE5
         rurQ==
X-Gm-Message-State: AOAM5320oE9Z/+8xpTqNqaFiBAO+YdLCkP5g4MFEmmIp9pUx6pXOl8TR
        EuIyoIfJvDwaxLf3xJWgs0A9Nn8tmpSDPAORPsI=
X-Google-Smtp-Source: ABdhPJzkgo/F5yjSPwlWMSpNNzqWY7WR/e4ufL3baCX59Xb05mLY7BM1ZNd+xqLd7fcmW24IlXXdFv1H1L1hE23Jlbs=
X-Received: by 2002:a17:90b:360a:: with SMTP id ml10mr4138240pjb.198.1599867040080;
 Fri, 11 Sep 2020 16:30:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200911060720.81033-1-xie.he.0141@gmail.com> <20200911.144121.2042949892921941512.davem@davemloft.net>
In-Reply-To: <20200911.144121.2042949892921941512.davem@davemloft.net>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 11 Sep 2020 16:30:28 -0700
Message-ID: <CAJht_EM8e_UxzVQk+NMzCaZdAj0iyFCYAYpgdo=ttrhxq=GBpg@mail.gmail.com>
Subject: Re: [PATCH net-next] net/socket.c: Remove an unused header file <linux/if_frad.h>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 2:41 PM David Miller <davem@davemloft.net> wrote:
>
> From: Xie He <xie.he.0141@gmail.com>
> Date: Thu, 10 Sep 2020 23:07:20 -0700
>
> > This header file is not actually used in this file. Let's remove it.
>
> How did you test this assertion?  As Jakub showed, the
> dlci_ioctl_set() function needs to be declared because socket.c
> references it.
>
> All of your visual scanning of the code is wasted if you don't
> do something simple like an "allmodconfig" or "allyesconfig"
> build to test whether your change is correct or not.
>
> Don't leave that step for us, that's your responsibility.
>

OK. I'm sorry for this.
