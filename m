Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935143A8C32
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 01:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhFOXFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 19:05:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229811AbhFOXFt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 19:05:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3518A61055;
        Tue, 15 Jun 2021 23:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623798224;
        bh=WBK8GrpEprcghWnNyrwT6kWzXp/Jz94GFIqC2zWgDrU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JXoMx6Y2oMLxMqKL7zqFlVWTitbKCiUckeputPz0XKOeRPd11tgbmF8IMT9k3Itie
         a8yy5bnccggqx1peCtnh6ghNE8kCi82VZ3h2SUfPdzQ4eCqrkFtvJH8upq7rCqY1cx
         1JHplTBdj3/Ui4bIt+e7TTg+nQ0EAwLF6hOza0eMww+OPYWiCm5NGZBkFSDbFep8JN
         lqC8uDv86aDNREX9+L1Si98ErCzbw9rEXP65PDw/9kJ4FW+odZglX+NLaCSlZYK/ng
         3AYwJ/KWRPdHzJ5g5JR5ne8/kxb4xlwgX/TUx4rPbqtZllI+wBIykTUTNWHlixrnwc
         SsFz9pN8BcZfQ==
Received: by mail-ej1-f42.google.com with SMTP id nd37so460581ejc.3;
        Tue, 15 Jun 2021 16:03:44 -0700 (PDT)
X-Gm-Message-State: AOAM530Sh2wFOROxVFqMQpqEieF7Ms+0+uDDiWCJ07HUt2JVFlus5a1h
        Wt1+Lvz1xubjEwvSxebaaIE+H7SBa5sK7zWGkw==
X-Google-Smtp-Source: ABdhPJyisgkjgLkaN0APZhInDthw5akaPjM+7qJQBi6KzOQnueY8+xWAafZiP63UckFpAWPh5P503AOeKqS2A81d82w=
X-Received: by 2002:a17:906:9419:: with SMTP id q25mr1916674ejx.341.1623798222868;
 Tue, 15 Jun 2021 16:03:42 -0700 (PDT)
MIME-Version: 1.0
References: <1623690937-52389-1-git-send-email-zhouyanjie@wanyeetech.com> <162370200625.25455.5879439335776203648.git-patchwork-notify@kernel.org>
In-Reply-To: <162370200625.25455.5879439335776203648.git-patchwork-notify@kernel.org>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 15 Jun 2021 17:03:31 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKEwrtZKK3viOzY8nW8fPmqnJO+WANvBfMzNYhg_aRrmg@mail.gmail.com>
Message-ID: <CAL_JsqKEwrtZKK3viOzY8nW8fPmqnJO+WANvBfMzNYhg_aRrmg@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] Add Ingenic SoCs MAC support.
To:     patchwork-bot+netdevbpf@kernel.org,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Giuseppe CAVALLARO <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, rick.tyliu@ingenic.com,
        sihui.liu@ingenic.com, jun.jiang@ingenic.com,
        sernia.zhou@foxmail.com,
        =?UTF-8?B?5ZGo55Cw5p2wIChaaG91IFlhbmppZSk=?= 
        <zhouyanjie@wanyeetech.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 2:20 PM <patchwork-bot+netdevbpf@kernel.org> wrote:
>
> Hello:
>
> This series was applied to netdev/net-next.git (refs/heads/master):
>
> On Tue, 15 Jun 2021 01:15:35 +0800 you wrote:
> > v2->v3:
> > 1.Add "ingenic,mac.yaml" for Ingenic SoCs.
> > 2.Change tx clk delay and rx clk delay from hardware value to ps.
> > 3.return -EINVAL when a unsupported value is encountered when
> >   parsing the binding.
> > 4.Simplify the code of the RGMII part of X2000 SoC according to
> >   Andrew Lunn=E2=80=99s suggestion.
> > 5.Follow the example of "dwmac-mediatek.c" to improve the code
> >   that handles delays according to Andrew Lunn=E2=80=99s suggestion.
> >
> > [...]
>
> Here is the summary with links:
>   - [v3,1/2] dt-bindings: dwmac: Add bindings for new Ingenic SoCs.
>     https://git.kernel.org/netdev/net-next/c/3b8401066e5a
>   - [v3,2/2] net: stmmac: Add Ingenic SoCs MAC support.
>     https://git.kernel.org/netdev/net-next/c/2bb4b98b60d7

Perhaps 3 hours is not sufficient time to review. It may be a v3, but
the binding appears to have changed quite a bit in addition to being
broken.

Rob
