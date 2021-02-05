Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9CF3112B4
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 21:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233244AbhBES7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 13:59:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:40086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233134AbhBES7Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 13:59:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DB1C64EE8;
        Fri,  5 Feb 2021 20:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612557670;
        bh=9J0YDG0VstWH6GPtFsg5La7moDRgqKTp0Al4ft+XByY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GnahPVtsD0n7ttUgdbsn+69YOzz+Vs3hLxEfVvdbPf8WgeufHG4Ljt0bfH16pPu74
         HiubRs5H2aiqxkYLIv4bCjFANWcNI6CB5ADFuSSclmI3nEEzAn/iYD/75VgYMeXp2p
         gxq1fIgKfDIHyQz5LogFJ6+RAzd5+wxeYYCxNe+kXCHuCBet/1xzOI6ixQxLfexjRK
         B0g/XFY3Z/T/399LuJ7fxDrM3ycv/ykrbxPAgnBLMbf4wN7OadfSL48tUrZxwqWX2m
         LrH/gxiOTM/cXzlFeZbnxe8igXCSm4fgvWLWNsI3VIpi1mYWirBIhPlRnIaAZ5itBu
         I04+r6nB9UrYA==
Date:   Fri, 5 Feb 2021 12:41:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [pull request][net-next 00/17] mlx5 updates 2021-02-04
Message-ID: <20210205124109.38fc6677@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210205064051.89592-1-saeed@kernel.org>
References: <20210205064051.89592-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  4 Feb 2021 22:40:34 -0800 Saeed Mahameed wrote:
> This series adds support for VF tunneling from Vlad,
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

Patch 2 and on do not build, could you investigate?
