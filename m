Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA535E421
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 14:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfGCMlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 08:41:39 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44770 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfGCMlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 08:41:39 -0400
Received: by mail-lf1-f67.google.com with SMTP id r15so1649521lfm.11
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 05:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xy4atC47KUkhRxvml94Kq1gg6hZsMUYINS4fjvWdvCo=;
        b=McGlDSOxEhWCKthKIE+gpLcPxbWgwKMrrLO60s7Qh4nwlG49H+YLqxceuhzil1otMt
         K37j2Icrf10zt7CxCWNJi1UDiM+ejYhV1kb2j1jWfRnwY8u9S0O8PtNMWArTBz4Gxb7w
         R6teFD8bDFWDPt5c9JoIKrYC48wvC/px85/MDRT+SA9nxDgoBNhSks7DE4FDo61vDmEL
         V0gSZfi9DaWn1asSSQN0/4VhIQ83nmB9GVns7ibbxOSDedWet6lcvPkvFoETlRymLS1n
         yo8SnuurCvS+8qYuBTeAx/GTnUFau/ttRSu97efdls7MS/OtVLUq/sefWcGcGf0dQr7l
         yuZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xy4atC47KUkhRxvml94Kq1gg6hZsMUYINS4fjvWdvCo=;
        b=XW9zd3G9ZX4VWNpAj4QocKArRLI1MTZHKZesxruXcg2OQyUQuuu3mAKq5dvaZw7DC6
         PrHzc66DxLYE+7VQYVN4RGsUhEPBQ7VihW6OumgogII4M9L1rWE08QTEy6xpDUIi21pp
         byjv33vwgw9qfbrRVOc17x4C+nctqta0pbbG9O8m3V5ZGrEinflDVzjWcsNkt0ZQuIFF
         uKzV/2TRiXIu5u4U3PV8h+oQyMGgWRbXAHiFWssQvWtwrdFbnCB7GUsOp7TTEZZbMvqh
         nhlfpEkh/qGuN9bspFO6PKPyRNmXpdjn7Ps9vQr9O4qwWRyURNQeb6nerunFY1suH0bp
         5vdg==
X-Gm-Message-State: APjAAAXMdZJbL43O4UmxV7OZlrmGBK8fz4YK2ojLFPH83HrVZMiYBnKQ
        VglGn/KU2FwkR5aq3ZTqOrq2ch6H76+3EQsO2omPBw==
X-Google-Smtp-Source: APXvYqxSZq8kK+Sf3ly/VpTa30WhTR81fi6H8aQwENAVhDZ+xbderjUjpKdryIIlUpIb+lO7f/hQ0SNAIZdSKuEFh/Q=
X-Received: by 2002:a19:7616:: with SMTP id c22mr18395121lff.115.1562157697300;
 Wed, 03 Jul 2019 05:41:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190701152723.624-1-paweldembicki@gmail.com> <20190703085757.1027-1-paweldembicki@gmail.com>
In-Reply-To: <20190703085757.1027-1-paweldembicki@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 3 Jul 2019 14:41:26 +0200
Message-ID: <CACRpkdabQbVosWjD22E6pM8t3gu8c=5qNMEtRsp2HLV0PJ9nYg@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] net: dsa: Change DT bindings for Vitesse VSC73xx switches
To:     Pawel Dembicki <paweldembicki@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
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

On Wed, Jul 3, 2019 at 10:58 AM Pawel Dembicki <paweldembicki@gmail.com> wrote:

> This commit introduce how to use vsc73xx platform driver.
>
> Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
> ---
> Changes in v2:
> - Drop -spi and -platform suffix
> - Change commit message

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
