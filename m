Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D48618FCFB
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 19:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbgCWSqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 14:46:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:51118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727188AbgCWSqv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 14:46:51 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF60A205ED;
        Mon, 23 Mar 2020 18:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584989211;
        bh=IJ4jRM0rHp+ywTbnVfShze7DpeZADv+8OWKIPIYHqGA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hMFWZLR7/248ZwC4IP+UuQK8Al6zgJI1Ie1q11A/0IYkoPFDifFMvVQlhhjJ8EwLS
         8GsNRJZe90PJpYVm+Y2bRyqMRdjd+5HRqr/NO/sVPOdE6HxqfQaXiJpM/8ZYVQ55tH
         4GoYl8QLc2OHC18qMrRhIfHat7HUOZiV9SiaQhNk=
Date:   Mon, 23 Mar 2020 11:46:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 0/5] devlink: Preparations for trap policers
 support
Message-ID: <20200323114648.192e4bef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200322184830.1254104-1-idosch@idosch.org>
References: <20200322184830.1254104-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 22 Mar 2020 20:48:25 +0200 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> This patch set prepares the code for devlink-trap policer support in a
> follow-up patch set [1][2]. No functional changes intended.
> 
> Policers are going to be added as attributes of packet trap groups,
> which are entities used to aggregate logically related packet traps.
> This will allow users, for example, to limit all the packets that
> encountered an exception during routing to 10Kpps.
> 
> However, currently, device drivers register their packet trap groups
> implicitly when they register their packet traps via
> devlink_traps_register(). This makes it difficult to pass additional
> attributes for the groups. For example, the policer bound to the group.
> 
> Therefore, this patch set converts device drivers to explicitly register
> their packet trap groups. This will later allow these drivers to
> register the group with additional attributes, if any.

Acked-by: Jakub Kicinski <kuba@kernel.org>
