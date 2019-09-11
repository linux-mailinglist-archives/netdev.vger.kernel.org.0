Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B41F2AF6E4
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 09:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbfIKHY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 03:24:59 -0400
Received: from mail-qk1-f181.google.com ([209.85.222.181]:45306 "EHLO
        mail-qk1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbfIKHY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 03:24:58 -0400
Received: by mail-qk1-f181.google.com with SMTP id z67so19778609qkb.12
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 00:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=leLYwCvy4Udhk/KznR1X6HmN07y9rKzHH9+4qUM5IRw=;
        b=Hg/5Z2b8TtNd9r0Jq5lFvHmDp8DMpbi9iyaJAFhHWeWWNedvnzPtl2bEx3yKu9PcSQ
         V+waKtWL6KTqojfu5/G8HbFmRda+7RFT827015wqskR/tzzeHal80FCTn4Zh8dZef+V5
         cfbNJY79Nmlxyqf7J1DkanHOCS48dL2AgPMoSz3Rx0SneeIC7bw9S6dW35hrknFaLZG6
         yeD3Zd7ijqDa1yS2GLz4e8iz0l/vPD0ZgheViFlebZrpgTGP0bZpPb31DEgja00wMOed
         Q/FCItzhju/mJs69BTXKHYjvB7xRMLrUQMeYk3IBxKZtDGwVTBFPeKNMYDfo13IX8Q3S
         Y64A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=leLYwCvy4Udhk/KznR1X6HmN07y9rKzHH9+4qUM5IRw=;
        b=IHBSFw0xuiuhdVPT2c377aVaAHJQTlZ/s2AYiBkDQeuDCNv1iuRLqbFIJN7fg41ATl
         bm9wpCFQxvsvgfqj0EcZCK2BhuS7LnTzxIa1M3oEkwoFU5hHfRgt/mVwpbaN1FW2c9TE
         WLWlAibIWrsuBSSMeW8efDtLzQ7TxJc3Xq77b3aBSjqA5V1G1AHydFb61wI+roP8pH7H
         A2uIFzmuXwzUjf8BvB1QtWItQ7ysyb3qmEYtXh5ZCjC9gQgmhglIoRraiZAF4fnopJgl
         x6DkyBQhxeUqct4tTvwuQGUOtij7qegTHgjDCDaLJK66jD6GateK9ZYlKnxGa9gaamBL
         VwDw==
X-Gm-Message-State: APjAAAWkQEuyiiZZ1XDB5HukchTbnzvadsmzmuTjl0PTDZkqBOXrBz8x
        KIZ0JRhjc1CVlO0T6EL1Y9UxNhDmWFs922SKM/fAnw==
X-Google-Smtp-Source: APXvYqxz5uv104UowOXP7l9y5v0eA95nnULqoISLtDJ/VEnCwsxBzyONDQHlCG/TJLYyRAGhxL/OLqIPrEcUtY1Uzmw=
X-Received: by 2002:a37:a03:: with SMTP id 3mr31835943qkk.405.1568186692301;
 Wed, 11 Sep 2019 00:24:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ2oMhKUTUU0eHTmS62itBw6L9Jut=ps6y8GuVDP44xadn03dw@mail.gmail.com>
 <20190908090551.GC28580@lunn.ch>
In-Reply-To: <20190908090551.GC28580@lunn.ch>
From:   Ranran <ranshalit@gmail.com>
Date:   Wed, 11 Sep 2019 10:25:13 +0300
Message-ID: <CAJ2oMhJKPxDEm=Zhwyfc4CVCd9Esd5PLT76WEUPY_sSyRN3GgA@mail.gmail.com>
Subject: Re: Q: fixed link
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 8, 2019 at 12:05 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sun, Sep 08, 2019 at 10:30:51AM +0300, Ranran wrote:
> > Hello,
> >
> > In documentation of fixed-link it is said:"
> > Some Ethernet MACs have a "fixed link", and are not connected to a
> > normal MDIO-managed PHY device. For those situations, a Device Tree
> > binding allows to describe a "fixed link".
> > "
> > Does it mean, that on using unmanaged switch ("no cpu" mode), it is
> > better be used with fixed-link ?
>
> Hi Ranran
>
> Is there a MAC to MAC connection, or PHY to PHY connection?
>
> If the interface MAC is directly connected to the switch MAC, fixed
> link is what you should use. The fixed link will then tell the
> interface MAC what speed it should use.
>
> If you have back to back PHYs, you need a PHY driver for the PHY
> connected to the interface MAC, to configure its speed, duplex
> etc. The dumb switch should be controlling its PHY, and auto-neg will
> probably work.
>
>          Andrew


Hi,

We are using RGMII mode with the switch, which probably means
mac-to-mac (as far as I understand).

Does it mean we can choose between these 2 options:
1. configure dsa switch in device tree
2. configure fixed link in device tree


Thanks,
ranran
