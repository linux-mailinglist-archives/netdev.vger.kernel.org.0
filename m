Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9363F1EB8
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 19:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbhHSRF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 13:05:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229659AbhHSRFZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 13:05:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D37A560FE6;
        Thu, 19 Aug 2021 17:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629392689;
        bh=b1C0UuJxo9EgVGFx3asIQX4aAG9C4OIYtJ17AXEQKrc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=izllx/PaTTwLgYh/SELfNqR043gpy/qD/omok6eOMcog4Rn/hP3rJnhjZN9SRxpnF
         a9PC2pzDsSkI/adnnYoYfm9UCTkE98fF/vj+FxM7ZPLfvrqXLjy7ZK33NS0QdCt/rx
         qUcM+ADTnNLdA8amI9TQ/mM9KW+ml7y6tHUTFP8Bf/mU3vVlvK7CZYveasLLCFsbAj
         DXY1Ad8EMPMAY8lPv+Jh26MyyXxFkjUrsEdpVWVbOUoeq94MeOjCPKpyDpd3NiIxWm
         tW4rw3fQU9Hl38uKXPKpXCMWvhCnEn6XnPyXtJ6clim3BFViraqYtMbmALGVC0vy+U
         3Wyj2nU+qrrqA==
Date:   Thu, 19 Aug 2021 10:04:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+ff8e1b9f2f36481e2efc@syzkaller.appspotmail.com
Subject: Re: [PATCH] ip_gre/ip6_gre: add check for invalid csum_start
Message-ID: <20210819100447.00201b26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CA+FuTSdsLzjMapC-OGugkSP-ML99xF5UC-FjDhFS1_BDDSJ2sg@mail.gmail.com>
References: <20210819143447.314539-1-chouhan.shreyansh630@gmail.com>
        <CA+FuTSdsLzjMapC-OGugkSP-ML99xF5UC-FjDhFS1_BDDSJ2sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Aug 2021 12:56:59 -0400 Willem de Bruijn wrote:
> Technically, for backporting purposes, the patch needs to be split
> into two, each with their own Fixes tag. And target [PATCH net]

Indeed, looks like the two parts will need to go to different
depths of stable - Shreyansh, would you mind splitting and 
reposting as instructed? Thanks.
