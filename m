Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1BBE45D152
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 00:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235479AbhKXXl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 18:41:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:38480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235495AbhKXXl2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 18:41:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85C9E6108F;
        Wed, 24 Nov 2021 23:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637797097;
        bh=aUZk2s0C/7IKSBSch/v68TcyjBboHe9UQyKNQq3c7J8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NtbgW+h1djwiCTvq/aTBcuAeIfMqa5FOMutra/ytg24FyDNsOPo81g4Z3/t/0Uq4s
         ip35Xr6sesAb250yw6kaIZ+pIiagQMjnJr/xwhs+Dx6PRfmc/9p++p2XMFuE9zm0Wa
         QTxNxnnYhA2tquy12QG3rlTRL00UDIjljdZw/JE8zk6p173KimX4Mqmo7M+9/H5Igm
         0icL85Siw2fFSp20D84ZmS1uxM2zO8nInnzVytn+xsSOvALP+Q85c0KaRRRIgirtcJ
         vxu0ruVIYRGvnoiSbnIZIEfRSCZoivQxZzWjEwLhPdRpJrXxJg5GStDYyJOlbgbYI9
         C3eWzD+2xTyLQ==
Date:   Wed, 24 Nov 2021 15:38:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Manish Chopra <manishc@marvell.com>
Cc:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <palok@marvell.com>, <pkushwaha@marvell.com>
Subject: Re: [PATCH net] qede: validate non LSO skb length
Message-ID: <20211124153816.124156fc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211124092405.28834-1-manishc@marvell.com>
References: <20211124092405.28834-1-manishc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Nov 2021 01:24:05 -0800 Manish Chopra wrote:
> Although it is unlikely that stack could transmit a non LSO
> skb with length > MTU, however in some cases or environment such
> occurrences actually resulted into firmware asserts due to packet
> length being greater than the max supported by the device (~9700B).
> 
> This patch adds the safeguard for such odd cases to avoid firmware
> asserts.
> 
> Signed-off-by: Manish Chopra <manishc@marvell.com>
> Signed-off-by: Alok Prasad <palok@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>

Please add an appropriate Fixes tag and repost.
