Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECA22B1682
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 08:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgKMHds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 02:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgKMHdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 02:33:46 -0500
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AE4C0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 23:33:46 -0800 (PST)
Received: by mail-oo1-xc36.google.com with SMTP id y3so1952457ooq.2
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 23:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v3WcCdaHYOQQZJH1aMQoM0oyWC0gSEUn6WiHpGeSdoQ=;
        b=Oh4QX9phUzzK1+RLrbOdpWTCe2vOUNe9F1YYskHWe6kg0H0p2BhPE2aCBLplRwJgQi
         wZh/TCBELVW4PHkXk52e4q+2CYbvM1rgJy3xqsnH+GbLT25cWvco+8mJTMMhQAQ7Phed
         9hcderDCyh8BevRfXYnfM8EBX/Ykl/97iyqLjpisUfvSa08CwFGd38UXETbHPq2gx6jm
         skupsCYb1z4MeYgTmS6hPLeYO8PxynTKBgRAyZiIStll3uxUHJWT2AGej9kIJdp5VcIr
         nW/6qN/vvWdKdPTq/Z2tvve6D1Oha4NuaUoSQ7R4pvS4u9CziT1jxknl5ggZBr9lz/Tx
         yIhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v3WcCdaHYOQQZJH1aMQoM0oyWC0gSEUn6WiHpGeSdoQ=;
        b=Z0jZeTu2khk8yu6nWJhJye4ZRqZLPbG0MD6NWFMKDWaMlNJNAbHZDAYss96b0xaG8i
         6/vArRoXOMWOsWGNTcccIu3Cc1+qcrTXIb0mvUNJPusUDJ9P3MpZHMpwjqgupDXSPp0j
         okweYvYcPNl1H1qdvI9GnpVNQ7CsIb5OKYMJcmjFEKJltpVVOlsWW/wC/233Pzt9f85B
         XCK/lhhxyXxeydxVXgdPr2DeUJKRX+OxkbqgEv0kOerjsl75DwgZqw79IkFiwM5QDMGX
         0ZUCH2AlQlOjjMROC+tF1BIu6tJszNqDLi1Xts5HIantPVITj9hC2OaRfRPBkpHpgIQf
         ZPMQ==
X-Gm-Message-State: AOAM531hkvk3ELmes7JrN7Z/j/UBpHk18bEZ+R2yVW3G8XxfF4Zs6TyZ
        5TloeCocMZVrmtzrdL595nCcVp5rXUXJ+kfoF92iFx0fAfw=
X-Google-Smtp-Source: ABdhPJzp/Fg6Gu7s3rj2mxUdnVAQRjrPaXaredyKUMsXY0SsXy+M/oI7KhMSQYcYPGVJOCOpeHoIlm2iiLluaBT7LeU=
X-Received: by 2002:a4a:5182:: with SMTP id s124mr594758ooa.88.1605252826061;
 Thu, 12 Nov 2020 23:33:46 -0800 (PST)
MIME-Version: 1.0
References: <CAMeyCbh8vSCnr-9-odi0kg3E8BGCiETOL-jJ650qYQdsY0wxeA@mail.gmail.com>
 <CAMeyCbjuj2Q2riK2yzKXRfCa_mKToqe0uPXKxrjd6zJQWaXxog@mail.gmail.com>
 <3f069322-f22a-a2e8-1498-0a979e02b595@gmail.com> <739b43c5c77448c0ab9e8efadd33dbfb@AcuMS.aculab.com>
In-Reply-To: <739b43c5c77448c0ab9e8efadd33dbfb@AcuMS.aculab.com>
From:   Kegl Rohit <keglrohit@gmail.com>
Date:   Fri, 13 Nov 2020 08:33:36 +0100
Message-ID: <CAMeyCbj4aVRtVQfzKmHvhUkzh08PqNs2DHS1nobbx0nR4LoXbg@mail.gmail.com>
Subject: Re: Fwd: net: fec: rx descriptor ring out of order
To:     David Laight <David.Laight@aculab.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> What are the addresses of the ring entries?
> I bet there is something wrong with the cache coherency and/or
> flushing.
>
> So the MAC hardware has done the write but (somewhere) it
> isn't visible to the cpu for ages.

CMA memory is disabled in our kernel config.
So the descriptors allocated with dma_alloc_coherent() won't be CMA memory.
Could this cause a different caching/flushing behaviour?

> I've seen a 'fec' ethernet block in a freescale DSP.
> IIRC it is a fairly simple block - won't be doing out-of-order writes.
>
> The imx6q seems to be arm based.
> I'm guessing that means it doesn't do cache coherency for ethernet dma
> accesses.
> That (more or less) means the rings need to be mapped uncached.
> Any attempt to just flush/invalidate the cache lines is doomed.
>
> ...

> > > I could only think of skipping/dropping the descriptor when the
> > > current is still busy but the next one is ready.
> > > But it is not easily possible because the "stuck" descriptor gets
> > > ready after a huge delay.
>
> I bet the descriptor is at the end of a cache line which finally
> gets re-read.
I stumbled across FEC ethernet issues [Was: PL310 errata workarounds]
https://www.spinics.net/lists/arm-kernel/thrd312.html#315574.
Changes to the PL310 cache driver (used in imx6q) were made, to also
fix fec issues.
This PL310 cleanup/fixes are not contained in the 3.10.108 kernel.
So maybe i have to look also there.
