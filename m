Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D983B0A68
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 18:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhFVQfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 12:35:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229501AbhFVQfW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 12:35:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB03261357;
        Tue, 22 Jun 2021 16:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624379586;
        bh=3tr8hncMNi9n9tTtvYn+09fDt3+FvMj/q1Ji3UZ1EgM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GYZgUOjlz9lEw31xY+3W3Cqd8k+sV2CnoaPGqM8aj9HRvQS5wsu8ml6Kf+n0FfQcJ
         dimJvVOuC4LloBXuiPawqgCrtL5vLWgyhtv2YIPK7E1zrmyXqMY+2YWilAY7l2VzbR
         rAPfJEFmq8jNz26svj2+MZa/Jdz2p3LkW8YA81Zd6cxI0+1gwgZv5bB5kryiC9/PPp
         WrD8XbZmd6euszMqHFOwBkeITPPYIjueUd0hS3WaebGNXiHwmZd3VW+drVFGwRxmP0
         MtLiHGSJ+svVenxwCBomjQLZKDiHjU/XyLgYGWWMZO7vr97f2Qn+23PHtrYGD3Obj0
         gxcHgyqoeg/Bw==
Received: by mail-ej1-f52.google.com with SMTP id he7so35435440ejc.13;
        Tue, 22 Jun 2021 09:33:06 -0700 (PDT)
X-Gm-Message-State: AOAM532OJVaXeDdC7jqOkdRGJergmzUU7moruIFCoT+8lOi6Xgkt/GdY
        OEGrFMwRtQQmpyQ2kpBkhsyhn18SSjWihFv4rQ==
X-Google-Smtp-Source: ABdhPJzaK4BPffOFMlQOHCufbEOnv01yqcHgTSSrNru1lz1eHoJgyCIqXzdmpJWrwDK9jMQnJr9tGh9SfMgVXPEykI4=
X-Received: by 2002:a17:906:82cf:: with SMTP id a15mr4849734ejy.359.1624379585262;
 Tue, 22 Jun 2021 09:33:05 -0700 (PDT)
MIME-Version: 1.0
References: <1624192730-43276-1-git-send-email-zhouyanjie@wanyeetech.com> <1624192730-43276-2-git-send-email-zhouyanjie@wanyeetech.com>
In-Reply-To: <1624192730-43276-2-git-send-email-zhouyanjie@wanyeetech.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 22 Jun 2021 10:32:51 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLuPG+XYBmL6hd_fW5NOwsB4rC1pYAc-_Erfbe-aW0DKQ@mail.gmail.com>
Message-ID: <CAL_JsqLuPG+XYBmL6hd_fW5NOwsB4rC1pYAc-_Erfbe-aW0DKQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: dwmac: Remove unexpected item.
To:     =?UTF-8?B?5ZGo55Cw5p2wIChaaG91IFlhbmppZSk=?= 
        <zhouyanjie@wanyeetech.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe CAVALLARO <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dongsheng.qiu@ingenic.com, aric.pzqi@ingenic.com,
        rick.tyliu@ingenic.com, sihui.liu@ingenic.com,
        jun.jiang@ingenic.com, sernia.zhou@foxmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 20, 2021 at 6:39 AM =E5=91=A8=E7=90=B0=E6=9D=B0 (Zhou Yanjie)
<zhouyanjie@wanyeetech.com> wrote:
>
> Remove the unexpected "snps,dwmac" item in the example.
>
> Fixes: 3b8401066e5a ("dt-bindings: dwmac: Add bindings for new Ingenic So=
Cs.")
>
> Signed-off-by: =E5=91=A8=E7=90=B0=E6=9D=B0 (Zhou Yanjie) <zhouyanjie@wany=
eetech.com>
> ---
>  Documentation/devicetree/bindings/net/ingenic,mac.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

I'd apply Thierry's patch instead.
