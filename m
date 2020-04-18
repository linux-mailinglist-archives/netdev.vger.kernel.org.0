Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B06B1AEC9A
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 14:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbgDRMqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 08:46:50 -0400
Received: from 8bytes.org ([81.169.241.247]:36380 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725804AbgDRMqs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Apr 2020 08:46:48 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 11EBF48C; Sat, 18 Apr 2020 14:46:45 +0200 (CEST)
Date:   Sat, 18 Apr 2020 14:46:44 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] iommu: spapr_tce: Disable compile testing to fix build
 on book3s_32 config
Message-ID: <20200418124644.GF6113@8bytes.org>
References: <20200414142630.21153-1-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414142630.21153-1-krzk@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 04:26:30PM +0200, Krzysztof Kozlowski wrote:
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Fixes: e93a1695d7fb ("iommu: Enable compile testing for some of drivers")
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> ---
>  drivers/iommu/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.
