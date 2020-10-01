Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAC12809AC
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 23:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733006AbgJAVwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 17:52:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726731AbgJAVwC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 17:52:02 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2FCB206C9;
        Thu,  1 Oct 2020 21:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601589122;
        bh=PHmNHD5kKvlUeD+4nlUWn80hx2u45PQEiCLJLWVxsv4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Azn3QUGvSkz5ikgBtZGXB/7GjzYXKSzUqGGK1OqwEMg3SqjNxWKnmERNSlFPbwz0H
         4oGOYEudcKB8KzJxErj3r78xDEEoNMsqJvN9nttINV7CQKRzR2fBrnNz2CioP1kCuB
         KewVVw1UZbZG7hycMavufCTAbBSA2rIdflQvSeS0=
Date:   Thu, 1 Oct 2020 14:52:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 15/16] net/mlx5: Add support for devlink reload
 limit no reset
Message-ID: <20201001145200.2ba769b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1601560759-11030-16-git-send-email-moshe@mellanox.com>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
        <1601560759-11030-16-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  1 Oct 2020 16:59:18 +0300 Moshe Shemesh wrote:
> +	err = mlx5_fw_reset_set_live_patch(dev);
> +	if (err)
> +		return err;
> +
> +	return 0;

nit return mlx...
