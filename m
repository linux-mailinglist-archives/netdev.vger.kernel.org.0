Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F4241712A
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 13:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343674AbhIXLt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 07:49:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239961AbhIXLtZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 07:49:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B3146124F;
        Fri, 24 Sep 2021 11:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632484072;
        bh=cfBrH7ovTdnfnA95LdMTguUG9WGpg9tzmCDexuwMXbQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QM7R24l8RqPxsvVnpNH4VPvjLYEGbjIzH5phU1hLwImuDn5LtYQs6A0ZFGBF8DkVw
         k7vZxG2CymW3k6h3rN0nNKi+gQfTIpnaU3NzPUWhpnOWC4DSwM7+ScCZtP9idJrz6I
         E20BNqsZe9KanyUprc7ulTQGiTj3rq3SeEOZTboVu1gQd69fRetPLje4UCaVG+wyM9
         dmQMF8RlfEnyNGOx/XyczJ2jWttHRYEprGVJDVd+llse3lpz5SoQxBOOSNVLsOuhsJ
         n/Ri+smge6o+HDL/aAwwIRbgGn7IXv53ttEUBQ0NweOH0pRm9+erZ6IcqvjtnJtCoW
         YX+ANSfRzxgQw==
Date:   Fri, 24 Sep 2021 07:47:51 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>, drt@linux.ibm.com,
        mpe@ellerman.id.au, kuba@kernel.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH AUTOSEL 5.10 01/26] ibmvnic: check failover_pending in
 login response
Message-ID: <YU265yembZGBojsf@sashalap>
References: <20210923033839.1421034-1-sashal@kernel.org>
 <20210923073347.GA2056@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210923073347.GA2056@amd>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 09:33:47AM +0200, Pavel Machek wrote:
>Hi!
>
>Something went wrong with this series. I only see first 7 patches. I
>thought it might be local problem, but I only see 7 patches on lore...

Huh, yes, apparently git-send-email timed out. I'll resend. Thanks!


-- 
Thanks,
Sasha
