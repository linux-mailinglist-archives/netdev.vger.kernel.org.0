Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D222CC48F
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 23:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730542AbfJDVIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 17:08:16 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36365 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfJDVIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 17:08:16 -0400
Received: by mail-lf1-f65.google.com with SMTP id x80so5422357lff.3
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 14:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HhK03oaSMo/8bfjDBpniHapGQAbMA85rfpZvXfLdmYE=;
        b=R/zTVZ9cr4Dv8veyibem6M6FqmnA1nRbPvXXGJhzC3vvRGdG4nQviiDVwQKAqeNO/Q
         j4G8zEWfji9Q79jp5eAF7Vrq0wcotCPVwy1nvuwPt3mBdfAFiuz9RhbZieNyMqfjMrlN
         lQ591WIa5foe+e1z6YOquDkGDQOeSW5umDpND2DY7gOIsHkbDT6s3YjCQS3U//XcfoQq
         e/s/oEgmdH6EbtFD/PzvfTviSN0w6EUlBlACaac32wmHxBoig/rsdE4EIeygRCEI0hJJ
         htXNEaLS7gnR7K8DOeTLvre3Lz28CRvH1hg6CpnbzVaMwi0tC+B/JUAU+02JAjGkCVsv
         pkgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HhK03oaSMo/8bfjDBpniHapGQAbMA85rfpZvXfLdmYE=;
        b=Fz+DbH3wKWuC+a2dHlQ3yVi4bcMJ09qSrxQxfZu0J+2yhXR7fdCc7GN7cEPKb1netx
         CTNA4d65nhSPRjUdeq4Asxk0Gs/vnZN7X1C0IxPXPal71sa4YFneo88TQO8JYqc7+U1Z
         esrs7BRZ/nn9UpwjJ0mwIRuKL2wduaDjK25MA7Kvad+xuV1CiT0r+O+V/n2Ntv1L+1sl
         VS7ZoJXgtiGAlGZ7BbGA4k7jz1UKn54bKb4HoWjKIa9Tq/wd7lkDWQjJeb2/WXXAwksd
         2+f2TkCE8l2xa5UqOXSo5AAvm7w8+bPQfCU48bTeytjcfIoqnw4WLwA9sEtn01oaqKJh
         wIcw==
X-Gm-Message-State: APjAAAXiBUfUsNiXOq8zgSij8FDYCOYCq0KsJl2FOQw6/jgue/DNlCsc
        Dtv348dRRSryuePUqM7eylEnPfiAaI5ovpHpBB6FVg==
X-Google-Smtp-Source: APXvYqwcJ2IUcDRtVTDYiQp+7VS7VKfkfuUC7BqSpv7lLTzAiR1ku6ptlziiaElGrVcXfadjuMfj784U4pQ1Sg51j4k=
X-Received: by 2002:ac2:5c11:: with SMTP id r17mr10121755lfp.61.1570223294668;
 Fri, 04 Oct 2019 14:08:14 -0700 (PDT)
MIME-Version: 1.0
References: <af65355e-c2f8-9142-4d0b-6903f23a98b2@web.de> <CH2PR02MB700047AFFFE08FE5FD563541C78E0@CH2PR02MB7000.namprd02.prod.outlook.com>
 <bd860b05-f493-20e6-083d-66ef3cb61f60@web.de>
In-Reply-To: <bd860b05-f493-20e6-083d-66ef3cb61f60@web.de>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 4 Oct 2019 23:08:02 +0200
Message-ID: <CACRpkdZPnRJWojgRsZvSTDWuxbOtQws5uQXDSPBBem6HE8iJgA@mail.gmail.com>
Subject: Re: [PATCH v2] ethernet: gemini: Use devm_platform_ioremap_resource()
 in gemini_ethernet_probe()
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Radhey Shyam Pandey <radheys@xilinx.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 20, 2019 at 11:23 AM Markus Elfring <Markus.Elfring@web.de> wro=
te:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 20 Sep 2019 10:52:56 +0200
>
> Simplify this function implementation by using the wrapper function
> =E2=80=9Cdevm_platform_ioremap_resource=E2=80=9D instead of calling the f=
unctions
> =E2=80=9Cplatform_get_resource=E2=80=9D and =E2=80=9Cdevm_ioremap_resourc=
e=E2=80=9D directly.
>
> * Thus reduce also a bit of exception handling code here.
> * Delete the local variable =E2=80=9Cres=E2=80=9D.
>
> This issue was detected by using the Coccinelle software.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Seems correct.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

BR
Linus Walleij
