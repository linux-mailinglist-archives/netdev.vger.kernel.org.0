Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80FD73EF580
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 00:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235459AbhHQWKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 18:10:49 -0400
Received: from mail-oi1-f173.google.com ([209.85.167.173]:46634 "EHLO
        mail-oi1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbhHQWKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 18:10:48 -0400
Received: by mail-oi1-f173.google.com with SMTP id o185so1361595oih.13;
        Tue, 17 Aug 2021 15:10:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uuDTZ+E5TViZz+9gRcz0712dMeUAPHHlujaFe5lJlNA=;
        b=TbHvNah6C5+/Q9jR9pqCtsLl3qOnGf9bWRb53OpXs+ZXRhDff440YKyywCx96snd1k
         vi9Ohvzgg56HblPvi/oqfB7g8Ul31PBwPjkrjj2/8I5/1A3HZqkP6ljoXgqsdyhXK92D
         y78oxqZFL+iDpxc5MDl+KUSmIfcH8UDeKpcvByE+s0ruQM7BwvThMjpj8e50jxv0GnbH
         o8KHhZ4rH4X1eByxNwARtIChDsXs74QRQdwtaSeTi0sukB1oZcD8Ur63w9B6PFN8Shvl
         +79bSdv6Qnbu5ZgwTsF0IXqE7uTUruAHbj3qTkwgZUfGPijgcVhCwgrp51I1pFgpUs9P
         J2Lw==
X-Gm-Message-State: AOAM5311WQ7c0i1WxHrTq6CUdSNQGOfuxEpTDHei/tR2VDb/hf4CMC1v
        Q3jzER29rBbcpw9hky8iQA==
X-Google-Smtp-Source: ABdhPJzkxYmwgLM/9/VvH2tnvrVzOr5znCO3oXXa5qSfCqfzTDYroc4oQWceBwtCfe7UR9WA8ueaMg==
X-Received: by 2002:aca:5c57:: with SMTP id q84mr4252716oib.159.1629238214303;
        Tue, 17 Aug 2021 15:10:14 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id a6sm645020oto.36.2021.08.17.15.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 15:10:13 -0700 (PDT)
Received: (nullmailer pid 927925 invoked by uid 1000);
        Tue, 17 Aug 2021 22:10:12 -0000
Date:   Tue, 17 Aug 2021 17:10:12 -0500
From:   Rob Herring <robh@kernel.org>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH] dt-bindings: net: renesas,etheravb: Drop "int_" prefix
 and "_n" suffix from interrupt names
Message-ID: <YRwzxNrZvgQutEch@robh.at.kernel.org>
References: <20210815133926.22860-1-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210815133926.22860-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Aug 2021 14:39:26 +0100, Biju Das wrote:
> This patch updates interrupt-names with dropping "int_" prefix and
> "_n" suffix.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
> Ref:- https://lore.kernel.org/linux-renesas-soc/CAMuHMdU6iO+LkL5WURGMN7kkYLRJe9v3MbrqA_CBp74oskdeyA@mail.gmail.com/T/#t
> ---
>  Documentation/devicetree/bindings/net/renesas,etheravb.yaml | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Applied, thanks!
