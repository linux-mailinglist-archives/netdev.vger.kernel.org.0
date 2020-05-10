Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10201CC652
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 05:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgEJDvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 23:51:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgEJDvx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 23:51:53 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96F30206A3;
        Sun, 10 May 2020 03:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589082712;
        bh=w6hi27IrIcGH7Y4ZIZ3e0zRwFcs8mRocr+ZB1tumEPk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=He9Sa5C4fKORHZbJr8PIvLK5G5W0bY5lBhlJ0Z0Osc38L2scTu5+mJyxq1LVzsfuV
         +Ag6Ndmrujgu5QeD7Td5CpVBtHDB36mSJYo6B/+1hNz0ZuZvyJiHKgl7tJ/kUvRALT
         f2adyirQZIJrF9Kt+GjTmqctXJH8OzTveZ3e/Fuo=
Date:   Sat, 9 May 2020 20:51:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Tariq Toukan <tariqt@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IB/mlx4: Replace zero-length array with flexible-array
Message-ID: <20200509205151.209bdc9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200507185921.GA15146@embeddedor>
References: <20200507185921.GA15146@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 May 2020 13:59:21 -0500 Gustavo A. R. Silva wrote:
> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
> 
> struct foo {
>         int stuff;
>         struct boo array[];
> };
>
> ...

Applied, thank you!
