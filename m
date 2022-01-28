Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95FEA49FE90
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 18:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245634AbiA1RA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 12:00:29 -0500
Received: from air.basealt.ru ([194.107.17.39]:36256 "EHLO air.basealt.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245662AbiA1RA1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 12:00:27 -0500
Received: by air.basealt.ru (Postfix, from userid 490)
        id D23BF58958B; Fri, 28 Jan 2022 17:00:24 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on
        sa.local.altlinux.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.1
Received: from localhost (unknown [193.43.9.4])
        by air.basealt.ru (Postfix) with ESMTPSA id 35166589436;
        Fri, 28 Jan 2022 17:00:23 +0000 (UTC)
Date:   Fri, 28 Jan 2022 21:00:19 +0400
From:   Alexey Sheplyakov <asheplyakov@basealt.ru>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Dmitry Dunaev <dmitry.dunaev@baikalelectronics.ru>
Subject: Re: [PATCH 1/2] net: stmmac: added Baikal-T1/M SoCs glue layer
Message-ID: <YfQhCMrySoza9Ykt@asheplyakov-rocket>
References: <20220126084456.1122873-1-asheplyakov@basealt.ru>
 <20220126170042.17ae0ad8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220126170042.17ae0ad8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Jakub,

On Wed, Jan 26, 2022 at 05:00:42PM -0800, Jakub Kicinski wrote:
> On Wed, 26 Jan 2022 12:44:55 +0400 Alexey Sheplyakov wrote:
> > The gigabit Ethernet controller available in Baikal-T1 and Baikal-M
> > SoCs is a Synopsys DesignWare MAC IP core, already supported by
> > the stmmac driver.
> > 
> > This patch implements some SoC specific operations (DMA reset and
> > speed fixup) necessary for Baikal-T1/M variants.
> 
> drivers/net/ethernet/stmicro/stmmac/dwmac-baikal.c:33:13: warning: unused variable ‘err’ [-Wunused-variable]
>    33 |         int err;
>       |             ^~~

thanks for spotting this. I've sent v2 patchset which appears to compile
with -Werror.

Best regards,
	Alexey
