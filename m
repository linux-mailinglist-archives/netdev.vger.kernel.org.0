Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8674908D1
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 13:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237036AbiAQMlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 07:41:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234166AbiAQMlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 07:41:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDD6C061574;
        Mon, 17 Jan 2022 04:41:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BC6BB81050;
        Mon, 17 Jan 2022 12:41:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE793C36AE3;
        Mon, 17 Jan 2022 12:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642423277;
        bh=xxJoEFGj3wMM7MoTzGkGqzbFVQtRZzLW7rU54sUS3rA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=XwEMN3IpFENJ5j2TbwquLb8ywuTZwInN8+No5wRLRypoKEwvTI46HeqE/5+NlRNCV
         Em3ljHsjn0lb47c7q0yM1psByRpdC+c11dSFyW4obUsjSgSjQ6FAh8RTYe/mSS2zKQ
         6TEv8iGpRceOLthTiWYUBTYv8R3rZs65IehTudgf3VbuO++AZ2lbTfuUwFG+dlcB1t
         VWwn/PJhaD/DZgIAcHUnsXMxWe7svDxQ3oqhKHRtJ/Y9iUDAs8FSdgbyn4gd1M3eB8
         tAg0kl5m59uXbS0apvPuMwISLUnOggwXp/SxFs0ZZrgTqWkQ7e2SRg9sFejsn3kdwD
         Z1ITMqaIaWNig==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 7/8] ath10k: Use platform_get_irq() to get the interrupt
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211224192626.15843-8-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211224192626.15843-8-prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164242327317.27899.10499132550349029858.kvalo@kernel.org>
Date:   Mon, 17 Jan 2022 12:41:14 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:

> platform_get_resource(pdev, IORESOURCE_IRQ, ..) relies on static
> allocation of IRQ resources in DT core code, this causes an issue
> when using hierarchical interrupt domains using "interrupts" property
> in the node as this bypasses the hierarchical setup and messes up the
> irq chaining.
> 
> In preparation for removal of static setup of IRQ resource from DT core
> code use platform_get_irq().
> 
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

f14c3f4db9cb ath10k: Use platform_get_irq() to get the interrupt

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211224192626.15843-8-prabhakar.mahadev-lad.rj@bp.renesas.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

