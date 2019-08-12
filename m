Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA7B8A6BF
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 21:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfHLTCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 15:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbfHLTCO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 15:02:14 -0400
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2100206C1;
        Mon, 12 Aug 2019 19:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565636533;
        bh=2Ey7LQhifd90JzjBnFtp3v8Cz42z64Zc1kv+o9XY4RE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Zj407EmjJWov9iMeVmEeLH4KOb2FOMBgAoYu5JPNAjtEbn3onHBeI//Md32KUGP5G
         AxJVy1DBIaLI6QbMKpOFhbiQHlOqxN3DvmMeXjT4U9RJoipt0VSVJb//lCxuk5T/sy
         uNhzF0S1UObgMhD7XvwZXIRMLGwK7ztlaNLFwIXQ=
Received: by mail-qt1-f170.google.com with SMTP id t12so15333479qtp.9;
        Mon, 12 Aug 2019 12:02:12 -0700 (PDT)
X-Gm-Message-State: APjAAAVqN21+4ACIONmdvZ6QMJQhV0GcqyQS4EiXY0HlA6DiqEJJA67v
        NMxHcR69dd+a9ylpWirD/dyx04esngfZeSfBig==
X-Google-Smtp-Source: APXvYqwm4oyAxCrOUtCaP/9WaxP5YFDXwYDFJy+uHeBuYWFEg/iMIC/MWdeH5kfUWTc7vfc3VmRpQMaCqUlNSzOqFUA=
X-Received: by 2002:ad4:4050:: with SMTP id r16mr6495889qvp.200.1565636532143;
 Mon, 12 Aug 2019 12:02:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190812112350.15242-1-alexandru.ardelean@analog.com> <20190812112350.15242-15-alexandru.ardelean@analog.com>
In-Reply-To: <20190812112350.15242-15-alexandru.ardelean@analog.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 12 Aug 2019 13:02:00 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLYFiuD6G6jDTxSz0m9N3xBRRQTcAv0PUeza_kwTyuVOg@mail.gmail.com>
Message-ID: <CAL_JsqLYFiuD6G6jDTxSz0m9N3xBRRQTcAv0PUeza_kwTyuVOg@mail.gmail.com>
Subject: Re: [PATCH v4 14/14] dt-bindings: net: add bindings for ADIN PHY driver
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 5:24 AM Alexandru Ardelean
<alexandru.ardelean@analog.com> wrote:
>
> This change adds bindings for the Analog Devices ADIN PHY driver, detailing
> all the properties implemented by the driver.
>
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> ---
>  .../devicetree/bindings/net/adi,adin.yaml     | 73 +++++++++++++++++++
>  MAINTAINERS                                   |  1 +
>  2 files changed, 74 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/adi,adin.yaml

Reviewed-by: Rob Herring <robh@kernel.org>
