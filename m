Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09302AC59A
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 20:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731271AbgKIT4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 14:56:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731228AbgKIT4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 14:56:50 -0500
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07351C0613CF;
        Mon,  9 Nov 2020 11:56:50 -0800 (PST)
Received: by mail-ua1-x942.google.com with SMTP id x13so3027009uar.4;
        Mon, 09 Nov 2020 11:56:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XDhDGc6eoDcjqpgQzXxY/nhRBOdKhyEfrea2lIPqfPU=;
        b=h3HUnJDl2LpWAoYiqzgHyrszXOc9V6fYf3xWsih3QDsLcMYFfiHvOtB6snU0wDZt7a
         h5/3ht4GeDmNuvu0xLewFKPvDbyOHke2I2C4dhtOjqY+6h8mNDO88wxUC4+EnsUbDZ18
         9UDvAxcNo6fKH6Dr2mZlTaYbVQape3APpttJNZr1aqIQ/Y9ygqfuhdDi19Z6pCucrMhp
         hT3Imvpm8HUlLQo4/s8uo6y4YgN/EAQDGAS3VJEuKr1d4slBdMYFnxBAokBVKIO2yKsB
         h7kbKPMdErVwHGZvVKu/okFWHCXBqzhjYZ+2J2CwNDM0bHYWsbmcoj3aJYbFUx8muStz
         9Pvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XDhDGc6eoDcjqpgQzXxY/nhRBOdKhyEfrea2lIPqfPU=;
        b=SV+2HwrkRlxeIj1xME7ooL49UvKjrPThBvsJ/FcyTNMQ/a6SsO0qse+IY1E+vTIyFR
         jh2GIBSFMVPOc7PfPu/mzfPW3ormNFPXk0IJRC/t3fpF1CsRPysab5jC8eYGbtw4cY1g
         u2y7djjefRSffRI6huIMmYqF0o8OWMnTiz+6RjryKSB6b11T++3Cc8abvMHWjTJipS/v
         EZRR8sg8waORkWvgVLpda16Ri1acRLLDwadB2aBcDpA3Nl9fUdwtGRJLVt8wuy53wwLE
         UvT6tGacnX9A4fI3GXb+6uyB719tFbGn0/2XTnsXmNkK7MZOIQPN8wKhJoPEHLQPIOba
         G5NA==
X-Gm-Message-State: AOAM533h5QpdI3kkRYwbPa2U6FbvorBThfdPqH2eds5yTZL1tBXmbCWA
        090mSXewCO1eyUoJpSSExrmz0Kj9BzSKX733h7w=
X-Google-Smtp-Source: ABdhPJx1XNEo4UYbPdyyMzNjSvjUTFMeO149EmP6Kpy1R13/UljOUS05KCmhNf8n1qcccTwP6zBoXrHT56lnicv4Sxw=
X-Received: by 2002:ab0:5e85:: with SMTP id y5mr7962789uag.101.1604951809104;
 Mon, 09 Nov 2020 11:56:49 -0800 (PST)
MIME-Version: 1.0
References: <20201109193117.2017-1-TheSven73@gmail.com> <20201109194934.GE1456319@lunn.ch>
In-Reply-To: <20201109194934.GE1456319@lunn.ch>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Mon, 9 Nov 2020 14:56:38 -0500
Message-ID: <CAGngYiVV1_65tZRgnzSxDV5mQGAkur8HwTOer9eDMXhBLvBCXw@mail.gmail.com>
Subject: Re: [PATCH net-next v1] net: phy: spi_ks8995: Do not overwrite SPI
 mode flags
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 2:49 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> Did you check to see if there is a help to set just the mode without
> changing any of the other bits?

Absolutely, but it doesn't exist, AFAIK.

It would be great if client spi drivers would use a helper function like
that. The spi bus driver on my platform (imx ecspi) was recently changed
upstream, which means SPI_CS_HIGH is now always set, irrespective
of the actual chip select polarity. This change breaks every single spi
driver which "plows over" the spi->mode flags. And there are quite
a few...

Sven
