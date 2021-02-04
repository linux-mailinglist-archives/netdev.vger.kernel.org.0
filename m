Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E03130FA6E
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 18:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238742AbhBDR5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 12:57:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238600AbhBDR5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 12:57:09 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36851C0613D6;
        Thu,  4 Feb 2021 09:56:23 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id j84so4083358ybg.1;
        Thu, 04 Feb 2021 09:56:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5I40DHI/h59AkCtOXx10UCUmoyFeXFyTwT5DDhItD+s=;
        b=sQYVIXMpXitQanDKb7QPgpDnb2TJSZ9VvJGyEsEDQ1LfFxgQyMeOz7Vij2ju750L+K
         5H/8M/sQXwzXMLQcn/DvDzCWi/PHvofauix/xAMagKVrUxn639HKW7iy2wLipqKhenHE
         j2UBhZCSG+KcWRfpRSo8xb2uwrrUs1XwjFEKj0ei4s340WkvyOCvd+qEEvScyEa8X2HU
         iSnoeC3+fo7vV/j1dMopp2Z92aqMhnYVJComXEwvnxFEmWE1X4jEg0HnpnHts6i8ifbs
         kRYmgUKTdWIVd2/OhafehvjlYe1Kf3Qu6GPjN4CvSPxf06jKAkSr+fhj7/MNK2U8J+E1
         eLkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5I40DHI/h59AkCtOXx10UCUmoyFeXFyTwT5DDhItD+s=;
        b=YMZgo6w1PD6Ftuz1INE3xReGu3zfcVOvBxCywK7o7bxt5cjzTkDdV/MYqv+U+fEmxp
         p5w9Jux8qs/BNQ0YiAibcEqZCHB3qreiYFRkIh61/N9r1+PQhtnbcZqzKXT/SPNUVphn
         T2dpIvOOzH1faQ29dczYn3oC1T85ZtLzZKq/IaFhcILc6H/z/Lu/TASXhsjOkFCrWaJt
         iYHo0hm83RdZgCZ7I6RN3BlvuhAoc799DbmCz5cE4GjROnGBADjYoYkwOlXM5/OpTWhi
         uxNSUHBHi0nJ+AyPwFQCHPiiVxXOvb+5/Cp8/bsEQ86BlW/xr8BWClkh3aptF+WDQAZc
         1oVA==
X-Gm-Message-State: AOAM530Gp/ugyLP0MwFrgTv5OugRr9b1aXLw0r1x7VCafJZWrEPq1SPm
        prJHmnYSvfOf5meZPCeRFmZzqLixm15wgfmqDnw=
X-Google-Smtp-Source: ABdhPJxRhWC5NXV5JEwvpeirQWFd4d1jO969HaFhJMvCmJoiKJN53VaDPC9gdMOgfDY66tag+jQ5od8h4l/1G1xtlOM=
X-Received: by 2002:a25:6c08:: with SMTP id h8mr454596ybc.499.1612461382582;
 Thu, 04 Feb 2021 09:56:22 -0800 (PST)
MIME-Version: 1.0
References: <20210204171942.469883-1-brianvv@google.com> <CAFSKS=P2d-szPdjukc_3HGBXKYv4k-fwh=OWBdHy2knqr-4-Hg@mail.gmail.com>
In-Reply-To: <CAFSKS=P2d-szPdjukc_3HGBXKYv4k-fwh=OWBdHy2knqr-4-Hg@mail.gmail.com>
From:   Brian Vazquez <brianvv.kernel@gmail.com>
Date:   Thu, 4 Feb 2021 09:56:11 -0800
Message-ID: <CABCgpaVCgBKGG8EeopROm4sGWyD_FHRveUpB1xyuy1n2=X3waA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: add EXPORT_INDIRECT_CALLABLE wrapper
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Brian Vazquez <brianvv@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yeah, I'm also not seeing it on patchwork. But I did get the email on
both corp and personal email. So maybe something is failing at
patchwork?


On Thu, Feb 4, 2021 at 9:50 AM George McCollister
<george.mccollister@gmail.com> wrote:
>
> I don't see the second patch.
>
> Regards,
> George McCollister
