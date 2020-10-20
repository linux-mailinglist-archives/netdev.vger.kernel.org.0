Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFD5293376
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 05:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390985AbgJTDKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 23:10:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390981AbgJTDKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 23:10:50 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03E1E222E9;
        Tue, 20 Oct 2020 03:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603163450;
        bh=jCNOTWsn1MjRusqgedcp+cQ1hp7+Ikl6GJG/pTGGXoI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VbNAOcvwOf4UY1hwtyTa0JSVlkE4Qofctr0HnH/BVsaUiaR9EQpsgDLuuM47P6Ksx
         LKP33ZdldCCF0HZ1M2z3lTxUSkgazojuCzC8oetm/SLruQKdB+HMJo4PrNOoLgfVEH
         nKM0BonxLf+PVCuvQOnHzWpmGc4WWFsZNhYI8TWk=
Date:   Mon, 19 Oct 2020 20:10:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@gmail.com,
        nikolay@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net] nexthop: Fix performance regression in nexthop
 deletion
Message-ID: <20201019201048.5278db6b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201016172914.643282-1-idosch@idosch.org>
References: <20201016172914.643282-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Oct 2020 20:29:14 +0300 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> While insertion of 16k nexthops all using the same netdev ('dummy10')
> takes less than a second, deletion takes about 130 seconds:

Applied, thank you!
