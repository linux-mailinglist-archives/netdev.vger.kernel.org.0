Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D448C46DDF9
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 23:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239989AbhLHWGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 17:06:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239908AbhLHWGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 17:06:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29037C061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 14:03:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2590B822FF
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 22:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A909C00446;
        Wed,  8 Dec 2021 22:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639000992;
        bh=hXWsCQSlwK1YgiOmcZvLF0CBuZW2IEMs0UvDl7crfdI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nq7Q6GGuNaE1uI/Hyopn5OOtut8RS+qllr3cAL17eycpYPgQOpK5c7XSpXo7EYkIZ
         Kq0LpZOUUeFqRc1WaIpkCafg4YGGp1ZCiSbNhU73qa25JFAlp2mDb7PPWfrTt8yXcJ
         VckTmpmG39qKZEpXCB62o/nR9XGvGKQjMr3CoRO2aBxw6a0FgbtpjOkMiyIWZjieO6
         HB31QdQelUZURhuyxlKG1mpy+eRM+5OzH2eyMZOiE4GCrGUPkhxUmCYvokzFvkxh1m
         NpYdeCeXAkofAqcRz/XvlBAodzjUbl40NtP703ufIprokRVjOS7jMcLrN/oXrYEE0b
         32GJWiWNIVaYA==
Date:   Wed, 8 Dec 2021 14:03:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 1/2] net_tstamp: add new flag
 HWTSTAMP_FLAGS_UNSTABLE_PHC
Message-ID: <20211208140310.5e74a5d0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YbBQZUoQjDC6Ea23@Laptop-X1>
References: <20211208044224.1950323-1-liuhangbin@gmail.com>
        <20211208044224.1950323-2-liuhangbin@gmail.com>
        <20211207220814.0ca3403f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YbBQZUoQjDC6Ea23@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 14:27:49 +0800 Hangbin Liu wrote:
> How about just add the check in net_hwtstamp_validate().

Seems like a good idea (modulo the exact implementation)
