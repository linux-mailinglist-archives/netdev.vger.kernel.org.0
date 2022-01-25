Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFDC749B7FB
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 16:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244806AbiAYPv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 10:51:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35094 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1582332AbiAYPtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 10:49:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53964B8189A
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 15:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E029FC340E0;
        Tue, 25 Jan 2022 15:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643125778;
        bh=FyzBCm/F5xLEAFx8GkTMwk8BBAFZV44giEr2QcekNJc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K0Ge9NSO5G9CqimwKmhs2NlairIW7lrIQHwIdlILjC8TEIOB5IjbmVnkxJfYGleHe
         unpRQvikJMlMHGb99ia5DwglWIUCTRoNY+6gR1Sh0ajuQVeIBSGVhqfnqp2K5O2S4U
         lZ4cW5JkkUJUscOSje/zZIcT6KxB73pP3sDHoDZEIQlrLHxGwYhV5uQzHkZmrNR9dy
         RtV0XSyQ7zXNtOTAums2pggBw/VQx5ActSgx3Y86SvHthlBRp1jZfhfts/I2hyreXl
         GXgyIWoJYL0zUhmbSco0vkAWTJZAPAmCgtHKzeUht4pCvUkidjfFknqILfldPCWrPA
         fb7anTrP/tkbA==
Date:   Tue, 25 Jan 2022 07:49:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH net] net: fec_mpc52xx: don't discard const from
 netdev->dev_addr
Message-ID: <20220125074937.6bb36ea4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220124172249.2827138-1-kuba@kernel.org>
References: <20220124172249.2827138-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 09:22:49 -0800 Jakub Kicinski wrote:
> Recent changes made netdev->dev_addr const, and it's passed
> directly to mpc52xx_fec_set_paddr().
> 
> Similar problem exists on the probe patch, the driver needs
> to call eth_hw_addr_set().
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Fixes: adeef3e32146 ("net: constify netdev->dev_addr")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

This is in net now:

74afa3063097 ("net: fec_mpc52xx: don't discard const from netdev->dev_addr")
