Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4D943BA1F
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 21:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236934AbhJZTFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 15:05:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235216AbhJZTE7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 15:04:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73D976103C;
        Tue, 26 Oct 2021 19:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635274955;
        bh=5i6nLNgMCoqcL3SxcdUlVgyXJBpR3WqcaSdO2QGRI3U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ugLxngwVJuogTj7LaSS08D2iHidf1hIdLCR25TgHRDdSi7klTXn3bVWvoKMWNmwxU
         DneTpPMmo4z56euWMU0eex9GW0oq3qV9jjRBw7r+OvWMaAgi8Qxh5dv7hgHKuXxNZo
         VYpfbq5/iNYuxpPYG6DSniWYtLNXpfUnT02iA6aoyyTHlZu7P1wLu1IKkUklWVObAZ
         /j//RLw8N6JcoX87bZfC7ZNM42wqVHX+/t3PZnTAVl1kYUOmgjkdqr9CLo1FV/I7sI
         cmZlib592N1Se/aZwZauD0jIyuwiQwbyzMKDdMk0QJanuZxnb2LxK3e/wEsbysIGHM
         2AZ3jz1NWnQdw==
Date:   Tue, 26 Oct 2021 12:02:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+93d5accfaefceedf43c1@syzkaller.appspotmail.com
Subject: Re: [PATCH net-next] netdevsim: Register and unregister devlink
 traps on probe/remove device
Message-ID: <20211026120234.3408fbcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YXgpgr/BFpbdMLJp@unreal>
References: <725e121f05362da4328dda08d5814211a0725dac.1635064599.git.leonro@nvidia.com>
        <YXUhyLXsc2egWNKx@shredder>
        <YXUtbOpjmmWr71dU@unreal>
        <YXU5+XLhQ9zkBGNY@shredder>
        <YXZB/3+IR6I0b2xE@unreal>
        <YXZl4Gmq6DYSdDM3@shredder>
        <YXaNUQv8RwDc0lif@unreal>
        <YXelYVqeqyVJ5HLc@shredder>
        <YXertDP8ouVbdnUt@unreal>
        <YXgMK2NKiiVYJhLl@shredder>
        <YXgpgr/BFpbdMLJp@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Oct 2021 19:14:58 +0300 Leon Romanovsky wrote:
> > By now I have spent more time arguing with you than you spent testing
> > your patches and it's clear this discussion is not going anywhere.
> > 
> > Are you going to send a revert or I will? This is the fourth time I'm
> > asking you.  
> 
> I understand your temptation to send revert, at the end it is the
> easiest solution. However, I prefer to finish this discussion with
> decision on how the end result in mlxsw will look like.
> 
> Let's hear Jiri and Jakub before we are rushing to revert something that
> is correct in my opinion. We have whole week till merge window, and
> revert takes less than 5 minutes, so no need to rush and do it before
> direction is clear.

Having drivers in a broken state will not be conducive to calm discussions.
Let's do a quick revert and unbreak the selftests.

Speaking under correction, but the model of operation where we merge
patches rather quickly necessarily must also mean we are quick to
revert changes which broke stuff if the fix is not immediately obvious
or disputed.
