Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6444F479835
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 03:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbhLRClN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 21:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhLRClN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 21:41:13 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A14C061574
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 18:41:12 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id be32so6346726oib.11
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 18:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NytYp57ABJtv09pQHFx5lPRSJoBdUWdmxuwHZvht0Wk=;
        b=k4z38pZ7a4CBzep8bhNV03W60tHuNfSUVmT00qoLABv98/dRHXw2wAkSP+Hli89xO0
         4Spzf1F6Q6ydcextM8CwGzAaSDSC6D93f1ZPzaD58pIedzdsOfXcFXtT/KUisC1rCPgJ
         Bw7+jNgFizp+g1FWdLVMeADRJCguJKimvl+23X6o7t99bj7chQvxmXhgRShjDt33E7Lb
         8V9N/jWYQqZpgR0tMqJwHIo7N7nfBov6TQiLaHUq1Wn5sEuig3NU6+5ul5+qA0TWVI2a
         rpayqyQ1X+uPglNoIQF2siFY8Uq60fJZRJ9+HqwM9WNOilfDaFvyZUWVBp2t31N6oC0E
         GxTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NytYp57ABJtv09pQHFx5lPRSJoBdUWdmxuwHZvht0Wk=;
        b=5WRzbvHR/BKY/LhhQ6/vszBIjvEIj8w8F6ubpoV1e5cuzUbx9Xh3PH18biK4V3M3fA
         tyPpQhbVFgNaNQCEbr6JVwEwDfK2goDvJ5+aKh9fAxL7OjEBxyZA1sigbs4IsckObJp2
         q/+GtLsxaEB8xOTTi+tHoXkYw+aq+VTM46PAAU9tCa5slgsESd2E5d8jJmww+4BBkTFR
         aAiRU/H/vYtDV4/q1/7mIg8ixja2nToHzdk7EFXzIc89KCmamftekczb4SbNXQ0x4lRY
         JT21KvS3cX/U+IRhS4n7u/f+m/wB9JppEzX83zlKGFbskivftGrdXH3Fykveh594Qye4
         +rpA==
X-Gm-Message-State: AOAM530SAinFWKPEcZWvi4xIaRUQ8AFjaQiao5c4VHdXsB9i4YD9Bi5i
        m+N7LH05BdY0HlJPZyXZlSH0XfTbrS58XRFPsEv6xw==
X-Google-Smtp-Source: ABdhPJymL7rnLZNOmuA4MUf3KNp3NjFVm1QJE4crmjiPIHzCS4E2jnXs8ZZ7FfolpLO9RklGQTKigcbiMNJsKhv77nM=
X-Received: by 2002:a05:6808:60e:: with SMTP id y14mr4224595oih.162.1639795271873;
 Fri, 17 Dec 2021 18:41:11 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211216201342.25587-2-luizluca@gmail.com>
In-Reply-To: <20211216201342.25587-2-luizluca@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sat, 18 Dec 2021 03:41:00 +0100
Message-ID: <CACRpkdaWY=YMHgbpuvghCMaYk1Fa9_PLdUknmTHyHh7vb1kSjQ@mail.gmail.com>
Subject: Re: [PATCH net-next 01/13] dt-bindings: net: dsa: realtek-smi: remove
 unsupported switches
To:     luizluca@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, ALSI@bang-olufsen.dk,
        arinc.unal@arinc9.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 9:14 PM <luizluca@gmail.com> wrote:

> From: Luiz Angelo Daros de Luca <luizluca@gmail.com>
>
> Remove some switch models that are not cited in the code. Although rtl836=
6s
> was kept, it looks like a stub driver (with a FIXME comment).
>
> Reviewed-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Why? The device tree bindings are done with the ambition to be used
on several operating systems and the fact that the code in the Linux
kernel is not using them or citing them is not a reason to remove them.
We often define bindings for devices which don't even have a driver
in Linux.

A reason to delete them would be if they are family names and not
product names, i.e. no devices have this printed on the package.
I have seen physical packages saying "RTL8366RB" and
"RTL8366S" for sure, the rest I don't know about...

So we need compatibles for each physically existing component
that people might want to put in their device tree. Whether they have
drivers or not.

Yours,
Linus Walleij
