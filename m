Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC0D47CD0B
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 07:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242796AbhLVGoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 01:44:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39198 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbhLVGoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 01:44:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5BAF617F3;
        Wed, 22 Dec 2021 06:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4182C36AE5;
        Wed, 22 Dec 2021 06:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640155460;
        bh=06+qXAesbN9GTyzqoY1xLowtSXQXtOyrtPnQ4r9S/co=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=cVwgv+vb1M3zySXsc5SPxntomPGL41N8thu+7o0j6jRiFI93cW5sa387Ok9ooTiXC
         jgWZxM2e2+k2ZK7f+PBxS0M0g0j73rdE7SP/40BkW/KDUMAUo5bFoa88a7BbJCXkb4
         mMkBeMTeYqA33hdUwuiy2vP7hM2WXvggjgOERokiOoPZG42VWIM3HXFHG1TBLtR58O
         P5inrp+sQ8Y7qVPJB+pLQkxTNERzmSqB7G6RHh1A4dZmIAx1F+tDkR53at3E6jmxGz
         iFmGLvwGeRU56zm/uI4u5myR3Ag7hmEF0LW5hFyPgJRtBRP5CfmWfjaQ+1tD0Q+1QL
         XSUnOw+Q/JU4Q==
From:   Kalle Valo <kvalo@kernel.org>
To:     Abhishek Kumar <kuabhs@chromium.org>
Cc:     briannorris@chromium.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, dianders@chromium.org,
        pillair@codeaurora.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath10k@lists.infradead.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ath10k: enable threaded napi on ath10k driver
References: <20211214223901.1.I777939e0ef1e89872d4ab65340f3fd756615a047@changeid>
Date:   Wed, 22 Dec 2021 08:44:16 +0200
In-Reply-To: <20211214223901.1.I777939e0ef1e89872d4ab65340f3fd756615a047@changeid>
        (Abhishek Kumar's message of "Tue, 14 Dec 2021 22:39:36 +0000")
Message-ID: <87fsql2l6n.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Abhishek Kumar <kuabhs@chromium.org> writes:

> NAPI poll can be done in threaded context along with soft irq
> context. Threaded context can be scheduled efficiently, thus
> creating less of bottleneck during Rx processing. This patch is
> to enable threaded NAPI on ath10k driver.
>
> Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.2.2-00696-QCAHLSWMTPL-1
> Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
> ---
>
>  drivers/net/wireless/ath/ath10k/pci.c  | 1 +
>  drivers/net/wireless/ath/ath10k/sdio.c | 1 +
>  drivers/net/wireless/ath/ath10k/snoc.c | 2 +-

I think also pci and sdio should be tested.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
