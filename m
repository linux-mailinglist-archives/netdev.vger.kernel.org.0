Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96DF31D5702
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgEORFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:05:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgEORFD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 13:05:03 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90D7320727;
        Fri, 15 May 2020 17:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589562302;
        bh=RWhvlBYTz2t4tOPhbTpL/3ul6ZxHxjtS/l/DX5gtuP4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nFD5UUCWi4e8mP3xFGHkdevF78+R+ALjWEAb3/jyLSzFScyr+Fxvm5lge7FvT/GbJ
         TRS4HOWxjSzXTERDogRac9So0lP1jSBB5KY7eDfgNCu6oJelb0uUZ+btaZ76IYGjLY
         Jrgbk25x27N/vi4ktqvR5YZSGQC8t9NH9ErUl7Sw=
Date:   Fri, 15 May 2020 10:04:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, dcaratti@redhat.com,
        marcelo.leitner@gmail.com
Subject: Re: [PATCH net-next v2 0/4] Implement classifier-action terse dump
 mode
Message-ID: <20200515100448.12b2c73d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200515114014.3135-1-vladbu@mellanox.com>
References: <20200515114014.3135-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 May 2020 14:40:10 +0300 Vlad Buslov wrote:
> Output rate of current upstream kernel TC filter dump implementation if
> relatively low (~100k rules/sec depending on configuration). This
> constraint impacts performance of software switch implementation that
> rely on TC for their datapath implementation and periodically call TC
> filter dump to update rules stats. Moreover, TC filter dump output a lot
> of static data that don't change during the filter lifecycle (filter
> key, specific action details, etc.) which constitutes significant
> portion of payload on resulting netlink packets and increases amount of
> syscalls necessary to dump all filters on particular Qdisc. In order to
> significantly improve filter dump rate this patch sets implement new
> mode of TC filter dump operation named "terse dump" mode. In this mode
> only parameters necessary to identify the filter (handle, action cookie,
> etc.) and data that can change during filter lifecycle (filter flags,
> action stats, etc.) are preserved in dump output while everything else
> is omitted.

Please keep the review tags you already got when making minor changes.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
