Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97DF73D103C
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 15:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239087AbhGUNJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 09:09:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238996AbhGUNJH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 09:09:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3453C6121E;
        Wed, 21 Jul 2021 13:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626875384;
        bh=Fcd46JsRF5Xzokx8EbEQAOvgZr4ne1Di199XOOqGdXI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MlngOFVzPy6D4n/vJS8cjv7UbvZgk2BbOpnI5+S4srLE5uyBvjmuzvuK6bVFb3fFj
         19HPLZGZUuiHcV3pVbD+3M2mCNVMqiZ2hmQprUrNSSdqQ2+6HZZKs4XkkeMRjPgsCF
         j/6ZYtYhD/trRr673VMxc9e6EOc0rL1pUmfUtUijh5aOHbIGCnCQ8Nxi8CTPWlypNM
         uCXisRccE7jOfEPF/4SZTKVHS8JIOZ6Wsk0Zon74S97Bmb3BzdgmWrhehfUzALQmrN
         +an+o4ZhXnKawCDxTNtX0d6jgAw7c+hMbNWhkva58kZcDvUDKAJ5khJ/kid8yv0l2q
         VRaXfzTQnwJtw==
Received: by mail-ej1-f54.google.com with SMTP id dp20so3351333ejc.7;
        Wed, 21 Jul 2021 06:49:44 -0700 (PDT)
X-Gm-Message-State: AOAM5331v6oohHBSF80LwYsbKi9X5VAFuedk6zKHNBlB31uxJ0CB1qYQ
        iVN8OjAlq9i/+Slb5UrxCjUu1TWer8xJtnoEgg==
X-Google-Smtp-Source: ABdhPJzh5cj++jO5fwUbg47UmcOOhxrwvB/MBLzILA/PNS+iWEyxrXcgOCfI8OpXmusl3DEp7otnJa9jAjW0ixfrR7g=
X-Received: by 2002:a17:906:5fc1:: with SMTP id k1mr37644013ejv.360.1626875382783;
 Wed, 21 Jul 2021 06:49:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210720172025.363238-1-robh@kernel.org> <8343dfe9d1af1ad4ab806104b74a95819c765dea.camel@pengutronix.de>
In-Reply-To: <8343dfe9d1af1ad4ab806104b74a95819c765dea.camel@pengutronix.de>
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 21 Jul 2021 07:49:30 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+XEbEJuoSiQ=PeL-34FkLqG-eYA86FvNK7K-uGbaTFwg@mail.gmail.com>
Message-ID: <CAL_Jsq+XEbEJuoSiQ=PeL-34FkLqG-eYA86FvNK7K-uGbaTFwg@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: Remove "status" from schema examples
To:     Philipp Zabel <p.zabel@pengutronix.de>
Cc:     devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Robert Marko <robert.marko@sartura.hr>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ramesh Shanmugasundaram <rashanmu@gmail.com>,
        "G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        ChiYuan Huang <cy_huang@richtek.com>,
        Wei Xu <xuwei5@hisilicon.com>,
        Dilip Kota <eswara.kota@linux.intel.com>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        Olivier Moysan <olivier.moysan@st.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:REAL TIME CLOCK (RTC) SUBSYSTEM" 
        <linux-rtc@vger.kernel.org>,
        Linux-ALSA <alsa-devel@alsa-project.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 2:33 AM Philipp Zabel <p.zabel@pengutronix.de> wrote:
>
> Hi Rob,
>
> On Tue, 2021-07-20 at 11:20 -0600, Rob Herring wrote:
> > There's no reason to have "status" properties in examples. "okay" is the
> > default, and "disabled" turns off some schema checks ('required'
> > specifically).
>
> Is this documented somewhere? If not, should it be? (Maybe in writing-
> schema.rst -> Schema Contents -> examples?)

I don't think it is. I'm writing a schema for it which works for both
those that read documentation and those that don't.

Rob
