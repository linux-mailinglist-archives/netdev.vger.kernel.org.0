Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F31FA9661A
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 18:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730344AbfHTQS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 12:18:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbfHTQS0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 12:18:26 -0400
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D55552339E;
        Tue, 20 Aug 2019 16:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566317905;
        bh=vSKsKdK9IvnILRtQlA/Vlb4e7VL6KyuijFf6Qr77Vyo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rRV0pwJXloEA2wNuxVron9horY8auSq1BuVfOvOfOJOzq16YPdKwyCVAqcu741qWd
         pAcXdP6ctMpLOsa/Yw24IZGOwNDXfnOuP6zZH0C3+NpHKNVUH9JSre1teubo59ATJS
         1Oohlb7ZuWpnYUulw9Y00xF1uDgKA/YqNNr5VNE4=
Received: by mail-qt1-f182.google.com with SMTP id y26so6687743qto.4;
        Tue, 20 Aug 2019 09:18:24 -0700 (PDT)
X-Gm-Message-State: APjAAAXAOwDMIu7XoaEfwbihkZw2j/zHC88foqRVF8TxiG18yqiggtCJ
        uBcYD5HLDfwmnBlMNn77SLojrRA4+9P8VM/Veg==
X-Google-Smtp-Source: APXvYqycMaa214ptNayJBYSEm7y6VToBsSlNqtP2In+5+f5juo9lDSmILxM4UZrWQJSIt7mf+ihWQZGtHJECipi/vbw=
X-Received: by 2002:a0c:9782:: with SMTP id l2mr15058937qvd.72.1566317903978;
 Tue, 20 Aug 2019 09:18:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190820145343.29108-1-megous@megous.com> <20190820145343.29108-2-megous@megous.com>
In-Reply-To: <20190820145343.29108-2-megous@megous.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 20 Aug 2019 11:18:12 -0500
X-Gmail-Original-Message-ID: <CAL_JsqL-fBA5fV=AwegyGpCKAEHtU1C6MZQX9dNYs0tpL9EbVw@mail.gmail.com>
Message-ID: <CAL_JsqL-fBA5fV=AwegyGpCKAEHtU1C6MZQX9dNYs0tpL9EbVw@mail.gmail.com>
Subject: Re: [PATCH 1/6] dt-bindings: net: sun8i-a83t-emac: Add phy-supply property
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
> This is already supported by the driver, but is missing from the
> bindings.

Really, the supply for the phy should be in the phy's node...

>
> Signed-off-by: Ondrej Jirman <megous@megous.com>
> ---
>  .../devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml    | 4 ++++
>  1 file changed, 4 insertions(+)

Reviewed-by: Rob Herring <robh@kernel.org>
