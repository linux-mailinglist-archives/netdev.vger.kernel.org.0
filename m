Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2FD4362892
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 21:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243008AbhDPTYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 15:24:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:32874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235362AbhDPTYs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 15:24:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 869A96137D;
        Fri, 16 Apr 2021 19:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618601063;
        bh=jZTCrBXycRUeWAsrhx6Y4pdb22jWEDY4zTSCCrq6ACM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AyUMfw0EImtUJNC2GSYYYrArx1Pdr73hyIUe2lDZaZObnaep6F7E8vmeHd8crvLlY
         KYeWAu5vwzwgv7X/J8IoPg48MWXHjsWyYsnJa4F0vg4My35YsF62nzymInoTsPRVT8
         fENmCUiCcFsW06HUYVO/NMaGSDY7KPIP5j1UdMKFu/nq3PLRifvW+ruzuWMSC13iO5
         G/5omF4WFwRk181k6WHvrFlTWk/oB4eaHZ5Yfnx8wfHRt/HToDQDmnnGQcVYqUPVpe
         DF61FV/9S7jFIV3eTKn2s3oACXCJmWJRJxppMcflltTdlWtLgJ8RVQiAZtqEeY6mF1
         yypWHRKGQ6Xlw==
Date:   Fri, 16 Apr 2021 12:24:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, idosch@nvidia.com, saeedm@nvidia.com,
        michael.chan@broadcom.com
Subject: Re: [PATCH net-next 7/9] mlxsw: implement ethtool standard stats
Message-ID: <20210416122421.6813145f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YHnjqCozQWYAXNmG@shredder.lan>
References: <20210416022752.2814621-1-kuba@kernel.org>
        <20210416022752.2814621-8-kuba@kernel.org>
        <YHnjqCozQWYAXNmG@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Apr 2021 22:21:12 +0300 Ido Schimmel wrote:
> On Thu, Apr 15, 2021 at 07:27:50PM -0700, Jakub Kicinski wrote:
> > mlxsw has nicely grouped stats, add support for standard uAPI.
> > I'm guessing the register access part. Compile tested only.  
> 
> Jakub, wanted to let you know that it seems to be working. I'll review
> the patches tomorrow/Sunday, as it's already late here. Thanks!

Great, thank you! Let me post v2 just in case Dave merges before you get
to it..
