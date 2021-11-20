Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D59457B00
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 05:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236313AbhKTEDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 23:03:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:39986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230055AbhKTEDc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 23:03:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADC286056B;
        Sat, 20 Nov 2021 04:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637380830;
        bh=tcQUD/2l4R9BC83ewPl2yetBw+5sqARQ8vAl7jIFQHk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U7TI1YOuuO8NzU7n59o+oTmZGzZgo3IEqJlI195pWPav/ItiXXLNiAPeGTM1bX9yl
         DetQ7l3LYDx7/74AGUUvn81HZYFOkA5mX7ZiL19BKHrR+dhYaO32mvz/qNLlt1a14M
         0nULfcNAgBn+y1ZgkJrEV076Ac53wcilN4KZ9asFL1uml/2ot2ICzr+W2Ou65mYN+X
         ltZHUGwVmAzfSMvXjaShDDKei08YsrSKSOdx4yugzYy03zaTxoMyES8qFaMLuTplwj
         QkBq4yV2XFQJ6g9WNHXmlePzBu/gpVndyba4fWqWjFmpsuoQ2Q8LaNcs6GPQZTwraw
         eiz2n7fC3nFPw==
Date:   Fri, 19 Nov 2021 20:00:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Lama Kayal <lkayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net 08/10] net/mlx5e: Add activate/deactivate stage to XDPSQ
Message-ID: <20211119200028.4d1cd9d5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211119195813.739586-9-saeed@kernel.org>
References: <20211119195813.739586-1-saeed@kernel.org>
        <20211119195813.739586-9-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Nov 2021 11:58:11 -0800 Saeed Mahameed wrote:
> Fixes: 0a06382fa406 ("net/mlx5e: Encapsulate open/close queues into a function"

missing closing bracket
