Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64EB307E88
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 20:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbhA1Sys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 13:54:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:45078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232704AbhA1Swx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 13:52:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB24364E22;
        Thu, 28 Jan 2021 18:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611859923;
        bh=9jUyGhOZGFfAx7KMUzbBwW/oGg5JjB1jGvvUh5OH3RU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V3+/S8n3eDteQ181028nwFEmwmnQoXTAU0qnRF9fJ1e0+BmhOgXTEDk/bP+JLllGL
         rUiVWeiVOV6Z+qxXt99A5JnEM5ouBvYyIv7uzOEi0tSWnCyNJOrEbdR+GPYyZJrOJ8
         DzNnv2KGYNGTUf8pkNOfZVnA7SkzfYH+dL73yoc/8CWDwLk7SuAC+1kNrdnxDap+sz
         rlaLy6SMBEhTm/ksmOAt9YHGFSdLK3LDzYN1f2UwyKOjg6Na/HmRAlQxWsqDB06yzl
         Q4EJudUOKgGU4+C7s+UUPkeDMvO5cJD4qvjkhUnOSIa0Yh3RIOyqgknuxzGSxyAPBj
         EFB9rNqK5LBxQ==
Date:   Thu, 28 Jan 2021 10:52:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>,
        <netdev@vger.kernel.org>, <roopa@nvidia.com>,
        <bridge@lists.linux-foundation.org>, <davem@davemloft.net>
Subject: Re: [PATCH net-next v2 0/2] net: bridge: multicast: per-port EHT
 hosts limit
Message-ID: <20210128105201.7c6bed82@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <046fad19-2f44-21d2-82b9-feb1fd62b068@nvidia.com>
References: <20210126093533.441338-1-razor@blackwall.org>
        <20210127174226.4d29f454@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <046fad19-2f44-21d2-82b9-feb1fd62b068@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021 11:12:26 +0200 Nikolay Aleksandrov wrote:
> On 28/01/2021 03:42, Jakub Kicinski wrote:
> > On Tue, 26 Jan 2021 11:35:31 +0200 Nikolay Aleksandrov wrote:  
> >> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> >>
> >> Hi,
> >> This set adds a simple configurable per-port EHT tracked hosts limit.
> >> Patch 01 adds a default limit of 512 tracked hosts per-port, since the EHT
> >> changes are still only in net-next that shouldn't be a problem. Then
> >> patch 02 adds the ability to configure and retrieve the hosts limit
> >> and to retrieve the current number of tracked hosts per port.
> >> Let's be on the safe side and limit the number of tracked hosts by
> >> default while allowing the user to increase that limit if needed.  
> > 
> > Applied, thanks!
> > 
> > I'm curious that you add those per-port sysfs files, is this a matter
> > of policy for the bridge? Seems a bit like a waste of memory at this
> > point.
> 
> Indeed, that's how historically new port and bridge options are added.
> They're all exposed via sysfs. I wonder if we should just draw the line
> and continue with netlink-only attributes. Perhaps we should add a comment
> about it for anyone adding new ones.
> 
> Since this is in net-next I can send a follow up to drop the sysfs part
> and another to add that comment.
> 
> WDYT?

SGTM!
