Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5259947D6B1
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 19:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344677AbhLVS0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 13:26:04 -0500
Received: from mail-qk1-f170.google.com ([209.85.222.170]:45950 "EHLO
        mail-qk1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234920AbhLVS0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 13:26:03 -0500
Received: by mail-qk1-f170.google.com with SMTP id e16so3134659qkl.12;
        Wed, 22 Dec 2021 10:26:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EiNGic/7Uk0xRMXUuPRSvEzPSJgDKtizB/7NByrGUGI=;
        b=cOLol6yZWmMVUhusoh67nGFrimNvGgMMJUYW7oBHoWoUpq+hhrfswFHGiK5vIRm5Rs
         nKyV514YVsCaCLc0Cxvj8ZRS8N+BxGr1sg9QWFu5yIss/WTJW81E3fqYpf7O+Jzmp4b2
         LxMZqjDPiBYtdp/p6rhGVwEAXgHMMxrHd0GiQgfldTnb+wD4AOoHRonfhTRSGT34qyFN
         4E4t4PKIDpP0hk8+hBNIFYeyWhhQzvioeLO7cfUclS96e5ZH6q3gqti1vR4O7nNG4lQz
         78Laj8GsR8rM6A9I/WnfiLx9K4xo3Y2+evFb66CKaxa7N/qO3QvxGtdXO3cHqwmdcQU8
         DFHw==
X-Gm-Message-State: AOAM531xiE+Yu1eN3d3BWtgVw4+M7cUncxYzglTE4OGxUUGCsL6Vghmg
        WzA+R0ArA7PdeLxpyT1DpA==
X-Google-Smtp-Source: ABdhPJwOW3FRILTSWh8U0aXGgKx7xFeVB1FWT0QX0oRjOofQ2fVd2uqCF0UyrnlL8DxlBvLTKaH1kQ==
X-Received: by 2002:a05:620a:24d4:: with SMTP id m20mr2891229qkn.575.1640197561906;
        Wed, 22 Dec 2021 10:26:01 -0800 (PST)
Received: from robh.at.kernel.org ([24.55.105.145])
        by smtp.gmail.com with ESMTPSA id o10sm2329911qtx.33.2021.12.22.10.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 10:26:01 -0800 (PST)
Received: (nullmailer pid 2459647 invoked by uid 1000);
        Wed, 22 Dec 2021 18:25:59 -0000
Date:   Wed, 22 Dec 2021 14:25:59 -0400
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-serial@vger.kernel.org, netdev@vger.kernel.org,
        Vinod Koul <vkoul@kernel.org>, devicetree@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, dmaengine@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-clk@vger.kernel.org,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Linus Walleij <linus.walleij@linaro.org>,
        Biju Das <biju.das.jz@bp.renesas.com>
Subject: Re: [PATCH 08/16] dt-bindings: clock: Add R9A07G054 CPG Clock and
 Reset Definitions
Message-ID: <YcNtt4vloXXGwZe5@robh.at.kernel.org>
References: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20211221094717.16187-9-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221094717.16187-9-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Dec 2021 09:47:09 +0000, Lad Prabhakar wrote:
> From: Biju Das <biju.das.jz@bp.renesas.com>
> 
> Define RZ/V2L (R9A07G054) Clock Pulse Generator Core Clock and module
> clock outputs, as listed in Table 7.1.4.2 ("Clock List r1.0") and also
> add Reset definitions referring to registers CPG_RST_* in Section 7.2.3
> ("Register configuration") of the RZ/V2L Hardware User's Manual (Rev.1.00,
> Nov.2021).
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  include/dt-bindings/clock/r9a07g054-cpg.h | 226 ++++++++++++++++++++++
>  1 file changed, 226 insertions(+)
>  create mode 100644 include/dt-bindings/clock/r9a07g054-cpg.h
> 

Acked-by: Rob Herring <robh@kernel.org>
