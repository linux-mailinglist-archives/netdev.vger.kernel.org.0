Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C1438BBBB
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 03:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237311AbhEUBl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 21:41:27 -0400
Received: from mail-ot1-f43.google.com ([209.85.210.43]:46835 "EHLO
        mail-ot1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237113AbhEUBlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 21:41:25 -0400
Received: by mail-ot1-f43.google.com with SMTP id d3-20020a9d29030000b029027e8019067fso16598329otb.13;
        Thu, 20 May 2021 18:40:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KrS2ImoxDpLOQ8y1v+DGJnRWn9kr/DL7TH/0NzkYf1Y=;
        b=QA1pYtxBip1P+ZNnVBKT2oGHKVBxsubQmYIGyVdTVtwbTM4ShkpRqrX6/TPk/dSQJ3
         B1REkDDyN+4pfy/4aRDTfgTUp6fYculJhkRIlgtTkc6MhcEc/lf+Cm2QkccEfMjcjXss
         srPmxLDp/y3ogkOCoM1RHgYers53+YKahjkxrPpW9qljDQZmbjKaAdQDy8QUs51VZDKX
         az4gLpvwsMuv9qm0+tBi6FJp58TlcdVuvrBcPT7fUNvhZimSTPIeM6VKYjtjHHI3ry74
         kbqEbxrz6yKLSCyWqnaW3Ra3JTIPDT9YEmAOJ/HlzxwT3ZsFxB2oFGGVYaNwEm508mOS
         RXXg==
X-Gm-Message-State: AOAM531eOqkrlU/wLWJcaXb5njJxVVypPoSkaShbw1sIVD8XIrAW6gte
        vCMN4MHsk/BAoUHo+fQzHQ==
X-Google-Smtp-Source: ABdhPJwCzBEmJz6ZaXDHHd0Fn7AUQ1EMmLZj85T2DCBDFNRlzZ658/eVTfiZ2OBYENpSkiw25M8MWA==
X-Received: by 2002:a05:6830:40a4:: with SMTP id x36mr5950611ott.342.1621561203225;
        Thu, 20 May 2021 18:40:03 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id d67sm873550oia.56.2021.05.20.18.40.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 18:40:02 -0700 (PDT)
Received: (nullmailer pid 2461072 invoked by uid 1000);
        Fri, 21 May 2021 01:40:01 -0000
Date:   Thu, 20 May 2021 20:40:01 -0500
From:   Rob Herring <robh@kernel.org>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>, netdev@vger.kernel.org,
        linux-sunxi@lists.linux.dev, devicetree@vger.kernel.org,
        Samuel Holland <samuel@sholland.org>,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org, Icenowy Zheng <icenowy@aosc.io>,
        Ondrej Jirman <megous@megous.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>
Subject: Re: [PATCH v6 06/17] dt-bindings: net: sun8i-emac: Add H616
 compatible string
Message-ID: <20210521014001.GA2461016@robh.at.kernel.org>
References: <20210519104152.21119-1-andre.przywara@arm.com>
 <20210519104152.21119-7-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519104152.21119-7-andre.przywara@arm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 May 2021 11:41:41 +0100, Andre Przywara wrote:
> Add the obvious compatible name to the existing EMAC binding, and pair
> it with the existing A64 fallback compatible string, as the devices are
> compatible.
> 
> On the way use enums to group the compatible devices together.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  .../devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml    | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
