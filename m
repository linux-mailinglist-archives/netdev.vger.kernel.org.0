Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89132F4BC2
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 13:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbhAMMzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 07:55:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:60248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbhAMMzN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 07:55:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4E32222F9;
        Wed, 13 Jan 2021 12:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610542472;
        bh=ha4DGgePmLUz5DawJjbkL39gsXdnG9tY1EHFdTU1Pm4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ow7pz/hS8zbpvP8E0oy4yive0IVP0A+4IlWeVlUaWJboi4zm1/f5ZZkcWHW7rmZ2i
         nqhdOxXT/5HMclwSrI9qtK1feBzX9qNvn4XqLiwRVeNeZ4g0dXiw19sUtaYF0SE3HY
         Oqq5nCk57pjy+YcHvpovnh2u8w82wffWnXJ70dRZYmG5TWyi7ZsHOheVI1yVoyKi5p
         N/SIrIvnGGpEPxgb3r40QNghtTzDP53r+mt9ehoyTk3bGpV1lJUJfSuM/3M/aj6hR0
         jFPjj2Xhe4xQ1WQOSxW8hTzA/78zidUkTqriu6eY8oHozZueELfGctE6HLB8beG75x
         JTaGQ+PByZ2RA==
Date:   Wed, 13 Jan 2021 18:24:27 +0530
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
Subject: Re: [PATCH v5 06/11] dt-bindings: phy: convert HDMI PHY binding to
 YAML schema
Message-ID: <20210113125427.GM2771@vkoul-mobl>
References: <20201225075258.33352-1-chunfeng.yun@mediatek.com>
 <20201225075258.33352-6-chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201225075258.33352-6-chunfeng.yun@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25-12-20, 15:52, Chunfeng Yun wrote:
> Convert HDMI PHY binding to YAML schema mediatek,hdmi-phy.yaml

Applied, thanks

-- 
~Vinod
