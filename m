Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A0649868E
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 18:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244452AbiAXRXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 12:23:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39344 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244445AbiAXRXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 12:23:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6248CB8119B;
        Mon, 24 Jan 2022 17:23:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C01C340E5;
        Mon, 24 Jan 2022 17:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643045019;
        bh=m/wg/IWT/bVyChMcDytMueNay+ZEXEAwNFpIPOGcW4A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CT5aW9G6CuSgV1bcFWriioswASoci6kwqYzjmCSQa3pZh3wo0TTUFlHd+pH35ADqt
         BfPVxG2IZWbROhpEzJGMmICqJ8dPD0sB0HP686ZQqBoUn3dvMwZxNTwN8nuruvCD8W
         t8DNh27n2XK6ZAVYaAIKZx/TpdGPsCQdqivxJPhWDNBSbX4w94yr2b+nU6+toc6HLl
         41fDFkbVAx3tRuAS0+VS6fJ6xcSvWxxF1ywhyPZm1geOlUEr35hx8nmaGpUnHRg3g7
         GzlSG7RwKyAGhcDojCVPLDDN3g6QzsJZC65vg1v/sHpaTK0m1tcqWDPhSz95UxuFSE
         BgBMILOagnNeg==
Date:   Mon, 24 Jan 2022 09:23:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
        Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>,
        kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        "Tobin C. Harding" <me@tobin.cc>, alsa-devel@alsa-project.org,
        amd-gfx@lists.freedesktop.org, netdev@vger.kernel.org
Subject: Re: Build regressions/improvements in v5.17-rc1
Message-ID: <20220124092337.5ecadd71@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220124090433.1951e2ea@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20220123125737.2658758-1-geert@linux-m68k.org>
        <alpine.DEB.2.22.394.2201240851560.2674757@ramsan.of.borg>
        <20220124090433.1951e2ea@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 09:04:33 -0800 Jakub Kicinski wrote:
> On Mon, 24 Jan 2022 08:55:40 +0100 (CET) Geert Uytterhoeven wrote:
> > >  + /kisskb/src/drivers/net/ethernet/freescale/fec_mpc52xx.c: error: passing argument 2 of 'mpc52xx_fec_set_paddr' discards 'const' qualifier from pointer target type [-Werror=discarded-qualifiers]:  => 659:29    
> > 
> > powerpc-gcc5/ppc32_allmodconfig

Sent:
https://lore.kernel.org/r/20220124172249.2827138-1-kuba@kernel.org/

> > >  + /kisskb/src/drivers/pinctrl/pinctrl-thunderbay.c: error: assignment discards 'const' qualifier from pointer target type [-Werror=discarded-qualifiers]:  => 815:8, 815:29    
> > 
> > arm64-gcc5.4/arm64-allmodconfig
> > arm64-gcc8/arm64-allmodconfig  

I take this one back, that's not me.
