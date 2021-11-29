Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3E4462269
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 21:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbhK2UtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 15:49:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33176 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbhK2UqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 15:46:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13150B815C3;
        Mon, 29 Nov 2021 20:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2D8C53FAD;
        Mon, 29 Nov 2021 20:43:03 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Hg0vCt6X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1638218580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IJIFhS7Gja0XaaDFazkxYZETJH7tXgLIebmHSwoi8oo=;
        b=Hg0vCt6X79iev1W7geLEXoIo7QUBjeIcrY4BU/rJH0FK5yI/wpvv8SyOCzHsgBm3SwIMN2
        VuFfFsgc7vkIvCXKAoeLyyVf7lNL/uwKwbfUkj1y7sFgNeJ+ZOjs7BKnTijzUMlXyQacv7
        I2yhmyovqbPXREBuGXyqlgLyOX9w/4o=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e9ebbd53 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 29 Nov 2021 20:43:00 +0000 (UTC)
Received: by mail-yb1-f180.google.com with SMTP id f186so45923634ybg.2;
        Mon, 29 Nov 2021 12:42:59 -0800 (PST)
X-Gm-Message-State: AOAM533UwjdPTXlV9lJfuen4ppAA7CerfWR0w0saazewc1sYp3Cu/NcL
        x1nlgTuWNZCxNdGSsPgSLTLYmRsNPYRReXV/CwM=
X-Google-Smtp-Source: ABdhPJyNzMvBiN8v0r3Ekoh8241Jcgl08VrNs/W0bi2/lgYBzo95/gIflWYXRIGTuQNr9JKeK1lAWjoDfaqZ/ZZadIs=
X-Received: by 2002:a25:a427:: with SMTP id f36mr37202220ybi.245.1638218578645;
 Mon, 29 Nov 2021 12:42:58 -0800 (PST)
MIME-Version: 1.0
References: <20211130073228.611fa87f@canb.auug.org.au>
In-Reply-To: <20211130073228.611fa87f@canb.auug.org.au>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 29 Nov 2021 15:42:47 -0500
X-Gmail-Original-Message-ID: <CAHmME9qSBPQ98nOy_xkjeHfJ9mCm4JWbWQTx3M6wB21YHrzjBg@mail.gmail.com>
Message-ID: <CAHmME9qSBPQ98nOy_xkjeHfJ9mCm4JWbWQTx3M6wB21YHrzjBg@mail.gmail.com>
Subject: Re: linux-next: Signed-off-by missing for commit in the net tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        msizanoen1 <msizanoen@qtmlabs.xyz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

This is known. Please see the below-the-break comment in the original
patch submission:

https://lore.kernel.org/netdev/20211123124832.15419-1-Jason@zx2c4.com/

> The original author of this commit and commit message is anonymous and
> is therefore unable to sign off on it. Greg suggested that I do the sign
> off, extracting it from the bugzilla entry above, and post it properly.
> The patch "seems to work" on first glance, but I haven't looked deeply
> at it yet and therefore it doesn't have my Reviewed-by, even though I'm
> submitting this patch on the author's behalf. And it should probably get
> a good look from the v6 fib folks. The original author should be on this
> thread to address issues that come off, and I'll shephard additional
> versions that he has.

Jason
