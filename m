Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D24C39E991
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 00:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbhFGW20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 18:28:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53194 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbhFGW2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 18:28:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 897ED4F6894D6;
        Mon,  7 Jun 2021 15:26:33 -0700 (PDT)
Date:   Mon, 07 Jun 2021 15:26:29 -0700 (PDT)
Message-Id: <20210607.152629.1604704104944229264.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        kasperd@gjkwv.06.feb.2021.kasperd.net, cascardo@canonical.com
Subject: Re: [PATCH net] neighbour: allow NUD_NOARP entries to be forced
 GCed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210607173530.46493-1-dsahern@kernel.org>
References: <20210607173530.46493-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 07 Jun 2021 15:26:33 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Mon,  7 Jun 2021 11:35:30 -0600

> IFF_POINTOPOINT interfaces use NUD_NOARP entries for IPv6. It's possible to
> fill up the neighbour table with enough entries that it will overflow for
> valid connections after that.
> 
> This behaviour is more prevalent after commit 58956317c8de ("neighbor:
> Improve garbage collection") is applied, as it prevents removal from
> entries that are not NUD_FAILED, unless they are more than 5s old.
> 
> Fixes: 58956317c8de (neighbor: Improve garbage collection)
> Reported-by: Kasper Dupont <kasperd@gjkwv.06.feb.2021.kasperd.net>
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> Signed-off-by: David Ahern <dsahern@kernel.org>
> ---
> rebased to net tree

Applied, thanks.
