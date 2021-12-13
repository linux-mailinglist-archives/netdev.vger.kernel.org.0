Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4DC473146
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 17:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234980AbhLMQIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 11:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235577AbhLMQIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 11:08:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B32C061751
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 08:08:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7CFA61163
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 16:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E683EC34603;
        Mon, 13 Dec 2021 16:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639411709;
        bh=7S2Xnbs/Kz5EP+BoKSBoDuapQGX/tD8UevhLIamg6es=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pufRsIic005TbqZMB8iw5uKOqn9ujB8+SFaCW57zQhpHzkw2Y/k4ZpG06k7STcCuH
         C+WT4fjBM4pVAszi5RemFknel0D/3N+PiRGiGz1612SK0Hi5F0yd0ROAyGcIMTUfBM
         74D5+1e9fI+3JLi8jB+g1UsLSQ5aGol1A0+98rkiFlzJxjmort/K+zsXHiOHOb8zdo
         eBPJHsU0Z4kjIgyrN7K0V9mFjQIRAD6E1McXuvQEX4IfncmOicKl92GPPhzU8HyDwc
         i2BD/XBjOLAx70LuHAD+/xC7R6ZMrNqQudPbw8RUfFBJVpDFOfWICAXbEsQMYwr5kE
         tm33w0RJhmLQA==
Date:   Mon, 13 Dec 2021 08:08:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Add tx fwd offload PVT on
 intermediate devices
Message-ID: <20211213080827.3a345fa8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87v8zu2603.fsf@waldekranz.com>
References: <20211209222424.124791-1-tobias@waldekranz.com>
        <20211210211851.6b8773e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87v8zu2603.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 11 Dec 2021 22:20:28 +0100 Tobias Waldekranz wrote:
> Since there was no cover letter for this patch I put that motivation
> after the commit message cutoff:
> 
>     Though this is a bugfix, it still targets net-next as it depends on
>     the recent work done by Vladimir here:
> 
>     https://lore.kernel.org/netdev/20211206165758.1553882-1-vladimir.oltean@nxp.com/


Sigh, I should read the stuff under ---, sorry.
