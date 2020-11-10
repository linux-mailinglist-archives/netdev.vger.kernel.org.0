Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB082ACA1D
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 02:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731487AbgKJBLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 20:11:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:56874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727311AbgKJBLu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 20:11:50 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8502206D8;
        Tue, 10 Nov 2020 01:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604970710;
        bh=qjR6p835OPgxdbzPBB3r2995G2ZwBWPB+MjkwHZw7cE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H5k/Fyx/KE51QO9OmyxWDv0EG+SlQYtTtG5KCOdTU4HKt38yN8GTjBLODVR4biX7D
         LXNqBjIC6eweQroMsRpOPFceaKmfGlpDNVvbXuJRAWpeUT/UyVlPrYR9Vwh7Z/ok9k
         l0pS0Mg9yVWykfsa7jTuhKtncSqfBAlJXZDGP3v0=
Date:   Mon, 9 Nov 2020 17:11:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tanner Love <tannerlove.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Tanner Love <tannerlove@google.com>
Subject: Re: [PATCH net-next 0/2] net/packet: make packet_fanout.arr size
 configurable up to 64K
Message-ID: <20201109171148.109710a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201106180741.2839668-1-tannerlove.kernel@gmail.com>
References: <20201106180741.2839668-1-tannerlove.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Nov 2020 13:07:39 -0500 Tanner Love wrote:
> From: Tanner Love <tannerlove@google.com>
> 
> First patch makes the change; second patch adds unit tests.

Applied, thanks.
