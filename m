Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7E51E4BEA
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 19:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387878AbgE0Rbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 13:31:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726487AbgE0Rby (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 13:31:54 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 443FF2075A;
        Wed, 27 May 2020 17:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590600714;
        bh=nHteemTBt2Vb5a7yp2zfvaxdrGMcj9HpABgnsh3thlM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R+WW6RgsoKW3fTDrDZxmUmuoKWEtvBpXT7KqjK1SMLKOcn+YqJXbhjF0Jy/XFpjLm
         tdXSchpmgBNqDxyCc94LuI6uKkcha6lFcrqPHPO36Y8L66cbnJnR1H3HpGu177QnYB
         vPkKQBEelHeCUgv/QIVCS9Cqrbu+Zd1M5EuK2e2o=
Date:   Wed, 27 May 2020 10:31:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [pull request][net-next V2 00/15] mlx5 updates 2020-05-26
Message-ID: <20200527103152.1a0d225a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200527162139.333643-1-saeedm@mellanox.com>
References: <20200527162139.333643-1-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 May 2020 09:21:24 -0700 Saeed Mahameed wrote:
> Hi Dave/Jakub.
> 
> This series adds support for mlx5 switchdev VM failover using FW bonded
> representor vport and probed VF interface via eswitch vport ACLs.
> Plus some extra misc updates.
> 
> v1->v2:
>   - Dropped the suspend/resume support patch, will re-submit it to net and
>     -stable as requested by Dexuan.
> 
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

Build problems from v1 apply
