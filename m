Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA7DDFD164
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 00:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfKNXNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 18:13:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55590 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbfKNXNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 18:13:42 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6FC1014AC47DD;
        Thu, 14 Nov 2019 15:13:41 -0800 (PST)
Date:   Thu, 14 Nov 2019 15:13:40 -0800 (PST)
Message-Id: <20191114.151340.735858877920708489.davem@davemloft.net>
To:     Mark-MC.Lee@mediatek.com
Cc:     sean.wang@mediatek.com, john@phrozen.org, matthias.bgg@gmail.com,
        andrew@lunn.ch, robh+dt@kernel.org, mark.rutland@arm.com,
        opensource@vdorst.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH net,v3 0/3] Rework mt762x GDM setup flow
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191113023844.17800-1-Mark-MC.Lee@mediatek.com>
References: <20191113023844.17800-1-Mark-MC.Lee@mediatek.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 Nov 2019 15:13:41 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: MarkLee <Mark-MC.Lee@mediatek.com>
Date: Wed, 13 Nov 2019 10:38:41 +0800

> The mt762x GDM block is mainly used to setup the HW internal
> rx path from GMAC to RX DMA engine(PDMA) and the packet
> switching engine(PSE) is responsed to do the data forward
> following the GDM configuration.
> 
> This patch set have three goals :
> 
> 1. Integrate GDM/PSE setup operations into single function "mtk_gdm_config"
> 
> 2. Refine the timing of GDM/PSE setup, move it from mtk_hw_init 
>    to mtk_open
> 
> 3. Enable GDM GDMA_DROP_ALL mode to drop all packet during the 
>    stop operation

Series applied, thanks.
