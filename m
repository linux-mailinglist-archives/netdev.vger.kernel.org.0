Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8AB4805A3
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 03:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234533AbhL1CIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 21:08:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbhL1CIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 21:08:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE14C06173E
        for <netdev@vger.kernel.org>; Mon, 27 Dec 2021 18:08:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF10D6117F
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 02:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212ADC36AEA;
        Tue, 28 Dec 2021 02:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640657303;
        bh=U/tzCmIW5+7gVUKf270E2CN0/5Q7mLpYz0P6KvA020Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dAov37jMn/f3T2sqnFpnRjIfuh2rGi0yiNbb4h1xopNsbQqN9pW7V2SHvtnzT27Lc
         2mx0HYOUezoTEkls05B2ekeT3yFVJ6FVQJamEOHwmnl6VLyLgAEAPJnX3ScJvMIFqA
         7bkOKgjvuK6DoTzLMPJL2qHCor85aS41OTKZ75kPCM2mO3/n6YvhyoQzQYcT1iO1Lt
         i2CP2Bc4iOorvQOiyvwLKBf69dFOAhODhKEiGOpXfzCpfvqBfaLPnvnQI90vvtKu+v
         Yso3sLv8pT9CvKUYCC061xxGoLFF3dB6T2gQ/fk29S5jdtFyB/1pgzh5AOh8zKwiul
         FvfndQJWDp7zQ==
Date:   Mon, 27 Dec 2021 18:08:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Dmitry V. Levin" <ldv@altlinux.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org
Subject: Re: [PATCH v2] uapi: fix linux/nfc.h userspace compilation errors
Message-ID: <20211227180821.00ec2e98@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211226130126.GA13003@altlinux.org>
References: <20170220181613.GB11185@altlinux.org>
        <20211225234229.GA5025@altlinux.org>
        <3d0af5ae-0510-8610-dfc2-b8e5ff682959@canonical.com>
        <3a89b2cf-33e4-7938-08e3-348b655493d7@canonical.com>
        <20211226130126.GA13003@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 26 Dec 2021 16:01:27 +0300 Dmitry V. Levin wrote:
> Replace sa_family_t with __kernel_sa_family_t to fix the following
> linux/nfc.h userspace compilation errors:
> 
> /usr/include/linux/nfc.h:266:2: error: unknown type name 'sa_family_t'
>   sa_family_t sa_family;
> /usr/include/linux/nfc.h:274:2: error: unknown type name 'sa_family_t'
>   sa_family_t sa_family;
> 
> Fixes: 23b7869c0fd0 ("NFC: add the NFC socket raw protocol")
> Fixes: d646960f7986 ("NFC: Initial LLCP support")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>

Applied to net:

commit 7175f02c4e5f ("uapi: fix linux/nfc.h userspace compilation errors")

thanks!
