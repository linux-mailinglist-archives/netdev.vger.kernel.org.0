Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF17B4A01CF
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 21:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244271AbiA1U1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 15:27:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbiA1U1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 15:27:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45B4C061714
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 12:27:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B4D2B826F3
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 20:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96A8C340E7;
        Fri, 28 Jan 2022 20:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643401640;
        bh=SjkKLo533mT5at9y+bEHIj8xjGkp8/m3kLAVAbbSro0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Bd68VRzDiQGzDW8CzkK/9uFCmXnYwndfvNedpCnOoN0clHImRDGGWjr2B8nYgjujw
         49c0ILlyUrnGlKWd4aS7AqKUCVdz1Vmzbcy4OvtxyPEuDLK2ESezYQIaJNFga4Yrwu
         7bucHtjmkU+LymZgJSbJzvkxmWBT6Ilxi+TkJ1S6DTwYlFY1RvuaJLPR8RwbXVSeC9
         UeBJZVNfa/zXB4E079Lg75B8YZHWztFTwJC0/FBH5hcI5h5Osf0aRnxDoLk+D+KcmV
         CBKFyPqdopD7wZDTpcNxk6rBP0guGggY72aI64Ocjzse4rteQmMI0+W6K4v7C1MF9s
         f8MoIsOEhGamw==
Date:   Fri, 28 Jan 2022 12:27:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Alexey Sheplyakov <asheplyakov@basealt.ru>, netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Evgeny Sinelnikov <sin@basealt.ru>
Subject: Re: [PATCH 1/2] net: stmmac: added Baikal-T1/M SoCs glue layer
Message-ID: <20220128122718.686912e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YfQ8De5OMLDLKF6g@asheplyakov-rocket>
References: <20220126084456.1122873-1-asheplyakov@basealt.ru>
        <20220128150642.qidckst5mzkpuyr3@mobilestation>
        <YfQ8De5OMLDLKF6g@asheplyakov-rocket>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jan 2022 22:55:09 +0400 Alexey Sheplyakov wrote:
> On Fri, Jan 28, 2022 at 06:06:42PM +0300, Serge Semin wrote:
> > Hello Alexey and network folks
> > 
> > First of all thanks for sharing this patchset with the community. The
> > changes indeed provide a limited support for the DW GMAC embedded into
> > the Baikal-T1/M1 SoCs. But the problem is that they don't cover all
> > the IP-blocks/Platform-setup peculiarities  
> 
> In general quite a number of Linux drivers (GPUs, WiFi chips, foreign
> filesystems, you name it) provide a limited support for the corresponding
> hardware (filesystem, protocol, etc) and don't cover all peculiarities.
> Yet having such a limited support in the mainline kernel is much more
> useful than no support at all (or having to use out-of-tree drivers,
> obosolete vendor kernels, binary blobs, etc).
> 
> Therefore "does not cover all peculiarities" does not sound like a valid
> reason for rejecting this driver. That said it's definitely up to stmmac
> maintainers to decide if the code meets the quality standards, does not
> cause excessive maintanence burden, etc.

Sounds sensible, Serge please take a look at the v2 and let us know if
there are any bugs in there. Or any differences in DT bindings or user
visible behaviors with what you're planning to do. If the driver is
functional and useful it can evolve and gain support for features and
platforms over time.
