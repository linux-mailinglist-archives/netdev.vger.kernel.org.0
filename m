Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939282F4BB7
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 13:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbhAMMyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 07:54:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:59802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726626AbhAMMyK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 07:54:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15A04233F8;
        Wed, 13 Jan 2021 12:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610542409;
        bh=xejEFAPZ3I6jmEQrIeXD/2zG/sIhK5c/B8ciA3nDuwE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=krYvN951qnp5EA27PwQqGtMCn43p+yVGY7aofWqMMKElRs5C80i19B/mSq/gNsq8H
         sGWZ2ICGAR3F2xt4kKpNP6aIx3crnR//pfTdOi1jA4WHZM9yYsYgv6t8pPb066X0sU
         O3AyqXtK+JOzG1rgX974LqNF5qVm+zJj6s8B3e0a3Xk/C5PIXiidOHw+vPEOY9wAJj
         rmTA8/3mYp9H80x7O8m7T+/d7YyNPZxCz73Jzr7CniHWPyOw5O+z+SbvBdBgDSctMM
         tPDRgDbW27dWcuw2QaEsdP9pHt2U/rOA2lFJfKcg8L6wjU0zFsxjTEWdyz1Q1izvrY
         rKlVjmoEgDGHA==
Date:   Wed, 13 Jan 2021 18:23:25 +0530
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
Subject: Re: [PATCH v5 04/11] dt-bindings: phy: convert phy-mtk-tphy.txt to
 YAML schema
Message-ID: <20210113125325.GK2771@vkoul-mobl>
References: <20201225075258.33352-1-chunfeng.yun@mediatek.com>
 <20201225075258.33352-4-chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201225075258.33352-4-chunfeng.yun@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25-12-20, 15:52, Chunfeng Yun wrote:
> Convert phy-mtk-tphy.txt to YAML schema mediatek,tphy.yaml

Applied, thanks

-- 
~Vinod
