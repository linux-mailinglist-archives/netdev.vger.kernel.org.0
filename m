Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479BB483B38
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 05:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbiADEGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 23:06:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbiADEGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 23:06:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54555C061761;
        Mon,  3 Jan 2022 20:06:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24EE8B8113E;
        Tue,  4 Jan 2022 04:06:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2AECC36AE3;
        Tue,  4 Jan 2022 04:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641269198;
        bh=CiHevgUGpME5+WxTUSowDl264JIRiGX3G2P3u9gEVrs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XwHx0z/6Qr8IztN3Mq/euYFUz26/wL4no6y5Z3d8jsDsJ0GLb/x4S+Et1niHwQeEh
         nndiJWCAPAaxyevdf8G8JKfFMiwdt7O2FyQI3YPU2LpsQRXLgpskCEuTrKGrbyZ2qr
         1in3sUvSpXth8nqu+pAwsPmRmGPNo03K1KlwzqAA7c+Rcdqqc2hPSzTsLaE0NYuQwK
         WH12pJNdtj0qFO9WT8BQ2+t+jC2uBG+YV8/FiYg6Xo37tAsm0qrv6pkv/OGXKYcWkX
         UzbZKQt1rEFRLrnEG2TYwvQmdFI/klVv0Xt+CmiC52536dmm7sE1L6LJCEBfMRXo58
         xZsKtieIjASvw==
Date:   Mon, 3 Jan 2022 20:06:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Neil Armstrong <narmstrong@baylibre.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-oxnas@groups.io,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] ARM: ox810se: Add Ethernet support
Message-ID: <20220103200637.0b9d7e4f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220103175638.89625-1-narmstrong@baylibre.com>
References: <20220103175638.89625-1-narmstrong@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  3 Jan 2022 18:56:35 +0100 Neil Armstrong wrote:
> This adds support for the Synopsys DWMAC controller found in the
> OX820SE SoC, by using almost the same glue code as the OX820.
> 
> Neil Armstrong (3):
>   dt-bindings: net: oxnas-dwmac: Add bindings for OX810SE
>   net: stmmac: dwmac-oxnas: Add support for OX810SE
>   ARM: dts: ox810se: Add Ethernet support

Judging by the subject tag on patches 1 and 2 and To: I presume you
intend this series to be merged via net-next? Can you please repost
with patch 3 CCed to netdev as well? It didn't register in patchwork.
