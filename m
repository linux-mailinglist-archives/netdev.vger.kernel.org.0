Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF423E4DDA
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 22:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbhHIUdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 16:33:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:38914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234411AbhHIUdM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 16:33:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C641660F35;
        Mon,  9 Aug 2021 20:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628541172;
        bh=czOtogfQzgrSdrrhkr3mRpk9WS0PuTqmL9pZfn8fFIs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DrV2efEYEFs+I7EUWjnj23pBxljmYVBsWYdcSPcUTWiSuL9oQUrTvNNBUAAEsOOkW
         mtq0AbgSLPUWk2SQroAeP8KpNBy9BB3vrR7TcvIpHikrvjuUaPwoCrMSrNBvN3nbfl
         qdOKpbS1FsQJq6lyP4zl9Mr3Sl0xhkT7d03QMkCw1odIvHl3dP/gj5y9Qxcr3rytFa
         BF4YJ3FAn4msVvTT1UqSVCy02YjfPOjMm2V/022OCg4Lc4fqQgy0F8znaDOyE283T4
         +i6PA8Dr3bhq5QEQ8twzNrAkzRJKeg4bEVf/Qy48QArfwYovwpf2lhhUq5mmmKKzBM
         4lK0Cwtg0qt5Q==
Date:   Mon, 9 Aug 2021 13:32:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lahav Schlesinger <lschlesinger@drivenets.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        dsahern@kernel.org, davem@davemloft.net
Subject: Re: [PATCH] net: Support filtering interfaces on no master
Message-ID: <20210809133250.4b438e77@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210809065432.lk2dx3abff4p6wmq@kgollan-pc>
References: <20210808132836.1552870-1-lschlesinger@drivenets.com>
        <439cf1f8-78ad-2fec-8a43-a863ac34297b@gmail.com>
        <20210809065432.lk2dx3abff4p6wmq@kgollan-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Aug 2021 09:54:32 +0300 Lahav Schlesinger wrote:
> Currently there's support for filtering neighbours/links for interfaces
> which have a specific master device (using the IFLA_MASTER/NDA_MASTER
> attributes).
> 
> This patch adds support for filtering interfaces/neighbours dump for
> interfaces that *don't* have a master.
> 
> I have a patch for iproute2 ready for adding this support in userspace.
> 
> Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>

Please make a fresh posting with [PATCH net-next v2] as the subject tag.
