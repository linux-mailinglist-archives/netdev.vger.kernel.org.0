Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642553C36C7
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 22:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhGJUfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 16:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhGJUfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 16:35:16 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4DAC0613DD
        for <netdev@vger.kernel.org>; Sat, 10 Jul 2021 13:32:31 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id m83so4538236pfd.0
        for <netdev@vger.kernel.org>; Sat, 10 Jul 2021 13:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sL61vUB/PehkKkCSa/Fn/0uL70Pu7mLqTzvYlVhHxq0=;
        b=yQoN3k13dbQ5sc1HDipeOiL7q+kwDagu+F/2JmHX79AbOYs+5hjnxVn0caMETbiA8Q
         nXRqQgNhVHu6nfu1YCYRO/YsnevorUMu9Nl0SJf4IJHN+WkT35KWfu736DHaJvQ2jnKq
         EiwXv1QmkEP9DpZyLe+FKl1TTpqfeqQvXyDAooWZbgbKPkZGoSR34+wIW5tbTOzBO8hC
         olWCXY8WcKvzXcmr1wKIP//JfI1p1tAADEnww7PQdFvLh1jXWEnrSIF2aF/fSqsnwbYx
         1WvQ3/BsHwgZrexYb8ipNEvS0l72HnnpyZyIn51MXKtyqdzVtGg4+LsVud3EvrHBskU0
         k5Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sL61vUB/PehkKkCSa/Fn/0uL70Pu7mLqTzvYlVhHxq0=;
        b=ubk8J8KauD07qEHCCiZadjzfvel7+ZT39PQcwyU5UgfWbxRJ6bslL5cPLfguYcKd9V
         mP56IKr3ANYiUTQ+NXWclPpLyO4X7lDsHJSQXTXaNkR6nJYWvwS/eC+Rq1gr3u9UtVHv
         aeDaqHiQ6mUoF+uA0Sfhi4rMTQznwr8unDtBgFZ5E+D9JfrwbhlGxD2skFGDK++cKIgN
         8nUc+MTlkvPgZW2h5F3TsWcw58pRzIF1Ljd8yGTA4M5dWQ4e3yttJ4GLHz7q46Yql72H
         YiCA07ISwoPlZbqvb8/5m3EFEM9EZBZO9OnSFdO8Cta8tWNa2DQJ4lCyRX2Bj25lGZaj
         2MEQ==
X-Gm-Message-State: AOAM53044AiqnXWUPtZ52M/1dLcr83v1KEt7tDtA5a5RlWfcJ3BUR4oo
        7HfuihWKHVJ+34U9J64bVL4Hkg==
X-Google-Smtp-Source: ABdhPJxbnZad34gHtIG8Xclp9DZ7GprOe+4Rf4Xgg/2ZAMyY3YbFOAocNRXkgZc7ExJuPLP/GSJBxw==
X-Received: by 2002:a62:2bc6:0:b029:2cc:242f:ab69 with SMTP id r189-20020a622bc60000b02902cc242fab69mr45153141pfr.16.1625949150002;
        Sat, 10 Jul 2021 13:32:30 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id z6sm2627697pjn.12.2021.07.10.13.32.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 13:32:29 -0700 (PDT)
Date:   Sat, 10 Jul 2021 13:32:27 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Dave Taht <dave.taht@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Jian Shen <shenjian15@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linuxarm@openeuler.org
Subject: Re: [RFC net-next] net: extend netdev features
Message-ID: <20210710133227.348899f8@hermes.local>
In-Reply-To: <CAA93jw4uhezgu05uM2xohoPMbDvbMAVmivSf2wgPiO4OzScwRg@mail.gmail.com>
References: <1625910047-56840-1-git-send-email-shenjian15@huawei.com>
        <20210710081120.5570fb87@hermes.local>
        <YOm5wgVv7PGx9AYi@lunn.ch>
        <CAA93jw4uhezgu05uM2xohoPMbDvbMAVmivSf2wgPiO4OzScwRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Jul 2021 08:35:52 -0700
Dave Taht <dave.taht@gmail.com> wrote:

> On Sat, Jul 10, 2021 at 8:18 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >  
> > > Infrastructure changes must be done as part of the patch that
> > > needs the new feature bit. It might be that your feature bit is
> > > not accepted as part of the review cycle, or a better alternative
> > > is proposed.  
> >
> > Hi Stephan
> >
> > I agree with what you are saying, but i also think there is no way to
> > avoid needing more feature bits. So even if the new feature bit itself
> > is rejected, the code to allow it could be useful.  
> 
> I would rather passionately like to expand several old currently 16
> bit fields in tc and iptables to 32 bits,
> and break the 1000 user limitation we have in things like this:
> 
> https://github.com/rchac/LibreQoS

Unfortunately, no one has stepped up to the heavy lifting of having a UAPI
compatibility layer for this.
