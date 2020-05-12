Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014B71D02A0
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 00:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731611AbgELW6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 18:58:16 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:44718 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgELW6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 18:58:15 -0400
Received: by mail-ot1-f65.google.com with SMTP id j4so11921546otr.11;
        Tue, 12 May 2020 15:58:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cBiUIrWE+UaIH5tajkgyIKVaNp7k7WAC/qZUFSsrV2E=;
        b=Quy2hnWtTrPiaE6w/mM3yp7OIxqHlGJ5eM+iUum/AwdpHUe4Rg7MFlDGRaqQAnX1SX
         E6FRZh8GGJ30bZwIrjJFxV1DzHtfhqIuo2/1nqAtZns97/R9JtUPlr3SJ7qEgghjXZ/1
         yVN/FGL/MFQE1W24lrgq7TbHWabnYGDdBC9pvebbrORwN4kLkUKVynIIh4Z0ky7AYaFm
         7j1iTAz0Ed6ci4wuk29R8zsU9PD7wLeeoBfC7+omGslPMb1ZHYocGFpWQkOdEe/Lv37e
         oI+4tl5lVY8WLmlm8yUVBsQhHG5EXMR9MpWhiKf/TCO2LW0ZBLSFK9e9LyckdmNOBVn7
         MQmw==
X-Gm-Message-State: AGi0PuYRrcYZUMViwY50619klgPsRgqJLAmWkrR+uJzMK7lM4wCfkBB7
        +gOLrJlN6G1cUJOLJ7foTw==
X-Google-Smtp-Source: APiQypL7PdOIK7Is7Nz5WrJlgO2HUyJLl2vgiulZfCULhki8ejQCn9T9ykjPsFKJznmjeuGro1Uq+g==
X-Received: by 2002:a05:6830:22f8:: with SMTP id t24mr18122890otc.148.1589324294619;
        Tue, 12 May 2020 15:58:14 -0700 (PDT)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id w62sm5632505oia.32.2020.05.12.15.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 15:58:13 -0700 (PDT)
Received: (nullmailer pid 32342 invoked by uid 1000);
        Tue, 12 May 2020 22:58:12 -0000
Date:   Tue, 12 May 2020 17:58:12 -0500
From:   Rob Herring <robh@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Sandy Huang <hjc@rock-chips.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jyri Sarha <jsarha@ti.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Olivier Moysan <olivier.moysan@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        linux-bluetooth@vger.kernel.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH] docs: dt: fix broken links due to txt->yaml renames
Message-ID: <20200512225812.GA28862@bogus>
References: <967df5c3303b478b76199d4379fe40f5094f3f9b.1588584538.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <967df5c3303b478b76199d4379fe40f5094f3f9b.1588584538.git.mchehab+huawei@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 04, 2020 at 11:30:20AM +0200, Mauro Carvalho Chehab wrote:
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
> 
> PS.: This patch is against today's linux-next.

That's not a base anyone can apply this patch against.

> 
> 
>  .../devicetree/bindings/display/bridge/sii902x.txt          | 2 +-
>  .../devicetree/bindings/display/rockchip/rockchip-drm.yaml  | 2 +-
>  .../devicetree/bindings/net/mediatek-bluetooth.txt          | 2 +-
>  .../devicetree/bindings/sound/audio-graph-card.txt          | 2 +-
>  .../devicetree/bindings/sound/st,sti-asoc-card.txt          | 2 +-
>  Documentation/mips/ingenic-tcu.rst                          | 2 +-
>  MAINTAINERS                                                 | 6 +++---
>  7 files changed, 9 insertions(+), 9 deletions(-)
