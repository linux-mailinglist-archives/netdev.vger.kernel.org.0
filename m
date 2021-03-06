Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B47132FC58
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 18:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhCFRw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 12:52:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:32930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230525AbhCFRwT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Mar 2021 12:52:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1ACC64FF2;
        Sat,  6 Mar 2021 17:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615053138;
        bh=pQs+TAfh6EJs7cth0Wwcsp0KwtV/o5rdBeJ6m13PGKo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VIS29iDQnpPBPy0s8CQq8ua/JnH1NjmzmNOL0vBIFGefggHczlu6YC09w9PGff8t+
         OuKNJKMaC8dtCCNnNU55QYtLWePsAalsW/ETOBpY464XYQUQnEaLa4KGF/5FxwjsqZ
         9tAD2ev+pffh2miymBBTGInBwo1H3sY5V1g9Y1iYr3d29e/ev3CXzGlRJ7bJRsgTLQ
         T8/dr++S+M9RGWHl2dYezKMUSAtFuPylzGGgXl8UuRPJWLCgkYswzWHzPaU2Wo/oIF
         vmHGxNiwczhixNcW/8WZ+HDGCAHD4u125+O07zersDh6fD1Sh1dvB1AcXEiqbMNkXi
         II4rURK5nO9vQ==
Date:   Sat, 6 Mar 2021 12:52:15 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.11 16/67] net: sfp: add mode quirk for GPON
 module Ubiquiti U-Fiber Instant
Message-ID: <YEPBT69EMWmulQwv@sashalap>
References: <20210224125026.481804-16-sashal@kernel.org>
 <20210224125212.482485-12-sashal@kernel.org>
 <20210225190306.65jnl557vvs6d7o3@pali>
 <YEFgHQt6bp7yBjH/@sashalap>
 <20210305233802.x3g6bfmgbpwmv3e2@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210305233802.x3g6bfmgbpwmv3e2@pali>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 06, 2021 at 12:38:02AM +0100, Pali Rohár wrote:
>On Thursday 04 March 2021 17:33:01 Sasha Levin wrote:
>> On Thu, Feb 25, 2021 at 08:03:06PM +0100, Pali Rohár wrote:
>> > On Wednesday 24 February 2021 07:49:34 Sasha Levin wrote:
>> > > From: Pali Rohár <pali@kernel.org>
>> > >
>> > > [ Upstream commit f0b4f847673299577c29b71d3f3acd3c313d81b7 ]
>> >
>> > Hello! This commit requires also commit~1 from that patch series:
>> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=426c6cbc409cbda9ab1a9dbf15d3c2ef947eb8c1
>> >
>> > Without it kernel cannot read EEPROM from Ubiquiti U-Fiber Instant
>> > module and therefore the hook based on EEPROM data which is below would
>> > not be applied.
>>
>> Looks like that commit is already in, thanks!
>
>Yes! Now I see that commit in 5.11 queue. So 5.11 would be OK.
>
>But I do not see it in 5.10 queue. In 5.10 queue I see only backport of
>f0b4f8476732 commit. 426c6cbc409c seems to be still missing.
>
>Could you check it?

Good point. It is now. Thanks!

-- 
Thanks,
Sasha
