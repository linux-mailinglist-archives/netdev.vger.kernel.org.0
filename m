Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC602D606
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 09:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfE2HOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 03:14:14 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34549 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfE2HOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 03:14:14 -0400
Received: by mail-lj1-f193.google.com with SMTP id j24so1374209ljg.1
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 00:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V4HZjwZy6g+yOqeFPHLupxc7wUdYODKV+sitJWCxtz4=;
        b=g3LwR9C73J2SwCgErj42rEklPryPi6b+4DwoSwUeHpdfoTCmNohlFVUL+av2ysD8hr
         n++gcav9HTQLfLeoAaBXoQi+RR4jtp8tAWCbNGTVA9OsZOlBPEm3aiR2+tHdhPxjkWCY
         8c1WopbjCKYTrqV2Ti01WLfqbCbFYb0L6P+ZAel0XjcIYOl9CONWLcG8Uuf2E071np4W
         nfBhrr1BzvvYrzfNd+0Sc29ginCAFiAwXJVL/4QhfxbnXiAl/hlLC/2JxHwjToAkNa2v
         91UfsH2gFwYiaC4zrlBW1kWjddHW2Hc/ieYvIueIseLCLRfB0LPiABePAcJVkrjlkWFg
         ZISg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V4HZjwZy6g+yOqeFPHLupxc7wUdYODKV+sitJWCxtz4=;
        b=R4DO3vyoCHtZPM6wNepFEJPLe5wu3lddep43LnTWDzXoiKUEMLIM11HVUqWTiiUGQ5
         CgtSazfHBO9eYn5stEihlBtNi0ZjEChRNYKglbyH3pes9zwa3qTy/BRxhfsF2URs3mEL
         PUM1lvHMyUZlqNqDnFy1O+XayjjJ1lmgA/SGtmmRNGHjDJlY2teycxmRG4fetiUhVNtY
         JYzR2+zEsFX54he5eaWRzP5zCisYRdBoQuFcMFIVPJ4Up/HpuPPiMZ3Ve1XTYedPV5Tn
         JpLpIIp3vFWbaETCOM0guBEzqa90ZIDt8AQDJ3kDKNbFIn4RTfinqoN3TRKr3BHIfpHY
         b9ag==
X-Gm-Message-State: APjAAAVYBfYNPYtcgyNAzCnMefrnnnJBEusLoPwCTofV8sh6YzQ2SZXN
        yO2YgSu51x2vF6MJQ9Cmvf2NfIYEEscZ3CsfJBBg0gex
X-Google-Smtp-Source: APXvYqxI/mO9/lDZ8FkVjVNwre4n8DuQFO4+UBfucannHEA55v5j+NszYh72PzZ/pZ8xHSxu3ugd5MxRV4mayypVAro=
X-Received: by 2002:a2e:129b:: with SMTP id 27mr36165429ljs.104.1559114051715;
 Wed, 29 May 2019 00:14:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190524162023.9115-1-linus.walleij@linaro.org>
 <20190524162023.9115-8-linus.walleij@linaro.org> <20190524200651.GQ21208@lunn.ch>
In-Reply-To: <20190524200651.GQ21208@lunn.ch>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 29 May 2019 09:13:58 +0200
Message-ID: <CACRpkdaWDAb2OTrwUhgWpr3RbfcXDFX0ar8faQwEFvFyK8BxQg@mail.gmail.com>
Subject: Re: [PATCH 7/8] net: ethernet: ixp4xx: Add DT bindings
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof Halasa <khalasa@piap.pl>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 10:06 PM Andrew Lunn <andrew@lunn.ch> wrote:

> > +description: |
> > +  The Intel IXP4xx ethernet makes use of the IXP4xx NPE (Network
> > +  Processing Engine) and the IXP4xx Queue Mangager to process
> > +  the ethernet frames. It can optionally contain an MDIO bus to
> > +  talk to PHYs.
>
> Hi Linus
>
> You mention MDIO and PHYs, but the code is not there yet. When you do
> add the needed code, it is a good idea to place the PHY nodes inside a
> container node:

Actually I think the MDIO needs to go into the NPE (network processing
engine) node, that is where it actually is implemented.

It coincides with having to rewrite the code in Linux to split that off into
its own device as you pointed out on patch 1, hm a bit of work ahead
here...

Yours,
Linus Walleij
