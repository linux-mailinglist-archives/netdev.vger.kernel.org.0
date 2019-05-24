Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E41E22A0BE
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 23:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404331AbfEXVzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 17:55:51 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:43971 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404259AbfEXVzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 17:55:51 -0400
Received: by mail-ot1-f66.google.com with SMTP id i8so9993501oth.10;
        Fri, 24 May 2019 14:55:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1Hd5HUE8FtAVIHZ0zOMuprsDH1qucHlAidVwNXNR0kE=;
        b=BcVJGqM10NqxsRnBFu3wEP26yf3AVll/Pjy/3Q+Q2g9YNIntg5Pb9/TR06pk57L2Pl
         ICoYnrvZEW5aFu5jpMCYt3RfKRMyQkXiM0t6FB+3RCfGCiIgFRaKkvXE5Xe6NKuISssL
         vYTPaO6j6Ny3H75TOIcAmroLtziJlWwtdb7xIEin9R+cg/Q2Cw37P+/M7XI/ogwH53mU
         cjH62njcllRoksuf1igvVD+6gV3NnQo2+U+AwL5XjRYefd/gbF9JbpXcY53MmxfSKPj4
         0LAXdsqApFcIGBHw/uduQE1nUdvjOecz3ObcPHGrW8V9OpIzcVqcauzLbdyKBOJriTAR
         kCxQ==
X-Gm-Message-State: APjAAAUXyrGBdf/d0vE9L7UXoUw4DjNRx5gbx8XL/kwYVxVvg3Ui/TR0
        GGrIpesQm5aD9blUbbOEcCjrt4w=
X-Google-Smtp-Source: APXvYqx38nwGxFFCwmvC358jGtt2sCWNYPbMOthN/1AGAmXZzhMX9GG7akLemxmhb6zk5JKBh2ArBw==
X-Received: by 2002:a9d:6312:: with SMTP id q18mr14150968otk.45.1558734950429;
        Fri, 24 May 2019 14:55:50 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id b25sm1193569otq.65.2019.05.24.14.55.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 14:55:49 -0700 (PDT)
Date:   Fri, 24 May 2019 16:55:49 -0500
From:   Rob Herring <robh@kernel.org>
To:     megous@megous.com
Cc:     linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Ondrej Jirman <megous@megous.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH v5 4/6] dt-bindings: display: hdmi-connector: Support DDC
 bus enable
Message-ID: <20190524215549.GA13928@bogus>
References: <20190520235009.16734-1-megous@megous.com>
 <20190520235009.16734-5-megous@megous.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520235009.16734-5-megous@megous.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 May 2019 01:50:07 +0200, megous@megous.com wrote:
> From: Ondrej Jirman <megous@megous.com>
> 
> Some Allwinner SoC using boards (Orange Pi 3 for example) need to enable
> on-board voltage shifting logic for the DDC bus using a gpio to be able
> to access DDC bus. Use ddc-en-gpios property on the hdmi-connector to
> model this.
> 
> Add binding documentation for optional ddc-en-gpios property.
> 
> Signed-off-by: Ondrej Jirman <megous@megous.com>
> ---
>  .../devicetree/bindings/display/connector/hdmi-connector.txt     | 1 +
>  1 file changed, 1 insertion(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
