Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A72AD5DD9
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 10:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730610AbfJNItP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 04:49:15 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:36601 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730476AbfJNItP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 04:49:15 -0400
Received: by mail-ot1-f66.google.com with SMTP id 67so13137687oto.3;
        Mon, 14 Oct 2019 01:49:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sHUOzEM8408QtReDEYnlN2fQ7S9od5yj7y894mX8AyY=;
        b=WrjMlvagSBM9oWeJq9GPGtcQnBe5ceGIn3l5vNCayUm5u9efbDjeyLoqcwEB1o8SY3
         NnErzyu+JkAenYyuX/AFwt3YEZSAe8pIwbMQj2hsK2rKFMQ79NFS8Ha89gIJNuej9vao
         q7Wd2SqgkPwi5/xglGUk/R5UkTT+KcUBMidNr7TiYuoaGrpfQHRmdCUcVxz3Dd5HgMQf
         /FvWq+OvuugUlWxgwlI9yXMuXwnpm6tuSbTK1ykCkvKm26Xr8G9kShCU6M5pKt613AGQ
         FSSpdNakv7THcxazpJ0tso11fGDz5oDTHi2HI+J4gBmynleMjmL9YrmR3YH2v6eYFcW1
         enUA==
X-Gm-Message-State: APjAAAXyrr9f9huBtdsisRp4W3/lEWzgNef8IkXnurdJ5kl0EuKlaSeb
        x1KQUR9hvm8RGgp652bXZMYJLMVIJrt7tChgOhI=
X-Google-Smtp-Source: APXvYqx6seOUQFOoO3JBxG2sL+Teqj0vkwCSvRcx4J0jdoKSUSOXCUPajOcoR2m0ZsBLLCmEDSKkcqkmc+kS7m2YJZ8=
X-Received: by 2002:a05:6830:1544:: with SMTP id l4mr9074793otp.297.1571042952900;
 Mon, 14 Oct 2019 01:49:12 -0700 (PDT)
MIME-Version: 1.0
References: <1570717560-7431-1-git-send-email-fabrizio.castro@bp.renesas.com> <1570717560-7431-4-git-send-email-fabrizio.castro@bp.renesas.com>
In-Reply-To: <1570717560-7431-4-git-send-email-fabrizio.castro@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 14 Oct 2019 10:49:01 +0200
Message-ID: <CAMuHMdWtK1+3AZ734j8rLsAx-b873Gxaif5g0+J4UVPLRR9X6g@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] arm64: dts: renesas: r8a774b1: Add CAN and CAN FD support
To:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>, linux-can@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 4:26 PM Fabrizio Castro
<fabrizio.castro@bp.renesas.com> wrote:
> Add CAN and CAN FD support to the RZ/G2N SoC specific dtsi.
>
> Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
i.e. will queue in renesas-devel for v5.5.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
