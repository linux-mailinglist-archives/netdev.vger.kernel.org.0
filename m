Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D184908EB
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 13:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239991AbiAQMoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 07:44:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiAQMoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 07:44:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A3EC061574;
        Mon, 17 Jan 2022 04:44:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F53FB8104D;
        Mon, 17 Jan 2022 12:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515EFC36AE3;
        Mon, 17 Jan 2022 12:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642423458;
        bh=WfSe0f2tp73p9eX+2t47RIEu4N4Dal4v9YDkwvB2ysE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=HqFIKHUQaTAkz6zUwf8OoIf6hGHdQYQOOodOUD4xhwppJUytyUguW3yTtj0eI2xej
         s9EW2y7/kvDANPDE9dD08k7AJOnAeOgJ569Ny5TLksF0g9bx5ATTsTfF4+yCVhr8Iw
         v1QPjcuFnJ//frQJzqg+t3x8Q6GcWpI9SnLdP6H8yitwOyOciDIdJ4txECts9qgE7O
         235kdOJkiMY6cvJg8bp4kzuJWxPo2hAsq6cyU7CjbJ+o1OTy0+qHYYZburqUAHm1Bw
         2x8MiKDDtQQkZ6jVh15LzxTEZgFlXgoUjNVoAGFBXAHyyXpeeppc1cGyhdKjgHxyKC
         3fCM3CRpyLymA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 6/8] wcn36xx: Use platform_get_irq_byname() to get the
 interrupt
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211224192626.15843-7-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211224192626.15843-7-prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164242345282.27899.3620486539382484087.kvalo@kernel.org>
Date:   Mon, 17 Jan 2022 12:44:16 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:

> platform_get_resource_byname(pdev, IORESOURCE_IRQ, ..) relies on static
> allocation of IRQ resources in DT core code, this causes an issue
> when using hierarchical interrupt domains using "interrupts" property
> in the node as this bypasses the hierarchical setup and messes up the
> irq chaining.
> 
> In preparation for removal of static setup of IRQ resource from DT core
> code use platform_get_irq_byname().
> 
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

d17efe4f80fc wcn36xx: Use platform_get_irq_byname() to get the interrupt

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211224192626.15843-7-prabhakar.mahadev-lad.rj@bp.renesas.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

