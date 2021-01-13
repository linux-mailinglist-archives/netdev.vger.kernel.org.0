Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B662F4BB3
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 13:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbhAMMxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 07:53:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:59706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbhAMMxe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 07:53:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF664233F6;
        Wed, 13 Jan 2021 12:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610542373;
        bh=K7rfJRt7FTyScHAF7Dc1SebMYXDZ9njQhTE1qfF4ZUc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l3zntwyUARbT34Zn/5cgDiko7uTG+bQ0XokCI4osKNhDgqKgLoy0CmYnemvogSu00
         TMZ0e7XiyjGU2WF06hXeW+bWerZDkuPTrzmRFd2bx6/Va9J81cwgmHJTTsiUnwKqVu
         YMO/IlSkqrmsPZaxiWbnpQYjgcvGG5ZmBlASJT/RTB2N2eTd/lYLVg86sasG/Y4KtO
         CF5auJsOgsqrrP6fYDUfl56IZaQi9R0DOF8TFMkLEJNJsX+WwzlRf/3AeiRRFeSWCi
         GQwFk4ljSf3dhg0i8JLBoqBd3cmxQWp3Czctpu8TWE0pVvrx/PqO3M4mh8W07xY1lu
         AEnGW/dr4Z0MA==
Date:   Wed, 13 Jan 2021 18:22:42 +0530
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
Subject: Re: [PATCH v5 03/11] dt-bindings: phy: convert phy-mtk-xsphy.txt to
 YAML schema
Message-ID: <20210113125242.GJ2771@vkoul-mobl>
References: <20201225075258.33352-1-chunfeng.yun@mediatek.com>
 <20201225075258.33352-3-chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201225075258.33352-3-chunfeng.yun@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25-12-20, 15:52, Chunfeng Yun wrote:
> Convert phy-mtk-xsphy.txt to YAML schema mediatek,xsphy.yaml

Applied, thanks

-- 
~Vinod
