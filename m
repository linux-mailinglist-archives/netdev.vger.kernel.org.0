Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34377257ADA
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 15:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgHaNvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 09:51:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgHaNvj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 09:51:39 -0400
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06B5020FC3;
        Mon, 31 Aug 2020 13:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598881899;
        bh=0yEwFKwwju+lazUkfX15BH1WWIsj5zWxercdqfb5PDc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QyP1LFSgNO6eg7DLMb6SA3GRZ3HCcRyb0eBdyx/llC/pvkVjG+8qXTatrwmSmUBAY
         xHvLpELWynrMwwNrYM91Tpt8bOlX1KZ1TqKPAaE11JObunRW0fgMMTwV+b287lkB/c
         1fjdZ0dU+rHWcZ/35cO1bviSqegf8/peTqKEVNfA=
Received: by mail-ed1-f50.google.com with SMTP id a12so5472408eds.13;
        Mon, 31 Aug 2020 06:51:38 -0700 (PDT)
X-Gm-Message-State: AOAM533mNQLEW7jvSAUKnxzXBED9LPt8uXtg2Qqzo2llg8K/AkYr2DJU
        m2vNtQzAvrSs8Vbl/IiDG9faeI/WAWEiY6f1IIQ=
X-Google-Smtp-Source: ABdhPJygfH4EYwB4Wvpx/86s42YhV3PYxFeVDYnzUd3LC/cNJK4ok2eS8McXa6+HcbxRDAItKto4Vt1XxzC1q2kW2Kw=
X-Received: by 2002:a05:6402:515:: with SMTP id m21mr1395416edv.348.1598881897601;
 Mon, 31 Aug 2020 06:51:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200829142948.32365-1-krzk@kernel.org> <CGME20200829143012eucas1p1b49614f85907091480a3b53ec70221b9@eucas1p1.samsung.com>
 <20200829142948.32365-4-krzk@kernel.org> <8fe346a7-3c6c-f51d-f2a2-623931628a25@samsung.com>
In-Reply-To: <8fe346a7-3c6c-f51d-f2a2-623931628a25@samsung.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Mon, 31 Aug 2020 15:51:26 +0200
X-Gmail-Original-Message-ID: <CAJKOXPd5XpKxC4COS1GypFwV82BYxSqQkgOfay3yhkk4pbcPTg@mail.gmail.com>
Message-ID: <CAJKOXPd5XpKxC4COS1GypFwV82BYxSqQkgOfay3yhkk4pbcPTg@mail.gmail.com>
Subject: Re: [PATCH 4/4] arm64: dts: exynos: Use newer S3FWRN5 GPIO properties
 in Exynos5433 TM2
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Kukjin Kim <kgene@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-nfc@lists.01.org, linux-arm-kernel@lists.infradead.org,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Inki Dae <inki.dae@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Aug 2020 at 15:16, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
>
>
> On 29.08.2020 16:29, Krzysztof Kozlowski wrote:
> > Since "s3fwrn5" is not a valid vendor prefix, use new GPIO properties
> > instead of the deprecated.
> >
> > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

Thanks for testing this and others in the series. Much appreciated!

Best regards,
Krzysztof
