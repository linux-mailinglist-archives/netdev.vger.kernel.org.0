Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4081D16AF11
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 19:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgBXS15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 13:27:57 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:34240 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727483AbgBXS15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 13:27:57 -0500
Received: by mail-oi1-f195.google.com with SMTP id l136so9885896oig.1;
        Mon, 24 Feb 2020 10:27:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8b3MliEDFbDrUpBm8jGhwYqreoGs6m8FNnF/yNIueEU=;
        b=BkRg2/6gEsYakveiAVaz5/SLu28xZ5uKrq6Zg22HgyTQAjavyWMUPy8gNAfUV4xorW
         E++f5oMa/9O5R6BH3cxB/tP1qodo6qjrXebTii0dtv0aI9Q4qcn7fuXtC8DF8A1HGlOI
         0PcZFnSVYDSJxwgi4xl53s550fCKeqh4rmkcykM17IsyJn1MZU6Po3uujNL1SWDFxkOW
         kYRia9cw9SWa0lSLVJ49ng5z4RTTDYDuISpOExK1XcLnn8CDW6Mf41jIX/p+3KkGJsAS
         Bvw4iR593L59oPXqYg2TPTOHhHwZ+YqmzHe9ip0zWM6ZdYyD3HIRnBed5GKcYXh/TRBL
         +kmw==
X-Gm-Message-State: APjAAAWzU2PAOj6NnKUk0FWL4zDcNmVEmfkyRHNsA2p6PVA9OADeof/1
        CyzdZRNMreOwTzLvaZqPjQ==
X-Google-Smtp-Source: APXvYqyzy4iiGXu+ZZ3t2yBP3j4K/yU2pKb0H/blTr6+iujeHVCL8mJihe7tO3CjLAVcADKqUCNWGQ==
X-Received: by 2002:aca:bfc2:: with SMTP id p185mr318449oif.57.1582568876626;
        Mon, 24 Feb 2020 10:27:56 -0800 (PST)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id v10sm4255017oic.32.2020.02.24.10.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 10:27:56 -0800 (PST)
Received: (nullmailer pid 13156 invoked by uid 1000);
        Mon, 24 Feb 2020 18:27:55 -0000
Date:   Mon, 24 Feb 2020 12:27:55 -0600
From:   Rob Herring <robh@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Piotr Sroka <piotrs@cadence.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Olivier Moysan <olivier.moysan@st.com>,
        Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] docs: dt: fix several broken doc references
Message-ID: <20200224182755.GB27161@bogus>
References: <0e530494349b37eb2eab4a8eccf56626e0b18e6d.1582448388.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e530494349b37eb2eab4a8eccf56626e0b18e6d.1582448388.git.mchehab+huawei@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 23, 2020 at 09:59:53AM +0100, Mauro Carvalho Chehab wrote:
> There are several DT doc references that require manual fixes.
> I found 3 cases fixed on this patch:
> 
> 	- directory named "binding/" instead of "bindings/";
> 	- .txt to .yaml renames;
> 	- file renames (still on txt format);
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  .../devicetree/bindings/mtd/cadence-nand-controller.txt       | 2 +-
>  .../devicetree/bindings/net/brcm,bcm7445-switch-v4.0.txt      | 2 +-
>  Documentation/devicetree/bindings/sound/st,stm32-sai.txt      | 2 +-
>  Documentation/devicetree/bindings/sound/st,stm32-spdifrx.txt  | 2 +-
>  Documentation/devicetree/bindings/spi/st,stm32-spi.yaml       | 2 +-
>  MAINTAINERS                                                   | 4 ++--
>  .../devicetree/bindings/net/wireless/siliabs,wfx.txt          | 2 +-
>  7 files changed, 8 insertions(+), 8 deletions(-)

Applied.

Rob
