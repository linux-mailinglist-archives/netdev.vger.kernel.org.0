Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6982D1AF51F
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 23:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgDRVUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 17:20:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726014AbgDRVUq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Apr 2020 17:20:46 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD34921D6C;
        Sat, 18 Apr 2020 21:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587244846;
        bh=2QTKjiopYEAmsX3oKHr1d4x/yXdKgoAiCY9R5mVgWxg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yQNIS0f67zLk1LDfck/vteQMw+YvycUdXU3cvwokPVioE3B/5nrmA5cWWkKqrhR8m
         ARNsdxU6Yx56/tS0/c7ztVULPjFdsADkVPfEMOJlI1MsehMhODT5GjvLZftZZVB6do
         h31oeoxvn91qqqots+htICc73GmGMlWLSqGAqkVA=
Date:   Sat, 18 Apr 2020 17:20:44 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Stable <stable@vger.kernel.org>, Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.5 006/106] net/mlx5e: Enforce setting of a
 single FEC mode
Message-ID: <20200418212044.GE1809@sasha-vm>
References: <20200415114226.13103-1-sashal@kernel.org>
 <20200415114226.13103-6-sashal@kernel.org>
 <CAJ3xEMjKozXW1h8Dwv96VzCegOsyvyyeZ4hapWzwStirLGnAqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAJ3xEMjKozXW1h8Dwv96VzCegOsyvyyeZ4hapWzwStirLGnAqg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 18, 2020 at 10:52:59PM +0300, Or Gerlitz wrote:
>On Thu, Apr 16, 2020 at 2:56 AM Sasha Levin <sashal@kernel.org> wrote:
>> From: Aya Levin <ayal@mellanox.com>
>> [ Upstream commit 4bd9d5070b92da012f2715cf8e4859acb78b8f35 ]
>>
>> Ethtool command allow setting of several FEC modes in a single set
>> command. The driver can only set a single FEC mode at a time. With this
>> patch driver will reply not-supported on setting several FEC modes.
>>
>> Signed-off-by: Aya Levin <ayal@mellanox.com>
>> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 4 ++++
>
>Haven't we agreed that drivers/net/ethernet/mellanox/mlx5 is not
>subject to autosel anymore?!

On Thu, Apr 16, 2020 at 09:08:06PM +0000, Saeed Mahameed wrote:
>Please don't opt mlx5 out just yet ;-), i need to do some more research
>and make up my mind..

It would be awesome if the Mellanox folks could agree between
themselves whether they want it or not and let us know which option they
pick.

Again, I really don't care whether mlx5 is opted out or not, I'm not
going to argue with anyone if you want to opt out, I just want to know
whether you're out or not :)

-- 
Thanks,
Sasha
