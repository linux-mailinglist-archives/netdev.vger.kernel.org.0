Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36682F4BC7
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 13:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbhAMMzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 07:55:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:60394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725801AbhAMMzn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 07:55:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3FE9233F6;
        Wed, 13 Jan 2021 12:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610542502;
        bh=R35icEekZdVOc0zpx+bjZE8H0/Hj68YPjmfywpr2VoA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d0ZlMXd+8YdRNLOyR2tqGLLvwtI1Yl0UoVNI917S1IP4PJc4PAexcxPmBN0UUaWzq
         dle17l7xJaJx7FBq4swvwmWrH0jwhqGG7y7l92tAEFJQB4cv2f3vSx1FCcUeEYOII4
         RzfZBSk3L9JQPuuwVxusmyr4sQAIIs7uZ/1AVF9wE/EVrv7e2sMppgg5pFXSuYq/BA
         uMWEgNa29esAVZtV9A45Z8GJ7zIXgC8gHVif1olvMkE0FwV+beJ04WJJoBQIjDwfhT
         hvplYhmotVS84daqruUFD0WqXJoMTUPTh3qjx4BAplB69zJ1XiLuUGFCaWZtnMjqek
         J+fufpuqeMkhg==
Date:   Wed, 13 Jan 2021 18:24:57 +0530
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
Subject: Re: [PATCH v5 07/11] dt-bindings: phy: convert MIPI DSI PHY binding
 to YAML schema
Message-ID: <20210113125457.GN2771@vkoul-mobl>
References: <20201225075258.33352-1-chunfeng.yun@mediatek.com>
 <20201225075258.33352-7-chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201225075258.33352-7-chunfeng.yun@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25-12-20, 15:52, Chunfeng Yun wrote:
> Convert MIPI DSI PHY binding to YAML schema mediatek,dsi-phy.yaml

Applied, thanks

-- 
~Vinod
