Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969923DE086
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 22:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhHBUPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 16:15:42 -0400
Received: from mail-il1-f181.google.com ([209.85.166.181]:44546 "EHLO
        mail-il1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbhHBUPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 16:15:41 -0400
Received: by mail-il1-f181.google.com with SMTP id i13so5690420ilm.11;
        Mon, 02 Aug 2021 13:15:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l6ZtgZcaeYXtKquhmALysKTK39kaFSBcFOftEh+yaGM=;
        b=ti7UprY72lUOX+vE1+D+MZc7gIwZdz91GHL53KsS85GtYJWU1x3psHDe+6BMnkhhR2
         qGPE1tvepbHWdW+xpRugGqixsP5ei87zb2COo7Att3ESTnNNayz+huqQBG65ViL8hV7d
         Xy3CZH29YTcrxJdyphfk5wUC3VpszOuhLVH5Rik+2XQD24s1QUGyLO+8x8Ieh5Uc5jaW
         LUxWzsCHam+TX6xSbMnnQBIEV5m+nRX9Z/jYpyiv3mOTEM1iDKwtgkhBFgVbrqOz2ptM
         BjS+c3/85xLGPySQUU5yLDb2iN1T0JLMhJd+IW3JQt2ssHnpMS0kUjvKlriUlLiECL/w
         BYZQ==
X-Gm-Message-State: AOAM531qnPKhH4Ek6ZU8WhvZ5PZosCAoIMjwrBdaA5ga7QVJMYNFHlNf
        WliO7YjO3CgQl1tKb/daeQ==
X-Google-Smtp-Source: ABdhPJzmBamUggwr11FW2bT1mealFL3SP5cqCyBgW8sjhwpC+CG8nW9muHsI8UX5DfIMm05Ek17RVQ==
X-Received: by 2002:a92:ce91:: with SMTP id r17mr304210ilo.264.1627935331680;
        Mon, 02 Aug 2021 13:15:31 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id l16sm1261728ilq.69.2021.08.02.13.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 13:15:31 -0700 (PDT)
Received: (nullmailer pid 1530860 invoked by uid 1000);
        Mon, 02 Aug 2021 20:15:29 -0000
Date:   Mon, 2 Aug 2021 14:15:29 -0600
From:   Rob Herring <robh@kernel.org>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        devicetree@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-renesas-soc@vger.kernel.org,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        netdev@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: Re: [PATCH v2] dt-bindings: net: renesas,etheravb: Document Gigabit
 Ethernet IP
Message-ID: <YQhSYTQRtSh2Dd3o@robh.at.kernel.org>
References: <20210727123450.15918-1-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727123450.15918-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Jul 2021 13:34:50 +0100, Biju Das wrote:
> Document Gigabit Ethernet IP found on RZ/G2L SoC.
> 
> Gigabit Ethernet Interface includes Ethernet controller (E-MAC),
> Internal TCP/IP Offload Engine (TOE) and Dedicated Direct memory
> access controller (DMAC) for transferring transmitted Ethernet
> frames to and received Ethernet frames from respective storage
> areas in the URAM at high speed.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
> v1->v2:
>  * No change. Seperated binding patch from driver patch series as per [1]
>  [1]
>   https://www.spinics.net/lists/linux-renesas-soc/msg59067.html
> v1:-
>  * New patch
> ---
>  .../bindings/net/renesas,etheravb.yaml        | 57 +++++++++++++++----
>  1 file changed, 45 insertions(+), 12 deletions(-)
> 

Applied, thanks!
