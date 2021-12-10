Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D60947056C
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 17:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240495AbhLJQUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 11:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240634AbhLJQUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 11:20:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868A9C0617A2;
        Fri, 10 Dec 2021 08:16:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BB4C0CE2BEB;
        Fri, 10 Dec 2021 16:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DEADC00446;
        Fri, 10 Dec 2021 16:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639153015;
        bh=3ifJrSFjNhly+TY2+b6L86AuUb/oef45UACm9ExPytk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hi78EGlVGdyLvNLR0hbzVr0GKRJWWcmA9R2nonRI7O2dCpOwjXmjAjtk4NNY5woVE
         Kel8PeqN5d+7iaJOB6aZXoZgEeSv/U0ScV4VU2X6W0PZq6UWdeDWZ2tvBiy5yvtxNG
         ldC9dx/ZpqE2WTSGycY9bxhpLV5/DHD52pCCTQiwCtmAThLndj+lkbYwXaLCEXFuqC
         NWDsjL2Qi6sKUgarJWHiRASkE172hze5EJqJZnrvDmMPyDVUE/wlNv1K/7XcI4RvS7
         0jRxRFjld06t27TL+8J9SZ5kojYJfHL9/WkxHhIJscx2hZENMijLDOqeg/d7+MFO5q
         5oR84vEJkQKeA==
Date:   Fri, 10 Dec 2021 08:16:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciej Machnikowski <maciej.machnikowski@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        arkadiusz.kubalewski@intel.com, richardcochran@gmail.com,
        abyagowi@fb.com, anthony.l.nguyen@intel.com, davem@davemloft.net,
        linux-kselftest@vger.kernel.org, idosch@idosch.org,
        mkubecek@suse.cz, saeed@kernel.org, michael.chan@broadcom.com,
        petrm@nvidia.com, Vadim Fedorenko <vfedorenko@novek.ru>
Subject: Re: [PATCH v5 net-next 0/4] Add ethtool interface for RClocks
Message-ID: <20211210081654.233a41b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211210134550.1195182-1-maciej.machnikowski@intel.com>
References: <20211210134550.1195182-1-maciej.machnikowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Dec 2021 14:45:46 +0100 Maciej Machnikowski wrote:
> Synchronous Ethernet networks use a physical layer clock to syntonize
> the frequency across different network elements.
> 
> Basic SyncE node defined in the ITU-T G.8264 consist of an Ethernet
> Equipment Clock (EEC) and have the ability to synchronize to reference
> frequency sources.
> 
> This patch series is a prerequisite for EEC object and adds ability
> to enable recovered clocks in the physical layer of the netdev object.
> Recovered clocks can be used as one of the reference signal by the EEC.
> 
> Further work is required to add the DPLL subsystem, link it to the
> netdev object and create API to read the EEC DPLL state.

You missed CCing Vadim. I guess Ccing the right people may be right up
there with naming things as the hardest things in SW development..

Anyway, Vadim - do you have an ETA on the first chunk of the PLL work?
