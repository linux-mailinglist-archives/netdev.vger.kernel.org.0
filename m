Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A82963CC7B
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 01:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiK3AVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 19:21:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiK3AVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 19:21:17 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90FB26D4BA
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 16:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wztaUraijUy9YYpZhl5Do14loetZ1Pu9fDlH9tOdDG8=; b=wP00jYvOPR7M7qYvmdEju7lvnu
        h08F4zh8X4WYBaNPFoEHqMvQTKoHigaKQVWTcxCvm8mRwT5pTsopXuT+Tzu3TWe3vITEnohEB/Agd
        LPpl/z/bPtuhZNRa6wOBwS4/MNvrFhvL2nn7XWZ9WtLNRQkjLdzrShy6uGDFTGrBVGr0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0Aqh-003vCT-1F; Wed, 30 Nov 2022 01:21:15 +0100
Date:   Wed, 30 Nov 2022 01:21:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        yc-core@yandex-team.ru, lvc-project@linuxtesting.org
Subject: Re: [PATCH v2 2/3] net/ethtool/ioctl: remove if n_stats checks from
 ethtool_get_phy_stats
Message-ID: <Y4ah+12METPh48Gg@lunn.ch>
References: <20221129103801.498149-1-d-tatianin@yandex-team.ru>
 <20221129103801.498149-3-d-tatianin@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129103801.498149-3-d-tatianin@yandex-team.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 01:38:00PM +0300, Daniil Tatianin wrote:
> Now that we always early return if we don't have any stats we can remove
> these checks as they're no longer necessary.
> 
> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
