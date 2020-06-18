Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B31A1FF983
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731978AbgFRQoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 12:44:37 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:35679 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728090AbgFRQog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 12:44:36 -0400
Received: by mail-io1-f68.google.com with SMTP id s18so7822174ioe.2;
        Thu, 18 Jun 2020 09:44:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P6K0NMCQ9QdVvPAqikzClu5E67Y9Qrb4CGCZ1kreB7k=;
        b=lQQF7kigInRkQfosEdD964L/MxE8WBfqhlcjat7uGcKAHLo05DRETCrqGSyks++q+N
         LD4YhxofHAtxiU5+rHlIy3fj7hI2j+51pQtcM6jdo+VhoSuWboDrT/C3r1LucoJ5fPo8
         XH90hJcCZpxLydo/zfi86U+YTKyjFpcCynbHwPNVBykLh/AwfkGFiYvV01UC7Njcn9Fm
         i7JzC87Ts5XcXKgf8rWto+0uBp8pgMrufHPIklBNXVWtmArrkvPMRXYS+6uQQNqXM3nF
         lkAvJYLMGcm+LVrud0JLT3mPZ6pXFG4l0Cfon9dqlnZ+CMrhPV3AS8sCW/3sHC9A7wxY
         h+Og==
X-Gm-Message-State: AOAM532zD6wytvJDMt90fD2r8Vx2DFdu1IjS513iNUXpDm7pYMOGOlBs
        R7JCddqfLJIs+WZMZ6CLdg==
X-Google-Smtp-Source: ABdhPJwkW4ZsJ4bdYKr0qKa9ryOy5g+2hE48HtjOUzrbj3WgzjP+FDJi5kL2BbFKLOci4Y0m6ArWyw==
X-Received: by 2002:a5d:858a:: with SMTP id f10mr6056867ioj.184.1592498674934;
        Thu, 18 Jun 2020 09:44:34 -0700 (PDT)
Received: from xps15 ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id g21sm1969126ioc.14.2020.06.18.09.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 09:44:34 -0700 (PDT)
Received: (nullmailer pid 504576 invoked by uid 1000);
        Thu, 18 Jun 2020 16:44:31 -0000
Date:   Thu, 18 Jun 2020 10:44:31 -0600
From:   Rob Herring <robh@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-rockchip@lists.infradead.org,
        Daniel Vetter <daniel@ffwll.ch>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Jonathan Corbet <corbet@lwn.net>,
        linux-arm-kernel@lists.infradead.org,
        Sandy Huang <hjc@rock-chips.com>, alsa-devel@alsa-project.org,
        Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 13/29] dt: fix broken links due to txt->yaml renames
Message-ID: <20200618164431.GA504444@bogus>
References: <cover.1592203542.git.mchehab+huawei@kernel.org>
 <0e4a7f0b7efcc8109c8a41a2e13c8adde4d9c6b9.1592203542.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e4a7f0b7efcc8109c8a41a2e13c8adde4d9c6b9.1592203542.git.mchehab+huawei@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Jun 2020 08:46:52 +0200, Mauro Carvalho Chehab wrote:
> There are some new broken doc links due to yaml renames
> at DT. Developers should really run:
> 
> 	./scripts/documentation-file-ref-check
> 
> in order to solve those issues while submitting patches.
> This tool can even fix most of the issues with:
> 
> 	./scripts/documentation-file-ref-check --fix
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  Documentation/devicetree/bindings/display/bridge/sii902x.txt  | 2 +-
>  .../devicetree/bindings/display/rockchip/rockchip-drm.yaml    | 2 +-
>  Documentation/devicetree/bindings/net/mediatek-bluetooth.txt  | 2 +-
>  Documentation/devicetree/bindings/sound/audio-graph-card.txt  | 2 +-
>  Documentation/devicetree/bindings/sound/st,sti-asoc-card.txt  | 2 +-
>  Documentation/mips/ingenic-tcu.rst                            | 2 +-
>  MAINTAINERS                                                   | 4 ++--
>  7 files changed, 8 insertions(+), 8 deletions(-)
> 

Applied, thanks!
