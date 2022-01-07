Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52F24871BC
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 05:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbiAGET7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 23:19:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiAGET6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 23:19:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D84DC061245;
        Thu,  6 Jan 2022 20:19:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2961CB8217F;
        Fri,  7 Jan 2022 04:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597C7C36AE9;
        Fri,  7 Jan 2022 04:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641529195;
        bh=VRFAxdq0ynqOO4uHrge8LZv9Vv2zlAKRCorK7REJKCQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jp2EFHELYDQdjcEKejOPpq3sfjndz73Fb08do+1tZpK3F0objcjF732wSRvWFx4qf
         LiDcL4VwuLWa/mCMY7PRU/VbwxMczkaF73S3n9Iz/fcsr2XA6h90QLaw6xRZqLc26S
         V1c4siXya1Q9I9eT+8lkTmnusfMQ1PYFwx6N3bWNC+lIYNzYyKoldI4w/DuFO8T3A3
         WhgWkJVAfH5sCTrKmad2j6DydbVe/oug+uPJID7hlqtqIFYPeVWXGj8ll1Wx67U1sH
         sTp7zxCZR3aWsR1pHJz5LzJE7lfuqA8kagbNq/+ZBpD+jpUHh+ReyrVLvukSfxwkS2
         x7SpX0lREg5pQ==
Date:   Thu, 6 Jan 2022 20:19:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yevhen Orlov <yevhen.orlov@plvision.eu>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org, andrew@lunn.ch,
        idosch@idosch.org, Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/6] prestera: add basic router driver
 support
Message-ID: <20220106201954.3b707080@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220107030139.8486-1-yevhen.orlov@plvision.eu>
References: <20220107030139.8486-1-yevhen.orlov@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  7 Jan 2022 05:01:30 +0200 Yevhen Orlov wrote:
> Changes for v3:
> * Reverse xmas tree variables refactor
> * Make friendly NL_SET_ERR_MSG_MOD messages
> * Refactor __prestera_inetaddr_event to use early return
> * Add prestera_router_hw_fini, which verify lists are empty
> * Fix error path in __prestera_vr_create. Remove unnecessary kfree.
> * Make __prestera_vr_destroy symmetric to "create"
> * prestera_vr_put/get now using refcount_t
> * Add WARN for sanity check path in __prestera_rif_entry_key_copy
> * Make prestera_rif_entry_create followed by prestera_rif_entry_destroy
> * Add missed call prestera_router_fini in prestera_switch_fini

Thanks for the update, could you send this set as incremental changes
as the previous version appears to have been applied?
