Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 681C05C446
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 22:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfGAUXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 16:23:45 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37719 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfGAUXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 16:23:44 -0400
Received: by mail-lj1-f195.google.com with SMTP id 131so14550721ljf.4
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 13:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2yeezC43PYS18W/SIzQiodt0jp2d2/Hn/sPPvB7Hkrs=;
        b=fvRVEuWalo7Pr6238+rkM+9g1mlIvP6z++a9qdgrfo11+VJyASL1zgTmiIwKi5iMMT
         YShRpuwPqGemeFZ7Z1VHUgwgWQVG4CtuVQki/LnGJ/ZSHEYN8zuBYrVylZDsn+HKSYbp
         kBYu5NSjWoUZTfta3+Lvc1Cabxww2yqA6eBvfAoNI3iFLNr4murQmwNjSQqHjEiA/6kE
         CMQT6EWcfQhNt2/XgGug8SxMLCVnV8ec3pNaGs0S04+U8TV+oYfv5Dq/+LzzRQVB8zpJ
         CyNinv4oxe6ZcmMyqSVS1+GAOu2jd7E9RJ9EGZQ6IggtKvPw+34fkt0kOCVGw3+OIHRj
         FeYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2yeezC43PYS18W/SIzQiodt0jp2d2/Hn/sPPvB7Hkrs=;
        b=SDNEBc6vStsdtTDaGa0H85a5mfihqXwAjBW+vroxKplSsfsdFA/aUVeAHQkWsXqspm
         AJk0T7dv3ApcEsM3Ku4GQXWF5bKLiM4J6phES3H4pQOdlPZTmlc7oEp5NZm+o3gqErDS
         h1fsClA3trkOXPcNYRp06rkoZzDha2knzUK5PS4zAgTzZsLuGWbYj5GroYea6xr9vqMv
         hbyma2Eqf5Km3HtQr5mDBKT27wrfX7dba/rCI4tGj3Pl1ajWYCNw9CJnIGbJffVHw0U+
         y2b8eCju2UB7l109PP5lbHTL0nPc2aATYM9AbEGGHsE3GB+Qd0gjKpdbPvi/kqync7f0
         8evw==
X-Gm-Message-State: APjAAAXNLWISQoWS9nJPpJOXVc0hL4rPOryIaWATJEjL1MO0ZTVeABqU
        6ZkoIfAWohbldfPxEiChBHnRkTuA1l1Xd/IgpXpj4w==
X-Google-Smtp-Source: APXvYqyUxzE1vHY3FGSByUi6GK2txxEik41ysV2f+vH6fGH86OktUnzJ178axhcKMNZYGvJVxtG9YJ2PxCvsjyXPERM=
X-Received: by 2002:a2e:81d8:: with SMTP id s24mr15172028ljg.37.1562012622393;
 Mon, 01 Jul 2019 13:23:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190701152723.624-1-paweldembicki@gmail.com> <45ff597a-5090-3874-b43d-5b5f45d2d2f6@gmail.com>
In-Reply-To: <45ff597a-5090-3874-b43d-5b5f45d2d2f6@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 1 Jul 2019 22:23:30 +0200
Message-ID: <CACRpkdaQhv+4RG8k+QaCE9F3-Oeo8-rjSqGgakr8r2pyOkyoGw@mail.gmail.com>
Subject: Re: [PATCH 1/4] net: dsa: Change DT bindings for Vitesse VSC73xx switches
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Pawel Dembicki <paweldembicki@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 1, 2019 at 6:44 PM Florian Fainelli <f.fainelli@gmail.com> wrote:

> Take b53 for instance which supports MDIO and SPI by default, and
> optionally memory mapped and SRAB (indirect memory map) accesses, they
> all have the same compatible strings. Whether the switches will appear
> as spi_device, platform_device, or something else is entirely based on
> how the Device Tree is laid out.

That's clever.

Pawel can you restructure the series around this observation?

Yours,
Linus Walleij
