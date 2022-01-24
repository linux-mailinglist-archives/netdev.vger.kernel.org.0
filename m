Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8F34985B7
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 18:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244214AbiAXREx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 12:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244163AbiAXREi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 12:04:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CABC061401;
        Mon, 24 Jan 2022 09:04:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDA97B8114B;
        Mon, 24 Jan 2022 17:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1A9C340EA;
        Mon, 24 Jan 2022 17:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643043875;
        bh=insQqMWnYMCGenvJ/GiGEQqwN5YovpVzQGFYxKA9tQg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PQnJEytBbZhtef4QS9fYOrX+Ch7nDfVnbG/JevXc/AFMdYQHZSDqJKIGTkB44ufwF
         V+18bE2CqrzYJ5hpVKIoii/NkUIZVgtlYwpzC+kdYmDhO/owqtkSnVpYY3MCWncTdd
         zsWneK3qAoWa9TL8pJNluNkNXT53C83adwivI2Q1UVUGvgTwXLnvtSazcvdKC42x36
         SQeMO73zU+UoAO/1q0Lxp7bifAxhzWk0oG3USUAnvA1VvcWtY3cgdS1DuUTI2cn7Zd
         Di3bjkEISM7VrAR64kwxah+grsjKM6XDhV4ePKo6AbZVK75wfPm3/md4voEHGx9klT
         DXM0UH/8fD42g==
Date:   Mon, 24 Jan 2022 09:04:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
        Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>,
        kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        "Tobin C. Harding" <me@tobin.cc>, alsa-devel@alsa-project.org,
        amd-gfx@lists.freedesktop.org, netdev@vger.kernel.org
Subject: Re: Build regressions/improvements in v5.17-rc1
Message-ID: <20220124090433.1951e2ea@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <alpine.DEB.2.22.394.2201240851560.2674757@ramsan.of.borg>
References: <20220123125737.2658758-1-geert@linux-m68k.org>
        <alpine.DEB.2.22.394.2201240851560.2674757@ramsan.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 08:55:40 +0100 (CET) Geert Uytterhoeven wrote:
> >  + /kisskb/src/drivers/net/ethernet/freescale/fec_mpc52xx.c: error: passing argument 2 of 'mpc52xx_fec_set_paddr' discards 'const' qualifier from pointer target type [-Werror=discarded-qualifiers]:  => 659:29  
> 
> powerpc-gcc5/ppc32_allmodconfig
> 
> >  + /kisskb/src/drivers/pinctrl/pinctrl-thunderbay.c: error: assignment discards 'const' qualifier from pointer target type [-Werror=discarded-qualifiers]:  => 815:8, 815:29  
> 
> arm64-gcc5.4/arm64-allmodconfig
> arm64-gcc8/arm64-allmodconfig

Let me take care of these in net.
