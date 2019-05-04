Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAED13B00
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 17:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfEDPlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 11:41:05 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:34223 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfEDPlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 11:41:05 -0400
Received: by mail-ot1-f65.google.com with SMTP id h2so174983oth.1;
        Sat, 04 May 2019 08:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NOqG3X6KeVU8jW9kB98iNlmMsjqP6JLYvww7EO9cTKU=;
        b=CUK4rgKdIDA1cxCLaZilQgFgzUsj9LIn0xHBaVoj+tL1ynJO1ymrgmzCIBt1XKa9DI
         7mjStmXpr4Md2G1X9It7LU6wyMY6LFu0S6zKL7bmKqY+bNDoDktyjuq1kMBlNR3owAYV
         fn8d4tEvrjEXSxRAUphxi0KgZvkd5mQHAeysOjiVrT5NsPY948XFIo8roUsyLuV4nLfc
         cToezmC45OVtOa6mCRXGhiyVILMOff9YGeo4gaTfIneOJAcp1eDoTn5R8Q2riM5NKqcC
         YbhC2kUg/NUE225KMl7PJN8hQF2uMslrUhtUP9fXKkN8freEXF8UCm0LZFuzmbn+Xonv
         q9eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NOqG3X6KeVU8jW9kB98iNlmMsjqP6JLYvww7EO9cTKU=;
        b=e9/KjuUzkp7Pd6MMPLP9p3eULVvJuukO586HbWrZWlVFzP/S1GAuPkHbpR4Si2Y6hW
         Lv4z9f13Z5KJp1Fg8fpHXy/0t0S+BZMtcUt1/79qZUVGuz6QkIYahCKZyAfTP/PIpEwb
         nXd9MZvHex1qSdqMqWD9sicpGVnIBWeWbqHJi7EMkJixE6NETfm3wgGNvnXrTXywsn2C
         pMR3tVdyg7+9fW4LcLY7rxH6NWi8mtWItMPc+36eUeOZz+4TxGdpwgy9tNCm3Jidh8qX
         ByDjc8QssUBquaOJcNb/RVckrzPSh6Xz8wDUzdsTYbwEFy37Iq04/DSuNGBla2WesAMs
         dHHg==
X-Gm-Message-State: APjAAAU0cmGbK0X4b7Z59hXDMHI0FE16LiaaKYelLDx0A6PFwDwS7Ib4
        rK3p0L0w//IY4BNwccWr9bYa6jJ9J+nhWX6Xs+4=
X-Google-Smtp-Source: APXvYqxcHQ/Bg7b3kWRZyf62dPFG7TyyCvCwOhkNH6X/hpK+QcYgbUfM30aI6ikuoHEyWbcw00nNIg2rTZHkgyI0YW8=
X-Received: by 2002:a05:6830:14c2:: with SMTP id t2mr5165076otq.64.1556984464473;
 Sat, 04 May 2019 08:41:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190422064046.2822-1-o.rempel@pengutronix.de>
 <20190422064046.2822-4-o.rempel@pengutronix.de> <20190422132533.GA12718@lunn.ch>
In-Reply-To: <20190422132533.GA12718@lunn.ch>
From:   Chuanhong Guo <gch981213@gmail.com>
Date:   Sat, 4 May 2019 23:40:53 +0800
Message-ID: <CAJsYDVJ84RsNVe9Mj9sYYwwLmmMkinRSJW4ziW22Sf04wS5gyw@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] net: ethernet: add ag71xx driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-mips@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

On Mon, Apr 22, 2019 at 9:28 PM Andrew Lunn <andrew@lunn.ch> wrote:
> [...]
> > +     /*
> > +      * On most (all?) Atheros/QCA SoCs dual eth interfaces are not equal.
> > +      *
> > +      * That is to say eth0 can not work independently. It only works
> > +      * when eth1 is working.
> > +      */
>
> Please could you explain that some more? Is there just one MDIO bus
> shared by two ethernet controllers? If so, it would be better to have
> the MDIO bus controller as a separate driver.

mdio registers exists on both ethernet blocks. And due to how reset
works on this ethernet IP, it's hard to split it into a separated
driver. (Only asserting both eth and mdio resets together will reset
everything including register values.)
The reason why gmac1 should be brought up first is that on some chips,
mdio on gmac0 connects to nothing and phy used by gmac0 is on mdio bus
of gmac1.

> [...]

Regards,
Chuanhong Guo
