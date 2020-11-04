Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6CE82A5BE6
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 02:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730029AbgKDB3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 20:29:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:54862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbgKDB3Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 20:29:24 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8E6A20870;
        Wed,  4 Nov 2020 01:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604453364;
        bh=Lnw0AVKJA+B9hBJu06nrLvfVbTao4UDUBpKOaIoeXv8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iNA7Qz/JWhjd2L0aXm5ytR5umpzNEqYMb0dyEfB5lqjyhT7lDXyKxwPihriytblDn
         XJV14FlXGOons21e2J//KQrH7/ITAIHNvwx4nyDBqtY5l+ftIv1hDyBJjx4hHEfWIN
         /rYG0ZL5y63ODFb5uXKbeG/lpdVld2YAnRD3bWkU=
Date:   Tue, 3 Nov 2020 17:29:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 0/2] mlxsw: spectrum: Prepare for XM
 implementation - LPM trees
Message-ID: <20201103172922.4b649b4d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201101134215.713708-1-idosch@idosch.org>
References: <20201101134215.713708-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  1 Nov 2020 15:42:13 +0200 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Jiri says:
> 
> This is a preparation patchset for follow-up support of boards with
> extended mezzanine (XM), which are going to allow extended (scale-wise)
> router offload.
> 
> XM requires a separate set of PRM registers to be used to configure LPM
> trees. Therefore, this patchset introduces operations that allow
> different implementations of tree configuration for legacy router
> offload and the XM router offload.

Applied, thanks!
