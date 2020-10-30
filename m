Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5102129FE89
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 08:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbgJ3HkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 03:40:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgJ3HkD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 03:40:03 -0400
Received: from dragon (80.251.214.228.16clouds.com [80.251.214.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B0EC221E2;
        Fri, 30 Oct 2020 07:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604043602;
        bh=eMy334Y1BDRACJxcdODlv/rw+bzkW4+XO8njlGWj3h4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UNE2TmebEYeiX7m9FPwmTffMVGC40Gefog4l8BCrgvTOg15TRVo5GRP3q8z4umxKj
         2tNWA9t4pF2tp7iO/wXuCShf2/eaX1Sp5LFUPiJKrBWXUg/+X+0T+bMvV1sjR1msh6
         6/cdMt65/eX+eLXpH541iMhKz85ArtkR71muU/Cw=
Date:   Fri, 30 Oct 2020 15:39:57 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     devicetree@vger.kernel.org, leoyang.li@nxp.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        camelia.groza@oss.nxp.com
Subject: Re: [PATCH] arm64: dts: fsl: DPAA FMan DMA operations are coherent
Message-ID: <20201030073956.GH28755@dragon>
References: <1601901999-28280-1-git-send-email-madalin.bucur@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1601901999-28280-1-git-send-email-madalin.bucur@oss.nxp.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 05, 2020 at 03:46:39PM +0300, Madalin Bucur wrote:
> Although the DPAA 1 FMan operations are coherent, the device tree
> node for the FMan does not indicate that, resulting in a needless
> loss of performance. Adding the missing dma-coherent property.
> 
> Fixes: 1ffbecdd8321 ("arm64: dts: add DPAA FMan nodes")
> 
> Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> Tested-by: Camelia Groza <camelia.groza@oss.nxp.com>

Applied, thanks.
