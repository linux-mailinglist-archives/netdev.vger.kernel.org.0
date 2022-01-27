Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87ED749D714
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 02:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234211AbiA0BAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 20:00:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234227AbiA0BAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 20:00:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C66C061747
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 17:00:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A32061B7C
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 01:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15458C340E7;
        Thu, 27 Jan 2022 01:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643245243;
        bh=HyiG7TmXHQPsxbzrIxS1cOYK3PWCLliqZci+S+WBYB0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EBeOuxQ1RDRjPcHHYfXoUAj0mIVvO/C2jJG9XWjw2qpeCQ5bFPY5T0NnR9g8l77rn
         +vD80dxWmyLT9SVI/0zDc8orJefYMy2NKwVnn96V39X450GbXJbeLShsdXAVVm7tVb
         aYtbP1vuVaiH+t+rRLiXegvSwHvoHAYS4hOJ/RWZyAoXAc1nR2M/DrLjQT5tK30npF
         PtR3nbqj6qIbW9vG/bYf4qGhHtyLaWWNS68DdbFzVSP2vz9rK6egHys6lR2OAffwOW
         snhiGUI+ohN81nauvEJOH986JFmScEZCYdzWrSMFaVQ0sUsgVHkOauHkHbLOhbV36N
         Efv8mgQeDqWWQ==
Date:   Wed, 26 Jan 2022 17:00:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexey Sheplyakov <asheplyakov@basealt.ru>
Cc:     netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Dmitry Dunaev <dmitry.dunaev@baikalelectronics.ru>
Subject: Re: [PATCH 1/2] net: stmmac: added Baikal-T1/M SoCs glue layer
Message-ID: <20220126170042.17ae0ad8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220126084456.1122873-1-asheplyakov@basealt.ru>
References: <20220126084456.1122873-1-asheplyakov@basealt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Jan 2022 12:44:55 +0400 Alexey Sheplyakov wrote:
> The gigabit Ethernet controller available in Baikal-T1 and Baikal-M
> SoCs is a Synopsys DesignWare MAC IP core, already supported by
> the stmmac driver.
>=20
> This patch implements some SoC specific operations (DMA reset and
> speed fixup) necessary for Baikal-T1/M variants.

drivers/net/ethernet/stmicro/stmmac/dwmac-baikal.c:33:13: warning: unused v=
ariable =E2=80=98err=E2=80=99 [-Wunused-variable]
   33 |         int err;
      |             ^~~
