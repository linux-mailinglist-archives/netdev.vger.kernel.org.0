Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01283D69C0
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 00:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbhGZWGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 18:06:16 -0400
Received: from mail-il1-f176.google.com ([209.85.166.176]:35771 "EHLO
        mail-il1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbhGZWGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 18:06:15 -0400
Received: by mail-il1-f176.google.com with SMTP id k3so10492186ilu.2;
        Mon, 26 Jul 2021 15:46:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3xQehkSUJPoWNPYuDHJm1QnxjcYyWYFk9UbyBzQlc28=;
        b=fiijZC/uKm17ruX5yeL4b8mkP7HSZWI78K5MdxUImiqNRM+x/JObPWQsZDX6Y95E2t
         G+M7fNQ71KmFmttjHwUaa5D1rW9aDBhZSAMCiNw0ZKKfbmxhSwaaGPib4TWZa3LkjrjR
         aN0fmB77OisEHPypC7KFBNLWWtVj5daFldLFfyEmVhO39NDQQsAen/5CtnhhffZ3zVaV
         AKs68xfBy+AkU4EECUP1y5LRNyGXila3zAqqvtzPPLo1EQyAM/425pvCVfGdDJygrdEs
         aZIfaZLEPwzrmsBrOqE4+I3rzTp04wiESmLkDi80tnQd6oR+jQGtlG3Ls+jbuAez0tOK
         yP7A==
X-Gm-Message-State: AOAM530ObspJxoMW4zGdbvI+JQICx5VSIuCIaaGkK4F2aDO5F6lxa20g
        dO192m3hN91lRZjVE7rSyg==
X-Google-Smtp-Source: ABdhPJwDc13JBpgUC2buiYv21chtkxuE8Z5+P9ZXkwf8q5nqGwMPgfEfdyvXy6GjrwD0UXaAVbnaFA==
X-Received: by 2002:a92:cf42:: with SMTP id c2mr14412234ilr.138.1627339602803;
        Mon, 26 Jul 2021 15:46:42 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id b8sm605563ilh.74.2021.07.26.15.46.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 15:46:42 -0700 (PDT)
Received: (nullmailer pid 1016217 invoked by uid 1000);
        Mon, 26 Jul 2021 22:46:40 -0000
Date:   Mon, 26 Jul 2021 16:46:40 -0600
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        devicetree@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-renesas-soc@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] dt-bindings: net: can: renesas,rcar-canfd:
 Document RZ/G2L SoC
Message-ID: <20210726224640.GA1016160@robh.at.kernel.org>
References: <20210721194951.30983-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20210721194951.30983-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210721194951.30983-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Jul 2021 20:49:49 +0100, Lad Prabhakar wrote:
> Add CANFD binding documentation for Renesas RZ/G2L SoC.
> 
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  .../bindings/net/can/renesas,rcar-canfd.yaml  | 69 +++++++++++++++++--
>  1 file changed, 63 insertions(+), 6 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
