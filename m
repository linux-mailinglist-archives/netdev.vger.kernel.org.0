Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746A2302756
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 16:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbhAYPyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 10:54:31 -0500
Received: from mail-oi1-f175.google.com ([209.85.167.175]:42219 "EHLO
        mail-oi1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730476AbhAYPxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 10:53:21 -0500
Received: by mail-oi1-f175.google.com with SMTP id x71so15196058oia.9;
        Mon, 25 Jan 2021 07:53:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1yZ0c7rEGx6fs5prkxGM3bg0LRxfxDPD57XXjzl1Uts=;
        b=id8VNL0VjYuaRx9+EOw3VpVWsoSW8JSHzJIV+vclx7z30xViDUemJ3wIFEamaAlsvt
         qYH/YTmdG+ALWaj+4fEAjwYw9LYFsjZwyKjgLl9VGis9wEB2NqOywGeEl2xg7ScZzUbo
         ynAvuTqliWjL+Y6FzRzeZOFdT3MS2xK2nUUoPorHlbp2/4zJaRvgjsMAn2Il7/8JkfKe
         Pp+y/Hm+MKB+6E0PTQr71phj7f7f7xM5J+TJ+6aYu7ZxqJodcCuBWTfluiHGjBeSUZgB
         PY9OiHLfRRnovjueXSV716XLpjzM2lZg3tkG1AJZ6B2LeZ3JMv5SZUKWJYtWrk54kXTi
         k0aw==
X-Gm-Message-State: AOAM533E5Ac4jgYmIv/0IsDiuaLlRhSPTHrM6t/AAZO5PVlro8R14Qm/
        SQF2KjcMAjKtduJfs5oMzw==
X-Google-Smtp-Source: ABdhPJyIyaU356Mk4aXZ1GdOShLRCqmFKrnVBcRmci0oX+onFDjf6FhTHcQuHXCioZHrCT+STr8gvw==
X-Received: by 2002:a05:6808:b3c:: with SMTP id t28mr502706oij.37.1611589960589;
        Mon, 25 Jan 2021 07:52:40 -0800 (PST)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id m185sm3570114oib.48.2021.01.25.07.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 07:52:39 -0800 (PST)
Received: (nullmailer pid 442514 invoked by uid 1000);
        Mon, 25 Jan 2021 15:52:33 -0000
Date:   Mon, 25 Jan 2021 09:52:33 -0600
From:   Rob Herring <robh@kernel.org>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-mediatek@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        linux-gpio@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH net-next v2 1/2] dt-bindings: net: dsa: add MT7530 GPIO
 controller binding
Message-ID: <20210125155233.GA438031@robh.at.kernel.org>
References: <20210125044322.6280-1-dqfext@gmail.com>
 <20210125044322.6280-2-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125044322.6280-2-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 12:43:21 +0800, DENG Qingfang wrote:
> Add device tree binding to support MT7530 GPIO controller.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
> Changes v1 -> v2:
> 	No changes.
> 
>  Documentation/devicetree/bindings/net/dsa/mt7530.txt | 6 ++++++
>  1 file changed, 6 insertions(+)
> 


Please add Acked-by/Reviewed-by tags when posting new versions. However,
there's no need to repost patches *only* to add the tags. The upstream
maintainer will do that for acks received on the version they apply.

If a tag was not added on purpose, please state why and what changed.

