Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B70C4AED71
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 10:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239318AbiBIJCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 04:02:05 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:48430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbiBIJB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 04:01:59 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FFCC1DC701
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 01:01:56 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id y17so1648538plg.7
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 01:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VwHSZ3s0JcHPLzzHINQePLd7HNHpA1/kmGVFl4aO6kI=;
        b=BA9hkdgJywcKv6PUKM5KSUYscmNQcadOBxH45OPvR+e0NwJsn59jfmfBn2AuaAcNuG
         swWEkY4uS70bIqtwefwXL8B2Tpdu+nU+hVyUhmzi+nKeyzvu9SMX4kHRCX8onmkKleqx
         a8wqAKk79YvW9u0rDk9TSWRRuFEP3rBteJSMVziUvfxJmZ1W8bIdoIrCqJ26qOY/MzWw
         asCQVCsLo9hALzcmH5sOxsMue/aPLdIWnOUXndwcH/Ptxo01uGvBMBlYzEd6YsFbupjw
         esJ3VKohqF0blEJdoPA60HGvqNR9bZSxQmGWsbBjl8vlfBdtKDsfCKybqCHcS94Y3KoP
         l/1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VwHSZ3s0JcHPLzzHINQePLd7HNHpA1/kmGVFl4aO6kI=;
        b=CQrjjKwLOjtYmL6yXzRhysMe4LVg04TBt+I4dv5WrPYU998AhYjK1nDkl5H7ziRFjc
         Mm571MHsMw4LW5eqIqMHBHXDwk3ITR7sYA7S9TlZogNyWb+IE2QahMvD3JHMxTZ1iK3Y
         7A9J+T8p62IXHzJJUbxdBQro4qYNF9gT0Ums/rPo1AXUAcy5gtPXSbeUUTKXTTNK+T8W
         DD2CUFghBqirbHOMUqRMdmNCGrdwZsKfkQmdqXc+4qOXGIjkxzKxTjQb2Wa53WjgED4A
         xOMh3jt055r/xBhiz5eVonUMGQE5kLpjxO2lCLjt3kj0vf2i0UZkHRIJggvS/cLziDxs
         1Lhg==
X-Gm-Message-State: AOAM532ubFRj4HWLadJj8gJuy1p/U4jWBAVoPC3gliDwF5DBLxfbpRCA
        8VBVzZmazXQ0lr818KLqY/4TtrhtCNPtbU8zPHwAr7+nKLfFaQ==
X-Google-Smtp-Source: ABdhPJwNuLaeL9fNdiT5ZlsIsil6aSt3RcucAZs1tE4eu/Fq3sCQD/qwgGiJEqmQscRXHySJaFo4FU6uIHHV2fEdb1Q=
X-Received: by 2002:a17:90b:2252:: with SMTP id hk18mr1440054pjb.183.1644397289453;
 Wed, 09 Feb 2022 01:01:29 -0800 (PST)
MIME-Version: 1.0
References: <20220208051552.13368-1-luizluca@gmail.com> <YgJtfdopgTBxmhpr@lunn.ch>
In-Reply-To: <YgJtfdopgTBxmhpr@lunn.ch>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Wed, 9 Feb 2022 06:01:18 -0300
Message-ID: <CAJq09z4qUF9OyE0z_6SMGi13G4_A2fjUPuFQcyzJBNY8mfmaEw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: add compatible strings for RTL8367RB-VB
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Tue, Feb 08, 2022 at 02:15:52AM -0300, Luiz Angelo Daros de Luca wrote:
> > RTL8367RB-VB was not mentioned in the compatible table, nor in the
> > Kconfig help text.
> >
> > The driver still detects the variant by itself and ignores which
> > compatible string was used to select it. So, any compatible string will
> > work for any compatible model.
>
> Please also update the binding documentation:
> Documentation/devicetree/bindings/net/dsa/realtek-smi.txt

No, I'll do better. I'll send a new yaml version covering both
realtek-smi and realtek-mdio.

>
> Thanks
>         Andrew
