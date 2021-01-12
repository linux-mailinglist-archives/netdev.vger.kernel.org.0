Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B712F3FDA
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395246AbhALXEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 18:04:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:36086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728321AbhALXEF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 18:04:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02FFC23123;
        Tue, 12 Jan 2021 23:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610492605;
        bh=LVKuODw65wf7ZbV6TpY1MLKuwFySUkX+3R0Qj6Rb6pc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EoAJYuJRrXKVbW3TMPldrnAJk9QqbwLD78FYA4jgS6ezCLYFSfYaHlY1LsmaOmjoj
         O2848ueVEBnmuRfs3eN6wiy7YVXuunNnducQ2nXkTfUR3dq7wlqPzQetMOQNDCDLYC
         H5aa2RUc9/Z7IIGNB6FboAu+S5xt9i4zHIo/bxvWk5HPP/dO+M2uryOSAq8w/ZR5kv
         GYWn8oi4Om35Y6KzpeBBcptgZEksJ8nGOkqJIHVg1IqbUc8IG0tz9Ka0tL+wZPnZMI
         1PCiarEwhGN8bJBqoxsRDvNu+vwmkLXoPka1u7wYBTitr8TJsKROa9mmxPe2AorFf0
         GodV592qZalEg==
Date:   Tue, 12 Jan 2021 15:03:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Geethasowjanya Akula <gakula@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCv4 net-next] octeontx2-pf: Add RSS multi group support
Message-ID: <20210112150324.5f12d412@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <DM6PR18MB2602DD7FFC517C638D8876B9CDAA9@DM6PR18MB2602.namprd18.prod.outlook.com>
References: <20210104072039.27297-1-gakula@marvell.com>
        <DM6PR18MB2602DD7FFC517C638D8876B9CDAA9@DM6PR18MB2602.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 04:17:44 +0000 Geethasowjanya Akula wrote:
> Hi All,
> 
> Any feedback on this patch.

I think Dave merged it already, see commit 81a4362016e7 ("octeontx2-pf:
Add RSS multi group support") in net-next.
