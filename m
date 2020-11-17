Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708E42B5B1F
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 09:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgKQIjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 03:39:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:50978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgKQIjK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 03:39:10 -0500
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87B9F2467B;
        Tue, 17 Nov 2020 08:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605602349;
        bh=Cy4GXcCCTrzvouUawUb+lUVg0c61NgYMg4LCDAnSajg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pcBulDDViZFjtMVmHT8AROBaOm7zOqxMnlHZUfQnkAiaWRYwukO4goGfGYrfAD/5D
         MaP/qBQ9LcbOUjfPxBT/WYZfNC/lWwVqJUf/tt1hw4O1ryYPFlQ03LWY0kgX7k0qf3
         wIT3jMvyh5RenR3wLOwPCGPob6idio6ltD0Rua80=
Received: by mail-ed1-f48.google.com with SMTP id v22so21540422edt.9;
        Tue, 17 Nov 2020 00:39:09 -0800 (PST)
X-Gm-Message-State: AOAM530SDoKsohndazhyGb4F4GFm13eyYp/DLfAiOCOOsBqnBRe9Cw/J
        qNubWNtC0T5FWWy+4sfTEbFP6WS2cgZTPLZejMc=
X-Google-Smtp-Source: ABdhPJxvy7lCCxsJGnRs2AsQAgaEPb8MUllAkLTlRtx6a6g4tlOHxhV2zK5kJo+XicMxbmEMQt9ABULEMBwP46a/IFg=
X-Received: by 2002:a05:6402:31b6:: with SMTP id dj22mr20391396edb.348.1605602348036;
 Tue, 17 Nov 2020 00:39:08 -0800 (PST)
MIME-Version: 1.0
References: <CGME20201117011611epcms2p22fb0315814144e94856a96014c376a04@epcms2p2>
 <20201117011611epcms2p22fb0315814144e94856a96014c376a04@epcms2p2>
 <20201117074207.GC3436@kozik-lap> <CAEx-X7epecwBYV7UYoesQ9+Q8ir+kjYGyysiyDtCa0BzKiCGtA@mail.gmail.com>
In-Reply-To: <CAEx-X7epecwBYV7UYoesQ9+Q8ir+kjYGyysiyDtCa0BzKiCGtA@mail.gmail.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Tue, 17 Nov 2020 09:38:56 +0100
X-Gmail-Original-Message-ID: <CAJKOXPdH49zOQ2caOvDDiZPkEptYiCjUmXw+O2dCC1tKHZgPag@mail.gmail.com>
Message-ID: <CAJKOXPdH49zOQ2caOvDDiZPkEptYiCjUmXw+O2dCC1tKHZgPag@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] nfc: s3fwrn5: Remove the max_payload
To:     Bongsu Jeon <bs.jeon87@gmail.com>
Cc:     Bongsu Jeon <bongsu.jeon@samsung.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        "linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 at 09:14, Bongsu Jeon <bs.jeon87@gmail.com> wrote:
>
> 2020-11-17 16:42 GMT+09:00, krzk@kernel.org <krzk@kernel.org>:
> > On Tue, Nov 17, 2020 at 10:16:11AM +0900, Bongsu Jeon wrote:
> >> max_payload is unused.
> >
> > Why did you resend the patch ignoring my review? I already provided you
> > with a tag, so you should include it.
> >
> > https://www.kernel.org/doc/html/latest/process/submitting-patches.html
> >
> > Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
> >
> > Best regards,
> > Krzysztof
> >
>
> Sorry about that. I included the tag.

You need to reduce the rate of sending new patches. You sent v1. Then
you sent again v1, which I reviewed. Then you send v2 without my
review. So I provided a review. Then you sent again a v2 with my
reviewed tags. So there are two v1 patches and two v2. Since I
provided you the review tags for v2, no need to send v2 again. It
confuses.

Best regards,
Krzysztof
