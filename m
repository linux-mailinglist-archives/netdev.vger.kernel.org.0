Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAE5302776
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 17:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730568AbhAYQGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 11:06:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730382AbhAYQGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 11:06:11 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B47C06174A;
        Mon, 25 Jan 2021 08:05:28 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id d81so27507230iof.3;
        Mon, 25 Jan 2021 08:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PKFdQJWox9aZ4PvErLOeFCl9Ca17gHD16VMhp7rOwKE=;
        b=eaWu6IaaAS1LwErvpIhsdIx/0+R9KO4T4Cx31RtpY0Yy3VtFfQ/6s00liOzOGJTwOk
         ZmfNaObMhPCkgFrcxhBQJnozdAfvcDmxBzvZpE4zdNvPQ4lRaGS89XnjAmxrkFp69Bx0
         ZhKsFzCWUwL8RlnSFwESG7dcN2SVziZE/ZDMrFjqu6fCrek5hBSwfzliRQOF29rrJj1Y
         /H8kpeQBkaAi7BpgDuyjRy9y3T87hjGVfICWv/JGyc6P5cI71vwe6zMT9fnpI0WcA+cJ
         JEKSaiNigmSFbpi7TXcrPkiH/nllazHNWPOKEltDzXfEpY0cDwi53GbmCISUT+gtjIXj
         XWBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PKFdQJWox9aZ4PvErLOeFCl9Ca17gHD16VMhp7rOwKE=;
        b=l2WGairOWxGnejGowPL9VbJNwAy42Y4ZPKwDa343gBA3qJR/+DGbnQ/sgWVrqIDgAW
         uptXcYtwBqCPCXjd/V/xtvy+MOJ+zV7K9eSS9U5Oiw0FOA8OKE2WFwQhH64cthcs4F/R
         L9xHTiyIEaRb3x7y8sSvrsulDzGZIKTOmIg1hKsjtA1yYoxKuzC08FZidXhXarUpmZ3k
         LuC9b5KAnHYVGTnpwJ7u3ZFzXHrnuPRQa1EIQECvuQcLjWrKGMEh2Z+eb8jXWPb7I5kT
         SVjjf8nW1x/zemF/OTkW/tMimKzYMGH3yoeJy4NOd3cCSBZuRyVngxMbdMeBjVkgiiMy
         KNcg==
X-Gm-Message-State: AOAM530AMTIvs1nuAzlhRMMEoVFqKYEz1FeD257nI26g78h41B/Zh8I2
        dRJz3wOHp5ccjXCqazIMpYJPpzV+c6tXPXYvK1TIkCxDEa5Sgg==
X-Google-Smtp-Source: ABdhPJya+WW0x+mSKy2+g1N2ELbfh9H+kwJYEORd7Sqf4JqMZg5irYw5+OZ2UJ4CA9yR84lFPe0qiYvozCA2otGsDVc=
X-Received: by 2002:a05:6e02:dea:: with SMTP id m10mr950392ilj.241.1611590728327;
 Mon, 25 Jan 2021 08:05:28 -0800 (PST)
MIME-Version: 1.0
References: <20210125044322.6280-1-dqfext@gmail.com> <20210125044322.6280-2-dqfext@gmail.com>
 <20210125155233.GA438031@robh.at.kernel.org>
In-Reply-To: <20210125155233.GA438031@robh.at.kernel.org>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Tue, 26 Jan 2021 00:05:17 +0800
Message-ID: <CALW65jb0W3R1fEDM8hGPR8kHFAg9KXpXkdmDJqxiTaVZ4vP+ig@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/2] dt-bindings: net: dsa: add MT7530 GPIO
 controller binding
To:     Rob Herring <robh@kernel.org>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        linux-gpio@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 11:52 PM Rob Herring <robh@kernel.org> wrote:
>
> Please add Acked-by/Reviewed-by tags when posting new versions. However,
> there's no need to repost patches *only* to add the tags. The upstream
> maintainer will do that for acks received on the version they apply.

Sorry. Will do that next time.

>
> If a tag was not added on purpose, please state why and what changed.
>
