Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81014270AC
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 20:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhJHS1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 14:27:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231237AbhJHS1G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 14:27:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34BA760F9D;
        Fri,  8 Oct 2021 18:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633717511;
        bh=SgbiS5u71nkMS6kHjowVFgReev15XfsDQWUshj3Snxw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S9DUH559j1TtDcJ3DClwlssQsLoEnZr+5kZgAOPXzzhuk8WWJ+L+gaVsgxqq4fwzm
         BcbLDuWcoWUhdkNognY/LC0VwqrSwXsRxbrk/IJTdg0ZHisvCptzBlPon4tP1CZH38
         51sbfsGS8ThD6V8806q0f0/EH6ugqvOOjRUDnd415HMh6ctxiqd2RMQOd/8SWmoCKA
         IZe4JePP4tjFzxlaOQOZtfrz7g/7/Mnnz5R1jXacgzkTZ5czN4dtMxA4BiD/T6iq0a
         mV0uOOAyOs7olPs8b+LH6pX8zjtG0cXpKGaGKd43WK2gVdlhVI6Xzh68Xcfr9AGnAJ
         gJGHPdYIJo9tQ==
Date:   Fri, 8 Oct 2021 11:25:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dev_addr_list: Introduce __dev_addr_add()
 and __dev_addr_del()
Message-ID: <20211008112510.56417490@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211008085354.9961-1-yajun.deng@linux.dev>
References: <20211008085354.9961-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 Oct 2021 16:53:54 +0800 Yajun Deng wrote:
> Introduce helper functions __dev_addr_add() and __dev_addr_del() for
> the same code, make the code more concise.
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>

Please leave net/core/dev_addr_lists.c alone for the time being. 
I have a lot of changes queued to add the main address the the rbtree.
