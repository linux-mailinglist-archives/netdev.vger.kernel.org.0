Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C47D5D692D
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 20:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733028AbfJNSKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 14:10:38 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:42484 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732457AbfJNSKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 14:10:37 -0400
Received: by mail-oi1-f196.google.com with SMTP id i185so14480042oif.9;
        Mon, 14 Oct 2019 11:10:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=brydErWP+N2L9d45tYVCDfdcZY1kzeEdeJQZ2XYUiZo=;
        b=TXPVhyeXjtUdUYpjGtu4SE7rID1M0RgSDE6WBllbzcrMmr4tbz5KiIX5iwxQ5mz/xM
         nXbvcAIdnC51YHEFya/fomT1XhlUkqyhCyutDYysXVfYVZLcyXj58XTCUmXI3fGOZHYX
         H4VFDw486Tcg3gntoMrFzfvrca5WRiDpMug8JewydoDYijIvtczq2BQOuLXHGJMnq842
         o4oKXay3/RwpHeLZJ+oaZxtWvhdFI4/8AOdIbV80Fhz4DJHEK3nOIqeA5+COCzSJrel9
         7hAE1NZ1s1gjuv6OPytIHlrVRvTWZnDDvXG+8DD66eSucexYYgU6w3q45Z4zIGQlJbVV
         kNmA==
X-Gm-Message-State: APjAAAWm3Id9Liyoi0K1egrnZrB9KKmVU97yNjES8heJo2IPaisOYfzK
        +vcXosHbhPRMAbO+2i7QEA==
X-Google-Smtp-Source: APXvYqw5KLzQfOtdpfE9+NWsb+KZJWl/E35ubmw5Tmx1d08+KqazubLPhRc7Qqi25jW0DFupNKrczw==
X-Received: by 2002:aca:5786:: with SMTP id l128mr283018oib.34.1571076636754;
        Mon, 14 Oct 2019 11:10:36 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id n127sm5791292oia.0.2019.10.14.11.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 11:10:36 -0700 (PDT)
Date:   Mon, 14 Oct 2019 13:10:35 -0500
From:   Rob Herring <robh@kernel.org>
To:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Subject: Re: [PATCH net-next v2 2/3] dt-bindings: can: rcar_canfd: document
 r8a774b1 support
Message-ID: <20191014181035.GA2613@bogus>
References: <1570717560-7431-1-git-send-email-fabrizio.castro@bp.renesas.com>
 <1570717560-7431-3-git-send-email-fabrizio.castro@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1570717560-7431-3-git-send-email-fabrizio.castro@bp.renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Oct 2019 15:25:59 +0100, Fabrizio Castro wrote:
> Document the support for rcar_canfd on R8A774B1 SoC devices.
> 
> Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> v1->v2:
> * Added the R8A774B1 to the clock paragraph according to Geert's comment
> 
>  Documentation/devicetree/bindings/net/can/rcar_canfd.txt | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
