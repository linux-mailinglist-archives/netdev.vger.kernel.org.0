Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16965D6928
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 20:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388724AbfJNSKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 14:10:20 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:42446 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732457AbfJNSKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 14:10:20 -0400
Received: by mail-oi1-f193.google.com with SMTP id i185so14479225oif.9;
        Mon, 14 Oct 2019 11:10:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/QGWbxMgyMyTdIAESXcdM36ks75xNEHCQzWTM00H660=;
        b=NyrhzbxE21xepZcRfpfp2HWJZrUfYK/4+nTb4Ihd26T8I9fkGwfFiUUBt9mz2/QZd6
         oQhzdCTCV3ErPNpfqwjiyAeFpEa9NHbomOdhPYbzHpwH0vSB9dzpXgHp0Qp2ZLU/sT9z
         DdB2G00I3UbDaYOebULtwJ/VQJSDAqFC512fE0SJF+DhVhAnpXeycekwJknyktlYqDCN
         MQc0Ans/gFFhqGW7qWCdcf//8ltl30iSqxrpkSZNCvvigJ9GyBxC7LpQp1a6mdPt1r6c
         yeR0T3LLq0FTe//Q8HGViwG21phlcf+oekcY1bsVoIZVwbTtsGM/Ci+PIMlPuH0aUNp9
         DSVA==
X-Gm-Message-State: APjAAAXsZaqsYwACxS+yEgcFegVRh4ui7xy2XnOlQHbbf5IXHi8SFGzo
        vuSOiX3Z3pkayAIfGRjd/w==
X-Google-Smtp-Source: APXvYqw22ZyOSAvp+Y75buzau5AuW+mFqDrz6vb6hKzzOzFK9zoEYkfe/z2qUzWP8ZyjEaKTbvF80A==
X-Received: by 2002:a05:6808:a83:: with SMTP id q3mr25395976oij.12.1571076617934;
        Mon, 14 Oct 2019 11:10:17 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id i13sm5938339otj.58.2019.10.14.11.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 11:10:17 -0700 (PDT)
Date:   Mon, 14 Oct 2019 13:10:16 -0500
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
Subject: Re: [PATCH net-next v2 1/3] dt-bindings: can: rcar_can: Add r8a774b1
 support
Message-ID: <20191014181016.GA1927@bogus>
References: <1570717560-7431-1-git-send-email-fabrizio.castro@bp.renesas.com>
 <1570717560-7431-2-git-send-email-fabrizio.castro@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1570717560-7431-2-git-send-email-fabrizio.castro@bp.renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Oct 2019 15:25:58 +0100, Fabrizio Castro wrote:
> Document RZ/G2N (r8a774b1) SoC specific bindings.
> 
> Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> v1->v2:
> * No change
> 
>  Documentation/devicetree/bindings/net/can/rcar_can.txt | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
