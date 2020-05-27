Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCAF1E4DFA
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 21:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbgE0TO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 15:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728025AbgE0TO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 15:14:58 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9EFC08C5C1;
        Wed, 27 May 2020 12:14:57 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id z13so20654996ljn.7;
        Wed, 27 May 2020 12:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vIHelVmHmpv+LPchrobAxBcJ2T90U0P8hBKPd9Ksmgg=;
        b=RiNqN3c2HvT+2txBAfmbTApoxnsb7mk0xUeBZFU58WZ8NSgj7GzlH8TpsQv/C4KgE5
         x+mCJ8QSF/uwcKBL2xBkFqvfPWaffY4xoHZaRH3mCRxGkpDpSFNYHEldTrsu/dOKygJu
         M7J3EW956Lan7jiHkIGsimtGBjv4dzBOcyq8vwmorxyMQcPwh2HRce/yfO+NltX15781
         /6r86+o7G0jwAB/vFsZgZII0B0HzBH5pnzoUXVE4O173qGJSe+zUoWbZG2fAjVZJfDmo
         7yTBIYFH3kHBdq2wUen1+qJFUH9A8UrfCiuGCTY8aHBCtXMpqETny0CtZFA4tZ+GYhfx
         3TsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vIHelVmHmpv+LPchrobAxBcJ2T90U0P8hBKPd9Ksmgg=;
        b=WgXShTtSzJ051hjBcC9sN6LVoeWNP9T4E3BUUnBuSfUdW3QkhoxjYR5oNp1i62OYQt
         +f89znAUNrmrr4Jv8pTH0QmCvceIgd5rp7HGo2OJMVFQ3zJxUmvw7Wy+K5i1WvaKXgGT
         gO19Rv7WScRaP91H/yrC/RKZnKy4C2PSXrzRx4qj97NHlzqpPolC0dFqg5adp3ucDHVb
         5aXIxdGOwwJRZiOuy0vgWEmEqO+ZSQZYmIEWnXtiBJj7J1wi97NP0RbCXwL9CTLCVnDE
         rK+TThVwZhRwwHCOGBJOHOFqlX7cQWu7tpj8LrlaYGn6QkRcOWhJPDSLzp+xhalelAU0
         UJYg==
X-Gm-Message-State: AOAM5312FDmYdI5f7W3t3tcdJOEtj/YVOHkZtDMnBBxw0Oa7t0jiFYZz
        ynW6v98RTyrLsptSqPFVgUnDXryfz2awJA4e+rPR//zK
X-Google-Smtp-Source: ABdhPJzG+P7meWe0LTEGaQLJTcvyJ54tgeEboR+VAW3PqoFGc2E/Q3mSFPXCYvEK3b0EJI1VO/Ry8s3DFVhZ3KO5P3g=
X-Received: by 2002:a2e:8884:: with SMTP id k4mr3904355lji.170.1590606896315;
 Wed, 27 May 2020 12:14:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200515164640.97276-1-ramonreisfontes@gmail.com>
 <ab7cac9c73dc8ef956a1719dc090167bcfc24b63.camel@sipsolutions.net>
 <CAK8U23ZaUhoPVdWo-fkFpg4pGOcQQrk7oSbs9z1XPVE3cR_Jow@mail.gmail.com> <0131b3dbcb2f97b6a76ad5be0c50f26e11af1c5a.camel@sipsolutions.net>
In-Reply-To: <0131b3dbcb2f97b6a76ad5be0c50f26e11af1c5a.camel@sipsolutions.net>
From:   Ramon Fontes <ramonreisfontes@gmail.com>
Date:   Wed, 27 May 2020 16:14:44 -0300
Message-ID: <CAK8U23YFGaWrzXnHiMA5KDeSDFLO7F7c+Dgp8CDTTEM2VastLg@mail.gmail.com>
Subject: Re: [PATCH] mac80211_hwsim: report the WIPHY_FLAG_SUPPORTS_5_10_MHZ capability
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        kvalo@codeaurora.org, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Yeah, but wmediumd won't know that it's not 20 MHz, I guess :-)

Yes, I know. You're right! I hope advances in wmediumd in this regard :).

> Yeah, but which channels? I believe with 10 MHz you can also use channel
> 175, for example, which doesn't exist in 20 MHz channelization.

I'm doing some research with 802.11p and I could use all the channels
between 171 and 185 with both 5 and 10MHz.

> Anyway, I've applied it now, we can fix more later.
Thanks!


Ramon
