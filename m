Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC9696623
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 18:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730431AbfHTQUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 12:20:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726742AbfHTQUf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 12:20:35 -0400
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A059233FF;
        Tue, 20 Aug 2019 16:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566318034;
        bh=MhrM+wnpo98DgCvfrw9p71rUiiQM/sQQEu+zF5hCEp8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tbPSe22P0yz80TXNq+TmiToY5Gbdd0QxeDFmQRKu5Ab/jv0rBQmWVmx5VHcyohU9E
         hqStg44RSY2kOyVylH5IMtvL8hTYXAs6XgqvTgi7+HXsdEoe5B9ToOJwko/jiNU7ul
         Wvz6OTpFY1A7xSXjAko24tJBv7z2fLHTP8z84w20=
Received: by mail-qt1-f181.google.com with SMTP id b11so6668603qtp.10;
        Tue, 20 Aug 2019 09:20:34 -0700 (PDT)
X-Gm-Message-State: APjAAAWa9UuQ+aGIXfwN70WOqcpw9CDgXP0m1H66fd/8XECkGxdjZGo8
        EKjaGGXL2nQNJkdUqLGP8CbtwBFmUwpOGK1VGw==
X-Google-Smtp-Source: APXvYqxQulqOuuzJ0nzppEZjKqYQUJ1LWIXaKSrDPdDKV1V49e8+VUYVdf8eB0g9VTWSMt7oK6gWHJ7swc+TgOoIpDE=
X-Received: by 2002:a0c:eb92:: with SMTP id x18mr15088587qvo.39.1566318033661;
 Tue, 20 Aug 2019 09:20:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190820145343.29108-1-megous@megous.com> <20190820145343.29108-3-megous@megous.com>
In-Reply-To: <20190820145343.29108-3-megous@megous.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 20 Aug 2019 11:20:22 -0500
X-Gmail-Original-Message-ID: <CAL_JsqLHeA6A_+ZgmCzC42Y6yJrEq6+D3vKn8ETh2D7LJ+1_-g@mail.gmail.com>
Message-ID: <CAL_JsqLHeA6A_+ZgmCzC42Y6yJrEq6+D3vKn8ETh2D7LJ+1_-g@mail.gmail.com>
Subject: Re: [PATCH 2/6] dt-bindings: net: sun8i-a83t-emac: Add phy-io-supply property
To:     Ondrej Jirman <megous@megous.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 9:53 AM <megous@megous.com> wrote:
>
> From: Ondrej Jirman <megous@megous.com>
>
> Some PHYs require separate power supply for I/O pins in some modes
> of operation. Add phy-io-supply property, to allow enabling this
> power supply.

Perhaps since this is new, such phys should have *-supply in their nodes.

>
> Signed-off-by: Ondrej Jirman <megous@megous.com>
> ---
>  .../devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml    | 4 ++++
>  1 file changed, 4 insertions(+)
