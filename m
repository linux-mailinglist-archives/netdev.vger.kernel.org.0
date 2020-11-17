Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9923E2B71DC
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 23:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729166AbgKQWzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 17:55:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbgKQWzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 17:55:39 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B87C0613CF;
        Tue, 17 Nov 2020 14:55:39 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id k27so4381759ejs.10;
        Tue, 17 Nov 2020 14:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qEpMsX7umrh9W1uoj4wOxIl7k65AMD4+895y5wqaPqQ=;
        b=KZY7kjNmYGv4a0Uipuqg5wXyUqIQvGZYBkO5n34n9uNgWczhClk8jRt0v8EfYTdbfz
         zpuaA69UXFIxk58q4VOKQTpN6dlzqtiYWPpHQ8QWRZ7R+X/MEtnc9Z/Bxx3rDS3JsOdF
         6BZi773NNYPLSTnnQYSgeIp93X4FQfZS6kZdQrk1cDYPMXoAhOxba1zVeQG74hZ8SpR/
         u2ssh18JioOyWC6ItFwTUVXoLANoNeHfJHKO3DSulKre7HDpYYpU06VWgybLDmQ+wFvo
         nBNABrOAYeTFCZq7kIzCgB+WATeKAD0ESkOWL42kTq9DDrORR6g3pGkGTR6c5EmHqK46
         jrWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qEpMsX7umrh9W1uoj4wOxIl7k65AMD4+895y5wqaPqQ=;
        b=jI5mTsiXirSVo3oah+m/27bfNJLz1/GC8UOPFqqGyi9RX7mqWd9LAeRRwfHCFR9dwn
         TmIzsliMoef2uoyBx/1K2BnHDSnH9pM2poPGUtAy9p48N047hnglqPB9FmwJiR0CUNuO
         bEjQtQmkFgwPwzvxyroRgdXSyC1ly1+zYUWLzXki4w2Zax8g9e7rGBWrKSGDPXEQrBFH
         DmXAFvvipE/ZarxviL+Z6xKLJV7Hs/psyQS5lhmozY9npBpwILq3vUmfZoCXbp/FfmsX
         dePJaqwsU0jGIRv6E7OiJTuHSmHO96cs20mPjNiZ8E75j7N4q+DpDwSd5NN0Y1wW2kWE
         yzng==
X-Gm-Message-State: AOAM530s/PrOaADjhUWdxtqM5ZuFryzKIwp70RGhl1RUA0FKlkgiHBzY
        8Oud8869nKUvgZc61VsqNIA6sA7AF2IhN0Czdcs=
X-Google-Smtp-Source: ABdhPJxbijK6/juoUqP/6V1GLG3p23sEWaIracp25d6S9D3+wLH6rLRBCosXcMAiY74K1MjHk1++m3w5bCpmNLMLoSs=
X-Received: by 2002:a17:906:76d3:: with SMTP id q19mr20994562ejn.162.1605653737992;
 Tue, 17 Nov 2020 14:55:37 -0800 (PST)
MIME-Version: 1.0
References: <20201115185210.573739-1-martin.blumenstingl@googlemail.com>
In-Reply-To: <20201115185210.573739-1-martin.blumenstingl@googlemail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Tue, 17 Nov 2020 23:55:27 +0100
Message-ID: <CAFBinCAXLqxqK=oB2eVDV+WY5up0dRYZ9=46riQ3uOWnw9jmng@mail.gmail.com>
Subject: Re: [PATCH RFC v2 0/5] dwmac-meson8b: picosecond precision RX delay support
To:     khilman@baylibre.com
Cc:     jianxin.pan@amlogic.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Neil Armstrong <narmstrong@baylibre.com>, jbrunet@baylibre.com,
        andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-amlogic@lists.infradead.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kevin,

On Sun, Nov 15, 2020 at 7:52 PM Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
[...]
> I have tested this on an X96 Air 4GB board (not upstream yet).
[...]
> Also I have tested this on a X96 Max board without any .dts changes

can you please add this series to your testing branch?
I am interested in feedback from Kernel CI for all the boards which
are there as well as any other testing bots


Thank you!
Best regards,
Martin
