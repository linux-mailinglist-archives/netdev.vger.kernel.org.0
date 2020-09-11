Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC47B26769A
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 01:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgIKXuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 19:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgIKXt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 19:49:56 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE06C061757;
        Fri, 11 Sep 2020 16:49:56 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id u9so1619324plk.4;
        Fri, 11 Sep 2020 16:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rt+55nXRvRqx+TxX15f4EGtqJmhA60cmwT62AcecY9E=;
        b=vK3KvwbNoqKoe96uvuCnLN3NZtSjGFciofAQaOxm1NUWyzbAB7vlaaiTjy1LqHB2go
         wkBilXLk48Fv631ctlZK7Q0a/lzTAhj29swL3WCaJRryf5P2LTanZTFtPVT6K2G6mf/f
         +FFUUkiDko6ffO1ihBp/hlkv2IwqYg7sTLP+O5OwqdDE3CK5DV0+FLmaHmRzvvRC6pEn
         utWM+MsA9Bh7Nsas/M1aAFHOwma0LxG4SMJeNY5htse+UpYM33RC+NmWbMPTBN0SV0wV
         CgsAwTwlEBAS4kl8BZ+9r8+T8IZMoLogRAJS2fcY3lWMK27dFU2++50VpIJvQUjPSBDD
         3sEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rt+55nXRvRqx+TxX15f4EGtqJmhA60cmwT62AcecY9E=;
        b=JuW0SLyXBuRep9simwCrYROJAJbACm/BW4WVUL9VJ4+iv3pD0VQW6nW/5DkkvKMCZO
         aC7gYQnffkuqJ3IA1+dNN22/5jeNfBW8n/pQbbuRByubtNtczrAvZrI2zKHLRol43FFz
         bxyXq8VDbIBmmYeRD9MEkYnlzDRxnVJQcqhGceHBxW6IdVacPD2cKxDb3yKhTDRLmQwk
         cgIL1VinS/J0ruqqZBJ/zzH/sNCxLDZlAetxOYPN4dZTO3foXyfrV4ogJGUnHAJ6GY2R
         Dj1XIicUEsgKI8J/x83jhdY1OoGZ7WsL5SwOyXD3H5Tm7pWsfe25uZBpamotWUfzZIlO
         m6rw==
X-Gm-Message-State: AOAM530u4nYdfBYCXMGGvs0gvyJjnQLZF9z+eDO+fyBfh74UGO3wfzuu
        rLHdDcqucDT9ZAw+sRm4+dT4KMD2ONe4zlMoYR8=
X-Google-Smtp-Source: ABdhPJy6wClFFo3A4Wj6LOAKbfYxZ8E4oi8FsI+d7Iu6kK8nXw7kkcoxB3Y9lalf0FZj7ysuCH6lPdt3/LpCgiIIgUs=
X-Received: by 2002:a17:902:b218:: with SMTP id t24mr4299671plr.113.1599868196057;
 Fri, 11 Sep 2020 16:49:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200911063503.152765-1-xie.he.0141@gmail.com> <20200911.144436.1790085156026689841.davem@davemloft.net>
In-Reply-To: <20200911.144436.1790085156026689841.davem@davemloft.net>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 11 Sep 2020 16:49:45 -0700
Message-ID: <CAJht_EPZdsgO9SEtgxRMTcGj5z0xJVp-LOTiU0wH41rLLfG+EA@mail.gmail.com>
Subject: Re: [PATCH net-next] drivers/net/wan/x25_asy: Remove an unused flag "SLF_OUTWAIT"
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 2:44 PM David Miller <davem@davemloft.net> wrote:
>
> From: Xie He <xie.he.0141@gmail.com>
> Date: Thu, 10 Sep 2020 23:35:03 -0700
>
> > The "SLF_OUTWAIT" flag defined in x25_asy.h is not actually used.
> > It is only cleared at one place in x25_asy.c but is never read or set.
> > So we can remove it.
> >
> > Signed-off-by: Xie He <xie.he.0141@gmail.com>
>
> Applied, it looks like this code wss based upon the slip.c code.

Oh! You are right! I can finally understand now why there are so many
things named "sl" in this file.
