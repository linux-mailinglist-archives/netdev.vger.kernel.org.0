Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1A7139306
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 15:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgAMODl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 09:03:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:52618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726976AbgAMODl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 09:03:41 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A30F920678;
        Mon, 13 Jan 2020 14:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578924220;
        bh=x6XS3FIEdZNZV+Yjb8AOXxcnvp8/Gr1B96230lY3pvk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xo3t8mAbByzPdaRNry1A0KbsI7OAzlS5RupUoF3W1CPooyIis7ysqRLiq//X2nCbX
         AnXbu5Xo2PeZy4sFn3vvNNBslug8UbDPP/PfCqpy3+9yVRA/wW7+CkNwP8bFu4wTLa
         K3KZwvMF62sJ94rZZ9YTg8XFgdxjd23AvGnUgZks=
Date:   Mon, 13 Jan 2020 06:03:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Habets <mhabets@solarflare.com>
Cc:     <ecree@solarflare.com>, <amaftei@solarflare.com>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] sfc/ethtool_common: Make some function to static
Message-ID: <20200113060339.4701c8db@cakuba>
In-Reply-To: <5c1a0337-3665-79bc-b275-6a2d0b8389c1@solarflare.com>
References: <20200113112411.28090-1-zhangxiaoxu5@huawei.com>
        <20200113045846.3330b57c@cakuba>
        <5c1a0337-3665-79bc-b275-6a2d0b8389c1@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jan 2020 13:29:42 +0000, Martin Habets wrote:
> Hi Jakub,
> 
> The fix is good. Even when we reuse this code these functions can remain static.

Okay then, applied to net-next, thank you!

