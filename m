Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D33547D439
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 16:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343703AbhLVPXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 10:23:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39722 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237912AbhLVPXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 10:23:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6357B81D0D;
        Wed, 22 Dec 2021 15:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E41AC36AE5;
        Wed, 22 Dec 2021 15:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640186595;
        bh=7suHNeZ0PFDbQZf4bG8MVJTVRqukHkRZ203fI09Smxw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X64BJkEgsi/rjNV6CGwHlrl6+3m9sKmtET6gjDb8gngLRa+ESP+I+N7Qm3mkDkFeD
         cO/T/FCA+XxR08S2aRquqgRg+I9gq9Xtq4D/2+4RCIokZgqxLWcYNHwt1yxaPYnWM2
         VvKofO2psiS2OVvsLsEaqxaNCJhfnYmAydm8s5mf0fUkg/7247g4C8TttVusdDQBzT
         2eEq5G+QTYWGFpvOU/MfcnLGs2UxJLOT6r9Vh31cTc8ahMeswqn56jhbt+9jFSNytm
         xZHqeifeNLgBXg/U7ewHa0TZRsXaNxrjaIezdGD9knWqXaNxWIcHa27xsgnoRWs/m0
         s/1eVvRJa7ktw==
Date:   Wed, 22 Dec 2021 07:23:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: micrel: Add config_init for LAN8814
Message-ID: <20211222072314.51294237@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211222114820.vj4obabkytuljqq6@soft-dev3-1.localhost>
References: <20211126103833.3609945-1-horatiu.vultur@microchip.com>
        <20211222114820.vj4obabkytuljqq6@soft-dev3-1.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Dec 2021 12:48:20 +0100 Horatiu Vultur wrote:
> The 11/26/2021 11:38, Horatiu Vultur wrote:
> 
> Sorry for reviving this old thread. I can see this patch was marked as
> "Changes Requested" [1]. The change that Heiner proposed, will not worked as
> we already discussed. It is using a different mechanism to access extend
> pages.
> Should I just try to resend the patch or is possible to get this one?
> 
> [1] https://patchwork.kernel.org/project/netdevbpf/patch/20211126103833.3609945-1-horatiu.vultur@microchip.com/

Please resend (preferably with a short note on why in the change log).
