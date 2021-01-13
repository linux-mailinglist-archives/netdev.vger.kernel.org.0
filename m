Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3E32F4BBF
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 13:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbhAMMyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 07:54:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:60010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbhAMMyx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 07:54:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D111233F6;
        Wed, 13 Jan 2021 12:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610542452;
        bh=XoZ3+HkveJD688OqbQa5akCHJkS2iwMRFZB5mx2FwrE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g9IbYmvjigVKlTn8edw3PK0dgtTohMoxtNPCdhRnl+MGU7m2tDz+ynHglun++V5zy
         tGIRZ8hjjK0LGMDFNoJqPdX8FVaHMUEg2EN2jm6SnIAPzM+vI95UkPgS2QB5/EHJ4K
         BQ7zRMJXSTFeiNn9JKqBRmhJkW9Xu+1/qjYwpcZDbLgwq63msdB0gntMCe1hYCEXPI
         b5/XJEoVPXosWsZaQScSkMIu0mhZH3IPjpvORmXO/lINyWAUuhGkHqZtUHV0LIiXBI
         vRL/9PlvPEYfn41Hreo8a5Ar4K79RkNgUlL6OQT/Q/z65f1qxDwAtn/zLXWNdhpFe3
         uu0ghyv3YOfWQ==
Date:   Wed, 13 Jan 2021 18:24:08 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Min Guo <min.guo@mediatek.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-usb@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>
Subject: Re: [PATCH v5 05/11] dt-bindings: phy: convert phy-mtk-ufs.txt to
 YAML schema
Message-ID: <20210113125408.GL2771@vkoul-mobl>
References: <20201225075258.33352-1-chunfeng.yun@mediatek.com>
 <20201225075258.33352-5-chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201225075258.33352-5-chunfeng.yun@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25-12-20, 15:52, Chunfeng Yun wrote:
> Convert phy-mtk-ufs.txt to YAML schema mediatek,ufs-phy.yaml

Applied, thanks

-- 
~Vinod
